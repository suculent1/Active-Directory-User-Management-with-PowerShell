# Import the Active Directory module
Import-Module ActiveDirectory

# Set AD domain details
$domain = "yourdomain.local"
$ou = "OU=Users,DC=yourdomain,DC=local"

# Function to create a new user
function New-ADUser {
    param (
        [string]$Username,
        [string]$Password,
        [string]$GivenName,
        [string]$Surname,
        [string]$EmailAddress
    )

    # Check if user already exists
    if (Get-ADUser -Filter {SamAccountName -eq $Username} -ErrorAction SilentlyContinue) {
        Write-Host "User $Username already exists."
        return
    }

    # Create the new user
    New-ADUser -SamAccountName $Username `
               -UserPrincipalName "$Username@$domain" `
               -Name "$GivenName $Surname" `
               -GivenName $GivenName `
               -Surname $Surname `
               -EmailAddress $EmailAddress `
               -Path $ou `
               -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
               -Enabled $true

    Write-Host "User $Username created successfully."
}

# Function to update user attributes
function Update-ADUser {
    param (
        [string]$Username,
        [hashtable]$Attributes
    )

    # Get the user
    $user = Get-ADUser -Filter {SamAccountName -eq $Username}
    if ($null -eq $user) {
        Write-Host "User $Username does not exist."
        return
    }

    # Update user attributes
    Set-ADUser -Identity $user.DistinguishedName @Attributes

    Write-Host "User $Username updated successfully."
}

# Function to query user information
function Get-ADUserInfo {
    param (
        [string]$Username
    )

    # Get the user
    $user = Get-ADUser -Filter {SamAccountName -eq $Username} -Properties *
    if ($null -eq $user) {
        Write-Host "User $Username does not exist."
        return
    }

    # Display user information
    $user | Select-Object SamAccountName, GivenName, Surname, EmailAddress, Enabled
}

# Example usage
# Creating a new user
New-ADUser -Username "jdoe" `
           -Password "P@ssw0rd123" `
           -GivenName "John" `
           -Surname "Doe" `
           -EmailAddress "jdoe@yourdomain.local"

# Updating user attributes
$attributes = @{
    Title = "Senior Developer"
    Department = "IT"
    OfficePhone = "123-456-7890"
}
Update-ADUser -Username "jdoe" -Attributes $attributes

# Querying user information
Get-ADUserInfo -Username "jdoe"
