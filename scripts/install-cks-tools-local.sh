#!/usr/bin/env bash
# Instala ferramentas CKS no host (macOS ou Linux) para rodar o lab localmente, sem devcontainer.
# Uso: ./scripts/install-cks-tools-local.sh
# Coloca binários em ./bin (ou BIN_DIR); adicione ao PATH: export PATH="$PWD/bin:$PATH"
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BIN_DIR="${BIN_DIR:-$REPO_ROOT/bin}"
mkdir -p "$BIN_DIR"
export PATH="$BIN_DIR:$PATH"

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)  ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
esac

# kind
KIND_VERSION="${KIND_VERSION:-v0.25.0}"
if ! command -v kind &>/dev/null; then
  echo "Installing kind ${KIND_VERSION}..."
  case "$OS" in
    darwin) KIND_SUFFIX="kind-darwin-${ARCH}" ;;
    linux)  KIND_SUFFIX="kind-linux-${ARCH}" ;;
    *) echo "Unsupported OS: $OS"; exit 1 ;;
  esac
  curl -sSLo "$BIN_DIR/kind" "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/${KIND_SUFFIX}"
  chmod +x "$BIN_DIR/kind"
fi

# kubectl (opcional: muitas vezes já está instalado via brew/apt)
if ! command -v kubectl &>/dev/null; then
  echo "Installing kubectl..."
  KUBE_VERSION="v1.32.0"
  case "$OS" in
    darwin) KUBE_OS="darwin" ;;
    linux)  KUBE_OS="linux" ;;
    *) exit 1 ;;
  esac
  curl -sSLo "$BIN_DIR/kubectl" "https://dl.k8s.io/release/${KUBE_VERSION}/bin/${KUBE_OS}/${ARCH}/kubectl"
  chmod +x "$BIN_DIR/kubectl"
fi

# Trivy
TRIVY_VERSION="${TRIVY_VERSION:-0.69.3}"
if ! command -v trivy &>/dev/null; then
  echo "Installing Trivy ${TRIVY_VERSION}..."
  case "$OS" in
    darwin) TRIVY_OS="macOS"; [ "$ARCH" = "arm64" ] && TRIVY_ARCH="ARM64" || TRIVY_ARCH="64bit" ;;
    linux)  TRIVY_OS="Linux"; [ "$ARCH" = "arm64" ] && TRIVY_ARCH="ARM64" || TRIVY_ARCH="64bit" ;;
    *) exit 1 ;;
  esac
  curl -sSfL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_${TRIVY_OS}-${TRIVY_ARCH}.tar.gz" \
    | tar -xz -C "$BIN_DIR" && chmod +x "$BIN_DIR/trivy"
fi

# kube-bench (0.15+ tem darwin; 0.6.x só linux)
KUBE_BENCH_VERSION="${KUBE_BENCH_VERSION:-0.15.0}"
if ! command -v kube-bench &>/dev/null; then
  echo "Installing kube-bench ${KUBE_BENCH_VERSION}..."
  case "$OS" in
    darwin) KUBEBENCH_OS="darwin" ;;
    linux)  KUBEBENCH_OS="linux" ;;
    *) exit 1 ;;
  esac
  # Nome do asset: kube-bench_0.15.0_darwin_arm64.tar.gz (sem 'v' no número)
  V="${KUBE_BENCH_VERSION#v}"
  curl -sSfL "https://github.com/aquasecurity/kube-bench/releases/download/v${KUBE_BENCH_VERSION}/kube-bench_${V}_${KUBEBENCH_OS}_${ARCH}.tar.gz" \
    | tar -xz -C /tmp
  mv /tmp/kube-bench "$BIN_DIR/" 2>/dev/null || mv /tmp/kube-bench_*_*/kube-bench "$BIN_DIR/" 2>/dev/null || true
  chmod +x "$BIN_DIR/kube-bench"
fi

# yq
YQ_VERSION="${YQ_VERSION:-v4.44.2}"
if ! command -v yq &>/dev/null; then
  echo "Installing yq ${YQ_VERSION}..."
  case "$OS" in
    darwin) YQ_OS="darwin" ;;
    linux)  YQ_OS="linux" ;;
    *) exit 1 ;;
  esac
  curl -sSL "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_${YQ_OS}_${ARCH}" -o "$BIN_DIR/yq"
  chmod +x "$BIN_DIR/yq"
fi

# bom (só Linux nos releases oficiais; no macOS podemos pular ou usar go install)
if [ "$OS" = "linux" ]; then
  BOM_VERSION="${BOM_VERSION:-v0.7.1}"
  if ! command -v bom &>/dev/null; then
    echo "Installing bom ${BOM_VERSION}..."
    curl -sSfL "https://github.com/kubernetes-sigs/bom/releases/download/${BOM_VERSION}/bom-${ARCH}-linux" \
      -o "$BIN_DIR/bom" && chmod +x "$BIN_DIR/bom"
  fi
fi

# kubeconform
if ! command -v kubeconform &>/dev/null; then
  echo "Installing kubeconform..."
  KUBECONFORM_VERSION="v0.6.3"
  case "$OS" in
    darwin) KUBECONFORM_OS="darwin" ;;
    linux)  KUBECONFORM_OS="linux" ;;
    *) exit 1 ;;
  esac
  curl -sSfL "https://github.com/yannh/kubeconform/releases/download/${KUBECONFORM_VERSION}/kubeconform-${KUBECONFORM_OS}-${ARCH}.tar.gz" \
    | tar -xz -C /tmp 2>/dev/null || curl -sSfL "https://github.com/yannh/kubeconform/releases/download/${KUBECONFORM_VERSION}/kubeconform-${KUBECONFORM_OS}-amd64.tar.gz" \
    | tar -xz -C /tmp
  mv /tmp/kubeconform "$BIN_DIR/" 2>/dev/null || true
  chmod +x "$BIN_DIR/kubeconform"
fi

echo ""
echo "Ferramentas instaladas em: $BIN_DIR"
echo "Para usar no terminal atual:"
echo "  export PATH=\"$BIN_DIR:\$PATH\""
echo ""
echo "Para usar sempre, adicione ao seu ~/.zshrc ou ~/.bashrc:"
echo "  export PATH=\"$BIN_DIR:\$PATH\""
echo ""
echo "Próximo passo: criar o cluster e namespaces"
echo "  export PATH=\"$BIN_DIR:\$PATH\""
echo "  ./scripts/kind-create-cluster.sh cks-lab"
echo "  export KUBECONFIG=\$(kind get kubeconfig --name cks-lab)"
echo "  ./scripts/create-lab-namespaces.sh"
echo ""
echo "Ou use o script único: ./scripts/setup-local-lab.sh"