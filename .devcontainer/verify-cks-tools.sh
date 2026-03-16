#!/usr/bin/env bash
# Verifica se as ferramentas CKS estão disponíveis (executado no postCreateCommand).
set -e
echo "Checking CKS lab tools..."
version_of() {
  case "$1" in
    trivy)       "$1" --version 2>/dev/null ;;
    kubeconform) "$1" -v 2>/dev/null ;;
    podman)      "$1" --version 2>/dev/null ;;
    *)           "$1" version --short 2>/dev/null || "$1" --version 2>/dev/null | head -1 ;;
  esac
}
for cmd in kubectl helm podman trivy kube-bench kind bom yq kubeconform; do
  if command -v "$cmd" &>/dev/null; then
    echo "  OK $cmd: $(version_of "$cmd")"
  else
    echo "  MISSING $cmd"
  fi
done
echo "Done. Use 'scripts/kind-create-cluster.sh' to create a lab cluster."
