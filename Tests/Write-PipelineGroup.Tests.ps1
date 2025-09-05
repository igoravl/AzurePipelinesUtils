Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Write-PipelineGroupStart/End' {
    It 'writes group start and end markers' {
        $temp = [IO.Path]::GetTempFileName()
        try {
            Start-Transcript -Path $temp -Force | Out-Null
            Write-PipelineGroupStart -Text 'Build Phase'
            Write-PipelineGroupEnd
            Stop-Transcript | Out-Null

            $content = Get-Content -Path $temp -Raw

            $content | Should Match '##\[group\]\[\d{2}:\d{2}:\d{2}\.\d{3}\] Build Phase'
            $content | Should Match '##\[endgroup\]'
        }
        finally {
            if (Test-Path $temp) { Remove-Item $temp -Force }
        }
    }
}
