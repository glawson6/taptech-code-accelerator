docker exec -i docker-postgres-1 /bin/bash -c "PGPASSWORD=keycloak pg_dump --username keycloak keycloak" > dump/keycloak-dump.sql
