#!/bin/bash
set -e

export REDIS_URL=redis://redis:6379
export DATABASE_URL=postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@postgres:5432/$POSTGRES_DB

exec "$@"
