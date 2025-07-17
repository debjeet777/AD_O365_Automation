Start-Transcript -path "D:\Office_Script\Scripts\transcript.csv" # replace your location based on you. where you want to store the log

# Import the Active Directory module
Import-Module ActiveDirectory
$OUPath = "OU=xx,OU=xxx,DC=xxx,DC=xxx,DC=xxx"
# Duplicate Account filtered 
$targetOU = "OU=DuplicateUsers,OU=xxx,OU=xx,DC=xxx,DC=xxx,DC=xxx"
$DuplicateAcount= Get-ADUser -Filter {(employeeID -like "*") } -property DisplayName, SAMAccountName, lastLogonTimestamp,LastLogon, Enabled,employeeID,co,company,mail,whencreated -SearchBase $OUPath |Group employeeid,co,company| ? {$_.Count -ge 2} | select -ExpandProperty group | Select-Object Enabled, ObjectClass, Name, distinguishedName, SamAccountName,lastLogonTimestamp,LastLogon, employeeID,co,company,mail,whencreated 


# Step 2: Filter users with null lastLogonTimestamp
$UsersNeverLoggedIn = $DuplicateAcount | Where-Object { 
    $_.lastLogonTimestamp -eq $null -or $_.lastLogonTimestamp -eq 0 
}

$ExportData = $UsersNeverLoggedIn | Select-Object DisplayName, SAMAccountName, DistinguishedName,lastlogintimestamp, whencreated, EmployeeID,co,company,mail,enabled

# Log accounts to be moved or deleted (optional)
$OutputFile = "D:\Office_Script\Scripts\development\duplicateaudit.csv"
$ExportData | Select-Object DisplayName, SAMAccountName, DistinguishedName,lastlogintimestamp, whencreated, EmployeeID,co,company,mail,enabled |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
Write-Output "Accounts to be deleted logged to $OutputFile."

$DuplicateUsers = import-csv "D:\Office_Script\Scripts\development\duplicateaudit.csv"

# Step 4: move these accounts - if needed you can delete those account based your organization requierments and security messure 
foreach ($User in $UsersNeverLoggedIn) {
    Write-Output "moving duplicate account: $($User.SAMAccountName) - $($User.DistinguishedName)"
    Move-ADObject -Identity $User.DistinguishedName -TargetPath $targetOU
}

Stop-Transcript


