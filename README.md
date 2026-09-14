# Windows SMB Signing Toolkit

A small PowerShell toolkit for auditing and validating SMB signing on Windows
servers and workstations.

## Included scripts

- `Get-SmbSigningStatus.ps1` reports local client/server settings.
- `Invoke-SmbSigningAudit.ps1` runs the same checks remotely against a text
  file of computers and exports a CSV.
- `Set-SmbSigningRequirement.ps1` can require or stop requiring signing
  locally and supports `-WhatIf`.

## Recommended deployment model

For an enterprise rollout, use Group Policy or your configuration-management
platform as the source of truth. The local setter is intended for lab testing,
pilots, troubleshooting, validation, or a controlled emergency rollback.

## Examples

```powershell
.\scripts\Invoke-SmbSigningAudit.ps1 `
  -ServersPath .\examples\servers.example.txt

.\scripts\Set-SmbSigningRequirement.ps1 `
  -RequireSigning $true `
  -WhatIf
```

Review legacy SMB clients, scan-to-folder workflows, backup applications, NAS
devices, and application shares before enforcing mandatory signing broadly.
