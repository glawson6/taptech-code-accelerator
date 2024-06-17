docker exec -i docker-postgres-1 /bin/bash -c "PGPASSWORD=keycloak psql --username keycloak keycloak" < ../dump/keycloak-dump.sql
