# Przewodnik Szybkiego Startu

Witaj! Ten dokument pokaze Ci krok po kroku, jak uruchomić samoistnie hostowaną aplikację Next.js z Supabase.

## Krok 1: Zainstaluj Docker Desktop

Docker to narzędzie, które pozwala uruchamiać aplikacje w tzw. kontenerach - to jak pudełeczka, w którym mamy wszystko czego potrzebujemy.

### Na Windows i macOS:
1. Przejdź do https://www.docker.com/products/docker-desktop
2. Kliknij "Download" (pobiera się ~600 MB)
3. Zainstaluj program, jak każdy inny software
4. Po instalacji uruchom Docker Desktop (będzie się startować w tle)

### Na Linux:
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io docker-compose

# Aktywuj bez sudo
sudo usermod -aG docker $USER
```

### Sprawdzenie, czy Docker działa:
Otwórz terminal/PowerShell i wpisz:
```bash
docker --version
```

Powinno wyświetlić coś typu: `Docker version 24.0.0`


## Krok 2: Skonfiguruj Zmienne Środowiskowe

### Skopiuj plik `.env.example` na `.env`

**Windows (CMD):**
```cmd
copy .env.example .env
```

**Windows (PowerShell):**
```powershell
Copy-Item .env.example .env
```

**macOS/Linux:**
```bash
cp .env.example .env
```

### Edytuj `.env` i dodaj dane Twojej bazy Supabase

Otwórz plik `.env` w edytorze tekstu (Notepad, VS Code, itp.) i zmień:

```env
NEXT_PUBLIC_SUPABASE_URL=https://[YOUR-PROJECT-ID].supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[YOUR-PUBLISHABLE-KEY]
DATABASE_URL=postgresql://postgres:[YOUR-PASSWORD]@db.[YOUR-PROJECT-ID].supabase.co:5432/postgres
```

Na Twoje dane z https://app.supabase.com:
- **Settings → API** - tam są URL i Publishable key
- **Settings → Database** - tam jest CONNECTION STRING z hasłem

## Krok 3: Uruchom Aplikację

### Opcja A: Automatycznie (najłatwiej)

**Windows (CMD)**:
```cmd
start.bat
```

**Windows (PowerShell)**:
```powershell
.\start.ps1
```

**macOS/Linux**:
```bash
chmod +x start.sh
./start.sh
```

### Opcja B: Ręcznie (jeśli powyższe nie zadziała)

```bash
docker-compose up -d
```

Czekaj ~10 sekund na uruchomienie aplikacji.

## Krok 4: Sprawdź Status

Aby sprawdzić, czy wszystko działa:

```bash
docker-compose ps
```

Powinno pokazać:
```
NAME                STATUS
nextjs-app          Up
postgres            Up
supabase-studio     Up
```

Jeśli któryś ma status `Exited` - zobacz TROUBLESHOOTING.md

## Krok 6: Otwórz Aplikacje w Przeglądarce

### Next.js Aplikacja
Przejdź do: **http://localhost:3000**

Powinieneś zobaczyć:
- Nagłówek "Self-Hosting Test"
- Status aplikacji: "✓ Running"
- Status Supabase: powinna być zaznaczona jako "Connected"

### Supabase Admin Panel
Przejdź do: **http://localhost:3001**

Tu możesz zarządzać bazą danych:
- Tworzyć tabele
- Dodawać dane
- Zarządzać użytkownikami

## Zatrzymanie Aplikacji

Jeśli chcesz ją wyłączyć:

```bash
docker-compose down
```

Dane w bazie będą zachowane!

### Usunięcie Wszystkiego (z Danymi)

```bash
docker-compose down -v
```

## Przydatne Komendy

| Komenda | Co robi |
|---------|---------|
| `docker-compose up -d` | Uruchamia aplikację |
| `docker-compose down` | Zatrzymuje aplikację |
| `docker-compose logs -f` | Wyświetla dziennik (naciśnij Ctrl+C aby wyjść) |
| `docker-compose restart` | Restartuje aplikację |
| `docker-compose ps` | Sprawdza status |

## Typowe Błędy

### "Port 3000 is already in use"
Zmień port w `.env`:
```env
NEXTJS_PORT=3005
```

### "Docker daemon is not running"
Otworz Docker Desktop - musi działać w tle.

### "Cannot find module 'next'"
Zrestartuj:
```bash
docker-compose down
docker-compose up -d --build
```

### "Database connection refused"
Czekaj 30 sekund na startup bazy wyświetl logi:
```bash
docker-compose logs postgres
```

## Potrzebujesz Więcej Pomocy?

1. Przeczytaj `README.md` - pełna dokumentacja
2. Sprawdź `TROUBLESHOOTING.md` - rozwiązania dla problemów
3. [Docker dokumentacja](https://docs.docker.com/)
4. [Next.js dokumentacja](https://nextjs.org/docs)
5. [Supabase dokumentacja](https://supabase.io/docs)

## Podsumowanie

✅ Zainstalowałeś Docker  
✅ Pobrałeś projekt  
✅ Skonfigurować `.env`  
✅ Uruchomiłeś `docker-compose up -d`  
✅ Przejrzałeś aplikację na http://localhost:3000  

**Gratulacje! Masz samodzielnie hostowaną aplikację! 🎉**

Teraz możesz:
- Dodawać nowe strony w `pages/`
- Zarządzać bazą w Supabase Studio
- Ulepszać aplikację
- Wdrażać na serwer (gdy będziesz gotowy)

Powodzenia!
