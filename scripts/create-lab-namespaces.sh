#!/usr/bin/env bash
# Cria namespaces usados nos labs do simulador CKS (Killer.sh / lab.txt).
# Uso: ./scripts/create-lab-namespaces.sh
# Requer: kubectl configurado (cluster Kind, Minikube ou outro).
set -e

# Namespaces das questões do simulador (team-*, metadata-access, restricted, security, internal)
NAMESPACES=(
  team-red
  team-blue
  team-green
  team-orange
  team-purple
  team-yellow
  team-pink
  team-white
  metadata-access
  restricted
  security
  internal
)

if ! command -v kubectl &>/dev/null; then
  echo "kubectl não encontrado. Configure o cluster antes (ex.: ./scripts/kind-create-cluster.sh)."
  exit 1
fi

echo "Criando namespaces para labs CKS..."
for ns in "${NAMESPACES[@]}"; do
  if kubectl get namespace "$ns" &>/dev/null; then
    echo "  OK (já existe): $ns"
  else
    kubectl create namespace "$ns"
    echo "  Criado: $ns"
  fi
done

echo ""
echo "Namespaces prontos. Exemplos de uso:"
echo "  kubectl get ns"
echo "  kubectl label ns team-red pod-security.kubernetes.io/enforce=baseline"
echo "  kubectl run nginx --image=nginx -n team-blue"
