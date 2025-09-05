Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Write-PipelineTaskProgress' {
    It 'writes task progress with currentoperation only' {
    (Write-PipelineTaskProgress -CurrentOperation 'Downloading').Trim() | Should -Be '##vso[task.setprogress currentoperation=Downloading]'
    }
    It 'writes task progress with percentcomplete' {
    (Write-PipelineTaskProgress -CurrentOperation 'Downloading' -PercentComplete 80).Trim() | Should -Be '##vso[task.setprogress currentoperation=Downloading;percentcomplete=80]'
    }
}
