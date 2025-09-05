Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Write-PipelineError' {
    Context 'outside pipeline context' {
        BeforeAll { $script:saved=$env:TF_BUILD; $env:TF_BUILD=$null }
        AfterAll { $env:TF_BUILD=$script:saved }
        It 'writes error logissue line' {
            $result = & { Write-PipelineError -Message 'Test error' } 6>&1 | Out-String
            $result -match '##vso\[task.logissue type=error]Test error' | Should Be $true
        }
    }
    Context 'inside pipeline context' {
        BeforeAll { $script:saved=$env:TF_BUILD; $env:TF_BUILD='true' }
        AfterAll { $env:TF_BUILD=$script:saved }
        It 'writes error logissue line' {
            $result = & { Write-PipelineError -Message 'Test error' } 6>&1 | Out-String
            $result -match '##vso\[task.logissue type=error]Test error' | Should Be $true
        }
        It 'includes source path' {
            $result = & { Write-PipelineError -Message 'Test error' -SourcePath 'test.ps1' } 6>&1 | Out-String
            $result -match '##vso\[task.logissue type=error;sourcepath=test.ps1]Test error' | Should Be $true
        }
    }
}
