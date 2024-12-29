#!/bin/sh

echo "\n🏴️ Destroying Kubernetes cluster...\n"

minikube stop --profile minikube

minikube delete --profile minikube

echo "\n🏴️ Cluster destroyed\n"