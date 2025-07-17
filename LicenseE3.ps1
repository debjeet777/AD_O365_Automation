Import-Module ActiveDirectory

Start-Transcript -path "D:\Office_Script\Scripts\O365_License_Assignment\log.csv"

# connect msgraph - Best you can user Azure application for uninterept login for the automation

Connect-MgGraph -ClientId f5cxxx-xxx-xxxx-xxxx-xxxxx -TenantId eaxxxx-423xxxx-xxxx-xxxx-xxxxx -CertificateThumbprint xxxxx


# Define variables
$AADGroupId = "xxxx-xxx-xxx-xxx-xxxx"  # Replace with the AAD Group ObjectId
$createdSinceDate = ((Get-Date).AddDays(-10)).Date
$OUpath = 'ou=xxx,ou=xxxx,dc=xxxx,DC=xxxx,dc=xxx'
$groupname = 'EU_LICENSES_StandardUser' #group name can be replace by your group name 

# Get users from Active Directory based on attribute
$ADUsers = Get-ADUser -Filter {whenCreated -ge $createdSinceDate} -Properties DisplayName, SamAccountName,mail,c, co,countrycode,company,distinguishedName, extensionattribute5,employeetype,extensionattribute8,WhenCreated -SearchBase $OUpath

$MatchingUsers = $ADUsers |  Where-Object {$_.extensionattribute5 -eq "employee" -or $_.extensionattribute5 -eq "contingent worker"   }


# Add each matching user to the AAD group
foreach ($User in $MatchingUsers) {

    $UPN = $User.UserPrincipalName

    try {
        # Get Azure AD user by UPN
        $AADUser = Get-MgUser -Filter "userPrincipalName eq '$UPN'"
        
        if ($AADUser -ne $null) {
            # Add user to Azure AD group
            New-MgGroupMember -GroupId $AADGroupId -DirectoryObjectId $AADUser.Id
            Write-Output "Successfully added user $UPN to the group $groupname ."
        } else {
            Write-Output "User $UPN not found in Azure AD."
        }
    } catch {
        Write-Error "Failed to add user $UPN to the group: $_"
    }
}

Start-Sleep -Seconds 5

$ADUsers = Get-ADUser -Filter * -Properties DisplayName, SamAccountName,mail,UserPrincipalName,c, co,countrycode,company,distinguishedName, extensionattribute5,employeetype,extensionattribute8,WhenCreated -SearchBase $OUpath
$MatchingUsers = $ADUsers |  Where-Object {$_.extensionattribute5 -eq "employee" -or $_.extensionattribute5 -eq "contingent worker"   } | Select-Object UserPrincipalName
$GroupName = "EU_LICENSES_StandardUser"  # Az Group Name 

# Step 3: Get the Azure AD Group
$AzureADGroup = Get-MgGroup -Filter "displayName eq '$GroupName'"
if (-not $AzureADGroup) {
    Write-Host "Azure AD group not found: $GroupName" -ForegroundColor Red
    return
}

# Step 4: Get Current Members of the Azure AD Group
$GroupMembers = Get-MgGroupMember -GroupId $AzureADGroup.Id -All
$GroupMemberUPNs = $GroupMembers | Where-Object { $_.UserPrincipalName -ne $null } | Select-Object -ExpandProperty UserPrincipalName

# Step 5: Check and Add Users to Azure AD Group
foreach ($ADUser in $MatchingUsers) {
    $UserPrincipalName = $ADUser.UserPrincipalName

    # Check if the User Exists in Azure AD
    $AzureADUser = Get-MgUser -Filter "userPrincipalName eq '$UserPrincipalName'" -ErrorAction SilentlyContinue
    if (-not $AzureADUser) {
        Write-Host "Azure AD User not found: $UserPrincipalName" -ForegroundColor Yellow
        continue
    }

    # Check Membership
    if ($GroupMemberUPNs -notcontains $UserPrincipalName) {
        try {
            # Add User to Azure AD Group
            New-MgGroupMember -GroupId $AzureADGroup.Id -DirectoryObjectId $AzureADUser.Id
            Write-Host "Added user to Azure AD group: $UserPrincipalName" -ForegroundColor Green
        } catch {
            Write-Host "Failed to add user $UserPrincipalName" -ForegroundColor Red
        }
    } else {
        Write-Host "User is already a member of the group: $UserPrincipalName" -ForegroundColor Yellow
    }
}

Write-Host "Script execution completed!" -ForegroundColor Cyan


Start-Sleep second 10

$MatchingUsers = Get-ADUser -Filter {EmployeeID -like "W*"} -Properties DisplayName, SamAccountName,mail,UserPrincipalName,c, co,countrycode,company,distinguishedName, extensionattribute5,employeetype,employeeid,extensionattribute8,WhenCreated -SearchBase $OUpath
#$MatchingUsers = $ADUsers |  Where-Object {EmployeeID -like "W*"} | Select-Object UserPrincipalName,employeeid
$GroupName = "EU_LICENSES_StandardUser"  # Az Group Name 

# Step 3: Get the Azure AD Group
$AzureADGroup = Get-MgGroup -Filter "displayName eq '$GroupName'"
if (-not $AzureADGroup) {
    Write-Host "Azure AD group not found: $GroupName" -ForegroundColor Red
    return
}

# Step 4: Get Current Members of the Azure AD Group
$GroupMembers = Get-MgGroupMember -GroupId $AzureADGroup.Id -All
$GroupMemberUPNs = $GroupMembers | Where-Object { $_.UserPrincipalName -ne $null } | Select-Object -ExpandProperty UserPrincipalName

# Step 5: Check and Add Users to Azure AD Group
foreach ($ADUser in $MatchingUsers) {
    $UserPrincipalName = $ADUser.UserPrincipalName

    # Check if the User Exists in Azure AD
    $AzureADUser = Get-MgUser -Filter "userPrincipalName eq '$UserPrincipalName'" -ErrorAction SilentlyContinue
    if (-not $AzureADUser) {
        Write-Host "Azure AD User not found: $UserPrincipalName" -ForegroundColor Yellow
        continue
    }

    # Check Membership
    if ($GroupMemberUPNs -notcontains $UserPrincipalName) {
        try {
            # Add User to Azure AD Group
            New-MgGroupMember -GroupId $AzureADGroup.Id -DirectoryObjectId $AzureADUser.Id
            Write-Host "Added user to Azure AD group: $UserPrincipalName" -ForegroundColor Green
        } catch {
            Write-Host "Failed to add user $UserPrincipalName" -ForegroundColor Red
        }
    } else {
        Write-Host "User is already a member of the group: $UserPrincipalName" -ForegroundColor Yellow
    }
}

Write-Host "Script execution completed!" -ForegroundColor Cyan


Disconnect-Graph

Stop-Transcript
