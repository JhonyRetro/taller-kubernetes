#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACK_DIR="$ROOT_DIR/back"
FRONT_DIR="$ROOT_DIR/front"

BACK_PID=""
FRONT_PID=""

cleanup() {
  if [[ -n "${FRONT_PID}" ]] && kill -0 "${FRONT_PID}" 2>/dev/null; then
    kill "${FRONT_PID}" 2>/dev/null || true
  fi

  if [[ -n "${BACK_PID}" ]] && kill -0 "${BACK_PID}" 2>/dev/null; then
    kill "${BACK_PID}" 2>/dev/null || true
  fi
}

require_command() {
  local command_name="$1"

  if ! command -v "${command_name}" >/dev/null 2>&1; then
    echo "Error: no se encontró '${command_name}' en el PATH." >&2
    exit 1
  fi
}

trap cleanup EXIT INT TERM

require_command dotnet
require_command npm

if [[ ! -d "$FRONT_DIR/node_modules" ]]; then
  echo "Instalando dependencias del frontend..."
  (cd "$FRONT_DIR" && npm install)
fi

echo "Restaurando dependencias del backend..."
(cd "$BACK_DIR" && dotnet restore >/dev/null)

echo "Levantando backend en http://localhost:5180 ..."
(cd "$BACK_DIR" && dotnet run) &
BACK_PID=$!

echo "Levantando frontend con Vite..."
(cd "$FRONT_DIR" && npm run dev) &
FRONT_PID=$!

wait -n "$BACK_PID" "$FRONT_PID"
