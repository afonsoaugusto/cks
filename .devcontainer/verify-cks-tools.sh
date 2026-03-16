#!/usr/bin/env bash
# Verifica se as ferramentas CKS estão disponíveis (executado no postCreateCommand).
set -e
echo "Checking CKS lab tools..."
for cmd in kubectl helm trivy kube-bench kind bom yq kubeconform; do
  if command -v "$cmd" &>/dev/null; then
    echo "  OK $cmd: $($cmd version --short 2>/dev/null || $cmd --version 2>/dev/null | head -1)"
  else
    echo "  MISSING $cmd"
  fi
done
echo "Done. Use 'scripts/kind-create-cluster.sh' to create a lab cluster."
