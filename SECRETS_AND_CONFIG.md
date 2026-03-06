# Configuration & Secrets Setup

## Overview
This project uses environment variables and local configuration files for database connections and other secrets.

## Development Setup

### 1. Create Local Configuration
Copy the template file to create your local development configuration:
```bash
cp appsettings.Development.template.json appsettings.Development.json
```

### 2. Update Connection String
Edit `appsettings.Development.json` and replace `YOUR_PASSWORD_HERE` with your actual SQL Server password:
```json
{
  "ConnectionStrings": {
    "Sql": "Server=localhost,1433;Database=TypeAheadDemo;User Id=sa;Password=YOUR_ACTUAL_PASSWORD;TrustServerCertificate=True;"
  }
}
```

### 3. Run the Application
```bash
dotnet run
```
ASP.NET Core automatically loads `appsettings.Development.json` when `ASPNETCORE_ENVIRONMENT=Development` (default for `dotnet run`)

### 4. Security Notes
- **Never commit** `appsettings.Development.json` - it's in `.gitignore`
- **Never commit passwords** or sensitive credentials to version control
- Use environment variables for production deployments
- Use secrets manager for sensitive local development

## Production Deployment

For production environments, use one of these approaches:

### Option 1: Environment Variables
```bash
export SQL_CONNECTION_STRING="Server=prod-server;Database=TypeAhead;User Id=user;Password=pwd;TrustServerCertificate=True;"
```

### Option 2: ASP.NET Core User Secrets (Development)
```bash
dotnet user-secrets set "ConnectionStrings:Sql" "Server=...;Password=...;"
```

### Option 3: Azure Key Vault / AWS Secrets Manager
Recommended for production - configure in your deployment pipeline.

## Files

- `appsettings.json` - Default settings (committed, no secrets)
- `appsettings.Development.template.json` - Template for local development
- `appsettings.Development.json` - Local settings (not committed - create from template)

## Key Vault Pattern
The code expects connection strings via environment variable: `${SQL_CONNECTION_STRING}`

This is resolved at runtime from:
1. `appsettings.Development.json` (development)
2. Environment variables
3. Secrets manager (production)
