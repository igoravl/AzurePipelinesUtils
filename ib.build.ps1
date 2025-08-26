#requires -module InvokeBuild, ModuleBuilder

param(
    [string] $BuildNumber 
)

# Synopsis: Default build target - runs Build task
task . Build

# Synopsis: Clean build artifacts
task Clean {
    Write-Host 'Cleaning build artifacts...'
    Remove-Item -Path (Join-Path $PSScriptRoot 'Build') -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path (Join-Path $PSScriptRoot 'artifacts') -Recurse -Force -ErrorAction SilentlyContinue
}

# Synopsis: Build the module using ModuleBuilder
task Build Clean, GetBuildNumber, {
    Write-Host "Building AzurePipelinesUtils module with ModuleBuilder..."
    
    # Use ModuleBuilder to transpile individual .ps1 files into a single .psm1
    $buildParams = @{
        SourcePath = Join-Path $PSScriptRoot 'Source'
        OutputDirectory = Join-Path $PSScriptRoot 'Build'
        UnversionedOutputDirectory = $true
    }
    
    Build-Module @buildParams
    Write-Host "Module built successfully using ModuleBuilder"
}

# Synopsis: Get the build number
task GetBuildNumber {
    Write-Host "Getting build number..."

    # Check if GitVersion.Tool is installed
    $gitVersionInstalled = $null -ne (dotnet tool list --global | Where-Object { $_ -match 'gitversion.tool' })

    if (-not $gitVersionInstalled) {
        Write-Error "GitVersion.Tool is not installed. Install it with: dotnet tool install --global GitVersion.Tool"
        throw "Required tool GitVersion.Tool is not installed."
    }

    # Use GitVersion to get the SemVer
    Write-Host "Running GitVersion..."
    $gitVersionOutput = dotnet-gitversion
    $gitVersionInfo = $gitVersionOutput | ConvertFrom-Json

    # Set the build number
    $script:BuildNumber = $gitVersionInfo.SemVer

    Write-Host "Build number set to: $BuildNumber"

    # If running in GitHub Actions, set the output parameter
    if ($env:GITHUB_ACTIONS -eq 'true') {
        Write-Host "::set-output name=build_number::$BuildNumber"
        # For newer GitHub Actions
        "build_number=$BuildNumber" >> $env:GITHUB_OUTPUT
        Write-Host "GitHub Actions build number set as output variable"
    }
}

# Synopsis: Run Pester tests
task Test Build, {
    Write-Host 'Running Pester tests...'
    
    $testParams = @{
        Path = Join-Path $PSScriptRoot 'Tests'
        OutputFile = Join-Path $PSScriptRoot 'Build\TestResults.xml'
        OutputFormat = 'NUnitXml'
        CodeCoverage = (Get-ChildItem -Path (Join-Path $PSScriptRoot 'Build') -Include '*.psm1' -Recurse).FullName
        CodeCoverageOutputFile = Join-Path $PSScriptRoot 'Build\CodeCoverage.xml'
        PassThru = $true
    }
    
    $testResult = Invoke-Pester @testParams
    
    if ($testResult.FailedCount -gt 0) {
        Write-Host "Tests failed: $($testResult.FailedCount) of $($testResult.TotalCount)" -ForegroundColor Red
        throw "Tests failed"
    }
    else {
        Write-Host "All tests passed: $($testResult.TotalCount)" -ForegroundColor Green
    }
}

# Synopsis: Create distribution package
task Pack Build, {
    Write-Host 'Packing module into zip...'
    $out = Join-Path $PSScriptRoot 'artifacts'
    if (-not (Test-Path $out)) { New-Item -ItemType Directory -Path $out | Out-Null }
    
    $buildPath = Join-Path $PSScriptRoot 'Build'
    $zip = Join-Path $out "AzurePipelinesUtils-$BuildNumber.zip"
    
    if (Test-Path $zip) { Remove-Item $zip }
    
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($buildPath, $zip)
    Write-Host "Created $zip"
}