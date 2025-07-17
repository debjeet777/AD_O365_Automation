Start-Transcript -Path "D:\Office_Script\Scripts\Production\AD_Others\ReleaseO365_Licenses\transcript.csv"
# Required modules
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Groups

# Authenticate using Azure AD App

Connect-MgGraph -ClientId xxxx-xxx-xxxx-xxxx -TenantId xxxx-xxxx-xxxx-xxx-xxxx -CertificateThumbprint xxxxx

# Step 1: Get AD users disabled for more than 30 days
$cutoffDate = (Get-Date).AddDays(-100)
$allusers = Get-ADUser -Filter 'Enabled -eq $false' -Properties Name,Enabled,whenChanged,Lastlogon |
    Where-Object { $_.whenChanged -lt $cutoffDate } 
$allusers | Select-Object Name,userPrincipalName,Enabled,whenChanged,Lastlogon #export-csv is option if you would like to then add the perameter

# Step 2: Get target license groups
$targetGroupNames = @("EU_LICENSES_StandardUser", "EU_LICENSES_BasicUser") #License group can be replace to yours 
$targetGroups = @{}
foreach ($groupName in $targetGroupNames) {
    $group = Get-MgGroup -Filter "displayName eq '$groupName'" -ConsistencyLevel eventual
    if ($group) {
        $targetGroups[$groupName] = $group.Id
    } else {
        Write-Warning "Group '$groupName' not found in Azure AD."
    }
}

# Step 3: Process users
foreach ($user in $allusers) {
    $userPrincipalName = "$($user.SamAccountName)@xxx.com"  # Adjust the domain name based on yours 
    try {
        $mgUser = Get-MgUser -UserId $userPrincipalName -ErrorAction Stop

        # Step 3a: Remove from license groups
        foreach ($groupName in $targetGroups.Keys) {
            $groupId = $targetGroups[$groupName]
            $isMember = Get-MgGroupMember -GroupId $groupId -All | Where-Object { $_.Id -eq $mgUser.Id }

            if ($isMember) {
                Write-Host "Removing $userPrincipalName from group $groupName"
                Remove-MgGroupMemberByRef -GroupId $groupId -DirectoryObjectId $mgUser.Id
            }
        }

        # Step 3b: Remove direct licenses
        if ($mgUser.AssignedLicenses.Count -gt 0) {
            $licenseSkuIds = $mgUser.AssignedLicenses.SkuId
            Write-Host "Removing direct licenses from $userPrincipalName"
            Set-MgUserLicense -UserId $mgUser.Id -AddLicenses @() -RemoveLicenses $licenseSkuIds
        }

    } catch {
        Write-Warning "Failed to process ${userPrincipalName}: $_"

    }
}



Start-Sleep -Seconds 10

Disconnect-Graph

