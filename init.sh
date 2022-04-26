#!/bin/bash
helm install argocd argo/argo-cd
kubectl apply -f environments/templates/argocd-project.yaml
kubectl apply -f environments/templates/app-of-apps.yaml