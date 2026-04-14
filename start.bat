@echo off
REM Quick Start Script for Windows (CMD)

echo.
echo ====================================
echo Next.js + Supabase Self-Hosting
echo ====================================
echo.

REM Check if Docker is installed
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker is not installed or not in PATH
    echo Please install Docker Desktop from https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo Checking Docker...
docker --version
echo Docker Compose...
docker-compose --version

echo.
echo Preparing environment...

REM Check if .env file exists
if not exist ".env" (
    echo Creating .env file from .env.example...
    copy .env.example .env
    echo.
    echo IMPORTANT: Edit .env file and change POSTGRES_PASSWORD to a secure value!
    echo.
)

echo.
echo Building and starting containers...
docker-compose up -d

echo.
echo Waiting for services to start (20 seconds)...
timeout /t 20 /nobreak

echo.
echo ====================================
echo Services Started!
echo ====================================
echo.
echo Next.js App:     http://localhost:3000
echo Supabase Admin:  http://localhost:3001
echo Database:        localhost:5432
echo.
echo To view logs:    docker-compose logs -f
echo To stop:         docker-compose down
echo.
pause
