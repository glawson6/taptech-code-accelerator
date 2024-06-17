
export HOST_FOR_KCADM=localhost
export KC_VERSION=23.0.6
export HOME=$(pwd)

export KCADM="docker run --rm --name kc-admin-cli --entrypoint /opt/keycloak/bin/kcadm.sh -v ${PWD}/.keycloak:/opt/keycloak/.keycloak quay.io/keycloak/keycloak:23.0.6"

$KCADM config credentials --server http://$HOST_FOR_KCADM:8080 --user admin --password admin --realm master
$KCADM config credentials --server http://localhost:8080 --user admin --password admin --realm master
$KCADM config credentials --server http://host.docker.internal:8080 --user admin --password admin --realm master
host.docker.internal