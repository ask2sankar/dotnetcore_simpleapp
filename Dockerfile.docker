# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy csproj and restore dependencies
COPY *.sln ./
COPY dotnet_core_simpleapp/*.csproj ./dotnet_core_simpleapp/
RUN dotnet restore

# Copy the remaining source code and build the application
COPY dotnet_core_simpleapp/. ./dotnet_core_simpleapp/
WORKDIR /app/dotnet_core_simpleapp
RUN dotnet publish -c Release -o /app/publish

# Use the ASP.NET Core runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Expose the port used by the ASP.NET Core app
EXPOSE 80

# Start the application
ENTRYPOINT ["dotnet", "dotnet_core_simpleapp.dll"]