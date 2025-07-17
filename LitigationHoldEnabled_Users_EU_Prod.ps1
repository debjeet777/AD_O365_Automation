# Module Used for this Script 
# Install MSGRAPH
# Install Exchange Online 
# RSAT AD Management 
# DRat Module 

########Login to the Exchnage Module ######################## Executing the Script #############################

$session = Connect-ExchangeOnline -AppId xxx-xxx-xxx-xxx -CertificateThumbprint xxxxx -Organization "xxx.com"

###################Enable the Litigation Hold Based ON AD Attribute#####################If Any Account Created Last 30 Days#######################

Get-Mailbox | Where {$_.CustomAttribute8 -match "Attribute value" } | Where-Object {$_.whenCreated -ge ((Get-Date).AddDays(-30)).Date} | ForEach-Object {$Identity = $_.alias; Set-Mailbox -Identity $Identity -LitigationHoldEnabled $True }
Get-Mailbox | Where {$_.CustomAttribute8 -match "Attribute value" } | Where-Object {$_.whenCreated -ge ((Get-Date).AddDays(-30)).Date} | ForEach-Object {$Identity = $_.alias; Set-Mailbox -Identity $Identity -LitigationHoldEnabled $True }
Get-Mailbox | Where {$_.CustomAttribute8 -match "Attribute value" } | Where-Object {$_.whenCreated -ge ((Get-Date).AddDays(-30)).Date} | ForEach-Object {$Identity = $_.alias; Set-Mailbox -Identity $Identity -LitigationHoldEnabled $True }
Get-Mailbox | Where {$_.CustomAttribute8 -match "Attribute value" } | Where-Object {$_.whenCreated -ge ((Get-Date).AddDays(-30)).Date} | ForEach-Object {$Identity = $_.alias; Set-Mailbox -Identity $Identity -LitigationHoldEnabled $True }
Get-Mailbox | Where {$_.CustomAttribute8 -match "Attribute value" } | Where-Object {$_.whenCreated -ge ((Get-Date).AddDays(-30)).Date} | ForEach-Object {$Identity = $_.alias; Set-Mailbox -Identity $Identity -LitigationHoldEnabled $True }
Get-Mailbox | Where {$_.CustomAttribute8 -match "Attribute value" } | Where-Object {$_.whenCreated -ge ((Get-Date).AddDays(-30)).Date} | ForEach-Object {$Identity = $_.alias; Set-Mailbox -Identity $Identity -LitigationHoldEnabled $True }


 ##################Get the Office365 Letigation Enabled Report. Those Account created last 60 days. File Stored for Future Investigation purpose #################

Get-Mailbox | Where-Object {$_.whenCreated -ge ((Get-Date).AddDays(-30)).Date} | select name,identity,whencreated,alias,customattribute8,LitigationHoldEnabled,office | export-csv "D:\Office_Script\office365_enable_litigation_report.csv"


############################ Send The Log to The IT Team Mates ############### Information Shared ################ Using Mailkit Module ############


$sendMailMessageLH = @{
    From = 'No reply <email@email.com>'
    To = 'Name <email@email.com>'
    CC = 'Name <email@email.com>'
    Subject = 'Litigation Hold Enabled Reports - All EU New Users'
    Body = "Write Text based on you"
    Attachments = 'D:\Office_Script\office365_enable_litigation_report.csv'
    Priority = 'High'
    DeliveryNotificationOption = 'OnSuccess', 'OnFailure'
    SmtpServer = 'Smtp server address here'
}
Send-MailMessage @sendMailMessageLH

Disconnect-ExchangeOnline -Confirm $false







