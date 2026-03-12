
# Guía de Instalación de Jenkins con Docker

## Versión Actualizada: Jenkins LTS con JDK 17

### Paso 1: Limpiar instalación anterior (si existe)

```bash
docker stop jenkins
docker rm jenkins
docker volume rm jenkins_home
docker rmi jenkins
```

## Paso 2: Construir la imagen de Docker

```bash
docker build -t jenkins .
```

## Paso 3: Cambiar permisos en el volumen (opcional)

```bash
docker run --rm -v jenkins_home:/var/jenkins_home alpine chown -R 1000:1000 /var/jenkins_home
```

## Paso 4: Ejecutar el contenedor de Jenkins

```bash
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins --privileged -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkins
```

## Paso 5: Verificar que el contenedor está corriendo

```bash
docker ps -f name=jenkins
```

## Paso 6: Esperar a que Jenkins inicie (30 segundos)

Verificar los logs para confirmar que Jenkins está listo:

```bash
docker logs jenkins --tail 20
```

Buscar el mensaje: **"Jenkins is fully up and running"**

## Paso 7: Obtener la clave de administrador

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

**Clave actual:**

```
64a3d63510b14d65bc4a881f8d838337
```

## Paso 8: Acceder a Jenkins

- **URL:** http://localhost:8080
- **Usuario:** admin (crear en el primer acceso)
- **Contraseña inicial:** usar la clave de arriba

## Paso 9 (opcional): Acceder al contenedor como root

```bash
docker exec -it --user root jenkins bash
```

---

## Solución de problemas con plugins

Si encuentras errores al instalar plugins sugeridos, hay varias opciones:

### Opción 1: Saltar la instalación de plugins y configurar manualmente

1. En la interfaz web, hacer clic en **"Select plugins to install"**
2. Desmarcar todos los plugins o seleccionar solo los esenciales
3. Continuar con la configuración del usuario administrador
4. Instalar plugins manualmente después desde **Manage Jenkins → Plugin Manager**

### Opción 2: Actualizar la lista de plugins desde el contenedor

```bash
docker exec -it jenkins bash -c "cd /var/jenkins_home/updates && curl -L https://updates.jenkins.io/update-center.json -o default.json"
docker restart jenkins
```

**Nota:** Espera 10-15 segundos después del reinicio para que Jenkins inicie completamente.

### Verificar el estado del contenedor

```bash
docker ps -f name=jenkins
docker logs jenkins --tail 20
```

### Opción 3: Instalar plugins esenciales vía CLI

```bash
docker exec -it jenkins bash
java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ -auth admin:YOUR_PASSWORD install-plugin git
java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ -auth admin:YOUR_PASSWORD install-plugin workflow-aggregator
java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ -auth admin:YOUR_PASSWORD install-plugin docker-workflow
exit
docker restart jenkins
```

### Opción 4: Realizar instalación limpia completa

Si los problemas persisten, hacer una instalación limpia desde cero:

```bash
# Detener y eliminar todo
docker stop jenkins
docker rm jenkins
docker volume rm jenkins_home
docker rmi jenkins

# Reconstruir y ejecutar
docker build -t jenkins .
docker run --rm -v jenkins_home:/var/jenkins_home alpine chown -R 1000:1000 /var/jenkins_home
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins --privileged \
-v jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
jenkins
```

**Nota:** El Dockerfile ya usa `jenkins/jenkins:lts-jdk17`, la versión más reciente y estable.

---

## Acceso manual a sudo para Jenkins

### Reiniciar el contenedor

```bash
docker ps
docker restart jenkins
```

### Acceder al contenedor como root y editar sudoers

```bash
docker exec -it --user root jenkins bash
nano /etc/sudoers
```

### Dentro de nano, agregar al final del archivo:

```
jenkins ALL=(ALL) NOPASSWD: ALL
```

### Guardar y salir de nano

- Presionar `Ctrl + X`
- Presionar `Y` para confirmar que deseas guardar los cambios
- Presionar `Enter` para confirmar el nombre del archivo

### Reiniciar el contenedor nuevamente

```bash
docker ps
docker restart jenkins
```
