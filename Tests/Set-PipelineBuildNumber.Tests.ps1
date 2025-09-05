Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Set-PipelineBuildNumber' {
    It 'outputs friendly text when not in pipeline context' {
        $saved = $env:TF_BUILD; $env:TF_BUILD=$null
        try {
            (Set-PipelineBuildNumber -BuildNumber '1.2.3') | Should -Be 'Build number: 1.2.3'
        } finally { $env:TF_BUILD = $saved }
    }
    It 'outputs vso command when in pipeline context' {
        $saved = $env:TF_BUILD; $env:TF_BUILD='true'
        try {
            (Set-PipelineBuildNumber -BuildNumber '1.2.3') | Should -Be '##vso[build.updatebuildnumber]1.2.3'
        } finally { $env:TF_BUILD = $saved }
    }
}
