#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
K8S_DIR="${REPO_ROOT}/poke-app/k8s"
NAMESPACE="poke-app"
HOSTNAME_VALUE="${HOSTNAME_VALUE:-poke.local}"

log() {
  printf '\n==> %s\n' "$1"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Falta el comando requerido: $1" >&2
    exit 1
  fi
}

build_images() {
  log "Construyendo imagen poke-auth:latest"
  docker build -t poke-auth:latest "${REPO_ROOT}/poke-app/auth"

  log "Construyendo imagen poke-back:latest"
  docker build -t poke-back:latest "${REPO_ROOT}/poke-app/back"

  log "Construyendo imagen poke-front:latest"
  docker build \
    -t poke-front:latest \
    "${REPO_ROOT}/poke-app/front" \
    --build-arg VITE_API_BASE_URL=/api/v2 \
    --build-arg VITE_AUTH_BASE_URL=/auth
}

main() {
  require_command minikube
  require_command kubectl
  require_command docker

  log "Arrancando Minikube"
  minikube start

  log "Activando addon ingress"
  minikube addons enable ingress

  log "Conectando al daemon Docker de Minikube"
  eval "$(minikube -p minikube docker-env --shell bash)"

  build_images
}

main "$@"
