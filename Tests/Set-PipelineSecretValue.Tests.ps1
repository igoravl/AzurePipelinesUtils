Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Set-PipelineSecretValue' {
    It 'masks secret in non-pipeline context' {
        $saved = $env:TF_BUILD; $env:TF_BUILD=$null
        try {
            (Set-PipelineSecretValue -Value 'abc123') | Should -Be 'Secret value has been masked in logs: ********'
        } finally { $env:TF_BUILD = $saved }
    }
    It 'emits vso command in pipeline context' {
        $saved = $env:TF_BUILD; $env:TF_BUILD='true'
        try {
            (Set-PipelineSecretValue -Value 'abc123') | Should -Be '##vso[task.setsecret]abc123'
        } finally { $env:TF_BUILD = $saved }
    }
}
