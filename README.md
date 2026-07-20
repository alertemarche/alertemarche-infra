# AlerteMarché — Infrastructure

![AlerteMarché](https://img.shields.io/badge/AlerteMarch%C3%A9-by%20PRO%20BENIN%20SARL-1a7f5a?style=for-the-badge)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-reverse%20proxy-009639?logo=nginx&logoColor=white)
![Cloudflare](https://img.shields.io/badge/Cloudflare-WAF%20%2F%20SSL-F38020?logo=cloudflare&logoColor=white)

Infrastructure et déploiement de **AlerteMarché**, la plateforme SaaS de veille intelligente pour les appels d'offres au **Bénin**, **Togo** et **Côte d'Ivoire**.

## À propos

Ce dépôt regroupe la configuration d'infrastructure du projet : orchestration Docker (dev & prod), reverse proxy Nginx, scripts de déploiement et de sauvegarde, et guide de mise en place. La production s'appuie sur un **VPS** protégé par **Cloudflare** (WAF, anti-DDoS, SSL).

## Stack technique

| Composant       | Technologie                        |
|-----------------|------------------------------------|
| Orchestration   | Docker / Docker Compose            |
| Reverse proxy   | Nginx                              |
| Base de données | PostgreSQL 15                      |
| Cache / queues  | Redis 7                            |
| Sécurité edge   | Cloudflare (WAF, DDoS, SSL)        |
| Hébergement     | VPS                                |

## Contenu

```
docker-compose.prod.yml   # stack de production
docker-compose.dev.yml    # stack de développement
nginx/
  alertemarche.conf       # vhost Nginx pour alertemarche.com
scripts/
  deploy.sh               # déploiement sur le VPS
  backup.sh               # sauvegarde PostgreSQL
docs/
  setup.md                # guide de mise en place (Semaine 1)
```

## Démarrage rapide

```bash
# Développement
docker compose -f docker-compose.dev.yml up -d --build

# Production (sur le VPS)
docker compose -f docker-compose.prod.yml up -d --build
```

## Dépôts du projet

- [alertemarche-backend](https://github.com/alertemarche/alertemarche-backend) — API & cœur métier
- [alertemarche-frontend](https://github.com/alertemarche/alertemarche-frontend) — Interface web
- [alertemarche-scrapers](https://github.com/alertemarche/alertemarche-scrapers) — Robots de collecte
- [alertemarche-infra](https://github.com/alertemarche/alertemarche-infra) — Infrastructure & déploiement (ce dépôt)

## Documentation

- [docs/setup.md](docs/setup.md) — Guide de mise en place (Semaine 1)

---

© PRO BENIN SARL — AlerteMarché
