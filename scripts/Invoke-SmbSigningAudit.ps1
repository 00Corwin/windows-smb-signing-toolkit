<#
.SYNOPSIS
    Audits SMB signing configuration across a list of Windows computers.

.PARAMETER ServersPath
    Text file containing one computer name per line.

.PARAMETER OutputPath
    CSV report path.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$ServersPath,

    [string]$OutputPath = ".\SMBSigning_Audit_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
)

$Servers = @(
    Get-Content -Path $ServersPath |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -and -not $_.StartsWith('#') } |
        Sort-Object -Unique
)

if ($Servers.Count -eq 0) {
    throw "No server names were found in '$ServersPath'."
}

$Results = foreach ($ComputerName in $Servers) {
    try {
        Invoke-Command -ComputerName $ComputerName -ErrorAction Stop -ScriptBlock {
            $Client = Get-SmbClientConfiguration
            $Server = Get-SmbServerConfiguration

            [PSCustomObject]@{
                ComputerName                   = $env:COMPUTERNAME
                Reachable                      = $true
                ClientEnableSecuritySignature  = $Client.EnableSecuritySignature
                ClientRequireSecuritySignature = $Client.RequireSecuritySignature
                ServerEnableSecuritySignature  = $Server.EnableSecuritySignature
                ServerRequireSecuritySignature = $Server.RequireSecuritySignature
                Error                          = $null
            }
        } | Select-Object ComputerName, Reachable,
            ClientEnableSecuritySignature, ClientRequireSecuritySignature,
            ServerEnableSecuritySignature, ServerRequireSecuritySignature, Error
    }
    catch {
        [PSCustomObject]@{
            ComputerName                   = $ComputerName
            Reachable                      = $false
            ClientEnableSecuritySignature  = $null
            ClientRequireSecuritySignature = $null
            ServerEnableSecuritySignature  = $null
            ServerRequireSecuritySignature = $null
            Error                          = $_.Exception.Message
        }
    }
}

$Results | Export-Csv -Path $OutputPath -NoTypeInformation
Write-Output "SMB signing audit written to: $OutputPath"
