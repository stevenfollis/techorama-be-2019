# escape=`

#=========================================================
# Stage 1: Download Docker CLI binary
#=========================================================
FROM mcr.microsoft.com/windows/servercore:ltsc2019 AS dockercli

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Invoke-WebRequest `
      -OutFile docker.zip `
      -Uri https://download.docker.com/components/engine/windows-server/18.09/docker-18.09.6.zip `
      -UseBasicParsing; `
    Expand-Archive `
      -DestinationPath 'C:\' `
      -Force `
      -Path docker.zip;

#=========================================================
# Stage 2: Download Azure DevOps Pipelines Agent
#=========================================================
FROM mcr.microsoft.com/windows/servercore:ltsc2019 AS adoagent

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV ADO_AGENT_URL='https://vstsagentpackage.azureedge.net/agent/2.148.2/vsts-agent-win-x64-2.148.2.zip'

RUN Invoke-WebRequest `
      -OutFile C:\agent.zip `
      -Uri $env:ADO_AGENT_URL `
      -UseBasicParsing; `
    Expand-Archive `
      -Destination C:\agent `
      -Force `
      -Path agent.zip;

#=========================================================
# Stage 3: Download ServiceMonitor
# https://github.com/microsoft/IIS.ServiceMonitor
#=========================================================
FROM mcr.microsoft.com/windows/servercore:ltsc2019 AS servicemonitor

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV SERVICE_MONITOR_VERSION='2.0.1.3'

RUN Invoke-WebRequest `
      -OutFile C:\ServiceMonitor.exe `
      -Uri "https://dotnetbinaries.blob.core.windows.net/servicemonitor/$Env:SERVICE_MONITOR_VERSION/ServiceMonitor.exe" `
      -UseBasicParsing;

#=========================================================
# Stage 4: Setup Azure Pipelines remote agent
#=========================================================
FROM mcr.microsoft.com/windows/servercore:ltsc2019 AS runtime

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:\agent

# Setup general tools via the Scoop package manager
RUN Invoke-Expression (New-Object Net.WebClient).DownloadString('https://get.scoop.sh'); `
    scoop install git;

# Setup Azure Pipelines Agent
COPY --from=adoagent C:\agent C:\agent

# Setup Docker CLI
COPY --from=dockercli C:\docker C:\docker

# Setup ServiceMonitor
COPY --from=servicemonitor C:\ServiceMonitor.exe C:\ServiceMonitor.exe

# Update path variable
RUN $env:PATH = 'C:\docker;' + $env:PATH; `
    Set-ItemProperty `
      -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' `
      -Name Path `
      -Value $env:PATH; 

# Copy startup script into container
COPY start.ps1 .

# Run startup script on initialization
CMD .\start.ps1
