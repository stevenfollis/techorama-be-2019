ARG BASE_BUILD_IMAGE
ARG BASE_BUILD_IMAGE_TAG
ARG BASE_RUNTIME_IMAGE
ARG BASE_RUNTIME_IMAGE_TAG

FROM ${BASE_BUILD_IMAGE}:${BASE_BUILD_IMAGE_TAG} AS build
# FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY aspnetapp/*.csproj ./aspnetapp/
RUN dotnet restore

# copy everything else and build app
COPY aspnetapp/. ./aspnetapp/
WORKDIR /app/aspnetapp
RUN dotnet publish -c Release -o out

FROM ${BASE_RUNTIME_IMAGE}:${BASE_RUNTIME_IMAGE_TAG} as runtime
# FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
EXPOSE 80
WORKDIR /app
COPY --from=build /app/aspnetapp/out ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
