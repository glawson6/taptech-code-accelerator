export DOCKER_IMAGE_REPO=image-repo
./mvnw clean install -Dmaven.test.skip=false
cd offices
./mvnw clean package k8s:build -Dmaven.test.skip=false
