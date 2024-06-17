//80143e480a4a

export CONTAINER_ID=80143e480a4a

docker ps
# copy the keycloak container id

# ssh into keycloak container
docker exec -it 80143e480a4a /bin/bash

# export the realm configuration
/opt/keycloak/bin/kc.sh export --dir /opt/keycloak/data/import --realm office

# exit from the container
exit

# copy the exported realm configuration to local machine
docker cp 80143e480a4a:/opt/keycloak/data/import/office-realm.json ~/Downloads/office-realm.json