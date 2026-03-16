#!/usr/bin/env bash
# Adiciona PODMAN_SOCKET ao seu shell rc para o devcontainer montar o socket do Podman (Mac).
# Uso: ./scripts/setup-podman-env.sh
# Rode uma vez; depois abra o Cursor normalmente (não precisa exportar no terminal).
set -e

RC_FILE=""
if [ -n "${ZDOTDIR:-$HOME}" ] && [ -f "${ZDOTDIR:-$HOME}/.zshrc" ]; then
  RC_FILE="${ZDOTDIR:-$HOME}/.zshrc"
elif [ -f "$HOME/.zshrc" ]; then
  RC_FILE="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
  RC_FILE="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
  RC_FILE="$HOME/.bash_profile"
else
  echo "Nenhum .zshrc, .bashrc ou .bash_profile encontrado. Crie um ou defina PODMAN_SOCKET manualmente."
  exit 1
fi

LINE='# CKS devcontainer: socket do Podman para o Kind dentro do container'
EXPORT='export PODMAN_SOCKET=$(podman machine inspect --format '\''{{.ConnectionInfo.PodmanSocket.Path}}'\'' 2>/dev/null) || true'

if grep -q 'PODMAN_SOCKET' "$RC_FILE" 2>/dev/null; then
  echo "PODMAN_SOCKET já está configurado em $RC_FILE"
else
  echo "" >> "$RC_FILE"
  echo "$LINE" >> "$RC_FILE"
  echo "$EXPORT" >> "$RC_FILE"
  echo "Adicionado a $RC_FILE:"
  echo "  $EXPORT"
fi

echo ""
echo "Próximos passos:"
echo "  1. Feche e reabra o terminal (ou: source $RC_FILE)"
echo "  2. Inicie a máquina: podman machine start"
echo "  3. Abra o Cursor e use Reopen in Container (não precisa abrir o Cursor pelo terminal)."
