# Download AdventureWorks sample database
New-Item `
  -ItemType Directory `
  -Path C:\demos\sql;

Invoke-WebRequest `
  -OutFile C:\demos\sql\AdventureWorks.bak `
  -Uri https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2012.bak `
  -UseBasicParsing;

# Build WS2019 image 
docker build --tag sql .\build 

# Create a container running SQL Server
docker run `
  --detach `
  --publish 1433:1433 `
  --env ACCEPT_EULA=y `
  --env SA_PASSWORD=Docker123 `
  --name sql `
  --volume C:\demos\sql:C:\data `
  sql

# Get IP address
docker inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}' sql