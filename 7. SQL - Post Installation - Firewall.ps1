# Parameters
$VerbosePreference = "Continue";
$ComputerName = $env:COMPUTERNAME;

$services = Get-Service -ComputerName $ComputerName -Name *sql*;

$counter = 0;
$isFound = $false;
# Check if any DatabaseEngine SQLService is found
foreach ($srv in $services) {
  if ($_.DisplayName -match "^SQL Server \(\w+\)$") {$isFound = $true; break; }
}

# Loop through DatabaseEngine Services, and open ports
foreach ($svc in $services) {
  # reset PortNo
  $pSqlPortNo = 1433;
  if ($svc.DisplayName -match "^SQL Server \((?'InstanceName'\w+)\)$") {
    $pInstanceName = $Matches['InstanceName'];

    # Increment Counter
    if ($pInstanceName -ne 'MSSQLSERVER') {
      $counter += 1;
      $pSqlPortNo -= $counter;
    }

    # Enabling SQL Server Ports
    $rules = Get-NetFirewallRule -DisplayName “SQL Server (MSSQLSERVER)” -ErrorAction SilentlyContinue
    if ($rules -eq $null) {
      New-NetFirewallRule -DisplayName “SQL Server ($pInstanceName)” -Direction Inbound –Protocol TCP –LocalPort $pSqlPortNo -Action allow;
      Write-Verbose "Port '$pSqlPortNo' opened for `"$pInstanceName`" instance";
    }
    else {
      Write-Verbose "Port '$pSqlPortNo' is already opened for `"$pInstanceName`" instance";
    }
  }
}

# If SQLServices are found, then open other ports as well
if ($isFound) {
  Write-Verbose "Adding Other rules";

  # Set-ExecutionPolicy -ExecutionPolicy RemoteSigned;

  #Enabling SQL Server Ports
  $ruleName = �SQL Admin Connection�;
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { New-NetFirewallRule -DisplayName $ruleName -Direction Inbound �Protocol TCP �LocalPort 1434 -Action allow; }

  $ruleName = �SQL Database Management";
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { New-NetFirewallRule -DisplayName $ruleName -Direction Inbound �Protocol UDP �LocalPort 1434 -Action allow; }

  $ruleName = �SQL Service Broker�;
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { New-NetFirewallRule -DisplayName $ruleName -Direction Inbound �Protocol TCP �LocalPort 4022 -Action allow; }

  $ruleName = �SQL Debugger/RPC�;
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { New-NetFirewallRule -DisplayName $ruleName -Direction Inbound �Protocol TCP �LocalPort 135 -Action allow; }

  <#
    #Enabling SQL Analysis Ports
    New-NetFirewallRule -DisplayName “SQL Analysis Services” -Direction Inbound –Protocol TCP –LocalPort 2383 -Action allow
    New-NetFirewallRule -DisplayName “SQL Browser” -Direction Inbound –Protocol TCP –LocalPort 2382 -Action allow
    #Enabling Misc. Applications
    New-NetFirewallRule -DisplayName “HTTP” -Direction Inbound –Protocol TCP –LocalPort 80 -Action allow
    New-NetFirewallRule -DisplayName “SSL” -Direction Inbound –Protocol TCP –LocalPort 443 -Action allow
    New-NetFirewallRule -DisplayName “SQL Server Browse Button Service” -Direction Inbound –Protocol UDP –LocalPort 1433 -Action allow
    #Enable Windows Firewall
    Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen True -AllowUnicastResponseToMulticast True
    #>
}