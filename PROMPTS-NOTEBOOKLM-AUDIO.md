# Prompts para NotebookLM — Áudio Explicativo por Tópico (CKS)

Use estes prompts no **NotebookLM** para gerar áudios de estudo e revisão. Adicione ao notebook as fontes do repositório (CKS-PREPARACAO.md, currículo CKS, README, etc.) e depois use cada prompt abaixo para pedir um **guia em áudio** ou uma **explicação em áudio** do tópico.

**Como usar:**  
- Copie um prompt e cole no chat do NotebookLM, ou use como instrução ao gerar um "Audio overview".  
- Você pode pedir: *"Gere um áudio explicativo com base nas minhas fontes, seguindo este prompt:"* e colar o texto.  
- Para revisão rápida: use os prompts da seção "Revisão em 1 minuto" para áudios curtos.

---

## Prompts por domínio (áudio completo por tópico)

### 1. Cluster Setup (15%)

**Prompt 1.1 — Cluster Setup (visão geral)**  
Gere um áudio explicativo para estudo CKS cobrindo o domínio **Cluster Setup (15%)**. Explique em linguagem clara: o que é cluster setup do ponto de vista de segurança; por que políticas de rede, CIS benchmark, Ingress com TLS, proteção de metadados dos nós e verificação de binários são importantes; e como esses temas se conectam. Inclua um resumo do que o candidato deve saber na prova e o que praticar no lab. Use as fontes deste notebook como base.

**Prompt 1.2 — Network Policies**  
Faça um áudio de estudo sobre **Network Policies** no Kubernetes para o exame CKS. Explique: o que são NetworkPolicies; como restringir tráfego ingress e egress por namespace, pod selector e portas; exemplos de regras comuns (negar todo ingress, permitir só de um namespace); e como aplicar e testar no lab. Dê dicas do que costuma cair na prova.

**Prompt 1.3 — CIS Benchmark e kube-bench**  
Gere um áudio explicativo sobre **CIS Kubernetes Benchmark** e uso do **kube-bench** para o CKS. Explique: o que é o CIS benchmark; o que são os alvos master e node; como rodar kube-bench (master, node, checks específicos); exemplos de correções típicas (etcd ownership, kubelet config permissions, controller-manager profiling); e como interpretar o relatório para o exame.

**Prompt 1.4 — Ingress com TLS e proteção de metadados**  
Faça um áudio de revisão sobre: (1) **Ingress com TLS** no Kubernetes — como configurar TLS (secret com certificado, referência no Ingress) e boas práticas de segurança; (2) **Proteção de metadados e endpoints dos nós** — risco do endpoint 169.254.169.254 (metadados do cloud), como restringir acesso (network policy, IMDSv2, etc.) e por que isso cai no CKS.

**Prompt 1.5 — Verificação de binários da plataforma**  
Explique em áudio o tópico **verificação de binários da plataforma** para o CKS: por que verificar integridade antes do deploy; uso de checksums (ex.: sha512sum); como comparar com valores oficiais e remover binários que não batem; e relação com supply chain security.

---

### 2. Cluster Hardening (15%)

**Prompt 2.1 — Cluster Hardening (visão geral)**  
Gere um áudio explicativo para o domínio **Cluster Hardening (15%)** do CKS. Aborde: padrões de segurança de pods (Pod Security Standards/Admission); gerenciamento de Secrets; isolamento (multi-tenancy, sandbox); criptografia pod-to-pod (Cilium, Istio); RBAC; service accounts; restrição de acesso à API; e atualização do Kubernetes. Conecte os temas e diga o que priorizar na prova.

**Prompt 2.2 — Pod Security Standards e Pod Security Admission**  
Faça um áudio de estudo sobre **Pod Security Standards (PSS)** e **Pod Security Admission (PSA)**. Explique: os três níveis (privileged, baseline, restricted); como aplicar por namespace (labels enforce, audit, warn); diferença entre audit e warn; e exemplos de configurações inseguras que baseline e restricted bloqueiam. Inclua comandos úteis para o lab.

**Prompt 2.3 — Secrets e RBAC**  
Explique em áudio para o CKS: (1) **Secrets** — como criar, usar em Pods (env ou volume), boas práticas (evitar em linha no YAML, encryption at rest); (2) **RBAC** — Role, ClusterRole, RoleBinding, ClusterRoleBinding; como usar “kubectl auth can-i” para verificar permissões; e como criar roles mínimas para usuários e ServiceAccounts. Dê exemplos do que costuma aparecer na prova.

