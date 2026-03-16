#!/usr/bin/env bash
# Instala todas as ferramentas do CKS Lab SEM usar build (para uso com devcontainer-podman.json).
# Evita buildx/build; roda como postCreateCommand. Requer: curl, ca-certificates.
# Instala em /usr/local/bin se tiver permissão, senão em ~/.local/bin.
set -e

if [ -w /usr/local/bin ] 2>/dev/null; then
  export BIN_DIR="/usr/local/bin"
else
  export BIN_DIR="${HOME:-/home/vscode}/.local/bin"
  mkdir -p "$BIN_DIR"
  echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "${HOME:-/home/vscode}/.bashrc" 2>/dev/null || true
fi
export PATH="${BIN_DIR}:${PATH}"

# Kubectl
install_kubectl() {
  if command -v kubectl &>/dev/null; then return; fi
  echo "[CKS Lab] Installing kubectl..."
  curl -sSL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /tmp/kubectl \
    && chmod +x /tmp/kubectl && mv /tmp/kubectl "$BIN_DIR"
}

# Helm (binário direto para não depender de get-helm-3)
install_helm() {
  if command -v helm &>/dev/null; then return; fi
  echo "[CKS Lab] Installing Helm..."
  HELM_VERSION="v3.16.3"
  curl -sSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" | tar -xz -C /tmp \
    && mv /tmp/linux-amd64/helm "$BIN_DIR" && chmod +x "$BIN_DIR/helm" && rm -rf /tmp/linux-amd64
}

# Podman remote client - para Kind usar o Podman do host (socket montado no devcontainer)
install_podman_remote() {
  # Só pular se o podman existente realmente executar (evita binário de arquitetura errada)
  if command -v podman &>/dev/null && podman --version &>/dev/null; then return; fi
  echo "[CKS Lab] Installing Podman (remote client)..."
  PODMAN_VERSION="v5.8.1"
  ARCH="$(uname -m)"
  case "$ARCH" in
    aarch64|arm64) PODMAN_ARCH="arm64";;
    x86_64|amd64) PODMAN_ARCH="amd64";;
    *)             echo "[CKS Lab] AVISO: arquitetura '$ARCH' não suportada para podman-remote. Pulando."; return;;
  esac
  echo "[CKS Lab] Arquitetura detectada: $ARCH -> podman-remote-static-linux_${PODMAN_ARCH}"
  curl -sSfL "https://github.com/containers/podman/releases/download/${PODMAN_VERSION}/podman-remote-static-linux_${PODMAN_ARCH}.tar.gz" \
    -o /tmp/podman-remote.tar.gz
  tar -xzf /tmp/podman-remote.tar.gz -C /tmp
  PODMAN_BIN="/tmp/bin/podman-remote-static-linux_${PODMAN_ARCH}"
  [ ! -f "$PODMAN_BIN" ] && PODMAN_BIN="$(find /tmp -maxdepth 3 -name 'podman-remote*' -type f 2>/dev/null | head -1)"
  if [ -z "$PODMAN_BIN" ] || [ ! -f "$PODMAN_BIN" ]; then
    echo "[CKS Lab] ERRO: binário podman não encontrado no tarball."
    rm -f /tmp/podman-remote.tar.gz
    return 1
  fi
  # Verificar se o binário executa nesta arquitetura antes de instalar
  if ! "$PODMAN_BIN" --version &>/dev/null; then
    echo "[CKS Lab] ERRO: binário podman não executa nesta máquina (arquitetura?). Tente usar a variante Docker do devcontainer."
    rm -f /tmp/podman-remote.tar.gz
    rm -rf /tmp/bin 2>/dev/null || true
    return 1
  fi
  rm -f "$BIN_DIR/podman" 2>/dev/null || true
  mv "$PODMAN_BIN" "$BIN_DIR/podman"
  chmod +x "$BIN_DIR/podman"
  rm -f /tmp/podman-remote.tar.gz
  rm -rf /tmp/bin 2>/dev/null || true
}

# Executa o script de ferramentas CKS (trivy, kube-bench, kind, bom, yq, kubeconform)
install_cks_tools() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [ -f "${script_dir}/install-cks-tools.sh" ]; then
    echo "[CKS Lab] Installing CKS tools (trivy, kube-bench, kind, bom, yq, kubeconform)..."
    bash "${script_dir}/install-cks-tools.sh"
  fi
}

# Diretório de lab
mkdir -p /opt/course
chown -R vscode:vscode /opt/course 2>/dev/null || true

install_kubectl
install_helm
install_podman_remote
install_cks_tools

# Garantir KIND_EXPERIMENTAL_PROVIDER e CONTAINER_HOST em novos shells (socket montado em /var/run/docker.sock no devcontainer)
echo 'export KIND_EXPERIMENTAL_PROVIDER=podman' >> "${HOME:-/home/vscode}/.bashrc" 2>/dev/null || true
echo 'export CONTAINER_HOST="${CONTAINER_HOST:-unix:///var/run/docker.sock}"' >> "${HOME:-/home/vscode}/.bashrc" 2>/dev/null || true
# Forçar o cliente podman-remote a usar o socket do host (evita conexão em /tmp/...)
CONTAINERS_CONF="${HOME:-/home/vscode}/.config/containers/containers.conf"
mkdir -p "$(dirname "$CONTAINERS_CONF")"
if [ ! -s "$CONTAINERS_CONF" ]; then
  cat > "$CONTAINERS_CONF" << 'EOF'
# CKS Lab: socket do host montado pelo devcontainer em /var/run/docker.sock
[engine]
active_service = "host"
[engine.service_destinations.host]
uri = "unix:///var/run/docker.sock"
EOF
fi

echo "[CKS Lab] Done. Tools: kubectl, helm, podman, trivy, kube-bench, kind, bom, yq, kubeconform"
if command -v podman &>/dev/null; then
  if podman info &>/dev/null; then
    echo "[CKS Lab] Podman: conectado ao host (socket montado). Pode rodar: ./scripts/kind-create-cluster.sh"
  else
    echo "[CKS Lab] AVISO: podman info falhou (socket do host inacessível ou Podman parado)."
    echo "  - Linux no host: confira se o Podman está rodando (ex.: systemctl --user start podman.socket)."
    echo "  - Mac/Windows: feche o terminal do container e abra um terminal NO HOST; aí rode:"
    echo "      podman machine init   # uma vez"
    echo "      podman machine start"
    echo "    (NÃO rode 'podman machine' dentro do devcontainer — aqui só temos o cliente que usa o socket do host.)"
    echo "  - Se o socket está em /var/run/docker.sock: rode  export CONTAINER_HOST=unix:///var/run/docker.sock  e tente  podman info  de novo."
  fi
fi
