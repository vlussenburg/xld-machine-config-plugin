$connectionStrings = $deployed.connectionStrings

[System.Reflection.Assembly]::LoadWithPartialName("System.Configuration")

$machineConfigs = Get-MachineConfigManagers

foreach ( $machineConfig in $machineConfigs.GetEnumerator() ) {

    Write-Host "Removing Connection Strings."
    foreach ( $connectionString in $connectionStrings.GetEnumerator() ) {
        Write-Host "Remove Connection String [$($connectionString.connectionStringName)]."

        $connectionStringObj = New-Object System.Configuration.ConnectionStringSettings($connectionString.connectionStringName, "", "")
        $machineConfig.ConnectionStrings.ConnectionStrings.Remove($connectionStringObj)
    }

    Write-Host ""
    Write-Host "Saving config."
    $machineConfig.Save([System.Configuration.ConfigurationSaveMode]::Modified)
}
