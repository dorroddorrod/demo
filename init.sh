#!/bin/bash
export envName=dev-main-01
export argoNamespace=argo
cd applications/argocd/$envName
helm dep up
helm install argo-cd . -f ../values.yaml -f values.yaml --namespace $argoNamespace
cd ../../../
kubectl apply -f environments/templates/argocd-project.yaml
kubectl apply -f environments/templates/app-of-apps.yaml
sleep 30
kubectl -n $argoNamespace get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
kubectl port-forward service/argocd-server -n $argoNamespace 8080:443