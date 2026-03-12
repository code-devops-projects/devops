# --- Detener y eliminar todos los contenedores ---
$containers = docker ps -aq
if ($containers) {
    docker stop $containers
    docker rm $containers
}

# --- Eliminar todas las imágenes ---
$images = docker images -q
if ($images) {
    docker rmi $images
}

# --- Eliminar todos los volúmenes ---
$volumes = docker volume ls -q
if ($volumes) {
    docker volume rm $volumes
}

# --- Eliminar todas las redes (excepto las predeterminadas) ---
# Filtramos las redes para excluir bridge, host y none
$networks = docker network ls --filter "name=^((?!bridge|host|none).)*$" -q
foreach ($net in $networks) {
    docker network rm $net
}