#!/usr/bin/env bash
#
# AlerteMarché — Sauvegarde de la base PostgreSQL
# Usage : ./scripts/backup.sh
# À planifier via cron (ex : quotidien à 02h00).
#
set -euo pipefail

PROJECT_DIR="${PROJECT_DIR:-/opt/alertemarche/alertemarche-infra}"
COMPOSE_FILE="docker-compose.prod.yml"
BACKUP_DIR="${BACKUP_DIR:-/opt/alertemarche/backups}"
RETENTION_DAYS="${RETENTION_DAYS:-14}"

DB_NAME="${DB_DATABASE:-alertemarche}"
DB_USER="${DB_USERNAME:-alertemarche}"

TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
OUTPUT_FILE="${BACKUP_DIR}/alertemarche_${TIMESTAMP}.sql.gz"

mkdir -p "$BACKUP_DIR"
cd "$PROJECT_DIR"

echo "💾 Sauvegarde de la base '${DB_NAME}' -> ${OUTPUT_FILE}"

docker compose -f "$COMPOSE_FILE" exec -T postgres \
    pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$OUTPUT_FILE"

echo "🧹 Suppression des sauvegardes de plus de ${RETENTION_DAYS} jours..."
find "$BACKUP_DIR" -name 'alertemarche_*.sql.gz' -type f -mtime +"$RETENTION_DAYS" -delete

echo "✅ Sauvegarde terminée : ${OUTPUT_FILE}"
