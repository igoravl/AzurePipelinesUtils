Describe 'Write-AzurePipelinesWarning' {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\Build\AzurePipelinesUtils.psd1" -Force
    }
    
    It 'writes a warning with the correct format' {
        $output = Write-AzurePipelinesWarning -Message 'Test warning'
        $output | Should -Be '##vso[task.logissue type=warning]Test warning'
    }
    
    It 'includes source path when provided' {
        $output = Write-AzurePipelinesWarning -Message 'Test warning' -SourcePath 'test.ps1'
        $output | Should -Be '##vso[task.logissue type=warning;sourcepath=test.ps1]Test warning'
    }
    
    It 'includes line number when provided' {
        $output = Write-AzurePipelinesWarning -Message 'Test warning' -LineNumber 42
        $output | Should -Be '##vso[task.logissue type=warning;linenumber=42]Test warning'
    }
    
    It 'includes both source path and line number when provided' {
        $output = Write-AzurePipelinesWarning -Message 'Test warning' -SourcePath 'test.ps1' -LineNumber 42
        $output | Should -Be '##vso[task.logissue type=warning;sourcepath=test.ps1;linenumber=42]Test warning'
    }
}

Describe 'Write-AzurePipelinesError' {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\Build\AzurePipelinesUtils.psd1" -Force
    }
    
    It 'writes an error with the correct format' {
        $output = Write-AzurePipelinesError -Message 'Test error'
        $output | Should -Be '##vso[task.logissue type=error]Test error'
    }
    
    It 'includes source path when provided' {
        $output = Write-AzurePipelinesError -Message 'Test error' -SourcePath 'test.ps1'
        $output | Should -Be '##vso[task.logissue type=error;sourcepath=test.ps1]Test error'
    }
}

Describe 'Set-AzurePipelinesVariable' {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\Build\AzurePipelinesUtils.psd1" -Force
    }
    
    It 'sets a variable with the correct format' {
        $output = Set-AzurePipelinesVariable -Name 'TestVar' -Value 'TestValue'
        $output | Should -Be '##vso[task.setvariable variable=TestVar]TestValue'
    }
    
    It 'sets a secret variable when Secret switch is used' {
        $output = Set-AzurePipelinesVariable -Name 'SecretVar' -Value 'SecretValue' -Secret
        $output | Should -Be '##vso[task.setvariable variable=SecretVar;issecret=true]SecretValue'
    }
    
    It 'sets an output variable when Output switch is used' {
        $output = Set-AzurePipelinesVariable -Name 'OutputVar' -Value 'OutputValue' -Output
        $output | Should -Be '##vso[task.setvariable variable=OutputVar;isoutput=true]OutputValue'
    }
}

Describe 'Add-AzurePipelinesBuildTag' {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\Build\AzurePipelinesUtils.psd1" -Force
    }
    
    It 'adds a build tag with the correct format' {
        $output = Add-AzurePipelinesBuildTag -Tag 'release'
        $output | Should -Be '##vso[build.addbuildtag]release'
    }
}

Describe 'Test-AzurePipelinesContext' {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\Build\AzurePipelinesUtils.psd1" -Force
    }
    
    It 'returns false when not in Azure Pipelines context' {
        # Save current environment variables
        $savedTfBuild = $env:TF_BUILD
        $savedAgentId = $env:AGENT_ID
        $savedBuildId = $env:BUILD_BUILDID
        
        try {
            # Clear Azure DevOps environment variables
            $env:TF_BUILD = $null
            $env:AGENT_ID = $null
            $env:BUILD_BUILDID = $null
            
            $result = Test-AzurePipelinesContext
            $result | Should -Be $false
        }
        finally {
            # Restore environment variables
            $env:TF_BUILD = $savedTfBuild
            $env:AGENT_ID = $savedAgentId
            $env:BUILD_BUILDID = $savedBuildId
        }
    }
}
