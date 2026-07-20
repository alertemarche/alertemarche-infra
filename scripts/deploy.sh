#!/usr/bin/env bash
#
# AlerteMarché — Script de déploiement VPS
# Usage : ./scripts/deploy.sh
#
set -euo pipefail

PROJECT_DIR="${PROJECT_DIR:-/opt/alertemarche/alertemarche-infra}"
COMPOSE_FILE="docker-compose.prod.yml"

echo "🚀 Déploiement AlerteMarché — $(date '+%Y-%m-%d %H:%M:%S')"

cd "$PROJECT_DIR"

echo "📥 Récupération des dernières modifications..."
git pull --ff-only

echo "⬇️  Récupération des images à jour..."
docker compose -f "$COMPOSE_FILE" pull

echo "🔧 (Re)construction et démarrage des conteneurs..."
docker compose -f "$COMPOSE_FILE" up -d --build

echo "🗃️  Exécution des migrations de base de données..."
docker compose -f "$COMPOSE_FILE" exec -T app php artisan migrate --force

echo "🧹 Nettoyage et mise en cache de la configuration..."
docker compose -f "$COMPOSE_FILE" exec -T app php artisan config:cache
docker compose -f "$COMPOSE_FILE" exec -T app php artisan route:cache

echo "🧽 Suppression des images inutilisées..."
docker image prune -f

echo "✅ Déploiement terminé avec succès."