**Prompt 2.4 — Service Accounts e acesso à API**  
Gere um áudio sobre **Service Accounts** e **restringir acesso à API** no Kubernetes. Aborde: o que são ServiceAccounts; token automático e montagem em Pods; por que desabilitar ou limitar montagem automática; como restringir acesso à API (remover NodePort inseguro do kube-apiserver, network policies); e relação com Cluster Hardening.

**Prompt 2.5 — Criptografia pod-to-pod e isolamento**  
Faça um áudio de revisão sobre: **criptografia pod-to-pod** (conceito, uso de Cilium ou Istio para mTLS); e **isolamento** (multi-tenancy soft vs hard, containers sandbox quando relevante). Explique por que isso faz parte do Cluster Hardening e o que o candidato deve saber na prova.

---

### 3. Minimize Microservice Vulnerabilities (20%)

**Prompt 3.1 — Minimize Microservice Vulnerabilities (visão geral)**  
Gere um áudio explicativo para o domínio **Minimize Microservice Vulnerabilities (20%)**. Cubra: minimizar a base das imagens (base image footprint); cadeia de fornecimento (SBOM, CI/CD, repositórios de artefatos); e análise estática de workloads e imagens (Kubesec, KubeLinter). Explique como esses tópicos se relacionam e o que praticar no lab.

**Prompt 3.2 — Imagens mínimas e análise estática**  
Faça um áudio sobre: (1) **Minimizar a base de imagens** — por que usar imagens pequenas e distroless; (2) **Análise estática** — Kubesec (security score de manifests); KubeLinter (lint de recursos Kubernetes); e como usar no fluxo de CI/CD. Inclua o que costuma cair na prova CKS.

**Prompt 3.3 — SBOM e cadeia de fornecimento**  
Explique em áudio **SBOM (Software Bill of Materials)** e a **cadeia de fornecimento** no contexto CKS: o que é SBOM; ferramentas como “bom”; como isso se conecta a CI/CD e repositórios de artefatos; e por que isso é importante para minimizar vulnerabilidades em microserviços.

---

### 4. Supply Chain Security (20%)

**Prompt 4.1 — Supply Chain Security (visão geral)**  
Gere um áudio explicativo para o domínio **Supply Chain Security (20%)** do CKS. Aborde: proteger a cadeia de fornecimento (registries permitidos, assinar e validar artefatos); verificar e validar binários e imagens; e implementar políticas para garantir integridade (admission controllers, políticas de imagem). Dê uma visão geral e o que priorizar na prova.

**Prompt 4.2 — Registries, assinatura e validação de imagens**  
Faça um áudio sobre: **registries permitidos**; **assinatura de imagens** (conceito, ferramentas como cosign); **validação de imagens** antes do deploy; e como políticas de admission (ex.: Gatekeeper, Kyverno) podem bloquear imagens não assinadas ou de registries não permitidos. Inclua dicas para o exame.

**Prompt 4.3 — Verificação de binários e políticas de integridade**  
Explique em áudio a **verificação de binários** e **políticas para integridade da cadeia de entrega**: checksums, verificação antes do deploy; e como políticas no cluster (admission, OPA, Kyverno) garantem que só artefatos válidos e verificados sejam usados.

---

### 5. System Hardening (10%)

**Prompt 5.1 — System Hardening (visão geral)**  
Gere um áudio explicativo para o domínio **System Hardening (10%)** do CKS. Cubra: minimizar a superfície de ataque do SO (host); princípio do menor privilégio em identidade e acesso; minimizar acesso externo à rede; e uso de **AppArmor** e **seccomp** para endurecimento do kernel. Conecte os temas e diga o que é essencial na prova.

**Prompt 5.2 — AppArmor e seccomp**  
Faça um áudio de estudo sobre **AppArmor** e **seccomp** no Kubernetes para o CKS. Explique: o que são e para que servem; como anotar Pods para usar perfis AppArmor e perfis seccomp; perfis padrão (runtime/default); e exemplos de uso no lab (criar perfil AppArmor, referenciar no Pod). Inclua o que costuma cair na prova.

