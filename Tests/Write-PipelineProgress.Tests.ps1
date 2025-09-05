Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Write-PipelineProgress' {
    Context 'outside pipeline context' {
        BeforeAll { $script:saved=$env:TF_BUILD; $env:TF_BUILD=$null }
        AfterAll { $env:TF_BUILD=$script:saved }
        It 'produces no output (Write-Progress only)' {
            $result = & { Write-PipelineProgress -PercentComplete 25 -Activity 'Deploy' } 6>&1 | Out-String
            ($result.Trim()).Length | Should Be 0
        }
    }
    Context 'inside pipeline context' {
        BeforeAll { $script:saved=$env:TF_BUILD; $env:TF_BUILD='true' }
        AfterAll { $env:TF_BUILD=$script:saved }
        It 'writes vso task progress command' {
            $result = & { Write-PipelineProgress -PercentComplete 25 -Activity 'Deploy' } 6>&1 | Out-String
            $result.Trim() | Should Be '##vso[task.setprogress value=25;]Deploy - 25%'
        }
    }
}
