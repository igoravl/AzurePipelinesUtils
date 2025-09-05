Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Write-PipelineWarning' {
    Context 'outside pipeline context' {
        BeforeAll { $script:saved=$env:TF_BUILD; $env:TF_BUILD=$null }
        AfterAll { $env:TF_BUILD=$script:saved }
        It 'writes warning logissue line' {
            $result = & { Write-PipelineWarning -Message 'Test warning' } 6>&1 | Out-String
            $result -match '##vso\[task.logissue type=warning]Test warning' | Should Be $true
        }
    }
    Context 'inside pipeline context' {
        BeforeAll { $script:saved=$env:TF_BUILD; $env:TF_BUILD='true' }
        AfterAll { $env:TF_BUILD=$script:saved }
        It 'writes base warning' {
            $result = & { Write-PipelineWarning -Message 'Test warning' } 6>&1 | Out-String
            $result -match '##vso\[task.logissue type=warning]Test warning' | Should Be $true
        }
        It 'includes source path' {
            $result = & { Write-PipelineWarning -Message 'Test warning' -SourcePath 'test.ps1' } 6>&1 | Out-String
            $result -match '##vso\[task.logissue type=warning;sourcepath=test.ps1]Test warning' | Should Be $true
        }
        It 'includes line number' {
            $result = & { Write-PipelineWarning -Message 'Test warning' -LineNumber 42 } 6>&1 | Out-String
            $result -match '##vso\[task.logissue type=warning;linenumber=42]Test warning' | Should Be $true
        }
        It 'includes source path and line number' {
            $result = & { Write-PipelineWarning -Message 'Test warning' -SourcePath 'test.ps1' -LineNumber 42 } 6>&1 | Out-String
            $result -match '##vso\[task.logissue type=warning;sourcepath=test.ps1;linenumber=42]Test warning' | Should Be $true
        }
    }
}
