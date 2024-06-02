# Mein HomeLab

Repository für mein HomeLab

## `traefik.toml`

```toml
[entryPoints]
  [entryPoints.http]
    address = ":80"
  [entryPoints.https]
    address = ":443"

[certificatesResolvers.myresolver.acme]
  email = "your-email@example.com"
  storage = "acme.json"
  [certificatesResolvers.myresolver.acme.httpChallenge]
    entryPoint = "http"

[providers.docker]
  exposedByDefault = false
```

### Aktualisierte vollständige `docker-compose.yml`

```yaml
version: '3'

services:
  traefik:
    image: traefik:v2.2
    container_name: traefik
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./traefik/traefik.toml:/traefik.toml
      - ./traefik/acme.json:/acme.json
    command:
      - --api.insecure=true
      - --providers.docker=true
      - --entryPoints.http.address=:80
      - --entryPoints.https.address=:443
      - --certificatesResolvers.myresolver.acme.httpChallenge.entryPoint=http
      - --certificatesResolvers.myresolver.acme.email=your-email@example.com
      - --certificatesResolvers.myresolver.acme.storage=/acme.json

  adguardhome:
    image: adguard/adguardhome
    container_name: adguardhome
    restart: unless-stopped
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "68:68/tcp"
      - "3000:3000/tcp"
    volumes:
      - ./adguardhome/workdir:/opt/adguardhome/work
      - ./adguardhome/confdir:/opt/adguardhome/conf

  homeassistant:
    image: homeassistant/home-assistant
    container_name: homeassistant
    restart: unless-stopped
    ports:
      - "8123:8123"
    volumes:
      - ./homeassistant/config:/config

  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    restart: unless-stopped
    ports:
      - "8096:8096"
    volumes:
      - ./jellyfin/config:/config
      - ./jellyfin/cache:/cache
      - /path/to/media:/media

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-storage:/var/lib/grafana
      - ./grafana/config:/etc/grafana
      - ./grafana/dashboards:/var/lib/grafana/dashboards

  promtail:
    image: grafana/promtail:2.2.1
    container_name: promtail
    volumes:
      - /var/log:/var/log
      - ./promtail:/etc/promtail
    command: -config.file=/etc/promtail/promtail-config.yaml

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus:/etc/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'

  loki:
    image: grafana/loki:2.2.1
    container_name: loki
    ports:
      - "3100:3100"
    volumes:
      - ./loki:/etc/loki

  nextcloud:
    image: nextcloud
    container_name: nextcloud
    restart: unless-stopped
    volumes:
      - ./nextcloud/html:/var/www/html
      - ./nextcloud/data:/var/www/html/data
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.nextcloud.rule=Host(`nextcloud.yourhome.dyndns.org`)"
      - "traefik.http.routers.nextcloud.entrypoints=https"
      - "traefik.http.routers.nextcloud.tls.certresolver=myresolver"

  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    ports:
      - "8081:80"
    volumes:
      - ./vaultwarden/data:/data
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.vaultwarden.rule=Host(`vaultwarden.yourhome.dyndns.org`)"
      - "traefik.http.routers.vaultwarden.entrypoints=https"
      - "traefik.http.routers.vaultwarden.tls.certresolver=myresolver"

  photoprism:
    image: photoprism/photoprism
    container_name: photoprism
    restart: unless-stopped
    ports:
      - "2342:2342"
    environment:
      PHOTOPRISM_ADMIN_PASSWORD: "YourPassword"
      PHOTOPRISM_UPLOAD_NSFW: "false"
    volumes:
      - ./photoprism/storage:/photoprism/storage
      - /home/pi/photos:/photoprism/originals

volumes:
  grafana-storage:
```

### Zusammengefasst

1. **Erstellen der Verzeichnisstruktur**:

    ```bash
    mkdir -p /home/pi/homelab/adguardhome/workdir
    mkdir -p /home/pi/homelab/adguardhome/confdir
    mkdir -p /home/pi/homelab/homeassistant/config
    mkdir -p /home/pi/homelab/jellyfin/config
    mkdir -p /home/pi/homelab/jellyfin/cache
    mkdir -p /home/pi/homelab/nextcloud/html
    mkdir -p /home/pi/homelab/nextcloud/data
    mkdir -p /home/pi/homelab/vaultwarden/data
    mkdir -p /home/pi/homelab/photoprism/storage
    mkdir -p /home/pi/homelab/photoprism/originals
    mkdir -p /home/pi/homelab/traefik
    mkdir -p /home/pi/homelab/prometheus
    mkdir -p /home/pi/homelab/loki
    mkdir -p /home/pi/homelab/promtail
    mkdir -p /home/pi/homelab/grafana/config
    mkdir -p /home/pi/homelab/grafana/dashboards
    touch /home/pi/homelab/traefik/acme.json
    chmod 600 /home/pi/homelab/traefik/acme.json
    ```

2. **Erstellen der Konfigurationsdateien**:

    - `traefik.toml` im Verzeichnis `/home/pi/homelab/traefik/`
    - `prometheus.yml` im Verzeichnis `/home/pi/homelab/prometheus/`
    - `loki-config.yaml` im Verzeichnis `/home/pi/homelab/loki/`
    - `promtail-config.yaml` im Verzeichnis `/home/pi/homelab/promtail/`

3. **Starten der Container**:

    ```bash
    cd /home/pi/homelab
    docker-compose up -d
    ```
