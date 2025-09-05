Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Write-PipelineCommand' {
    Context 'outside pipeline context' {
        It 'writes plain message' {
            $result = & { Write-PipelineCommand -Message 'Do something' } 6>&1 | Out-String
            ($result.Trim()) | Should Be 'Do something'
        }
    }
    Context 'inside pipeline context' {
        BeforeAll { $script:saved=$env:TF_BUILD; $env:TF_BUILD='true' }
        AfterAll { $env:TF_BUILD=$script:saved }
        It 'still writes plain message (non-issue)' {
            $result = & { Write-PipelineCommand -Message 'Do something' } 6>&1 | Out-String
            ($result.Trim()) | Should Be 'Do something'
        }
    }
}
