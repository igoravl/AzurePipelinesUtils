try {
    # Prefer built module if present
    $built = Join-Path $PSScriptRoot '../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1'
    if (Test-Path $built) {
        Import-Module $built -Force
    }
    else {
        # Fallback: import from source folder for quicker inner-loop testing
        $srcRoot = Join-Path $PSScriptRoot '../Source'
        $manifest = Join-Path $srcRoot 'AzurePipelinesUtils.psd1'
        if (Test-Path $manifest) { Import-Module $manifest -Force }
        else { Write-Warning "Module manifest not found for tests: $manifest" }
    }
}
catch {
    Write-Error "Failed to import module under test: $_"; throw
}

Describe 'Write-PipelineCommand' {
    Context 'outside pipeline context' {
        It 'writes plain message' {
            $result = & { Write-PipelineCommand -Message 'Do something' } 6>&1 | Out-String
            ($result.Trim()) | Should -Be 'Do something'
        }
    }
    Context 'inside pipeline context' {
        BeforeAll { $script:saved=$env:TF_BUILD; $env:TF_BUILD='true' }
        AfterAll { $env:TF_BUILD=$script:saved }
        It 'still writes plain message (non-issue)' {
            $result = & { Write-PipelineCommand -Message 'Do something' } 6>&1 | Out-String
            ($result.Trim()) | Should -Be 'Do something'
        }
    }
}
