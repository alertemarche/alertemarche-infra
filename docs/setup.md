# Guide de mise en place — Semaine 1

Ce guide décrit l'initialisation de l'infrastructure AlerteMarché lors de la première semaine de la feuille de route.

## 1. Comptes & services à provisionner

| Service      | Usage                              | Action Semaine 1                     |
|--------------|------------------------------------|--------------------------------------|
| VPS          | Hébergement production             | Commander, durcir (SSH, firewall)    |
| Cloudflare   | WAF, anti-DDoS, SSL, DNS           | Ajouter le domaine `alertemarche.com`, mode SSL **Full** |
| GitHub       | Code source (4 dépôts)             | Dépôts créés, accès équipe           |
| OpenAI       | Résumés & matching (GPT-4o)        | Créer la clé API, définir un budget  |
| WhatsApp Business Platform (Meta) | Notifications | Créer l'app, numéro, token           |
| Brevo        | E-mails transactionnels            | Créer la clé API, valider l'expéditeur |
| KKPays       | Paiement Mobile Money & cartes     | Créer le compte marchand, clés API   |

## 2. Préparation du VPS

```bash
# Mises à jour & outils de base
sudo apt update && sudo apt upgrade -y
sudo apt install -y git ufw fail2ban

# Docker + Docker Compose
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"

# Pare-feu
sudo ufw allow OpenSSH
sudo ufw allow 80,443/tcp
sudo ufw enable
```

## 3. Récupération du dépôt infra

```bash
sudo mkdir -p /opt/alertemarche && cd /opt/alertemarche
git clone https://github.com/alertemarche/alertemarche-infra.git
cd alertemarche-infra
cp .env.example .env   # renseigner les secrets de production
```

## 4. Configuration DNS & Cloudflare

1. Pointer `alertemarche.com` et `www` vers l'IP du VPS (enregistrements A, proxy activé 🟧).
2. SSL/TLS : mode **Full**.
3. Activer le WAF et les règles anti-DDoS.
4. Forcer HTTPS (Always Use HTTPS).

## 5. Démarrage de la stack de production

```bash
docker compose -f docker-compose.prod.yml up -d --build
docker compose -f docker-compose.prod.yml exec app php artisan migrate --force
```

## 6. Sauvegardes automatiques

Ajouter une tâche cron pour la sauvegarde quotidienne de PostgreSQL :

```bash
0 2 * * * /opt/alertemarche/alertemarche-infra/scripts/backup.sh >> /var/log/alertemarche-backup.log 2>&1
```

## 7. Déploiement continu

Les mises à jour se déploient via :

```bash
./scripts/deploy.sh
```

## Dépôts liés

- Backend : https://github.com/alertemarche/alertemarche-backend
- Frontend : https://github.com/alertemarche/alertemarche-frontend
- Scrapers : https://github.com/alertemarche/alertemarche-scrapers
- Infra : https://github.com/alertemarche/alertemarche-infra
