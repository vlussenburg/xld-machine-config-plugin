$settings = $deployed.settings

[System.Reflection.Assembly]::LoadWithPartialName("System.Configuration")

$machineConfigs = Get-MachineConfigManagers

foreach ( $machineConfig in $machineConfigs.GetEnumerator() ) {

	Write-Host "Applying settings for $config."
	foreach ( $setting in $settings.GetEnumerator() ) {
		$machineConfig.AppSettings.Settings.Remove($setting.Name)
		$machineConfig.AppSettings.Settings.Add($setting.Name, $setting.Value)
	}

	$machineConfig.AppSettings.Settings

	Write-Host "Saving config."
	$machineConfig.Save([System.Configuration.ConfigurationSaveMode]::Modified)
}
