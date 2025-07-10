# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY ["*.csproj", "./"]
RUN dotnet restore

# Copy everything else and build
COPY . .
RUN dotnet publish -c Release -o /app/publish --no-restore

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# OpenShift: run as non-root user
USER 10001

# Expose port (change if your app uses a different port)
EXPOSE 8080

ENV ASPNETCORE_URLS=http:/MyfirstApp/+:8080

ENTRYPOINT ["dotnet", "dotnet_core_simpleapp.dll"]