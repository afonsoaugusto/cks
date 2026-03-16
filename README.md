[![afonsoaugusto - cks](https://img.shields.io/static/v1?label=afonsoaugusto&message=cks&color=blue&logo=github)](https://github.com/afonsoaugusto/cks "Go to GitHub repo")
[![stars - cks](https://img.shields.io/github/stars/afonsoaugusto/cks?style=social)](https://github.com/afonsoaugusto/cks)
[![forks - cks](https://img.shields.io/github/forks/afonsoaugusto/cks?style=social)](https://github.com/afonsoaugusto/cks)

# Certified Kubernetes Security Specialist (CKS) Exam Curriculum

Uma publicação da **Cloud Native Computing Foundation (CNCF)**  
Website: [cncf.io](https://cncf.io)

---

## Documentação (arquivos Markdown)

| Arquivo | Descrição |
|---------|-----------|
| [README.md](./README.md) | Este arquivo — visão geral do repositório CKS. |
| [CKS-PREPARACAO.md](./CKS-PREPARACAO.md) | Guia de preparação para a prova CKS: comandos, plano de estudo e checklist. |
| [LINKS-KCNA-KCSA-NOTEBOOKLM.md](./LINKS-KCNA-KCSA-NOTEBOOKLM.md) | Lista de links para preparação KCNA e KCSA (para uso no NotebookLM). |
| [PERGUNTAS-RESPOSTAS-KCNA-KCSA.md](./PERGUNTAS-RESPOSTAS-KCNA-KCSA.md) | Perguntas e respostas com explicações para as provas KCNA e KCSA. |
| [.devcontainer/README.md](./.devcontainer/README.md) | Instruções do Dev Container (Docker/Podman) para o lab CKS. |
| [apparmor/README.md](./apparmor/README.md) | Documentação do diretório AppArmor (perfis e uso no lab). |
| [PROMPTS-NOTEBOOKLM-AUDIO.md](./PROMPTS-NOTEBOOKLM-AUDIO.md) | Prompts para usar no NotebookLM e gerar áudio explicativo de cada tópico CKS. |

---

## Preparação para a prova

**[CKS-PREPARACAO.md](./CKS-PREPARACAO.md)** — Guia de preparação com:
- Revisão do repositório e uso do material
- Comandos que precisam estar na ponta do dedo (por domínio)
- Plano de ações diárias (4 semanas) até a prova
- Checklist rápido e referências externas

---

## Ambiente de lab

### Opção 1: Rodar localmente (sem devcontainer)

No seu Mac ou Linux, com **Docker** ou **Podman** instalado:

```bash
# Com Podman (opcional): export KIND_EXPERIMENTAL_PROVIDER=podman
./scripts/setup-local-lab.sh cks-lab
```

Esse script instala as ferramentas (kind, kubectl, trivy, kube-bench, yq, etc.) em `./bin`, cria o cluster Kind e os namespaces dos labs. Depois, use no terminal:

```bash
export KUBECONFIG=$(kind get kubeconfig --name cks-lab)
kubectl get nodes && kubectl get ns
```

Se preferir instalar as ferramentas manualmente: `./scripts/install-cks-tools-local.sh` e depois `./scripts/kind-create-cluster.sh cks-lab` e `./scripts/create-lab-namespaces.sh`.  
Comandos diários e plano de estudo: [CKS-PREPARACAO.md](CKS-PREPARACAO.md).

### Opção 2: Dev Container

Use **Reopen in Container** no VS Code/Cursor para subir o ambiente **CKS Lab** com:

- **kubectl**, **Kind**, **Minikube**, **Helm**
- **Trivy**, **kube-bench**, **bom** (SBOM), **kubeconform**, **yq**
- Docker-in-Docker, **kubectx/kubens**, Go, Python

Depois, crie um cluster e os namespaces dos labs:

- `./scripts/kind-create-cluster.sh cks-lab`
- `./scripts/create-lab-namespaces.sh`

**Usando Podman:** o Dev Container e o Kind funcionam com Podman; veja [.devcontainer/README.md](.devcontainer/README.md#usar-com-podman-na-sua-máquina).  
Detalhes do ambiente: [.devcontainer/README.md](.devcontainer/README.md)

---

## Conteúdo do repositório (revisão)

| Recurso | Descrição |
|--------|-----------|
| **lab.txt** | Simulador Killer.sh CKS (K8s 1.32): 23 questões com respostas. Material principal de prática. |
| **CKS-PREPARACAO.md** | Guia de estudo: comandos essenciais + plano diário. |
| **.devcontainer/** | Ambiente **CKS Lab**: Docker, kubectl, Kind, Minikube, Trivy, kube-bench, bom, yq, etc. |
| **scripts/** | `setup-local-lab.sh` — lab local (instala ferramentas + cluster + namespaces). `install-cks-tools-local.sh` — instala kind, kubectl, trivy, etc. no host. `kind-create-cluster.sh`, `create-lab-namespaces.sh` — cluster e namespaces. |
| **course-resources/** | Submódulo Git com material extra. Inicialize com: `git submodule update --init` |

---

## Cursos

Lab: <https://learn.kodekloud.com/user/courses/cks-challenges>
Udemy: <https://www.udemy.com/course/certified-kubernetes-security-specialist-certification>
  Coupom: **CKS-MAY-25** (R$ 64,90)

---

## Distribuição de Tópicos

- **15% - Cluster Setup**
- **15% - Cluster Hardening**
- **20% - Minimize Microservice Vulnerabilities**
- **20% - Supply Chain Security**
- **10% - System Hardening**
- **20% - Monitoring, Logging and Runtime Security**

---

## Detalhamento dos Tópicos

### Cluster Setup (15%)

- Usar políticas de segurança de rede para restringir acesso em nível de cluster
- Usar benchmark CIS para revisar a configuração de segurança dos componentes Kubernetes (etcd, kubelet, kubedns, kubeapi)
- Configurar corretamente objetos Ingress com TLS
- Proteger metadados e endpoints dos nós
- Verificar binários da plataforma antes de fazer o deploy

### Cluster Hardening (15%)

- Utilizar padrões apropriados de segurança de pods
- Gerenciar segredos do Kubernetes
- Compreender e implementar técnicas de isolamento (multi-tenancy, containers sandbox, etc.)
- Implementar criptografia Pod-para-Pod (Cilium, Istio)
- Usar RBAC (Role Based Access Controls) para minimizar exposição
- Ter cautela no uso de service accounts (ex: desabilitar padrões, minimizar permissões nas novas)
- Restringir acesso à API do Kubernetes
- Atualizar o Kubernetes para evitar vulnerabilidades

### Minimize Microservice Vulnerabilities (20%)

- Minimizar a base de imagens (base image footprint)
- Compreender a cadeia de fornecimento (ex: SBOM, CI/CD, repositórios de artefatos)
- Realizar análise estática de workloads e imagens de containers (ex: Kubesec, KubeLinter)

### Supply Chain Security (20%)

- Proteger a cadeia de fornecimento (ex: registries permitidos, assinar e validar artefatos)
- Verificar e validar binários e imagens
- Implementar políticas para garantir integridade da cadeia de entrega

### System Hardening (10%)

- Minimizar a superfície de ataque do sistema operacional (host OS footprint)
- Usar o princípio de menor privilégio na gestão de identidade e acesso
- Minimizar o acesso externo à rede
- Usar adequadamente ferramentas de endurecimento do kernel como AppArmor, seccomp

### Monitoring, Logging and Runtime Security (20%)

- Realizar análise comportamental para detectar atividades maliciosas
- Detectar ameaças na infraestrutura física, aplicações, redes, dados, usuários e workloads
- Investigar e identificar fases de ataques e agentes maliciosos no ambiente
- Garantir imutabilidade de containers em tempo de execução
- Usar logs de auditoria do Kubernetes para monitorar acessos

---

## Sobre a CNCF

A computação nativa da nuvem utiliza um stack de software open source para implantar aplicações como microserviços, empacotando cada parte em seu próprio container e orquestrando dinamicamente esses containers para otimizar a utilização de recursos.

A **Cloud Native Computing Foundation (CNCF)** hospeda componentes críticos desse stack, incluindo:

- Kubernetes
- Fluentd
- Linkerd
- Prometheus
- OpenTracing
- gRPC

Ela reúne os principais desenvolvedores, usuários finais e fornecedores da indústria e serve como uma casa neutra para colaboração. A CNCF faz parte da **The Linux Foundation**, uma organização sem fins lucrativos.

Para mais informações: [https://cncf.io](https://cncf.io/)
