Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Set-PipelineReleaseNumber' {
    It 'outputs friendly text when not in pipeline context' {
        $saved = $env:TF_BUILD; $env:TF_BUILD=$null
        try {
            (Set-PipelineReleaseNumber -ReleaseNumber '9.8.7') | Should Be 'Release name: 9.8.7'
        } finally { $env:TF_BUILD = $saved }
    }
    It 'outputs vso command when in pipeline context' {
        $saved = $env:TF_BUILD; $env:TF_BUILD='true'
        try {
            (Set-PipelineReleaseNumber -ReleaseNumber '9.8.7') | Should Be '##vso[release.updatereleasename]9.8.7'
        } finally { $env:TF_BUILD = $saved }
    }
}
