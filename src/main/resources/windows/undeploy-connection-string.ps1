$connectionStrings = $deployed.connectionStrings

[System.Reflection.Assembly]::LoadWithPartialName("System.Configuration")

$configs = (
	"$($env:SystemRoot)\Microsoft.NET\Framework\v2.0.50727\CONFIG\machine.config", 
	"$($env:SystemRoot)\Microsoft.NET\Framework64\v2.0.50727\CONFIG\machine.config", 
	"$($env:SystemRoot)\Microsoft.NET\Framework\v4.0.30319\Config\machine.config", 
	"$($env:SystemRoot)\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config"
)

foreach ( $config in $configs.GetEnumerator() ) {
	$configFileMap = New-Object System.Configuration.ConfigurationFileMap($config)

	$machineConfig = [System.Configuration.ConfigurationManager]::OpenMappedMachineConfiguration($configFileMap)

	Write-Host "Removing Connection Strings."
	foreach ( $connectionString in $connectionStrings.GetEnumerator() ) {
		Write-Host "Remove Connection String [$connectionString.connectionStringName]."
		$connectionStringObj = New-Object System.Configuration.ConnectionStringSettings($connectionString.connectionStringName, $connectionString.connectionString, $connectionString.providerName)
		$connectionStringObj
		$machineConfig.ConnectionStrings.ConnectionStrings.Remove($connectionStringObj)
	}

	Write-Host ""
	Write-Host "Saving config."
	$machineConfig.Save([System.Configuration.ConfigurationSaveMode]::Modified)
}
