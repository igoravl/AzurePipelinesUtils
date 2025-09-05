Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Complete-PipelineTask' {
    It 'does nothing outside pipeline context for default status' {
        $out = Complete-PipelineTask
        $out | Should Be $null
    }
}