**Prompt 5.3 — Menor privilégio e acesso à rede**  
Explique em áudio o **princípio do menor privilégio** na gestão de identidade e acesso no Kubernetes, e como **minimizar o acesso externo à rede** (network policies, restrição de LoadBalancer/NodePort, proteção do API server). Relacione com System Hardening.

---

### 6. Monitoring, Logging and Runtime Security (20%)

**Prompt 6.1 — Monitoring, Logging and Runtime Security (visão geral)**  
Gere um áudio explicativo para o domínio **Monitoring, Logging and Runtime Security (20%)** do CKS. Aborde: análise comportamental para detectar atividades maliciosas; detecção de ameaças (infraestrutura, aplicações, rede, dados, workloads); investigação e fases de ataque; **imutabilidade de containers** em runtime; e **logs de auditoria** do Kubernetes. Dê uma visão geral e o que priorizar na prova.

**Prompt 6.2 — Falco e detecção comportamental**  
Faça um áudio sobre **Falco** e **detecção comportamental** no Kubernetes: o que é Falco; como detecta comportamento suspeito (syscalls, arquivos, rede); regras comuns; e como isso se relaciona com runtime security e com o que cai no CKS.

**Prompt 6.3 — Auditoria do Kubernetes e imutabilidade**  
Explique em áudio: (1) **Logs de auditoria** do Kubernetes — o que são, como habilitar no kube-apiserver, o que registrar (quem, recurso, verbo, resultado) e uso para compliance e resposta a incidentes; (2) **Imutabilidade de containers** em runtime — readOnlyRootFilesystem, evitar writable paths desnecessários, e por que isso importa para segurança.

---

## Prompts de revisão rápida (áudio curto)

Use estes para pedir um **resumo em áudio de 1–2 minutos** por domínio, ideal para revisão no dia anterior à prova.

- **R1.** Faça um áudio curto (cerca de 1 minuto) resumindo o domínio **Cluster Setup** do CKS: os 5 pontos principais que o candidato deve lembrar na prova.
- **R2.** Faça um áudio curto resumindo **Cluster Hardening**: Pod Security, Secrets, RBAC, ServiceAccounts, API e criptografia pod-to-pod em uma lista objetiva.
- **R3.** Faça um áudio curto resumindo **Minimize Microservice Vulnerabilities**: imagem mínima, SBOM, Kubesec e KubeLinter em poucas frases.
- **R4.** Faça um áudio curto resumindo **Supply Chain Security**: registry, assinatura, validação e políticas de integridade.
- **R5.** Faça um áudio curto resumindo **System Hardening**: host, menor privilégio, AppArmor e seccomp.
- **R6.** Faça um áudio curto resumindo **Monitoring, Logging and Runtime Security**: Falco, auditoria, imutabilidade e detecção de ameaças.

---

## Prompt genérico para guia em áudio do exame inteiro

Use quando quiser **um único áudio** cobrindo todo o currículo:

**Prompt — Guia em áudio completo CKS**  
Com base nas fontes deste notebook, gere um guia em áudio para estudo do exame **Certified Kubernetes Security Specialist (CKS)**. O áudio deve seguir a ordem dos domínios oficiais: (1) Cluster Setup 15%, (2) Cluster Hardening 15%, (3) Minimize Microservice Vulnerabilities 20%, (4) Supply Chain Security 20%, (5) System Hardening 10%, (6) Monitoring, Logging and Runtime Security 20%. Para cada domínio, explique os conceitos principais, por que são importantes para a prova e o que o candidato deve praticar. Use linguagem clara e objetiva, como em um podcast de revisão para o exame.

---

## Dica de uso no NotebookLM

1. **Adicione as fontes** ao notebook: CKS-PREPARACAO.md, README.md, currículo CKS (PDF se disponível), e opcionalmente trechos do lab.txt ou do arquivo de perguntas e respostas.
2. **Para áudio por tópico:** use um prompt da seção "Prompts por domínio" e peça explicitamente: *"Gere um áudio explicativo com base nas minhas fontes usando este prompt: [colar prompt]."*
3. **Para revisão rápida:** use os prompts R1–R6 e peça áudios curtos (1–2 minutos).
4. **Para um único áudio longo:** use o "Prompt genérico para guia em áudio do exame inteiro" ao criar o Audio overview ou ao pedir o guia no chat.

*Documento criado para uso no NotebookLM com as fontes do repositório CKS.*
