#
# AzurePipelinesUtils Build Script
#
# This script checks for required build dependencies
# and invokes Invoke-Build with the appropriate parameters.
#

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string[]]$Targets = @('.'),

    [Parameter()]
    [string]$BuildNumber,

    [Parameter()]
    [switch]$InstallDependencies
)

if($Verbose.IsPresent) {
    $VerbosePreference = 'Continue'
}
else {
    $VerbosePreference = 'SilentlyContinue'
}

# Verifies InvokeBuild module
if (-not (Get-Module -ListAvailable -Name InvokeBuild)) {
    Write-Warning "InvokeBuild module not found."
    
    if ($InstallDependencies -or $PSCmdlet.ShouldContinue("The InvokeBuild module is required for building. Would you like to install it?", "Install InvokeBuild")) {
        Write-Host "Installing InvokeBuild module..." -ForegroundColor Cyan
        Install-Module -Name InvokeBuild -Scope CurrentUser -Force -AllowClobber -Verbose:$Verbose.IsPresent
        Write-Host "InvokeBuild module installed successfully." -ForegroundColor Green
    }
    else {
        Write-Error "The InvokeBuild module is required to continue. Run the script again with the -InstallDependencies parameter to install automatically."
        return
    }
}

# Verifies ModuleBuilder module
if (-not (Get-Module -ListAvailable -Name ModuleBuilder)) {
    Write-Warning "ModuleBuilder module not found."
    
    if ($InstallDependencies -or $PSCmdlet.ShouldContinue("The ModuleBuilder module is required for building. Would you like to install it?", "Install ModuleBuilder")) {
        Write-Host "Installing ModuleBuilder module..." -ForegroundColor Cyan
        Install-Module -Name ModuleBuilder -Scope CurrentUser -Force -AllowClobber -Verbose:$Verbose.IsPresent
        Write-Host "ModuleBuilder module installed successfully." -ForegroundColor Green
    }
    else {
        Write-Error "The ModuleBuilder module is required to continue. Run the script again with the -InstallDependencies parameter to install automatically."
        return
    }
}

# Verifies GitVersion.Tool installation
$gitVersionInstalled = $null -ne (dotnet tool list --global | Where-Object { $_ -match 'gitversion.tool' })
if (-not $gitVersionInstalled) {
    Write-Warning "GitVersion.Tool not found."
    
    if ($InstallDependencies -or $PSCmdlet.ShouldContinue("GitVersion.Tool is required for building. Would you like to install it?", "Install GitVersion.Tool")) {
        Write-Host "Installing GitVersion.Tool..." -ForegroundColor Cyan
        dotnet tool install --global GitVersion.Tool 
        Write-Host "GitVersion.Tool installed successfully." -ForegroundColor Green
    }
    else {
        Write-Error "GitVersion.Tool is required to continue. Run the script again with the -InstallDependencies parameter to install automatically."
        return
    }
}

# Preparing arguments for Invoke-Build
$ibArgs = @{
    File = (Join-Path $PSScriptRoot 'ib.build.ps1')
    Task = $Targets
}

# Adds the BuildNumber if provided
if ($BuildNumber) {
    $ibArgs['BuildNumber'] = $BuildNumber
    $ibArgs['Verbose'] = $Verbose.IsPresent
    Write-Verbose "Build number set to: $BuildNumber"
}

# Executes Invoke-Build
try {
    Write-Host "Starting build with Invoke-Build..." -ForegroundColor Cyan
    Write-Verbose "Invoke-Build parameters: $($ibArgs | ConvertTo-Json -Depth 3 -Compress)"
    Invoke-Build @ibArgs
    Write-Host "Build completed successfully!" -ForegroundColor Green
}
catch {
    Write-Error "Error during build: $_"
    exit 1
}
