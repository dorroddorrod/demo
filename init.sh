#!/bin/bash
helm install argocd argo/argo-cd
kubectl apply -f enviroments/templates/argocd-project.yaml
kubectl apply -f enviroments/templates/app-of-apps.yaml