$connectionStrings = $deployed.connectionStrings

[System.Reflection.Assembly]::LoadWithPartialName("System.Configuration")

$machineConfigs = Get-MachineConfigManagers

foreach ( $machineConfig in $machineConfigs.GetEnumerator() ) {

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
