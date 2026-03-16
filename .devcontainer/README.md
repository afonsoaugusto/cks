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

**Alternativa sem container:** para rodar o lab só no host (Mac/Linux), use `./scripts/setup-local-lab.sh cks-lab` (requer Docker ou Podman). Veja [README.md](../README.md#opção-1-rodar-localmente-sem-devcontainer).

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

### Erro "An error occurred building the image" (podman buildx build)

O Dev Containers usa **buildx** para construir a imagem com *features* (kubectl, Docker-in-Docker, etc.). O **Podman** não suporta bem esse fluxo (build-context, BuildKit), então o build pode falhar.

**Solução: usar a configuração que não faz build**

1. Faça backup e troque a configuração:
   ```bash
   cd /caminho/para/cks
   mv .devcontainer/devcontainer.json .devcontainer/devcontainer-docker.json
   cp .devcontainer/devcontainer-podman.json .devcontainer/devcontainer.json
   ```
2. No Cursor, **Reopen in Container**.

A **devcontainer-podman.json** usa só uma **imagem pré-pronta** (sem build) e instala as ferramentas (kubectl, helm, podman-remote, trivy, kube-bench, kind, bom, yq, kubeconform) no **postCreateCommand**. A primeira abertura pode levar alguns minutos.

**Kind dentro do container (com Podman no host):** O devcontainer monta o socket do host em **`/var/run/docker.sock`** (no Mac com Podman Machine esse é o socket de compatibilidade Docker). Dentro do container é instalado o **podman-remote**, com `CONTAINER_HOST=unix:///var/run/docker.sock` e `KIND_EXPERIMENTAL_PROVIDER=podman`. Assim você pode rodar **dentro do container** `./scripts/kind-create-cluster.sh` — o Kind usará o Podman do host para criar os nós.

**Mac:** No macOS o socket do Podman fica em um path **dinâmico** (em `TMPDIR`). O devcontainer monta o socket usando a variável de ambiente do host **`PODMAN_SOCKET`**.

**Opção A – Manual (uma sessão):** No terminal, `export PODMAN_SOCKET=$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')` e abra o Cursor por esse terminal.

**Opção B – Fixa (recomendada):** Rode uma vez o script que adiciona o export ao seu `~/.zshrc` (ou `.bashrc`). Depois disso, qualquer terminal e o Cursor herdam a variável; não precisa abrir o Cursor pelo terminal.
   ```bash
   ./scripts/setup-podman-env.sh
   source ~/.zshrc   # ou feche e reabra o terminal
   podman machine start
   ```
   Em seguida abra o Cursor e use **Reopen in Container** normalmente.

**Alternativa (symlink fixo):** Se preferir um path fixo em vez da variável, crie o symlink e altere o mount no `devcontainer.json` para `source=${localEnv:HOME}/.local/share/containers/podman/machine/podman.sock,...`:
   ```bash
   mkdir -p ~/.local/share/containers/podman/machine
   ln -sf "$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')" ~/.local/share/containers/podman/machine/podman.sock
   ```
   Recrie o symlink após reiniciar o Mac (o path em TMPDIR muda).

### Kind e Minikube com Podman

- **Kind dentro do dev container:** Com a configuração atual (socket montado + podman-remote), rode **dentro do container**: `./scripts/kind-create-cluster.sh cks-lab`. O Kind usa o Podman do host.
- **Kind no host (alternativa):** Se preferir criar o cluster no Mac: `export KIND_EXPERIMENTAL_PROVIDER=podman && ./scripts/kind-create-cluster.sh cks-lab`. Depois use o mesmo `KUBECONFIG` no container.
- **Minikube:** Suporta driver **podman** no host: `minikube start --driver=podman`.

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
