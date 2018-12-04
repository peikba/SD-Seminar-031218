Set-ExecutionPolicy RemoteSigned
# Import the module
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\130\Service\NavAdminTool.ps1'

# Get Information of the app
Get-NAVAppInfo -ServerInstance BC130 -Name "Payment and Reconciliation Formats (DK)"

# Uninstall the old version of the app
Uninstall-NAVApp -ServerInstance BC130 -Name "Payment and Reconciliation Formats (DK)"

# Publish the new version of the app
Publish-NAVApp -ServerInstance BC130 -path "C:\Install\Microsoft Dynamics NAV 2018 DK CU5\Extensions\FIK\FIK.app" 

# Synchronize the tenant
Sync-NAVTenant -ServerInstance BC130 

# Synchronize the app
sync-NAVApp -ServerInstance BC130 -Name "Payment and Reconciliation Formats (DK)" -Version 1.0.21836.0

# Execute the upgrade codeunits
Start-NAVAppDataUpgrade -ServerInstance BC130 -Name "Payment and Reconciliation Formats (DK)" -Version 1.0.21836.0

# Install the new version of the app
install-NAVApp -ServerInstance BC130 -Name "Payment and Reconciliation Formats (DK)" -Version 1.0.21836.0

# Unpublish the old version of the app
UnPublish-NAVApp -ServerInstance BC130 -Name "Payment and Reconciliation Formats (DK)" -Version 1.0.20348.0

