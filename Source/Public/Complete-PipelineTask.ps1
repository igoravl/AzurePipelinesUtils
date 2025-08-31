Function Complete-PipelineTask {
    Param(
        [Parameter()]
        [string] $Status = 'Succeeded'
    )

    if(-not (Test-PipelineContext)) {
        return
    }

    if($Status -eq 'Succeeded' -and ($Global:_task_status -ne 'Succeeded')) {
        $Status = $Global:_task_status
    }

    if ($Status -ne 'Succeeded') {
        Write-Host "##vso[task.complete result=$Status;]"
    }
}
