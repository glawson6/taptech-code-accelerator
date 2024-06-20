export DOCKER_IMAGE_REPO=image-repo
./mvnw clean install -Dmaven.test.skip=true
cd offices
./mvnw clean package k8s:build -Dmaven.test.skip=true

