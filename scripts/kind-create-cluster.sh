#!/usr/bin/env bash
# Cria um cluster Kind para praticar labs CKS (NetworkPolicy, RBAC, etc.).
# Uso: ./scripts/kind-create-cluster.sh [nome-do-cluster]
# Funciona no host (local) ou dentro do devcontainer.
# Requer: Docker ou Podman. No host com Podman: export KIND_EXPERIMENTAL_PROVIDER=podman
set -e

CLUSTER_NAME="${1:-cks-lab}"

if ! command -v kind &>/dev/null; then
  echo "kind não encontrado."
  echo "  Local: rode ./scripts/install-cks-tools-local.sh e use: export PATH=\"\$PWD/bin:\$PATH\""
  echo "  Devcontainer: use Reopen in Container (o ambiente já inclui kind)."
  exit 1
fi

# Kind needs Docker or Podman to create node containers
if [ -n "${KIND_EXPERIMENTAL_PROVIDER:-}" ] && [ "$KIND_EXPERIMENTAL_PROVIDER" = "podman" ]; then
  if ! command -v podman &>/dev/null; then
    echo "ERROR: KIND_EXPERIMENTAL_PROVIDER=podman mas 'podman' não está no PATH."
    echo "Instale Podman no host ou use Docker (sem exportar KIND_EXPERIMENTAL_PROVIDER)."
    exit 1
  fi
else
  if ! command -v docker &>/dev/null; then
    echo "ERROR: Nenhum runtime encontrado (Docker ou Podman)."
    echo "  Com Docker: instale e inicie o Docker Desktop (ou docker.service)."
    echo "  Com Podman: instale Podman e rode: export KIND_EXPERIMENTAL_PROVIDER=podman"
    exit 1
  fi
fi

if kind get kubeconfig --name "$CLUSTER_NAME" &>/dev/null; then
  echo "Cluster '$CLUSTER_NAME' já existe."
  echo "  Usar: export KUBECONFIG=\$(kind get kubeconfig --name $CLUSTER_NAME)"
  echo "  Recriar: kind delete cluster --name $CLUSTER_NAME && ./scripts/kind-create-cluster.sh $CLUSTER_NAME"
  exit 0
fi

# Usar Podman se a variável estiver definida (ex.: na máquina com Podman)
if [ -n "${KIND_EXPERIMENTAL_PROVIDER:-}" ]; then
  echo "Usando provider: $KIND_EXPERIMENTAL_PROVIDER"
fi

echo "Creating Kind cluster: $CLUSTER_NAME"
kind create cluster --name "$CLUSTER_NAME" --wait 2m

export KUBECONFIG="$(kind get kubeconfig --name "$CLUSTER_NAME")"
echo ""
echo "KUBECONFIG=$KUBECONFIG"
kubectl cluster-info
echo ""
echo "Cluster pronto. Próximo passo (namespaces dos labs):"
echo "  export KUBECONFIG=\$(kind get kubeconfig --name $CLUSTER_NAME)"
echo "  ./scripts/create-lab-namespaces.sh"
