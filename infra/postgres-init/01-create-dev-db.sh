#!/bin/bash
# Создаёт отдельную базу и пользователя для dev-стенда.
# Выполняется один раз, при первой инициализации тома Postgres.
#
# Прод и dev делят один инстанс Postgres ради экономии памяти на 4 ГБ,
# но живут в разных базах: у dev-пользователя нет никаких прав на
# продовую базу, поэтому ошибка на dev не может тронуть боевые данные.

set -euo pipefail

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER ${DEV_DB_USER} WITH PASSWORD '${DEV_DB_PASSWORD}';
	CREATE DATABASE ${DEV_DB} OWNER ${DEV_DB_USER};

	-- Явно отбираем доступ к продовой базе.
	REVOKE ALL ON DATABASE ${POSTGRES_DB} FROM ${DEV_DB_USER};
	REVOKE CONNECT ON DATABASE ${POSTGRES_DB} FROM PUBLIC;
EOSQL

# pgvector включается в каждой базе отдельно.
for db in "$POSTGRES_DB" "$DEV_DB"; do
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$db" \
		-c 'CREATE EXTENSION IF NOT EXISTS vector;'
done
