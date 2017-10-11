<############################################################################################ 
    Get all relevant Machine Config Managers
############################################################################################>
function Get-MachineConfigManagers()
{
    [CmdletBinding()]
    param ( )
    BEGIN { }
    PROCESS
    {
        #$configs = (
        #    "$($env:SystemRoot)\Microsoft.NET\Framework\v2.0.50727\CONFIG\machine.config", 
        #    "$($env:SystemRoot)\Microsoft.NET\Framework64\v2.0.50727\CONFIG\machine.config"
        #)

        $configs = (
            "$($env:SystemRoot)\Microsoft.NET\Framework\v4.0.30319\Config\machine.config", 
            "$($env:SystemRoot)\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config"
        )

        $machineConfigs = @()
        foreach ( $config in $configs.GetEnumerator() ) {
            $configFileMap = New-Object System.Configuration.ConfigurationFileMap($config)
            $machineConfig = [System.Configuration.ConfigurationManager]::OpenMappedMachineConfiguration($configFileMap)
            $machineConfigs += $machineConfig
        }
        return $machineConfigs
    }
    END { }
}