#!/bin/sh

echo "\n📦 Initializing Kubernetes cluster...\n"

minikube start --driver=docker

echo "\n🔌 Enabling NGINX Ingress Controller...\n"

minikube addons enable ingress

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

echo "\n📦 Deploying Keycloak..."
kubectl apply -f services/keycloak-config.yml
kubectl apply -f services/keycloak.yml

sleep 5

echo "\n⌛ Waiting for Keycloak to be deployed..."

while [ $(kubectl get pod -l app=el-keycloak | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for Keycloak to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=app=el-keycloak \
  --timeout=300s

echo "\n⌛ Ensuring Keycloak Ingress is created..."

kubectl apply -f services/keycloak.yml

echo "\n⛵ Well done!\n"