#!/usr/bin/env bash
# Instala ferramentas usadas no exame e labs CKS (Certified Kubernetes Security Specialist).
# Executado durante o build do devcontainer.
set -e

BIN_DIR="${BIN_DIR:-/usr/local/bin}"
TRIVY_VERSION="${TRIVY_VERSION:-0.52.0}"
KUBE_BENCH_VERSION="${KUBE_BENCH_VERSION:-0.6.3}"
KIND_VERSION="${KIND_VERSION:-v0.25.0}"
BOM_VERSION="${BOM_VERSION:-v0.8.1}"
YQ_VERSION="${YQ_VERSION:-v4.44.2}"

# Trivy - scan de vulnerabilidades e SBOM
install_trivy() {
  if command -v trivy &>/dev/null; then return; fi
  echo "Installing Trivy ${TRIVY_VERSION}..."
  curl -sSfL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz" \
    | tar -xz -C /tmp && mv /tmp/trivy "$BIN_DIR" && chmod +x "$BIN_DIR/trivy"
}

# kube-bench - CIS Kubernetes Benchmark
install_kube_bench() {
  if command -v kube-bench &>/dev/null; then return; fi
  echo "Installing kube-bench ${KUBE_BENCH_VERSION}..."
  curl -sSfL "https://github.com/aquasecurity/kube-bench/releases/download/v${KUBE_BENCH_VERSION}/kube-bench_${KUBE_BENCH_VERSION}_linux_amd64.tar.gz" \
    | tar -xz -C /tmp && mv /tmp/kube-bench "$BIN_DIR" && chmod +x "$BIN_DIR/kube-bench"
}

# kind - Kubernetes in Docker (clusters locais para lab)
install_kind() {
  if command -v kind &>/dev/null; then return; fi
  echo "Installing kind ${KIND_VERSION}..."
  curl -sSLo /tmp/kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64" \
    && chmod +x /tmp/kind && mv /tmp/kind "$BIN_DIR"
}

# bom - Bill of Materials (SBOM SPDX)
install_bom() {
  if command -v bom &>/dev/null; then return; fi
  echo "Installing bom ${BOM_VERSION}..."
  curl -sSfL "https://github.com/kubernetes-sigs/bom/releases/download/${BOM_VERSION}/bom-linux-amd64" \
    -o /tmp/bom && chmod +x /tmp/bom && mv /tmp/bom "$BIN_DIR"
}

# yq - YAML/JSON (útil para audit logs e manifests)
install_yq() {
  if command -v yq &>/dev/null; then return; fi
  echo "Installing yq ${YQ_VERSION}..."
  curl -sSL "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /tmp/yq \
    && chmod +x /tmp/yq && mv /tmp/yq "$BIN_DIR"
}

# kubeconform - validação de manifests (opcional, leve)
install_kubeconform() {
  if command -v kubeconform &>/dev/null; then return; fi
  echo "Installing kubeconform..."
  KUBECONFORM_VERSION="v0.6.3"
  curl -sSfL "https://github.com/yannh/kubeconform/releases/download/${KUBECONFORM_VERSION}/kubeconform-linux-amd64.tar.gz" \
    | tar -xz -C /tmp && mv /tmp/kubeconform "$BIN_DIR" && chmod +x "$BIN_DIR/kubeconform"
}

install_trivy
install_kube_bench
install_kind
install_bom
install_yq
install_kubeconform

echo "CKS tools installed: trivy, kube-bench, kind, bom, yq, kubeconform"
