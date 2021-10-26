#!/usr/bin/env bash

CONTAINER_HEALTH=$(docker inspect --format='{{json .State.Health.Status}}' $1)
if [ -z $CONTAINER_HEALTH ]; then
    echo "Container not found"
    exit 1
fi;

until test $CONTAINER_HEALTH = \"healthy\"; do
    echo "Waiting..." $CONTAINER_HEALTH
    sleep 2
    CONTAINER_HEALTH=$(docker inspect --format='{{json .State.Health.Status}}' $1)
    if [ -z $CONTAINER_HEALTH ]; then
        echo "Container crashed"
        exit 1
    fi;
	if [ $CONTAINER_HEALTH == \"unhealthy\" ]; then
        echo "Healthcheck failed"
        exit 1
    fi;
done
echo "Ready!"