## This script only for DL Europe Employee all
start-Transcript -path "D:\Office_Script\Scripts\report.csv" -append -force 

# Import the Active Directory module
Import-Module ActiveDirectory

# Define the date range for user account creation, change the time stamp based on your preferences 
$createdSinceDate = ((Get-Date).AddDays(-30)).Date
$OUpath = 'ou=ssodrop,ou=sso,ou=emea,dc=emea,DC=nevint,dc=com'

# Query AD and store all usrs in a variable
$allUsers = Get-ADUser -Filter * -Properties DisplayName, SamAccountName,mail, co,company,distinguishedName, extensionattribute5,employeetype,extensionattribute8,WhenCreated -SearchBase $OUpath

# Filter the stored users based on specific conditions
# Example: Filter users where Department is "IT" and Title is "Engineer"
$filteredUsers = $allUsers | Where-Object {$_.extensionattribute5 -eq "employee"}

## Exchange session with app registration 

$session = Connect-ExchangeOnline -AppId xxx-xxx-xxx-xxx -CertificateThumbprint xxxxxxx -Organization "xxxx.com"


## Execute Data to the DL Germany Employee 

# Loop through each user and check if they are a member of the distribution list

foreach ($user in $filteredUsers) {
    # Check if the user is already a member - change the DL name based on yours 
    $isMember = Get-DistributionGroupMember -Identity DLname@xxx.com | Where-Object { $_.PrimarySmtpAddress -eq $user.mail }

    # If the user is not a member, add them
    if (-not $isMember) {
        Add-DistributionGroupMember -Identity DLname@xxx.com -Member $user.mail
        Write-Host "Added $($user.DisplayName) to DLname@xxx.com"
    } else {
        Write-Host "$($user.DisplayName) is already a member of DLname@xxx.com"
    }
}



Start-Sleep -Seconds 5

Disconnect-ExchangeOnline -Confirm:$false

stop-Transcript

start-Sleep -Seconds 2

Exit

