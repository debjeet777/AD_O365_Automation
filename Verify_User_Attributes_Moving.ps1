Start-Transcript -Path "D:\Office_Script\Scripts\transcript.csv" -Append -Force

## This script move user to the germany OU if attributed matched 


# Import the Active Directory module
Import-Module ActiveDirectory

# Define the date range for user account creation
$createdSinceDate = ((Get-Date).AddDays(-60)).Date
$OUpath = 'ou=xxx,ou=xxx,ou=xxx,dc=xxx,DC=xxx,dc=xxx'
$targetOU = 'ou=xxx,ou=xxx,ou=xxx,dc=xxx,dc=xxx,dc=xxx'

# Query AD and store all usrs in a variable
$allUsers = Get-ADUser -Filter * -Properties DisplayName, SamAccountName,mail, co,company,c,distinguishedName, extensionattribute5,employeetype,extensionattribute8,countryCode,WhenCreated -SearchBase $OUpath

# Filter the stored users based on specific conditions
# Example: Filter users where Department is "IT" and Title is "Engineer"
$filteredUsers = $allUsers | Where-Object {$_.co -eq "Attribute Value" -and $_.countryCode -eq "Attribute Value" -and $_.extensionattribute5 -eq "Attribute Value" -and $_.extensionattribute8 -eq "Attribute Value" -and $_.company -eq "Attribute Value"}

# $filteredUsers | Export-Csv -Path "C:\Users\admin.dghosh\Desktop\Script\data.csv" 



# Loop through each user in the variable
foreach ($adUser in $filteredUsers) {
            # Move the user to the target OU
            Move-ADObject -Identity $adUser.DistinguishedName -TargetPath $targetOU
            Write-Host "Moved $($adUser.SamAccountName) to $targetOU)"
        } 

Start-Sleep -Seconds 5

$filteredUsers = $allUsers | Where-Object {$_.co -eq "Attribute Value" -and $_.countryCode -eq "Attribute Value" -and $_.extensionattribute5 -eq "Attribute Value" -and $_.extensionattribute8 -eq "Attribute Value" -and $_.company -eq "Attribute Value"}

# $filteredUsers | Export-Csv -Path "C:\Users\admin.dghosh\Desktop\Script\data.csv" 



# Loop through each user in the variable
foreach ($adUser in $filteredUsers) {
            # Move the user to the target OU
            Move-ADObject -Identity $adUser.DistinguishedName -TargetPath $targetOU
            Write-Host "Moved $($adUser.SamAccountName) to $targetOU)"
        }

Stop-Transcript 



