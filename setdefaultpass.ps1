# Import the Active Directory module
Import-Module ActiveDirectory

$OUpath = 'ou=xxxx,ou=xxx,ou=xxx,dc=xxx,DC=xxx,dc=xxx' #replace by your AD OU locations

# Get all enabled users where last logon timestamp is null
$users = Get-ADUser -Filter {Enabled -eq $true -and LastLogonTimestamp -notlike "*"} -Properties SamAccountName, LastLogonTimestamp -SearchBase $OUpath

# Loop through each user and set a default password
foreach ($user in $users) {
    # Extract parts of the SamAccountName
    $firstNameInitial = ($user.SamAccountName.Split(".")[0]).Substring(0, 1).ToUpper()
    $firstNameRest = ($user.SamAccountName.Split(".")[0]).Substring(0, 1).ToLower()
    $lastNameInitial = ($user.SamAccountName.Split(".")[1]).Substring(0, 1).ToUpper()

    # Construct the default password
    $defaultPassword = "$firstNameInitial$firstNameRest$lastNameInitial@Eu4981679!"

    # Set the user's password
    try {
        Set-ADAccountPassword -Identity $user.SamAccountName -Reset -NewPassword (ConvertTo-SecureString -String $defaultPassword -AsPlainText -Force)
        Write-Host "Password set successfully for $($user.SamAccountName)" 
    } catch {
        Write-Host "Failed to set password for $($user.SamAccountName)"
    }
}
