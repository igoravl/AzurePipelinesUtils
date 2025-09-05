Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Write-PipelineDebug' {
    Context 'outside pipeline context' {
        It 'writes plain debug message' {
            $result = & { Write-PipelineDebug -Message 'Debug details' } 6>&1 | Out-String
            $result.Trim() | Should -Be 'Debug details'
        }
    }
    Context 'inside pipeline context' {
        BeforeAll { $script:saved=$env:TF_BUILD; $env:TF_BUILD='true' }
        AfterAll { $env:TF_BUILD=$script:saved }
        It 'writes same debug message' {
            $result = & { Write-PipelineDebug -Message 'Debug details' } 6>&1 | Out-String
            $result.Trim() | Should -Be 'Debug details'
        }
    }
}
