# Przewodnik Rozwiązywania Problemów

## Typowe Problemy i Rozwiązania

### 1. Docker nie jest zainstalowany lub nie działa

**Symptom:** `docker: command not found` lub `The Docker daemon is not running`

**Rozwiązanie:**
- Pobierz Docker Desktop z https://www.docker.com/products/docker-desktop
- Zainstaluj i uruchom Docker Desktop
- Uruchom ponownie terminal/PowerShell po instalacji

### 2. Port już w użyciu

**Symptom:** 
```
Error response from daemon: Ports are not available: exposing port TCP 0.0.0.0:3000
```

**Rozwiązanie:**
Zmień porty w pliku `.env`:
```env
NEXTJS_PORT=3005
STUDIO_PORT=3006
POSTGRES_PORT=5433
```

### 3. Baza danych nie startuje

**Symptom:** Kontener `postgres` nie startuje lub pokazuje błędy

**Sprawdź logi:**
```bash
docker-compose logs postgres
```

**Rozwiązania:**
- Upewnij się, że hasło w `.env` jest poprawne i bezpieczne
- Spróbuj usunąć stary wolumin danych:
  ```bash
  docker-compose down -v
  docker-compose up -d
  ```

### 4. Next.js nie buduje się

**Symptom:** 
```
failed to build
ERR! code ERESOLVE
```

**Rozwiązania:**
- Usuń `node_modules` i zaczynaj od nowa:
  ```bash
  docker-compose down
  docker system prune
  docker-compose up -d --build
  ```

### 5. Strona ładuje się, ale bez stylów

**Symptom:** http://localhost:3000 działa, ale wygląda źle

**Rozwiązanie:** To normalne dla prostej aplikacji bez CSS framework'ów. Dodaj CSS w `pages/_app.js`:
```javascript
import '../styles/globals.css'
```

### 6. Supabase Studio nie otwiera się

**Symptom:** http://localhost:3001 się nie ładuje

**Sprawdź:**
```bash
docker-compose logs supabase-studio
```

**Rozwiązanie:**
- Poczekaj 30 sekund na pełny startup
- Sprawdź czy port 3001 jest wolny
- Spróbuj: `docker-compose restart supabase-studio`

### 7. Błąd połączenia z bazą danych

**Symptom:** Błędy dotyczące połączenia PostgreSQL

**Sprawdzenie dostału:**
```bash
docker-compose ps
```

Upewnij się, że wszystkie kontenery mają status `Up`:
```
NAME                COMMAND                  STATUS
nextjs-app          "node server.js"         Up
postgres            "docker-entrypoint..."   Up
supabase-studio     "docker-entrypoint..."   Up
```

### 8. Zmiana kodu nie jest widoczna

**Problem:** Po edycji plików nie widać zmian

**Rozwiązanie:** Rebuild kontenera:
```bash
docker-compose up -d --build
```

### 9. Wolne działanie/wysokie użycie zasobów

**Symptom:** CPU/RAM macie maksimum, aplikacja wolna

**Rozwiązania:**
- Przydziel więcej zasobów Dockerowi (Docker Desktop Settings)
- Zmniejsz logi: `docker-compose logs --tail=10`
- Sprawdź czy nie uruchamiasz wielu instancji:
  ```bash
  docker ps -a
  ```

### 10. SSH/Terminal problemy na Windows

**Problem:** `start.ps1` nie uruchamia się

**Rozwiązanie 1 - Bypass (tymczasowo):**
```powershell
powershell -ExecutionPolicy Bypass -File start.ps1
```

**Rozwiązanie 2 - Zgoda na skrypty:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Rozwiązanie 3 - Użyj CMD:**
```cmd
start.bat
```

## Debug Polecenia

### Sprawdzenie statusu kontenerów
```bash
docker-compose ps
```

### Przeglądanie logów
```bash
# Wszystkie
docker-compose logs

# Tylko Next.js
docker-compose logs nextjs

# Tylko baza
docker-compose logs postgres

# Ostatnie 50 linii
docker-compose logs --tail=50

# Na bieżąco
docker-compose logs -f
```

### Wejście do kontenera
```bash
# Do kontenera Next.js
docker-compose exec nextjs sh

# Do bazy danych
docker-compose exec postgres psql -U postgres -d postgres
```

### Restart usługi
```bash
docker-compose restart

docker-compose restart nextjs
```

### Pełne wyczyszczenie
```bash
docker-compose down -v
docker system prune -a
docker-compose up -d --build
```

## Zaawansowane Kroki

### Sprawdzenie konfiguracji Docker
```bash
docker info
```

### Statystyki kontenerów
```bash
docker stats
```

### Inspekcja kontenera
```bash
docker inspect nextjs-app
```

### Limit zasobów kontenera
W `docker-compose.yml` dodaj:
```yaml
services:
  nextjs:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
```

## System Operacyjny - Specyficzne Problemy

### Windows
- Upewnij się że masz WSL2 (Windows Subsystem for Linux 2)
- Docker Desktop Settings > Resources > WSL integration

### macOS
- Jeśli używasz M1/M2 chip, może być potrzeba ARM64 image'ów
- Docker Desktop powinien to obsługiwać automatycznie

### Linux
- Musisz zainstalować `docker-compose`:
  ```bash
  sudo apt-get install docker-compose
  ```
- Lub użyj nowej wersji: `docker compose` (bez myślnika)

## Gdy Wszystko Zawiedzie

1. **Pełny restart:**
   ```bash
   docker-compose down -v
   docker system prune -a -f
   docker-compose up -d --build
   ```

2. **Sprawdź logi:**
   ```bash
   docker-compose logs > debug.log
   ```

3. **Zweryfikuj konfigurację:**
   - `.env` istnieje
   - `docker-compose.yml` ma poprawny syntax YAML
   - Porty nie są zablokowane

4. **Jeśli dalej nie działa:**
   - Upewnij się że Docker is fully started
   - Restart komputera
   - Reinstall Docker
   - Poszukaj błędu w dziennikach i Google'u

## Przydatne Linki

- Docker Documentation: https://docs.docker.com/
- Docker Compose: https://docs.docker.com/compose/
- Next.js: https://nextjs.org/docs
- Supabase: https://supabase.io/docs
