Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Add-PipelinePath' {
    It 'prepends path locally when not in pipeline context' {
        $temp = New-Item -ItemType Directory -Path (Join-Path $env:TEMP "apitest") -Force
        $file = Join-Path $temp.FullName 'dummy.txt'
        Set-Content -Path $file -Value 'x'
        Add-PipelinePath -Path $temp.FullName
        $env:PATH.Split([IO.Path]::PathSeparator)[0] | Should Be $temp.FullName
    }
}
