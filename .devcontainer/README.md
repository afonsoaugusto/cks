# CKS Lab — Dev Container

Ambiente de desenvolvimento e laboratório para preparação ao exame **Certified Kubernetes Security Specialist (CKS)**.

## O que está incluído

- **Kubernetes:** `kubectl`, **Kind** e **Minikube** para clusters locais
- **Segurança e supply chain:** **Trivy**, **kube-bench**, **bom** (SBOM), **kubeconform**
- **Utilitários:** **Helm**, **kubectx/kubens**, **yq**, **Go**, **Python**, **uv**
- **Docker-in-Docker:** para construir imagens e rodar Kind/Minikube

## Como usar

1. Abra o repositório no VS Code/Cursor.
2. Use **“Reopen in Container”** (Dev Containers) ou **“Codespaces”** para iniciar o ambiente.
3. Após o build, as ferramentas estarão disponíveis no terminal.

## Usar com Podman na sua máquina

**Sim, o fluxo funciona com Podman.**

### Erro "spawn docker ENOENT" ao abrir o Dev Container

Se a extensão Dev Containers falhar com **docker** não encontrado, é porque ela procura o binário `docker`. Com Podman, é preciso dizer ao Cursor/VS Code para usar o `podman` no lugar.

**Opção 1 – Configuração no repositório (já feita)**  
O arquivo **`.vscode/settings.json`** deste projeto já contém:

```json
"dev.containers.dockerPath": "podman",
"dev.containers.mountWaylandSocket": false
```

Assim, ao abrir esta pasta, o Dev Containers usa Podman. Certifique-se de que o comando `podman` existe no PATH (ex.: `which podman`).

**Opção 2 – Configuração no usuário (Cursor/VS Code)**  
Se preferir aplicar para todos os projetos:

1. Abra **Settings** (Ctrl+, / Cmd+,).
2. Procure por **Dev Containers: Docker Path**.
3. Defina o valor para **`podman`**.

Ou edite o `settings.json` do usuário e adicione:

```json
"dev.containers.dockerPath": "podman",
"dev.containers.mountWaylandSocket": false
```

Depois disso, use **Reopen in Container** de novo. No Mac/Windows, se o Podman rodar em máquina virtual, inicie antes: `podman machine start`.

### Kind e Minikube com Podman

- **Kind:** No host com Podman:
  ```bash
  export KIND_EXPERIMENTAL_PROVIDER=podman
  ./scripts/kind-create-cluster.sh cks-lab
  ```
  Requer Kind 0.22+ e Podman 5+ (em alguns ambientes rootless o Kind pode ter limitações).
- **Minikube:** Suporta driver **podman** nativamente:
  ```bash
  minikube start --driver=podman
  ```

## Criar um cluster para lab

Com **Kind** (recomendado para NetworkPolicy e multi-node):

```bash
# Com Docker (padrão) ou, no host com Podman: export KIND_EXPERIMENTAL_PROVIDER=podman
./scripts/kind-create-cluster.sh cks-lab
export KUBECONFIG=$(kind get kubeconfig --name cks-lab)
./scripts/create-lab-namespaces.sh
kubectl get nodes && kubectl get ns
```

Com **Minikube** (com Podman: `minikube start --driver=podman`):

```bash
minikube start
./scripts/create-lab-namespaces.sh
kubectl get nodes
```

## Ferramentas CKS (referência rápida)

| Ferramenta    | Uso no exame / lab                          |
|---------------|---------------------------------------------|
| `kubectl`     | Contextos, RBAC, Pod Security, recursos      |
| `kind`        | Cluster local para exercícios               |
| `trivy`       | Scan de imagens e SBOM, vulnerabilidades    |
| `kube-bench`  | CIS Kubernetes Benchmark (control plane/node) |
| `bom`         | SBOM em formato SPDX                         |
| `yq`          | Edição/consulta YAML/JSON (ex.: audit logs)  |
| `kubeconform` | Validação de manifests Kubernetes           |

## Diretório de trabalho

- `/opt/course` existe no container (como no simulador Killer.sh) para você criar cenários de lab.
- O repositório é montado no workspace; use `lab.txt` e `CKS-PREPARACAO.md` como referência.

## Limitações no container

- **Falco:** o binário não é instalado por padrão (depende do kernel do host). Para runtime security, use o simulador Killer.sh ou um cluster com Falco nos nós.
- **kube-bench:** no Kind/Minikube muitos checks do CIS falham por design; use para praticar os comandos e a leitura do output.
- **etcd:** em Kind o etcd fica dentro do nó; para acessar como no exame, use o simulador ou um cluster kubeadm.

## Referências

- [CKS-PREPARACAO.md](../CKS-PREPARACAO.md) — Comandos e plano de estudo
- [lab.txt](../lab.txt) — Simulador Killer.sh (questões e respostas)
- [README do repositório](../README.md) — Currículo e links
