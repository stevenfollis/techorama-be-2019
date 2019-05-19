ARG BASE_IMAGE_BUILD=dtr.west.us.se.dckr.org/official/dotnet-core-sdk:2.1
ARG BASE_IMAGE_RUNTIME=dtr.west.us.se.dckr.org/official/dotnet-core-aspnet:2.1

#=======================================================
# Stage 1: Use the larger SDK image to compile .NET code
#=======================================================
FROM ${BASE_IMAGE_BUILD} AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY aspnetapp/*.csproj ./aspnetapp/
RUN dotnet restore

# copy everything else and build app
COPY aspnetapp/. ./aspnetapp/
WORKDIR /app/aspnetapp
RUN dotnet publish -c Release -o out

#=========================================================
# Stage 2: Copy built artifact into the slim runtime image 
#=========================================================
FROM ${BASE_IMAGE_RUNTIME} AS runtime
EXPOSE 80
WORKDIR /app
COPY --from=build /app/aspnetapp/out ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
