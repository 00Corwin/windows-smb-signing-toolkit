<#
.SYNOPSIS
    Enables or disables mandatory SMB signing on the local Windows computer.

.DESCRIPTION
    Intended for lab, pilot, validation or emergency rollback scenarios.
    In centrally managed environments, Group Policy or MDM should normally be
    the source of truth.

.PARAMETER RequireSigning
    $true to require signing for SMB client and server; $false to stop
    requiring it.

.EXAMPLE
    .\Set-SmbSigningRequirement.ps1 -RequireSigning $true -WhatIf
#>

[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory)]
    [bool]$RequireSigning
)

$Action = if ($RequireSigning) { 'Require SMB signing' } else { 'Stop requiring SMB signing' }

if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, $Action)) {
    Set-SmbClientConfiguration -RequireSecuritySignature $RequireSigning -Force
    Set-SmbServerConfiguration -RequireSecuritySignature $RequireSigning -Force

    $Client = Get-SmbClientConfiguration
    $Server = Get-SmbServerConfiguration

    [PSCustomObject]@{
        ComputerName                   = $env:COMPUTERNAME
        ClientRequireSecuritySignature = $Client.RequireSecuritySignature
        ServerRequireSecuritySignature = $Server.RequireSecuritySignature
    }
}
