## transcripting the script log 
Start-Transcript  -path "D:\Office_Script\Scripts\transcript_log.csv" -Append -Force

# Import the Active Directory module
Import-Module ActiveDirectory

# Define the date range for user account creation, change the days perameter based on your requierments
$createdSinceDate = ((Get-Date).AddDays(-30)).Date
$OUpath = 'ou=xxx,ou=xxx,ou=xxxx,dc=xxx,DC=xxx,dc=xxx'

# Query AD and store all usrs in a variable
$allUsers = Get-ADUser -Filter {whenCreated -ge $createdSinceDate} -Properties DisplayName, SamAccountName,mail,c, co,countrycode,company,distinguishedName, extensionattribute5,employeetype,extensionattribute8,WhenCreated -SearchBase $OUpath


## Attribute value 
$newattributename = "Attribute Name"
$newvalue = "Attribute Value"
# Filter the stored users based on specific conditions
# Example: Filter users where Department is "IT" and Title is "Engineer"
#$filteredUsers = $allUsers | Where-Object {$_.co -eq "Germany"  }

# Update the attribute for matched users


start-sleep -Seconds 5

$filteredUsers = $allUsers | Where-Object {$_.company -eq "Company Name"  } #use the logic based on name or other attributes 

# Update the attribute for matched users


foreach ($user in $filteredUsers) {
        Set-ADUser -Identity $user -Replace @{ $newattributename = $newvalue }
        Write-Host "Updated germany user $($user.SamAccountName) - set to '$newValue'"
    }

Start-Sleep -Seconds 5

$filteredUsers = $allUsers | Where-Object {$_.company -eq "Company Name"  }

# Update the attribute for matched users


foreach ($user in $filteredUsers) {
    # Check if the attribute is empty (null or empty string)
        Set-ADUser -Identity $user -Replace @{ $newattributename = $newvalue }
        Write-Host "Updated germany user $($user.SamAccountName) - set to '$newValue'"
    }

Stop-Transcript


Start-Sleep -Seconds 5

exit 
