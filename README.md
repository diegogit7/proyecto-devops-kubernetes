# 🚀 Proyecto: Despliegue en Kubernetes

## 📋 Descripción

Despliegue de una aplicación web en un clúster de Kubernetes. (opción local o imagen publica) 

## 🛠️ Tecnologías usadas

- **Docker**
- **kind**
- **kubectl**
- **nginx**
- **GitHub Container Registry (GHCR)**

## 📦 Paquete público

La imagen está publicada en GHCR:

`ghcr.io/diegogit7/proyecto-devops-kubernetes/mi-web:v1`

## 🚀 Cómo correr el proyecto

### Opción 1: Automático (usar la imagen pública)

No necesitas Docker. Solo kind y kubectl.

**Paso a paso:**

```bash
# 1. Clonar el repositorio
git clone https://github.com/diegogit7/proyecto-devops-kubernetes.git

# 2. Entrar a la carpeta
cd proyecto-devops-kubernetes

# 3. Crear el clúster de Kubernetes
kind create cluster --name devops-cluster

# 4. Desplegar la aplicación (la imagen se baja sola de GHCR)
kubectl apply -f deploy-ghcr.yaml

# 5. Exponer la web
kubectl port-forward service/web-service 8080:80

# 6. Entrar al navegador
Abrir http://localhost:8080
```

### Opción 2: Construir la imagen localmente (para modificar la web)

Necesitas Docker
```

# 1. Clonar el repositorio
git clone https://github.com/diegogit7/proyecto-devops-kubernetes.git

# 2. Entrar a la carpeta
cd proyecto-devops-kubernetes

# 3. Construir la imagen
docker build -t mi-web:v1 .

# 4. Crear el clúster
kind create cluster --name devops-cluster

# 5. Cargar la imagen al clúster
kind load docker-image mi-web:v1 --name devops-cluster

# 6. Desplegar
kubectl apply -f deploy.yaml

# 7. Exponer la web
kubectl port-forward service/web-service 8080:80

# 8. Entrar al navegador
Abrir http://localhost:8080


## Cuando no se quiera usar mas ser recomienda limpiar 🧹
kind delete cluster --name devops-cluster 
