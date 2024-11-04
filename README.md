# Active Directory Automation Projects with PowerShell

This repository contains two projects that demonstrate how to use PowerShell for managing Active Directory. The projects include user management and group management with user details export functionalities.

## Project 1: Active Directory User Management with PowerShell

### Description
This project provides a PowerShell script to automate the creation, modification, and deletion of user accounts in Active Directory.

### Prerequisites
Ensure you have the `Active Directory` module installed. You can install it using the following command if it's not already available:

```powershell
Install-WindowsFeature -Name RSAT-AD-PowerShell
Script: Active Directory User Management
powershell
Copy code
# Import the Active Directory module
Import-Module ActiveDirectory

# Function to create a new user
function New-ADUser {
    param (
        [string]$Username,
        [string]$Password,
        [string]$FirstName,
        [string]$LastName,
        [string]$OU
    )

    # Create the new user
    New-ADUser -Name "$FirstName $LastName" `
               -SamAccountName $Username `
               -UserPrincipalName "$Username@yourdomain.local" `
               -Path $OU `
               -GivenName $FirstName `
               -Surname $LastName `
               -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
               -Enabled $true

    Write-Host "User $Username created successfully."
}

# Function to modify an existing user
function Set-ADUser {
    param (
        [string]$Username,
        [hashtable]$Attributes
    )

    # Set user attributes
    Set-ADUser -Identity $Username @Attributes
    Write-Host "User $Username modified successfully."
}

# Function to delete a user
function Remove-ADUser {
    param (
        [string]$Username
    )

    # Remove the user
    Remove-ADUser -Identity $Username -Confirm:$false
    Write-Host "User $Username deleted successfully."
}

# Example usage
# Creating a new user
New-ADUser -Username "jdoe" `
           -Password "P@ssw0rd!" `
           -FirstName "John" `
           -LastName "Doe" `
           -OU "OU=Users,DC=yourdomain,DC=local"

# Modifying an existing user
Set-ADUser -Username "jdoe" -Attributes @{Title="Manager"; Department="Sales"}

# Deleting a user
Remove-ADUser -Username "jdoe"
Instructions for Running the Script
Save the script to a .ps1 file, for example, ADUserManagement.ps1.
Open PowerShell with administrative privileges.
Navigate to the directory containing the script.
Run the script using the following command:
powershell
Copy code
.\ADUserManagement.ps1
Notes
Replace yourdomain.local and paths with actual values from your Active Directory environment.
Ensure you have the necessary permissions to perform AD management tasks.