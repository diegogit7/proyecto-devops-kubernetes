
# Proyecto DevOps: Despliegue en Kubernetes con GitOps

## 📋 Descripción

Aplicación web desplegada en Kubernetes usando **Kind**. El despliegue es automático mediante **GitOps con ArgoCD**. La imagen se publica en **GHCR** y cada cambio en Git sincroniza el clúster sin intervención manual. Incluye **monitoreo con Prometheus y Grafana** para observar métricas en tiempo real.

## 🛠️ Tecnologías

- Docker / GHCR
- Kind / kubectl
- ArgoCD (GitOps)
- GitHub Actions (CI)
- Prometheus / Grafana (monitoreo)
- 
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


## 📈 Monitoreo con Prometheus y Grafana

El clúster incluye monitoreo automático con **Prometheus** (métricas) y **Grafana** (visualización).

### Instalación 

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring


kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80 &

    URL: http://localhost:3000

    Usuario: admin

    Contraseña: prom-operator
```

### Explorar métricas

1. En el menú lateral izquierdo, haz clic en el ícono de la **brújula** (Explore).
2. Asegúrate de que la fuente de datos sea **Prometheus**.
3. Escribe una consulta como `container_memory_usage_bytes` y presiona **Run query**.



### Dashboard preconfigurado

Puedes importar el dashboard **`315`** (Kubernetes Cluster Monitoring) para una vista general del clúster:

- **Dashboards → New → Import**
- Ingresa el ID `315` → **Load**
- Data source: **Prometheus** → **Import**


markdown

## 🧹 Limpiar el entorno

Para eliminar el clúster y liberar recursos:

```bash
kind delete cluster --name devops-cluster
```

📦 Imagen pública

La imagen de la aplicación está publicada en GHCR:
text
```
ghcr.io/diegogit7/proyecto-devops-kubernetes/mi-web:v1
```
Puedes usarla en cualquier clúster con:
bash
```
kubectl run mi-web --image=ghcr.io/diegogit7/proyecto-devops-kubernetes/mi-web:v1 --port=80
```
