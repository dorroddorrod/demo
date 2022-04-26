#!/bin/bash
export envName=dev-main-01
cd applications/argocd/$envName
helm dep up
helm install argo-cd . -f ../values.yaml -f values.yaml
cd ../../../
kubectl apply -f environments/templates/argocd-project.yaml
kubectl apply -f environments/templates/app-of-apps.yaml