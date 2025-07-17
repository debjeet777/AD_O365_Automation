# IT Automation Scripts – AD, Office 365 & More 🛠️

This repository contains a growing collection of PowerShell scripts and automation tools designed to streamline and simplify routine administrative tasks for IT environments.

## 🔧 Key Areas Covered:
- **Active Directory (AD):** User management, group policies, bulk operations, account audits, etc.
- **Office 365 (Microsoft 365):** User provisioning, license management, mailbox operations, and reporting.
- **General IT Automation:** Task scheduling, system cleanup, log analysis, and more.

## Prerequisites
Powershell 7
AD Managaement Module 
Exchange Online 
MG Graph Module 
MailKit 

## 💡 Purpose
To reduce manual workload, improve consistency, and accelerate IT operations by leveraging automation in a secure and scalable way.

## 📂 Structure (optional)
- `AD-Scripts/` – All Active Directory related automation
- `O365-Scripts/` – Office 365 / Microsoft 365 automation
- `Utils/` – Common helper scripts and modules

-Logic One: Creation AD and Exchange Accounts (Hybrid or AAD join )
- Logic Two: Set Dafalu Pass
- Logic Three: Assigning Licenses E3,E5,F3, AnySKU
- Logic Four: Litigation Hold Enabled
- Logic Five: Validate and update User AD Attributes
- Logic Six: Add user to the DL management
- Logic Seven: After all the execution moving all the suer to the right OU based on country or depertmet
- Logic Eight: Disable the Account- Pending
- Logic Nine: Move the user to the Archive OU - Pending
- Logic Ten: Disable the users and Litigation Hold, Remove the Account - Depends on the busienss Retaintion policy - Pending
- Extra : Manage Exchange online with multiple functions include - Grant Full Access: Enter a user and a shared mailbox username to grant the user Full Access to the mailbox.
          SendAs Permissions: Assign SendAs rights to allow a user to send emails as another mailbox.
          SendOnBehalf Permissions: Give a user the ability to send on behalf of another mailbox.
          Configure Out of Office: Easily set up auto-reply messages for a user’s mailbox.
          Forwarding: Set mail forwarding to another internal user or an external email address.

## 🔒 Notes
All scripts are provided as-is and intended for educational or internal use. Always test in a safe environment before deploying to production.
If you would like to have any quesries feel free to reach me. or any automation support. 

