#!/bin/bash

readonly PORT=8081
readonly NETWORK_NAME="simple-auth-app"
readonly CONTAINER_NAME="auth-backend"
readonly CONTAINER_TAG="latest"
readonly IMAGE_NAME="auth-backend"

check_and_create_network() {
    local network_name="$1"
    network_exists=$(docker network ls | grep "$NETWORK_NAME")

    if [ -z "$network_exists" ]; then
        docker network create "$network_name"
        echo "Docker network $network_name created."
    else
        echo "Docker network $network_name already exists."
    fi
}

check_and_remove_container() {
  local container_name="$1"

    container_exists=$(docker ps -a --filter "name=^${container_name}$" --format '{{.Names}}')

    if [ -n "$container_exists" ]; then
        docker rm -f "${container_name}"
        echo "Docker container '${container_name}' removed."
    else
        echo "Docker container '${container_name}' does not exist."
    fi
}

./mvnw clean
./mvnw install -DskipTests

rm -r ./extracted

java -Djarmode=layertools -jar target/simple-auth-app-backend-0.0.1-SNAPSHOT.jar extract --destination extracted/

docker build -t "$CONTAINER_NAME":"$CONTAINER_TAG" -f local.Dockerfile .
check_and_remove_container "$CONTAINER_NAME"
check_and_create_network "$NETWORK_NAME"
docker run -p "$PORT":"$PORT" --rm --name "$CONTAINER_NAME" -d --env SERVER_PORT="$PORT" --network="$NETWORK_NAME" "$IMAGE_NAME":"$CONTAINER_TAG"