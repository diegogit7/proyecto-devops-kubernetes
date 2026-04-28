# Usar una imagen base de nginx (servidor web)
FROM nginx:alpine

# Copiar nuestra página web al contenedor
COPY index.html /usr/share/nginx/html/index.html

# Exponer el puerto 80
EXPOSE 80

# Comando para correr nginx
CMD ["nginx", "-g", "daemon off;"]
