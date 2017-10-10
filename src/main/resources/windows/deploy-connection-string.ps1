$connectionStrings = $deployed.connectionStrings

[System.Reflection.Assembly]::LoadWithPartialName("System.Configuration")

$configs = (
    "$($env:SystemRoot)\Microsoft.NET\Framework\v4.0.30319\Config\machine.config", 
    "$($env:SystemRoot)\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config"
)

foreach ( $config in $configs.GetEnumerator() ) {
    $configFileMap = New-Object System.Configuration.ConfigurationFileMap($config)
    $machineConfig = [System.Configuration.ConfigurationManager]::OpenMappedMachineConfiguration($configFileMap)

    Write-Host "Applying Connection Strings."
    foreach ( $connectionString in $connectionStrings.GetEnumerator() ) {
        Write-Host "Applying Connection String [$($connectionString.connectionStringName)]."

        $connectionStringValue = $connectionString.connectionString
        if ($connectionString.password) {
            $connectionStringValue += ";Password=$($connectionString.password)"
        }

        $connectionStringObj = New-Object System.Configuration.ConnectionStringSettings($connectionString.connectionStringName, $connectionStringValue, $connectionString.providerName)

        $machineConfig.ConnectionStrings.ConnectionStrings.Add($connectionStringObj)
    }

    Write-Host ""
    Write-Host "Applied Connection Strings."

    Write-Host ""
    Write-Host "Saving config."
    $machineConfig.Save([System.Configuration.ConfigurationSaveMode]::Modified)
}
