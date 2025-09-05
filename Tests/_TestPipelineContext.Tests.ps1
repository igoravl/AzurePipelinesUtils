Import-Module "$PSScriptRoot/../out/module/AzurePipelinesUtils/AzurePipelinesUtils.psd1" -Force

InModuleScope -ModuleName 'AzurePipelinesUtils' {
    Describe '_TestPipelineContext' {
        It 'returns false when not in Azure Pipelines context' {
            $savedTfBuild = $env:TF_BUILD; $savedAgentId = $env:AGENT_ID; $savedBuildId = $env:BUILD_BUILDID
            try {
                $env:TF_BUILD = $null; $env:AGENT_ID = $null; $env:BUILD_BUILDID = $null
                (_TestPipelineContext) | Should -Be $false
            } finally { $env:TF_BUILD = $savedTfBuild; $env:AGENT_ID = $savedAgentId; $env:BUILD_BUILDID = $savedBuildId }
        }
        It 'returns true when TF_BUILD is set' {
            $savedTfBuild = $env:TF_BUILD
            try { $env:TF_BUILD = 'true'; (_TestPipelineContext) | Should -Be $true } finally { $env:TF_BUILD = $savedTfBuild }
        }
    }
}
