# escape=`
# FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-20190514-windowsservercore-ltsc2019
FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV AGENT_URL='https://vstsagentpackage.azureedge.net/agent/2.148.2/vsts-agent-win-x64-2.148.2.zip'
ENV DOCKER_VERSION='18.09'

WORKDIR C:\agent

# Setup Docker CLI
RUN Invoke-WebRequest `
      -UseBasicParsing `
      -OutFile docker.zip `
      -Uri https://download.docker.com/components/engine/windows-server/18.09/docker-18.09.6.zip; `
    Expand-Archive docker.zip -DestinationPath $Env:ProgramFiles -Force; `
    $env:Path = 'C:\ProgramFiles\docker;' + $env:PATH; `
    Remove-Item docker.zip;

# Setup general tools
RUN Invoke-Expression (New-Object Net.WebClient).DownloadString('https://get.scoop.sh'); `
  scoop install git;

# Setup Azure Pipelines Agent
RUN Invoke-WebRequest `
      -OutFile C:\agent\agent.zip `
      -Uri $env:AGENT_URL `
      -UseBasicParsing; `
    Expand-Archive `
      -Path agent.zip `
      -Destination C:\agent; `
    Remove-Item agent.zip;

# Copy startup script into container
COPY start.ps1 .

# Run startup script on initialization
CMD .\start.ps1