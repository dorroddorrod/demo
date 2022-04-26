#!/bin/bash
export envName=dev-main-01
helm install argocd applications/argocd/$envName -f applications/argocd/values.yaml -f applications/argocd/$envName/$envName-values.yaml
kubectl apply -f environments/templates/argocd-project.yaml
kubectl apply -f environments/templates/app-of-apps.yaml