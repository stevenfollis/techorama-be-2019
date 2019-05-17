# Check if required variables are present
if (!$env:AZP_URL) { Write-Host "The AZP_URL environment variable is null. Please adjust before continuing"; exit 1; }
if (!$env:AZP_TOKEN) { Write-Host "The AZP_TOKEN environment variable is null. Please adjust before continuing"; exit 1; }
if (!$env:AZP_POOL) { $env:AZP_POOL='Default' }

# ===============================
# Configure Azure Pipelines Agent
# ===============================
.\config.cmd `
  --unattended `
  --url "${env:AZP_URL}" `
  --auth PAT `
  --token "${env:AZP_TOKEN}" `
  --pool "${env:AZP_POOL}" `
  --replace `
  --acceptTeeEula

# ==============================
# Run Azure Pipelines Agent
# ==============================
.\run.cmd