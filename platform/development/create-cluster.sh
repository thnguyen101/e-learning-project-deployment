#!/bin/sh

echo "\n📦 Initializing Kubernetes cluster...\n"

minikube start --driver=docker

echo "\n📦 Deploying PostgreSQL..."

kubectl apply -f services/postgresql.yml

sleep 5

echo "\n⌛ Waiting for PostgreSQL to be deployed..."

while [ $(kubectl get pod -l db=el-postgres | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for PostgreSQL to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=el-postgres \
  --timeout=180s

echo "\n⛵ Well done!\n"