# Next.js + Cloud Supabase Self-Hosting

To projekt demonstruje jak samodzielnie hostować aplikację Next.js ze zintegrowaną chmurową bazą danych Supabase za pomocą Docker.

## Wymagania

Aby uruchomić ten projekt, potrzebujesz:
- **Docker** (https://www.docker.com/)
- **Docker Compose** (zwykle instalowany razem z Dockerem)
- **Konto Supabase** (https://app.supabase.com) z istniejącym projektem

## Struktura Projektu

```
├── pages/                  # Next.js pages
│   ├── api/               # API routes
│   │   └── health.js      # Health check endpoint
│   └── index.js           # Home page
├── package.json           # Zależności projektu
├── next.config.js         # Konfiguracja Next.js
├── Dockerfile             # Dockerfile dla aplikacji Next.js
├── docker-compose.yml     # Docker Compose configuration
├── .env.example           # Szablon zmiennych środowiskowych
└── README.md             # Ten plik
```

## Jak Uruchomić

### 1. Przygotowanie

Sklonuj lub pobierz ten projekt i przejdź do katalogu:

```bash
cd test-hosting
```

### 2. Konfiguracja Zmiennych Środowiskowych

Skopiuj plik `.env.example` na `.env`:

**Na Windows (PowerShell):**
```powershell
Copy-Item .env.example .env
```

**Na Windows (CMD):**
```cmd
copy .env.example .env
```

**Na macOS/Linux:**
```bash
cp .env.example .env
```

### 3. Dodaj Dane Twojej Bazy Supabase

Edytuj plik `.env` i uzupełnij swoimi danymi:

```env
# Z https://app.supabase.com/project/[YOUR-PROJECT]/settings/database
DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT-ID].supabase.co:5432/postgres

# Z https://app.supabase.com/project/[YOUR-PROJECT]/settings/api
NEXT_PUBLIC_SUPABASE_URL=https://[PROJECT-ID].supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[YOUR-ANON-KEY]
```

### 4. Uruchomienie Aplikacji

```bash
docker-compose up -d
```

Opcje:
- `-d` - Run in background (detached mode)
- `--build` - Rebuild images (użyj jeśli zmieniłeś kod)

### 4. Sprawdzenie Statusu

```bash
docker-compose ps
```

Powinno pokazać 2 kontenery w stanie `Up`:
- `nextjs-app` - Nasza aplikacja (port 3000)
- `supabase-studio` - Admin panel Supabase (port 3001)

## Dostęp do Aplikacji

| Usługa | URL | Opis |
|--------|-----|------|
| Next.js App | http://localhost:3000 | Aplikacja główna |
| Supabase Studio | http://localhost:3001 | Panel administracyjny bazy danych |
| PostgreSQL | localhost:5432 | Baza danych (dostęp programistyczny) |

### Dane Logowania do Supabase

- **Email**: Możesz użyć dowolnego emaila (np. `test@example.com`)
- **Hasło**: Dowolne hasło
- **API URL**: `http://localhost:3001`

## Polecenia Docker Compose

### Wyświetlenie dziennika (logs)
```bash
docker-compose logs -f nextjs
docker-compose logs -f supabase-studio
```

### Zatrzymanie aplikacji
```bash
docker-compose down
```

### Zatrzymanie i usunięcie danych
```bash
docker-compose down -v
```

### Restart usług
```bash
docker-compose restart
```

## Zmienne Środowiskowe

W pliku `.env` możesz konfigurować:

- `POSTGRES_USER` - Użytkownik bazy danych
- `POSTGRES_PASSWORD` - Hasło do bazy danych (zmień na bezpieczne!)
- `POSTGRES_DB` - Nazwa domyślnej bazy danych
- `NEXTJS_PORT` - Port aplikacji Next.js (domyślnie 3000)
- `STUDIO_PORT` - Port Supabase Studio (domyślnie 3001)
- `POSTGRES_PORT` - Port bazy danych (domyślnie 5432)

## Rozwiązywanie Problemów

### Problem: Port już w użyciu

Jeśli port 3000 lub 3001 jest już zajęty, zmień go w pliku `.env`:

```env
NEXTJS_PORT=3005
STUDIO_PORT=3006
```

Następnie uruchom ponownie:
```bash
docker-compose down
docker-compose up -d
```

### Problem: Błędy połączenia

1. Upewnij się, że Docker jest uruchomiony
2. Sprawdź logs: `docker-compose logs`
3. Upewnij się, że kontenery są uruchomione: `docker-compose ps`

### Problem: Zmiana kodu nie widać

Po zmianie kodu aplikacji Next.js, przebuduj i uruchom ponownie:

```bash
docker-compose up -d --build
```

### Problem: Baza danych nie reaguje

Poczekaj 10-15 sekund na uruchomienie bazy danych. Możesz monitorować:

```bash
docker-compose logs postgres
```

## Testowanie Aplikacji

Aplikacja zawiera:
- **Home Page** (`/`) - Dashboard ze statusem usług
- **Health Check** (`/api/health`) - Endpoint do sprawdzenia dostępności

Przejdź do http://localhost:3000, aby zobaczyć status połączeń.

## Dalszy Rozwój

Aby dodać więcej funkcjonalności:

1. **Dodaj nowe strony** w katalogu `pages/`
2. **Dodaj API routes** w `pages/api/`
3. **Zainstaluj pakiety** - Zmodyfikuj `package.json`, następnie:
   ```bash
   docker-compose up -d --build
   ```

4. **Zintegruj Supabase w kodzie** - Użyj `@supabase/supabase-js`:
   ```javascript
   import { createClient } from '@supabase/supabase-js'
   
   const supabase = createClient(
     process.env.NEXT_PUBLIC_SUPABASE_URL,
     process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
   )
   ```

## Skalowanie

Do produkcji:
1. Zmień `NODE_ENV` na `production`
2. Ustaw silne hasła w `.env`
3. Skonfiguruj reverse proxy (np. Nginx)
4. Zastosuj SSL/TLS

## Licencja

MIT

## Wsparcie

Dla zaawansowanych potrzeb, zobacz:
- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.io/docs)
- [Docker Documentation](https://docs.docker.com/)
