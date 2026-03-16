# Guia de Preparação CKS — Comandos e Ações Diárias

Documento de preparação para o exame **Certified Kubernetes Security Specialist (CKS)** com comandos que precisam estar **na ponta do dedo** e um plano de ações diárias.

---

## 1. Visão geral do repositório (após revisão)

| Recurso | Descrição |
|--------|-----------|
| **lab.txt** | Simulador Killer.sh CKS (Kubernetes 1.32) — 23 questões com respostas completas. **Material principal de prática.** |
| **README.md** | Currículo oficial, pesos dos domínios e links para cursos. |
| **.devcontainer/** | Ambiente **CKS Lab**: Docker, kubectl, Kind, Minikube, Trivy, kube-bench, bom, yq, kubeconform — use para labs locais. |
| **scripts/** | `kind-create-cluster.sh` — cria cluster Kind. `create-lab-namespaces.sh` — cria namespaces do simulador (team-red, team-blue, metadata-access, etc.). |
| **course-resources/** | Submódulo Git (zealvora/certified-kubernetes-security-specialist). Inicialize com `git submodule update --init`. |

**Recomendações:**  
- Inicialize o submódulo para material extra: `git submodule update --init`  
- Use o **lab.txt** como referência de comandos e fluxos; pratique cada tipo de questão até automatizar.  
- No ambiente de lab (devcontainer): após criar o cluster com `scripts/kind-create-cluster.sh`, rode `scripts/create-lab-namespaces.sh` para criar os namespaces do simulador.  
- **Podman:** o dev container e o Kind funcionam com Podman; veja a seção "Usar com Podman" em [.devcontainer/README.md](.devcontainer/README.md).

---

## 2. Domínios do exame e peso

| Domínio | Peso | Foco |
|---------|------|------|
| Cluster Setup | 15% | Network Policies, CIS Benchmark, Ingress TLS, metadata, binários |
| Cluster Hardening | 15% | Pod Security Standards, Secrets, RBAC, API, ServiceAccounts, atualização K8s |
| Minimize Microservice Vulnerabilities | 20% | Imagem mínima, SBOM, análise estática (Kubesec, KubeLinter) |
| Supply Chain Security | 20% | Registry, assinatura/validação, políticas de integridade |
| System Hardening | 10% | OS, menor privilégio, AppArmor, seccomp |
| Monitoring, Logging and Runtime Security | 20% | Falco, auditoria, imutabilidade, detecção de ameaças |

---

## 3. Comandos na ponta do dedo

### 3.1 kubectl e contexto

```bash
# Contextos: listar e usar
k config get-contexts
k config get-contexts -o name
k config get-contexts -o name | tr " " "\n" > /opt/course/1/contexts
k config use-context <context-name>

# Extrair certificado do kubeconfig (base64 decode)
k config view --raw -o jsonpath='{.users[?(@.name=="restricted@infra-prod")].user.client-certificate-data}' | base64 -d > /opt/course/1/cert
```

### 3.2 RBAC

```bash
# Verificar permissões (impersonation)
k auth can-i get secrets --as <user>
k auth can-i list secrets --as <user>

# ClusterRole + RoleBinding (reutilizável em vários namespaces)
k create clusterrole <name> --verb=create --resource=pods --resource=deployments
k create rolebinding <name> --clusterrole=<clusterrole> --user=<user> -n <namespace>
# Para cada namespace: security, restricted, internal
```

### 3.3 Pod Security Standards

```bash
# Aplicar baseline (ou restricted) no namespace
k label ns <namespace> pod-security.kubernetes.io/enforce=baseline --overwrite
# Opcional: audit e warn
k label ns <namespace> pod-security.kubernetes.io/audit=baseline
k label ns <namespace> pod-security.kubernetes.io/warn=baseline
```

### 3.4 API Server (manifest estático)

```bash
# Backup SEMPRE fora de /etc/kubernetes/manifests (senão vira Pod)
cp /etc/kubernetes/manifests/kube-apiserver.yaml ~/kube-apiserver.yaml.bak

# Editar e remover NodePort inseguro
vim /etc/kubernetes/manifests/kube-apiserver.yaml
# Remover: --kubernetes-service-node-port=31000

# Recriar Service ClusterIP (após remover node-port)
k delete svc kubernetes
# K8s recria automaticamente como ClusterIP
```

### 3.5 kube-bench (CIS)

```bash
# Control plane
kube-bench run --targets=master
kube-bench run --targets=master --check='1.3.2'

# Node
kube-bench run --targets=node

# Correções típicas
# 1.3.2 Controller Manager: --profiling=false em kube-controller-manager.yaml
# 1.1.12 etcd: chown etcd:etcd /var/lib/etcd
# 4.1.9 kubelet config: chmod 600 /var/lib/kubelet/config.yaml
chown etcd:etcd /var/lib/etcd
chmod 600 /var/lib/kubelet/config.yaml
```

### 3.6 Verificação de binários (SHA512)

```bash
sha512sum /opt/course/6/binaries/*
# Comparar com valores fornecidos; remover os que não batem
rm /opt/course/6/binaries/<binary-name>
```

### 3.7 Kubelet config

```bash
# Localização típica
/var/lib/kubelet/config.yaml

# Permissões CIS
chmod 600 /var/lib/kubelet/config.yaml
# clientCAFile em authentication.x509.clientCAFile
```

### 3.8 NetworkPolicy (Kubernetes nativa)

```bash
# Deny egress para IP específico (metadata server)
# spec.podSelector: {} = todos os pods do namespace
# egress: to.ipBlock.cidr: 0.0.0.0/0, except: [192.168.x.x/32]
k apply -f metadata-deny.yaml

# Allow apenas para um label
# spec.podSelector.matchLabels: role=metadata-accessor
# egress: to.ipBlock.cidr: 192.168.x.x/32
k apply -f metadata-allow.yaml
```

### 3.9 Cilium NetworkPolicy

```bash
k get cnp -n <namespace>
k apply -f policy.yaml   # kind: CiliumNetworkPolicy, apiVersion: cilium.io/v2
# Estrutura: endpointSelector, egress/egressDeny, toEndpoints, authentication (mTLS)
```

### 3.10 AppArmor

```bash
# No nó: carregar perfil
sudo apparmor_parser -q ./profile
sudo apparmor_status

# No cluster: label do node
k label node <node-name> security=apparmor

# No Pod: securityContext
# securityContext.appArmorProfile.type: Localhost
# securityContext.appArmorProfile.localhostProfile: <profile-name>
```

### 3.11 RuntimeClass (gVisor/runsc)

```bash
# Criar RuntimeClass
# apiVersion: node.k8s.io/v1, kind: RuntimeClass, handler: runsc

# No Pod
# spec.runtimeClassName: gvisor
# spec.nodeName: <node com runsc>
```

### 3.12 Secrets no etcd

```bash
# Certificados do apiserver para etcd
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd

ETCDCTL_API=3 etcdctl \
  --cert /etc/kubernetes/pki/apiserver-etcd-client.crt \
  --key /etc/kubernetes/pki/apiserver-etcd-client.key \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  get /registry/secrets/<namespace>/<secret-name>

# Decodificar valor de secret (base64)
echo <base64-value> | base64 -d
```

### 3.13 “Hack” Secrets (RBAC escape)

```bash
# Listar pods e ver onde secrets estão montados
k -n <ns> get pod -o yaml | grep -i secret

# Ler de volume montado
k -n <ns> exec <pod> -- cat /path/to/secret-volume/password

# Ou env
k -n <ns> exec <pod> -- env | grep PASS

# Via ServiceAccount (token no pod)
curl -k -H "Authorization: Bearer $(cat /run/secrets/kubernetes.io/serviceaccount/token)" \
  https://kubernetes.default/api/v1/namespaces/<ns>/secrets
# Decodificar .data.password com base64 -d
```

### 3.14 Falco

```bash
# Rodar (unbuffered para ver rápido)
sudo falco -U

# Regras em /etc/falco/rules.d/
# custom output: output: key=value (time, container-id, container-name, user-name)
# crictl ps -a, crictl inspect <id> para achar container/pod
```

### 3.15 TLS no Ingress

```bash
k -n <ns> create secret tls tls-secret --cert=tls.crt --key=tls.key
# No Ingress: spec.tls[].secretName: tls-secret, hosts: [...]
```

### 3.16 Audit log

```bash
# Apiserver: --audit-policy-file, --audit-log-path, --audit-log-maxbackup=1
# policy.yaml: level (None|Metadata|Request|RequestResponse), resources, userGroups
# Reiniciar apiserver: mv manifest para fora, depois de volta; ou tocar no arquivo
echo > /etc/kubernetes/audit/logs/audit.log   # limpar log
```

### 3.17 SBOM e vulnerabilidades

```bash
# bom (SPDX)
bom generate --image <image> --format json --output sbom.json

# Trivy (CycloneDX e scan)
trivy image --format cyclonedx --output sbom2.json <image>
trivy sbom sbom_check.json --format json --output sbom_check_result.json
```

### 3.18 Root filesystem read-only (imutabilidade)

```yaml
# No container:
# securityContext.readOnlyRootFilesystem: true
# volumeMounts: /tmp (ou /var) com emptyDir
# volumes: emptyDir: {}
```

### 3.19 Atualizar Kubernetes (kubeadm)

```bash
# Control plane
k drain <control-plane-node> --ignore-daemonsets
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.32.1
sudo apt install kubelet=1.32.1-1.1 kubectl=1.32.1-1.1
sudo apt-mark hold kubelet kubectl
sudo systemctl restart kubelet
k uncordon <control-plane-node>

# Worker
k drain <worker-node> --ignore-daemonsets
# No worker: apt install kubeadm=1.32.1-1.1, kubeadm upgrade node, apt install kubelet kubectl, restart kubelet
k uncordon <worker-node>
```

### 3.20 ImagePolicyWebhook

```yaml
# admission-config.yaml (AdmissionConfiguration)
# plugins: name: ImagePolicyWebhook, configuration.imagePolicy: kubeConfigFile, allowTTL, denyTTL, defaultAllow
# Apiserver: --enable-admission-plugins=...,ImagePolicyWebhook
# --admission-control-config-file=/etc/kubernetes/webhook/admission-config.yaml
# volumeMount: /opt/course/23/webhook -> /etc/kubernetes/webhook
```

### 3.21 Syscalls (strace)

```bash
# No nó: achar PID do container
crictl pods --name <deploy>
crictl ps --pod <pod-id>
ps aux | grep <process>
strace -p <PID>   # procurar syscall proibida (ex: kill)
# Scale deployment com pod ofensor: k scale deploy <name> --replicas 0
```

### 3.22 crictl / containers

```bash
crictl ps -a
crictl pods
crictl inspect <container-id>  # apparmor, args, etc.
# Container ID -> Pod: crictl ps -id <container-id>
```

### 3.23 Utilitários de rede / debug

```bash
# Testar acesso
k exec -it -n <ns> <pod> -- curl -m 2 http://<ip>:port
# Testar policy: ping, curl para outro pod/svc
```

### 3.24 Análise estática (security-issues)

```bash
# Listar arquivos com problemas (Dockerfile com USER root, deployment com secret em command, env com senha)
echo Dockerfile-mysql >> /opt/course/22/security-issues
echo deployment-redis.yaml >> /opt/course/22/security-issues
echo statefulset-nginx.yaml >> /opt/course/22/security-issues
```

---

## 4. Ações diárias de preparação

### Semana 1 – Base e Cluster Setup/Hardening

| Dia | Ação | Tempo |
|-----|------|--------|
| 1 | Revisar **lab.txt** Questões 1–4 (contextos, Falco, apiserver, Pod Security). Executar cada comando no seu cluster ou Killercoda. | 1h |
| 2 | Praticar CIS (Q5) e binários (Q6): kube-bench, chown/chmod, sha512sum. Revisar Kubelet config (Q7). | 1h |
| 3 | NetworkPolicy e Cilium (Q8): escrever 2–3 policies do zero (deny metadata, allow label). | 1h |
| 4 | AppArmor (Q9) e RuntimeClass gVisor (Q10): criar perfil, carregar, label node, deployment com securityContext. | 1h |
| 5 | Secrets: etcd (Q11), “hack” (Q12), metadata deny/allow (Q13). Revisar RBAC (list vs get secrets). | 1h |

### Semana 2 – Supply Chain e Runtime

| Dia | Ação | Tempo |
|-----|------|--------|
| 1 | Syscalls (Q14): strace, crictl, scale deploy. TLS Ingress (Q15). | 1h |
| 2 | Dockerfile seguro (Q16), Audit policy (Q17). | 1h |
| 3 | SBOM: bom + Trivy (Q18). Imutabilidade readOnlyRootFilesystem (Q19). | 1h |
| 4 | Upgrade cluster (Q20): kubeadm upgrade apply, drain/uncordon, apt. | 1h |
| 5 | Trivy image scan (Q21), análise estática (Q22), ImagePolicyWebhook (Q23). | 1h |

### Semana 3 – Integração e simulado

| Dia | Ação | Tempo |
|-----|------|--------|
| 1–2 | Refazer todas as 23 questões do **lab.txt** em sequência, sem colar respostas. | 2h/dia |
| 3 | Focar nos domínios que você mais errou; repetir comandos em voz alta ou em um “cheat sheet” próprio. | 1h |
| 4 | Simulado Killer.sh completo (2h) ou sessão de 5–6 questões aleatórias. | 2h |
| 5 | Revisar apenas a seção **Comandos na ponta do dedo** deste documento; fazer 2–3 questões de cada domínio. | 1h |

### Semana 4 (pré-prova)

| Dia | Ação | Tempo |
|-----|------|--------|
| 1–2 | Mais um simulado completo; cronometrar. | 2h |
| 3 | Documentação permitida: abrir kubernetes.io/docs, falco.org e treinar buscar rápido (audit, Pod Security, NetworkPolicy). | 30min |
| 4 | Descanso; revisão leve só dos comandos que você ainda tropeça. | 30min |
| 5 | Prova. | — |

---

## 5. Recursos externos recomendados

- **Currículo oficial:** [CNCF CKS](https://www.cncf.io/training/certification/cks/)  
- **Docs durante o exame:** kubernetes.io/docs, falco.org/docs (e outros da lista oficial).  
- **Prática adicional:**  
  - [bmuschko/cks-study-guide](https://github.com/bmuschko/cks-study-guide)  
  - [moabukar/CKS-Exercises](https://github.com/moabukar/CKS-Exercises)  
  - [KodeKloud CKS Challenges](https://learn.kodekloud.com/user/courses/cks-challenges)  
- **Simulador:** Killer.sh CKS (incluído com a compra do exame).

---

## 6. Checklist rápido antes da prova

- [ ] `k config get-contexts` e troca de contexto automática  
- [ ] Backup de manifest **fora** de `/etc/kubernetes/manifests`  
- [ ] Pod Security: label `pod-security.kubernetes.io/enforce=baseline`  
- [ ] kube-bench: `--targets=master` e `--targets=node`, chown/chmod clássicos  
- [ ] NetworkPolicy: `podSelector: {}`, `ipBlock` + `except`  
- [ ] ETCD: `ETCDCTL_API=3`, cert/key/cacert, path `/registry/secrets/ns/name`  
- [ ] base64 -d para decodificar secrets  
- [ ] Falco: `falco -U`, regras em `rules.d`  
- [ ] Audit: Policy levels, `--audit-log-maxbackup=1`  
- [ ] SBOM: `bom generate`, `trivy image`, `trivy sbom`  
- [ ] readOnlyRootFilesystem + emptyDir para /tmp  
- [ ] kubeadm: drain → upgrade apply → kubelet/kubectl → uncordon  

Use este documento como referência diária e para revisão final; os comandos desta seção 3 são os que devem estar **na ponta do dedo** no exame.
