# HomeLab

Repository für mein HomeLab auf GitHub mit Docker oder Podman sowie ein paar Skripten um HomeLab, Docker oder Podman einzurichten.

## Dienste

Dienste und Standalone Pakete, welche ich verwende.

Dienste

- Podman
- Docker
- Cronjobs
- Dynamisches DNS
- No-IP

</br>

Pakete

- AdGuard Home
- Jellyfin Server mit web-ui

## Skripte

Mit dem Skript [homelab_setup.sh](https://github.com/dieBakterie/HomeLab/blob/6c10260ab1b7b8b12fae87aab1cb5d22b95db4d7/homelab/podman/podman-compose.yaml) kann man eine HomeLab-Installation mit vershiednen Skripten machen. Es ruft die vershiedene Skripte auf, um die HomeLab-Installation zu konfigurieren.

## Podman

**Ein** großer Pod mit verschiedenen Diensten und ein skript, welches es einem ermöglicht alle Pfade in einem 

- AdGuard Home
- Jellyfin
- Nextcloud(All-In-One)
- Photoprism
- Vaultwarden
- Prometheus
- Grafana
- Promtail
- Loki
- Traefik
- influxdb

## Docker

Eine Docker-Installation für HomeLab. Mit dem Skript [docker_setup.sh](https://github.com/dieBakterie/HomeLab/blob/6c10260ab1b7b8b12fae87aab1cb5d22b95db4d7/homelab/Skripte/docker_setup.sh) lässt sich anhand einer yaml/yml Datei ein oder mehrere Docker-Container erstellen lassen. Die folgenden Dienste, wie in der [docker-compose.yaml](https://github.com/dieBakterie/HomeLab/blob/6c10260ab1b7b8b12fae87aab1cb5d22b95db4d7/homelab/docker/docker-compose.yaml) festgelegt, werden verwendet.

- AdGuard Home
- Jellyfin
- Nextcloud(All-In-One)
- Photoprism
- Vaultwarden
- Prometheus
- Grafana
- Promtail
- Loki
- Traefik
- influxdb

## Dynamisches DNS

Ich verwende für Dynamisches DNS die DuckDNS. Ich möchte nextcloud, vaultwarden und Jellyfin auch von außerhalb meines Netzwerkes erreichen können. Es gibt auch die Möglichkeit, No-IP zu verwenden, jedoch kann man dort nur eine domäne erstellen. DuckDNS bietet die Möglichkeit, mehrere Domänen zu erstellen, bis zu fünf um genau zu sein. Duckdns bietet jedoch im gegensatz zu No-IP kein Paket an um die IP-Adresse automatisch zu aktualisieren. Wir können Cronjob nutzen wie hier in diesem Beispiel um alle fünf Minuten die IP-Adresse zu aktualisieren.

### DuckDNS

DuckDNS bietet eine einfache Möglichkeit, eine dynamische IP-Adresse mit einer statischen Subdomain zu verknüpfen. Hier sind die Schritte zur Einrichtung:

1. **Einrichten eines Cron-Jobs**:

   - Öffnen Sie den Crontab-Editor:

     ```bash
     crontab -e
     ```

   - Fügen Sie die folgende Zeile am Ende der Crontab-Datei hinzu, um Ihre IP-Adresse alle 5 Minuten zu aktualisieren:

     ```bash
     */5 * * * * /usr/bin/curl -k -s "https://www.duckdns.org/update?domains=yourhome&token=YOUR_TOKEN&ip="
     ```

   Ersetzen Sie `yourhome` durch Ihre DuckDNS-Subdomain und `YOUR_TOKEN` durch den Token, den Sie von DuckDNS erhalten haben.

### No-IP

No-IP bietet einen offiziellen Dynamic Update Client (DUC), der die IP-Adresse automatisch aktualisiert. Hier ist eine kurze Anleitung zur Installation und Konfiguration des No-IP Clients:

1. **Herunterladen und Installieren des No-IP Clients**:

   ```bash
   cd /usr/local/src/
   sudo wget https://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
   sudo tar xf noip-duc-linux.tar.gz
   cd noip-2.1.9-1/
   sudo make
   sudo make install
   ```

   Während der Installation werden Sie nach Ihrem No-IP-Benutzernamen und -Passwort gefragt.

2. **Starten des No-IP Clients**:

   ```bash
   sudo /usr/local/bin/noip2
   ```

3. **Einrichten von systemd für No-IP**:

   Erstellen Sie eine neue systemd Service-Datei für No-IP:

   ```bash
   sudo nano /etc/systemd/system/noip2.service
   ```

   Fügen Sie den folgenden Inhalt in die Datei ein:

   ```ini
   [Unit]
   Description=No-IP Dynamic DNS Update Service
   After=network.target

   [Service]
   Type=forking
   ExecStart=/usr/local/bin/noip2
   ExecStop=/usr/local/bin/noip2 -K
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

4. **Aktivieren und Starten des Dienstes**:

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable noip2
   sudo systemctl start noip2
   ```

5. **Überprüfen des Dienstes**:

   ```bash
   sudo systemctl status noip2
   ```
