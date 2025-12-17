#!/bin/bash
set -e #if there is an error stop running the script

#check docker
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Start docker desktop."
    exit 1
fi
CONTAINER_NAME=postgres-test
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
DB_NAME=productapp

#check if there is a container
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}"; then
  echo "Postgres is being creating..."
  docker run \
    --name ${CONTAINER_NAME} \
    -e POSTGRES_USER=${POSTGRES_USER} \
    -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    -p 6432:5432 \
    -d postgres:latest
else
  echo "This container is already exists."
  docker start ${CONTAINER_NAME}
fi

echo "Postgres is being ready."
until docker exec ${CONTAINER_NAME} pg_isready -U ${POSTGRES_USER} >/dev/null 2>&1; do
  sleep 1
done

echo "Postgres is ready"

# Creating database
docker exec ${CONTAINER_NAME} psql -U ${POSTGRES_USER} -tc \
  "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'" \
  | grep -q 1 || \
docker exec ${CONTAINER_NAME} psql -U ${POSTGRES_USER} -c \
  "CREATE DATABASE ${DB_NAME};"

echo "Database productapp created."

# Create table
docker exec ${CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${DB_NAME} -c "
CREATE TABLE IF NOT EXISTS products
(
  id bigserial PRIMARY KEY,
  name varchar(255) NOT NULL,
  price double precision NOT NULL,
  discount double precision,
  store varchar(255) NOT NULL
);
"
echo "Table products created."