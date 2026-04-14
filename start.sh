#!/bin/bash
# Quick Start Script for macOS/Linux

echo ""
echo "===================================="
echo "Next.js + Supabase Self-Hosting"
echo "===================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed"
    echo "Please install Docker from https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo "Docker found: $(docker --version)"

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    # Try with 'docker compose' (new syntax)
    if ! docker compose --version &> /dev/null; then
        echo "ERROR: Docker Compose is not installed"
        exit 1
    fi
    COMPOSE_CMD="docker compose"
else
    COMPOSE_CMD="docker-compose"
fi

echo "Docker Compose found"
echo ""

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
    echo ""
    echo "IMPORTANT: Edit .env file and change POSTGRES_PASSWORD to a secure value!"
    echo ""
fi

echo "Building and starting containers..."
$COMPOSE_CMD up -d

echo ""
echo "Waiting for services to start (20 seconds)..."
sleep 20

echo ""
echo "===================================="
echo "Services Started!"
echo "===================================="
echo ""
echo "Next.js App:     http://localhost:3000"
echo "Supabase Admin:  http://localhost:3001"
echo "Database:        localhost:5432"
echo ""
echo "To view logs:    $COMPOSE_CMD logs -f"
echo "To stop:         $COMPOSE_CMD down"
echo ""
