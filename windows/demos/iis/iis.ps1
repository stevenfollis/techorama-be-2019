For ($i=1; $i -le 5; $i++) {

  # Create 5 containers running IIS
  docker run --detach --publish 80 mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2016 | 

  # Open browser tab for each IIS container instance
  ForEach-Object { Start-Process "http://$(docker inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}' $_ )" }

}