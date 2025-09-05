Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Write-PipelineSection' {
    Context 'outside pipeline context' {
        BeforeAll { $script:saved=$env:TF_BUILD; $env:TF_BUILD=$null }
        AfterAll { $env:TF_BUILD=$script:saved }
        It 'writes plain header without section prefix' {
            $out = & { Write-PipelineSection -Text 'My Section' } 6>&1 | Out-String
            ($out -match '== My Section ==') | Should -Be $true
            ($out -match '##\[section\]') | Should -Be $false
        }
    }
    Context 'inside pipeline context' {
        BeforeAll { $script:saved=$env:TF_BUILD; $env:TF_BUILD='true' }
        AfterAll { $env:TF_BUILD=$script:saved }
        It 'writes section header with prefix' {
            $out = & { Write-PipelineSection -Text 'My Section' } 6>&1 | Out-String
            ($out -match '##\[section\].*== My Section ==') | Should -Be $true
        }
    }
}
