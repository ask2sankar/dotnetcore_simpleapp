# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy .csproj and restore
COPY dotnet_core_simpleapp/dotnet_core_simpleapp.csproj ./dotnet_core_simpleapp/
WORKDIR /src/dotnet_core_simpleapp
RUN dotnet restore

# Copy the rest of the source code
COPY dotnet_core_simpleapp/. .

# Publish (restore was done in this same directory)
RUN dotnet publish -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Run as non-root (for OpenShift)
USER 10001

# Set port and environment
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "dotnet_core_simpleapp.dll"]