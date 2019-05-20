#<#
#.Synopsis
#	Create and install gMSA + Credential Spec
#.Description
#	This script sets up a Group Managed Service Account (gMSA) within Active Directory 
#   and generates a Credential Spec file for use with Docker Containers
#.Author
#   Steven Follis (steven.follis@docker.com)
##>

# Install Remote Server Admin Tools (RSAT) Pre-Requisite
Add-WindowsFeature RSAT-AD-PowerShell

# Load Active Directory commandlets
Import-Module ActiveDirectory

# Setup AD's Key Distribution Service (Only run once)
# Add-KdsRootKey -EffectiveTime ((get-date).addhours(-10));

# Create Group Managed Service Account (gMSA)
# Ensure Worker Nodes are added to the AD group named "Windows Worker Nodes"
# Check via Get-ADGroupMember -Identity "Windows Worker Nodes"
New-ADServiceAccount `
    -Name "jobs-gmsa" `
    -DNSHostName "jobs-gmsa.dckr.org" `
    -PrincipalsAllowedToRetrieveManagedPassword "CN=Windows Worker Nodes,OU=Groups,OU=DOCKER,DC=dckr,DC=org" `
    -ServicePrincipalNames "HTTP/jobs-gmsa", "HTTP/jobs-gmsa.dckr.org"

# Ensure account was created
Get-ADServiceAccount -Identity "jobs-gmsa"

# Install and test service account onto each worker node
# If you get an Access Denied error, restart the node
# Also ensure installation is run via a terminal with Administrator privs
Install-ADServiceAccount -Identity "jobs-gmsa"

# Download PowerShell commandlet from Microsoft
Invoke-WebRequest `
    -UseBasicParsing `
    -Uri "https://raw.githubusercontent.com/MicrosoftDocs/Virtualization-Documentation/live/windows-server-container-tools/ServiceAccounts/CredentialSpec.psm1" `
    -OutFile CredentialSpec.psm1

# Import module
Import-Module .\CredentialSpec.psm1

# Create a new Credential Spec file
New-CredentialSpec `
    -Name jobs-gmsa-cred-spec `
    -AccountName jobs-gmsa `
    -Domain $(Get-ADDomain -Current LocalComputer)

# View contents of the Cred Spec file
Get-Content -Path "C:\ProgramData\docker\credentialspecs\jobs-gmsa-cred-spec.json"

# Run container with Cred Spec
docker run `
    --name jobs `
    -d `
    --publish 8080 `
    --hostname jobs-gmsa `
    --security-opt "credentialspec=file://jobs-gmsa-cred-spec.json" `
    jobs

Start-Process "http://$(docker inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}' jobs ):8080"

# Done
