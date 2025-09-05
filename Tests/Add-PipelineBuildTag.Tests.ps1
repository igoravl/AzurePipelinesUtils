Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Add-PipelineBuildTag' {
    It 'adds a build tag with the correct format' {
        $output = Add-PipelineBuildTag -Tag 'release'
        $output | Should Be '##vso[build.addbuildtag]release'
    }
}
