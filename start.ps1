#!/usr/bin/env pwsh
# Quick Start Script for Windows (PowerShell)

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "Next.js + Supabase Self-Hosting" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is installed
try {
    docker --version | Out-Null
    Write-Host "Docker found" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Docker is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Docker Desktop from https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check Docker Compose
try {
    docker-compose --version | Out-Null
    Write-Host "Docker Compose found" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Docker Compose is not installed" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "Creating .env file from .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host ""
    Write-Host "IMPORTANT: Edit .env file and change POSTGRES_PASSWORD to a secure value!" -ForegroundColor Red
    Write-Host ""
}

Write-Host "Building and starting containers..." -ForegroundColor Yellow
docker-compose up -d

Write-Host ""
Write-Host "Waiting for services to start (20 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "Services Started!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next.js App:     http://localhost:3000" -ForegroundColor Cyan
Write-Host "Supabase Admin:  http://localhost:3001" -ForegroundColor Cyan
Write-Host "Database:        localhost:5432" -ForegroundColor Cyan
Write-Host ""
Write-Host "To view logs:    docker-compose logs -f" -ForegroundColor Yellow
Write-Host "To stop:         docker-compose down" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to continue"
