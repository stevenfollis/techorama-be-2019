# Set image name
$REGISTRY='dtr.west.us.se.dckr.org'
$IMAGE="$REGISTRY/$env:USERNAME/jobs:ltsc2019";
$USER=$env:USERNAME.replace('.', '');

# Remove running container on local machine
docker container rm --force jobs-$USER;

# Un-tag image
docker image rm $IMAGE;

# Remove generated Stack file
If (Test-Path -Path "C:\Demos\dac\docker-stack-$USER.yml") {
    Remove-Item -Path "C:\Demos\dac\docker-stack-$USER.yml" -Force;
    Write-Output "Removed generated Stack file"
}