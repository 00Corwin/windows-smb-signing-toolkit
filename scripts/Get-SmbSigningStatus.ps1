<#
.SYNOPSIS
    Reports SMB client and server signing configuration on the local computer.
#>

[CmdletBinding()]
param()

$Client = Get-SmbClientConfiguration
$Server = Get-SmbServerConfiguration

[PSCustomObject]@{
    ComputerName                   = $env:COMPUTERNAME
    ClientEnableSecuritySignature  = $Client.EnableSecuritySignature
    ClientRequireSecuritySignature = $Client.RequireSecuritySignature
    ServerEnableSecuritySignature  = $Server.EnableSecuritySignature
    ServerRequireSecuritySignature = $Server.RequireSecuritySignature
}
