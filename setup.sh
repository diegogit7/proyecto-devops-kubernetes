#!/bin/bash

# setup.sh - Despliegue automático del proyecto con Kind, ArgoCD y GHCR
# Uso: ./setup.sh <tu_token_de_github>

set -e

# --- Colores ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- Validar token ---
if [ -z "$1" ]; then
  echo -e "${RED}❌ Error: No se proporcionó el token de GitHub.${NC}"
  echo "Uso: $0 <tu_token_de_github>"
  exit 1
fi

GITHUB_TOKEN=$1

# --- 1. Verificar dependencias ---
echo -e "${YELLOW}🔍 Verificando dependencias...${NC}"
for cmd in kind kubectl; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}❌ $cmd no está instalado.${NC}"
        exit 1
    fi
done

# --- 2. Crear clúster Kind ---
echo -e "${YELLOW}🚀 Creando clúster de kind...${NC}"
kind create cluster --name devops-cluster

# --- 3. Instalar ArgoCD ---
echo -e "${YELLOW}📦 Instalando ArgoCD...${NC}"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 2>&1 | grep -v "Too long" || true

# --- 4. Esperar a que ArgoCD esté listo ---
echo -e "${YELLOW}⏳ Esperando a que ArgoCD esté listo...${NC}"
while [[ $(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    echo "Esperando ArgoCD... (10s)"
    sleep 10
done

# --- 5. Exponer ArgoCD ---
echo -e "${YELLOW}🌐 Exponiendo ArgoCD...${NC}"
kubectl port-forward svc/argocd-server -n argocd 8443:443 &

# --- 6. Obtener contraseña ---
echo -e "${GREEN}🔐 Contraseña de ArgoCD (admin):${NC}"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

# --- 7. Crear secret de GHCR ---
echo -e "${YELLOW}🔐 Creando secret de GHCR...${NC}"
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=diegogit7 \
  --docker-password=$GITHUB_TOKEN \
  --dry-run=client -o yaml | kubectl apply -f -

# --- 8. Desplegar la aplicación ---
echo -e "${YELLOW}🚢 Desplegando la aplicación web...${NC}"
kubectl apply -f deploy-ghcr.yaml

# --- 9. Esperar a que el deployment esté disponible ---
echo -e "${YELLOW}⏳ Esperando a que la app esté lista...${NC}"
sleep 3
kubectl wait --for=condition=available --timeout=180s deployment/web-deployment

# --- 10. Exponer la aplicación ---
echo -e "${YELLOW}🌐 Exponiendo la aplicación web...${NC}"
kubectl port-forward service/web-service 8080:80 &

# --- 11. Final ---
echo -e "${GREEN}✅ ¡Proyecto desplegado con éxito!${NC}"
echo -e "${GREEN}🌍 Aplicación web: http://localhost:8080${NC}"
echo -e "${GREEN}🔐 UI de ArgoCD: https://localhost:8443 (admin / contraseña de arriba)${NC}"
