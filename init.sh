#!/bin/bash
export envName=dev-main-01
export argoNamespace=argo-cd
cd applications/argo-cd/$envName
helm dep up
helm install argo-cd . -f ../values.yaml -f values.yaml --namespace $argoNamespace --create-namespace
cd ../../../
cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: argocd
spec:
  description: project for management of Argo CD itself
  clusterResourceWhitelist:
  - group: '*'
    kind: '*'
  destinations:
  - namespace: argo-cd
    server: https://kubernetes.default.svc
  sourceRepos:
  - https://github.com/dorroddorrod/demo.git
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-of-apps
spec:
  destination:
    namespace: argo-cd
    server: https://kubernetes.default.svc
  project: argocd
  syncPolicy:
    automated:
      prune: true
  source:
    path: environments
    repoURL: https://github.com/dorroddorrod/demo.git
    targetRevision: HEAD
    helm:
      valueFiles:
      - $envName.yaml
EOF
sleep 60
kubectl -n $argoNamespace get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
kubectl port-forward service/argo-cd-argocd-server -n $argoNamespace 8080:443