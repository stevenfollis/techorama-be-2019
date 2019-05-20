# escape=`
# FROM microsoft/aspnet:4.7.2-windowsservercore-ltsc2016
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.7.2-windowsservercore-ltsc2019
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Remove-Website 'Default Web Site'

RUN Enable-WindowsOptionalFeature -Online -All -FeatureName `
    IIS-ApplicationDevelopment, `
    IIS-CommonHttpFeatures, `
    IIS-DefaultDocument, `
    IIS-DirectoryBrowsing, `
    IIS-HealthAndDiagnostics, `
    IIS-HttpCompressionStatic, `
    IIS-HttpErrors, `
    IIS-HttpLogging, `
    IIS-ISAPIExtensions, `
    IIS-ISAPIFilter, `
    IIS-Performance, `
    IIS-RequestFiltering, `
    IIS-Security, `
    IIS-StaticContent, `
    IIS-WebServer, `
    IIS-WebServerRole

EXPOSE 8080

# Create and configure app pools
RUN Import-Module WebAdministration ; `
    New-Item -Path 'IIS:\AppPools\JobsAppPool' ; `
    Set-ItemProperty -Path 'IIS:\AppPools\JobsAppPool' -Name processModel -Value @{identitytype='ApplicationPoolIdentity'}

# Copy physical paths
COPY Jobs C:\Jobs

# Set ACLs
RUN $path='C:\Jobs' ; `
    $acl = Get-Acl $path ; `
    $newOwner = [System.Security.Principal.NTAccount]('BUILTIN\IIS_IUSRS') ; `
    $acl.SetOwner($newOwner) ; `
    dir -r $path | Set-Acl -aclobject  $acl

# Initialize website
RUN New-Item -Path 'C:\Jobs' -Type Directory -Force ; `
    New-Website -Name 'Jobs' -PhysicalPath 'C:\Jobs' -IP '*' -Port 8080 -ApplicationPool 'JobsAppPool' -Force

