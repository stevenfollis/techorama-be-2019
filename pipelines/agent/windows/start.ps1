# https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows

# Check if required variables are present
if (!$env:AZP_URL) { Write-Host "The AZP_URL environment variable is null. Please adjust before continuing"; exit 1; }
if (!$env:AZP_TOKEN) { Write-Host "The AZP_TOKEN environment variable is null. Please adjust before continuing"; exit 1; }
if (!$env:AZP_POOL) { $env:AZP_POOL='Default' }

# ===============================
# Configure Azure Pipelines Agent
# ===============================
if(!(Test-Path -Path C:\agent\_work )) {
  
  Write-Output "No previous agent configuration detected. Configuring agent."
  
  .\config.cmd `
    --acceptTeeEula `
    --auth PAT `
    --pool "${env:AZP_POOL}" `
    --replace `
    --runAsService `
    --token "${env:AZP_TOKEN}" `
    --unattended `
    --url "${env:AZP_URL}" `
    --windowsLogonAccount "NT AUTHORITY\SYSTEM"

}

# ==============================
# Run Azure Pipelines Agent with ServiceMonitor
# ==============================
C:\ServiceMonitor.exe (Get-Service vstsagent*).Name
