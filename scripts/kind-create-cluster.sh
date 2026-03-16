#!/usr/bin/env bash
# Cria um cluster Kind para praticar labs CKS (NetworkPolicy, RBAC, etc.).
# Uso: ./scripts/kind-create-cluster.sh [nome-do-cluster]
# Requer: Docker ou Podman (no host ou no devcontainer).
# Com Podman no host: export KIND_EXPERIMENTAL_PROVIDER=podman antes de rodar.
set -e

CLUSTER_NAME="${1:-cks-lab}"

if ! command -v kind &>/dev/null; then
  echo "kind não encontrado. Use o devcontainer CKS Lab ou instale kind."
  exit 1
fi

if kind get kubeconfig --name "$CLUSTER_NAME" &>/dev/null; then
  echo "Cluster '$CLUSTER_NAME' já existe. Use: kind delete cluster --name $CLUSTER_NAME"
  echo "Para usar: export KUBECONFIG=\$(kind get kubeconfig --name $CLUSTER_NAME)"
  exit 0
fi

# Usar Podman se a variável estiver definida (ex.: na máquina com Podman)
if [ -n "${KIND_EXPERIMENTAL_PROVIDER:-}" ]; then
  echo "Usando provider: $KIND_EXPERIMENTAL_PROVIDER"
fi

echo "Creating Kind cluster: $CLUSTER_NAME"
kind create cluster --name "$CLUSTER_NAME" --wait 2m

export KUBECONFIG="$(kind get kubeconfig --name "$CLUSTER_NAME")"
echo "KUBECONFIG=$KUBECONFIG"
kubectl cluster-info
echo ""
echo "Cluster pronto. Para criar os namespaces dos labs: ./scripts/create-lab-namespaces.sh"
