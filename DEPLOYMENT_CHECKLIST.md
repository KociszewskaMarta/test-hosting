# Checklist Wdrażania do Produkcji

Ten dokument zawiera listę kontrolną wszystkich rzeczy, które musisz zrobić zanim wdrożysz aplikację do produkcji.

## 🔐 Bezpieczeństwo

- [ ] Zmień wszystkie domyślne hasła w `.env`
- [ ] Wygeneruj silne hasło PostgreSQL (min. 16 znaków, znaki specjalne)
- [ ] Zaktualizuj klucze Supabase na własne
- [ ] Włącz HTTPS (SSL/TLS certyfikat)
- [ ] Ustaw `NODE_ENV=production` w `.env`
- [ ] Usuń zmienne debugowania z `.env`
- [ ] Skonfiguruj CORS dla domenach produkcji
- [ ] Włącz Row Level Security (RLS) w Supabase

## 🏗️ Architektura

- [ ] Zabezpiecz bazę danych (firewall, IP whitelist)
- [ ] Skonfiguruj reverse proxy (Nginx/Caddy)
- [ ] Utwórz backupy bazy danych automatycznie
- [ ] Skonfiguruj monitoring i alerty
- [ ] Utwórz plan disaster recovery

## 📦 Kod Aplikacji

- [ ] Przetestuj aplikację w trybie produkcji (`npm run build && npm start`)
- [ ] Usuń console.log() z kodu
- [ ] Zoptymalizuj obrazy i zasoby
- [ ] Skonfiguruj logowanie błędów
- [ ] Przetestuj wszystkie API endpoints

## 🐳 Docker i Compose

- [ ] Zaktualizuj wersje base images (Node, PostgreSQL)
- [ ] Zmniejsz rozmiar obrazu Docker
- [ ] Ustaw memory/CPU limits
- [ ] Skonfiguruj restart policy
- [ ] Przetestuj na rzeczywistym serwerze

## 📊 Performance

- [ ] Włącz caching dla static assets
- [ ] Skonfiguruj CDN (opcjonalnie)
- [ ] Zoptymalizuj bundle size aplikacji
- [ ] Ustaw compression (gzip)
- [ ] Dodaj monitoring wydajności

## 🌐 Sieć i DNS

- [ ] Skonfiguruj DNS dla domeny
- [ ] Utwórz SSL/TLS certificate (Let's Encrypt)
- [ ] Skonfiguruj auto-renewal certyfikatów
- [ ] Ustaw port forwarding na serwerze
- [ ] Przetestuj dostęp z internetu

## 📝 Dokumentacja

- [ ] Udokumentuj variusy produkcji w `.env.production`
- [ ] Napisz instrukcje backup'ów
- [ ] Stwórz dokumentację deployment'u
- [ ] Utwórz runbook dla emergency cases
- [ ] Dokumentuj wszystkie custom zmienne

## ☑️ Testing

- [ ] Testuj aplikację przez HTTPS
- [ ] Testuj mobilne
- [ ] Testuj brzegi (edge cases)
- [ ] Testuj failure scenarios
- [ ] Testuj load testing (jeśli spodziewasz się dużo użytkowników)

## 🚀 Wdrażanie

- [ ] Stwórz deployment plan
- [ ] Zaplanuj maintenance window
- [ ] Przygotuj rollback procedure
- [ ] Przetestuj upgrade procedure
- [ ] Powiadom użytkowników (jeśli dotyczy)

## 👁️ Post-Deployment

- [ ] Monitoruj logi
- [ ] Sprawdzaj metryki wydajności
- [ ] Testuj funkcjonalność na żywo
- [ ] Zbieraj feedback użytkowników
- [ ] Bądź gotowy do szybkiego rollback'u

## 🔄 Continuous Improvement

- [ ] Ustaw CI/CD pipeline
- [ ] Automatyzuj testy
- [ ] Planuj regularne updates
- [ ] Monitoruj bezpieczeństwo (CVE)
- [ ] Zbieraj analytics i user behavior

---

## Konfiguracja Produkcyjna - Przykład

### `docker-compose.prod.yml`

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}  # Zmień!
    volumes:
      - postgres-backup:/backups
    restart: always

  nextjs:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      NODE_ENV: production
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 512M
    restart: always
```

### Wdrażanie

```bash
# Build dla produkcji
docker-compose -f docker-compose.prod.yml build

# Start
docker-compose -f docker-compose.prod.yml up -d

# Monitoring
docker-compose -f docker-compose.prod.yml logs -f
```

## Bezpieczeństwo - Kluczowe Punkty

### Zaktualizuj `.env` dla produkcji:

```env
# ZMIEŃ WSZYSTKIE HASŁA!
POSTGRES_PASSWORD=SuperSecurePassword123!@#XYZ

# Twoje domeny
NEXT_PUBLIC_SUPABASE_URL=https://yourdomain.com
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com

# Wyłącz debug
DEBUG=false
NODE_ENV=production
```

### Nginx Reverse Proxy (Przykład)

```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://nextjs:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Monitoring i Logging

Zainstaluj tool do monitorowania:
- **Prometheus** - metryki
- **Grafana** - dashboards
- **ELK Stack** - logi
- **Sentry** - error tracking

## Backupy

Ustaw automated backupy:

```bash
# Daily backup script
0 2 * * * docker-compose exec -T postgres pg_dump -U postgres postgres > /backups/db-$(date +\%Y\%m\%d).sql
```

---

## Gotowy do Wdrażania?

Zanim pójdziesz dalej:

1. ✅ Przebiegłeś całą listę
2. ✅ Przetestowałeś w staging environment
3. ✅ Masz plan B na wypadek problemów
4. ✅ Backupujesz dane regularnie
5. ✅ Masz monitoring skonfigurowany

Powodzenia z wdrażaniem! 🚀
