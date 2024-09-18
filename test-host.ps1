# Security Test script written for COIT11241 Subject
# Assignment 2
# Tevin Herath
# # Acknowledgment: Some copntent of this script was generated using ChatGPT 
# ----------------------------------------------------------------
# Check if the script is run with Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "Please run this script as Administrator!"
    exit
}

# Menu to choose between testing file existence and antivirus status
Write-Host "Choose an option:"
Write-Host "1. Check Open Firewall Ports"
Write-Host "2. Check Windows Defender Antivirus status"
Write-Host "3. Exit"
$choice = Read-Host "Enter your choice (1/2)"

# Check open ports
function Get-OpenFirewallPorts {
    # Get the list of all inbound firewall rules
    $rules = Get-NetFirewallRule | Where-Object { $_.Enabled -eq 'True' }

    # Initialize an array to store open ports
    $openPorts = @()

    # Iterate through each rule
    foreach ($rule in $rules) {
        # Get the associated port information
        $portFilters = Get-NetFirewallPortFilter -AssociatedNetFirewallRule $rule

        foreach ($filter in $portFilters) {
            # Create a custom object for each port
            $openPorts += [PSCustomObject]@{
                RuleName = $rule.DisplayName
                Direction = $rule.Direction
                Action = $rule.Action
                LocalPorts = $filter.LocalPort
                RemotePorts = $filter.RemotePort
            }
        }
    }

    # Return the list of open ports
    return $openPorts
}

# Function to check Windows Defender Antivirus status
function Test-AntivirusStatus {
    Write-Host "Checking Windows Defender Antivirus status..."

    # Get the status of the Windows Defender service
    $service = Get-Service -Name "WinDefend" -ErrorAction SilentlyContinue

    if ($service.Status -eq 'Running') {
        Write-Host "Windows Defender Antivirus is running."
    } else {
        Write-Host "Windows Defender Antivirus is not running."
    }

    # Get the Windows Defender antivirus status
    $defenderStatus = Get-MpComputerStatus

    Write-Host "Real-Time Protection Enabled: " $defenderStatus.RealTimeProtectionEnabled
    Write-Host "Antivirus Enabled: " $defenderStatus.AntivirusEnabled
    Write-Host "Quick Scan Status: " $defenderStatus.LastQuickScanStatus
    Write-Host "Full Scan Status: " $defenderStatus.LastFullScanStatus
    Write-Host "Last Threat Status: " $defenderStatus.LastThreatStatus

    # Trigger a quick scan if required
    $runScan = Read-Host "Would you like to run a quick scan? (y/n)"
    if ($runScan -eq "y") {
        Write-Host "Starting a quick scan..."
        Start-MpScan -ScanType QuickScan
    }
}

# Execute based on the user's choice
switch ($choice) {
    1 {
        Get-OpenFirewallPorts | Format-Table -AutoSize
    }
    2 {
        Test-AntivirusStatus
    }
    3 {
    Write-Host "See you Later!"
        exit
    }
    default {
        Write-Host "Invalid option selected!"
        exit
    }
}
