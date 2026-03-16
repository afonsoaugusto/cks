#!/usr/bin/env bash
# Configura o lab CKS localmente (sem devcontainer): instala ferramentas, cria cluster Kind e namespaces.
# Uso: ./scripts/setup-local-lab.sh [nome-do-cluster]
# Requer: Docker ou Podman no host. Com Podman: export KIND_EXPERIMENTAL_PROVIDER=podman
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CLUSTER_NAME="${1:-cks-lab}"

# 1) Garantir que as ferramentas estão no PATH (bin do repo ou sistema)
if ! command -v kind &>/dev/null; then
  if [ -x "$REPO_ROOT/bin/kind" ]; then
    export PATH="$REPO_ROOT/bin:$PATH"
  else
    echo "kind não encontrado. Instalando ferramentas em $REPO_ROOT/bin ..."
    BIN_DIR="$REPO_ROOT/bin" bash "$SCRIPT_DIR/install-cks-tools-local.sh"
    export PATH="$REPO_ROOT/bin:$PATH"
  fi
fi

# 2) Criar cluster
bash "$SCRIPT_DIR/kind-create-cluster.sh" "$CLUSTER_NAME"
export KUBECONFIG="$(kind get kubeconfig --name "$CLUSTER_NAME")"

# 3) Criar namespaces dos labs
bash "$SCRIPT_DIR/create-lab-namespaces.sh"

echo ""
echo "=============================================="
echo "  Lab CKS configurado localmente (cluster: $CLUSTER_NAME)"
echo "=============================================="
echo ""
echo "Use no terminal (ou adicione ao ~/.zshrc):"
echo "  export KUBECONFIG=\$(kind get kubeconfig --name $CLUSTER_NAME)"
echo ""
echo "Comandos diários úteis:"
echo "  kubectl get nodes && kubectl get ns"
echo "  kubectl config get-contexts"
echo "  ./scripts/create-lab-namespaces.sh   # recriar namespaces se precisar"
echo "  kind delete cluster --name $CLUSTER_NAME && ./scripts/setup-local-lab.sh $CLUSTER_NAME   # resetar cluster"
echo ""
echo "Material de estudo: lab.txt (questões) e CKS-PREPARACAO.md (comandos e plano diário)."
echo ""
