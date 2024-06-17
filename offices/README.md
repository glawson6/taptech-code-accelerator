# Building Docker Image and Starting Services Locally

This guide will walk you through the process of building a Docker image locally and starting services for the `offices-postgres` project.

## Pre-requisites

Ensure you have the following installed on your system:

- taptech-code-accelerator libraries: install taptech-code-accelerator You can get from [here](t). And install it using the command `mvn clean install`
- Docker: Docker should be running in order to build images and start services. You can download Docker from [here](https://www.docker.com/products/docker-desktop).
- Maven: Maven wrapper is already installed. you can use the command ./mvnw to invoke

## Steps

### Step 1 - Build Docker Image

To build the Docker image, navigate to the root directory of the project where your `pom.xml` file is located using the terminal or command prompt. Use the command provided below:
Set the docker image repo first.

```bash
export DOCKER_IMAGE_REPO=127418365645.dkr.ecr.us-east-1.amazonaws.com
```

```bash
./mvnw clean package k8s:build
```

This command will clean the project, package it, and then build a Docker image using the Kubernetes Maven plugin.

### Step 2 - Create local.env file and save it in the docker directory
```properties
POSTGRES_DB=keycloak
POSTGRES_USER=keycloak
POSTGRES_PASSWORD=admin
KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=admin
KC_DB_USERNAME=keycloak
KC_DB_PASSWORD=keycloak
SPRING_PROFILES_ACTIVE=default
```
### Step 3- Start Services

To start the services, navigate to the `src/test/docker` directory in your terminal or command prompt. There should be a script file that you can run to start the services. The command to run the script will depend on the script file. If the script file is a `.sh` file, you can use the following command:

```bash
./start-services.sh
```

### Step 4 - Start offices-postgres Service

To start the service, you can use the command provided in the `src/test/docker` directory. The exact command will depend on the service you are trying to start. Please refer to the specific instructions provided in the `src/test/docker` directory.
```bash
./start-offices-postgres.sh
```

### Optional Step 5 - Extract the `admin-cli` client secret from a running Keycloak installation
read the document [here](EXTRACTING-ADMIN-CLI-CLIENT-SECRET.md)

### Optional Step 6 - turn security on by changing SPRING_PROFILES_ACTIVE to `secure` in the `local.env` file and restart the service and setting admin-cli client secret 
```properties
```properties
SPRING_PROFILES_ACTIVE=secure
KEYCLOAK_ADMIN_CLIENT_SECRET=<admin-cli client secret>
```
### Restart the service
```bash
./start-offices-postgres.sh
```
That's it! You have now built a Docker image locally and started the services for the `offices-postgres` project.