# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["hello-world-dotnet.csproj", "."]
RUN dotnet restore "./dotnet-repo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./dotnet-repo.csproj" -c ${BUILD_CONFIGURATION} -o /app/build
# Stage 2: Publish the application
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./dotnet-repo.csproj" -c ${BUILD_CONFIGURATION} -o /app/publish /p:UseAppHost=false
# Stage 3: Final image with application files (runtime environment)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
COPY --from=publish /app/publish .
# Expose ports (if needed by your application)
EXPOSE 8080
EXPOSE 8081
# Command to run the application
ENTRYPOINT ["dotnet", "hello-world-dotnet.dll"]
