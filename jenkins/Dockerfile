# Usa una imagen Jenkins LTS con JDK 17 más reciente y estable
FROM jenkins/jenkins:lts-jdk17

# Cambia al usuario root para instalar paquetes
USER root

# Instalar Docker CLI + plugin de Compose v2 (sin daemon) y utilidades
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg lsb-release sudo \
  && install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg \
     | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
     https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
     > /etc/apt/sources.list.d/docker.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin \
  && rm -rf /var/lib/apt/lists/*

# Agregar el usuario jenkins al grupo docker (créalo si no existe)
RUN groupadd -f docker && usermod -aG docker jenkins \
  && echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Volver al usuario Jenkins
USER jenkins

# (Opcional) Exponer puertos — ya vienen en la imagen base, pero no estorba
EXPOSE 8080 50000

# No redefinimos ENTRYPOINT: la imagen oficial ya usa tini y /usr/local/bin/jenkins.sh
