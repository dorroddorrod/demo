#!/bin/bash
export envName=dev-main-01
export argoNamespace=argo-cd
cd applications/argocd/$envName
helm dep up
helm install argo-cd . -f ../values.yaml -f values.yaml --namespace $argoNamespace --create-namespace
cd ../../../
kubectl -n $argoNamespace apply -f environments/templates/argocd-project.yaml
kubectl -n $argoNamespace apply -f environments/templates/app-of-apps.yaml
sleep 60
kubectl -n $argoNamespace get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
kubectl port-forward service/argo-cd-argocd-server -n $argoNamespace 8080:443