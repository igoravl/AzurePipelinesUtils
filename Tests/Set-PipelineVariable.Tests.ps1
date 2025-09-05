Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

Describe 'Set-PipelineVariable' {
    It 'sets a variable with the correct format' {
        $output = Set-PipelineVariable -Name 'TestVar' -Value 'TestValue'
        $output | Should Be '##vso[task.setvariable variable=TestVar]TestValue'
    }
    
    It 'sets a secret variable when Secret switch is used' {
        $output = Set-PipelineVariable -Name 'SecretVar' -Value 'SecretValue' -Secret
        $output | Should Be '##vso[task.setvariable variable=SecretVar;issecret=true]SecretValue'
    }
    
    It 'sets an output variable when Output switch is used' {
        $output = Set-PipelineVariable -Name 'OutputVar' -Value 'OutputValue' -Output
        $output | Should Be '##vso[task.setvariable variable=OutputVar;isoutput=true]OutputValue'
    }
}
