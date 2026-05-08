
# Proyecto DevOps: Despliegue en Kubernetes con GitOps

## 📋 Descripción

Aplicación web desplegada en Kubernetes usando **Kind**. El despliegue es automático mediante **GitOps con ArgoCD**. La imagen se publica en **GHCR** y cada cambio en Git sincroniza el clúster sin intervención manual.

## 🛠️ Tecnologías

- Docker / GHCR
- Kind / kubectl
- ArgoCD (GitOps)
- GitHub Actions (CI)

## 🚀 Cómo correr el proyecto

### Requisitos

- kind, kubectl
- Token de GitHub (permisos `read:packages`)

### Instalación (un solo comando)

```bash
git clone https://github.com/diegogit7/proyecto-devops-kubernetes.git
cd proyecto-devops-kubernetes
chmod +x setup.sh
./setup.sh <tu_token_de_github>

```


### El script crea el clúster, instala ArgoCD, despliega la app y expone los servicios.
🌐 Acceso

    App web: http://localhost:8080

    ArgoCD UI: https://localhost:8443 (usuario: admin, contraseña: la que muestra el script)

🔄 GitOps en acción

    Modificá deploy-ghcr.yaml (cambia réplicas, imagen, etc.)

    git push

    ArgoCD detecta el cambio y actualiza el clúster solo

🧹 Limpiar
bash
```
kind delete cluster --name devops-cluster
```
📦 Imagen pública
```
ghcr.io/diegogit7/proyecto-devops-kubernetes/mi-web:v1
```
