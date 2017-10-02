$settings = $deployed.settings

[System.Reflection.Assembly]::LoadWithPartialName("System.Configuration")

$configs = (
	"$($env:SystemRoot)\Microsoft.NET\Framework\v2.0.50727\CONFIG\machine.config", 
	"$($env:SystemRoot)\Microsoft.NET\Framework64\v2.0.50727\CONFIG\machine.config", 
	"$($env:SystemRoot)\Microsoft.NET\Framework\v4.0.30319\Config\machine.config", 
	"$($env:SystemRoot)\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config"
)

foreach ( $config in $configs.GetEnumerator() ) {
	$configFileMap = New-Object System.Configuration.ConfigurationFileMap($config)
	$configFileMap

	$machineConfig = [System.Configuration.ConfigurationManager]::OpenMappedMachineConfiguration($configFileMap)
	$machineConfig

	Write-Host "Applying settings for $config."
	foreach ( $setting in $settings.GetEnumerator() ) {
		$machineConfig.AppSettings.Settings.Remove($setting.Name)
		$machineConfig.AppSettings.Settings.Add($setting.Name, $setting.Value)
	}

	$machineConfig.AppSettings.Settings

	Write-Host "Saving config."
	$machineConfig.Save([System.Configuration.ConfigurationSaveMode]::Modified)
}
