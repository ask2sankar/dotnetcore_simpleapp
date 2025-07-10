# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY dotnet_core_simpleapp/dotnet_core_simpleapp.csproj ./dotnet_core_simpleapp/
WORKDIR /src/dotnet_core_simpleapp

# Clean + Restore + Clear NuGet cache
RUN dotnet clean \
 && dotnet restore \
 && dotnet nuget locals all --clear

COPY dotnet_core_simpleapp/. .

# Publish
RUN dotnet publish -c Release -o /app/publish --no-restore

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Run as non-root user for OpenShift
USER 10001

# Expose the port (ensure this matches your Kestrel config)
EXPOSE 8080

# Set the app's URL binding (corrected URL syntax)
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "dotnet_core_simpleapp.dll"]