#!/usr/bin/env bash
#
# AlerteMarché — Script de déploiement VPS
# À exécuter depuis le dossier infra/ (où se trouve docker-compose.prod.yml).
# Le code des 4 dépôts doit être présent côté serveur :
#   alertemarche/{backend,frontend,scrapers,infra}
#
# Usage : ./scripts/deploy.sh
#
set -euo pipefail

COMPOSE_FILE="docker-compose.prod.yml"
cd "$(dirname "$0")/.."

echo "🚀 Déploiement AlerteMarché — $(date '+%Y-%m-%d %H:%M:%S')"

if [ ! -f .env ]; then
    echo "❌ Fichier .env manquant dans infra/. Copiez et complétez .env.example."
    exit 1
fi

echo "🔧 (Re)construction des images et démarrage des conteneurs..."
docker compose -f "$COMPOSE_FILE" up -d --build

echo "⏳ Attente de la disponibilité de l'application..."
sleep 8

echo "🗃️  Migrations + seed de la base de données..."
docker compose -f "$COMPOSE_FILE" exec -T app php artisan migrate --force || true
docker compose -f "$COMPOSE_FILE" exec -T app php artisan db:seed --force || true

echo "🧹 Mise en cache de la configuration..."
docker compose -f "$COMPOSE_FILE" exec -T app php artisan config:cache || true
docker compose -f "$COMPOSE_FILE" exec -T app php artisan route:cache || true

echo "🧽 Suppression des images inutilisées..."
docker image prune -f || true

echo "📊 État des services :"
docker compose -f "$COMPOSE_FILE" ps

echo "✅ Déploiement terminé. Vérifiez : curl -s http://localhost/api/health"
