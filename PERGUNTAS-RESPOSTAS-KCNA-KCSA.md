# Perguntas e Respostas — KCNA e KCSA

Conjunto de perguntas de prática para **Kubernetes and Cloud Native Associate (KCNA)** e **Kubernetes and Cloud Native Security Associate (KCSA)** com explicações detalhadas. Baseado nos currículos oficiais CNCF/Linux Foundation e na documentação do Kubernetes.

---

# Parte 1 — KCNA (Kubernetes and Cloud Native Associate)

Domínios do exame: Kubernetes Fundamentals (44%), Container Orchestration (28%), Cloud Native Application Delivery (16%), Cloud Native Architecture (12%).

---

## KCNA — Kubernetes Fundamentals

### 1. Qual é a menor unidade implantável que você pode criar e gerenciar no Kubernetes?

**A)** Container  
**B)** Pod  
**C)** ReplicaSet  
**D)** Node  

**Resposta correta: B — Pod**

**Explicação:** No Kubernetes, o **Pod** é a menor unidade de computação que você cria e gerencia. Um Pod agrupa um ou mais contêineres com namespaces, rede e volumes compartilhados; eles são sempre agendados juntos no mesmo nó. Você não implanta um contêiner sozinho: ele sempre faz parte de um Pod. ReplicaSet e Deployment gerenciam Pods; Node é a máquina que executa os Pods. A documentação oficial define: "A Pod is the smallest deployable unit of computing that you can create and manage in Kubernetes."

**Por que as outras estão erradas:** Container (A) é a unidade de execução dentro do Pod, mas não é a unidade *implantável* no cluster. ReplicaSet (C) é um controlador que mantém um conjunto de Pods. Node (D) é o host (VM ou servidor físico) que executa os Pods.

**Referência:** [Kubernetes - Pods](https://kubernetes.io/docs/concepts/workloads/pods/)

---

### 2. O que significa a sigla CNCF?

**A)** Cloud Native Computing Foundation  
**B)** Container Native Computing Foundation  
**C)** Cloud Native Container Federation  
**D)** Cloud Network Computing Foundation  

**Resposta correta: A — Cloud Native Computing Foundation**

**Explicação:** **CNCF** é a **Cloud Native Computing Foundation**, fundação de código aberto e neutra em relação a fornecedores que abriga projetos como Kubernetes, Helm, Prometheus e Envoy. Ela faz parte da Linux Foundation e promove tecnologias cloud native: contêineres, service mesh, microserviços, infraestrutura imutável e APIs declarativas. O KCNA valida conhecimento do ecossistema CNCF e de como o Kubernetes se encaixa nele.

**Por que as outras estão erradas:** As opções B, C e D trocam "Cloud" por "Container", "Federation" por "Foundation" ou alteram "Computing", o que não corresponde ao nome oficial da fundação.

**Referência:** [CNCF - Who We Are](https://www.cncf.io/about/who-we-are/)

---

### 3. Qual componente do control plane é responsável por agendar Pods nos nós?

**A)** kubelet  
**B)** kube-scheduler  
**C)** kube-controller-manager  
**D)** kube-proxy  

**Resposta correta: B — kube-scheduler**

**Explicação:** O **kube-scheduler** é o componente do control plane que atribui Pods a nós. Ele observa Pods recém-criados que ainda não têm nó e escolhe um nó para cada um com base em critérios como recursos (CPU/memória), afinidade/anti-afinidade, taints e tolerations. O kubelet roda em cada nó e garante que os contêineres dos Pods estejam em execução; o kube-controller-manager executa loops de controle (ex.: ReplicaSet, Deployment); o kube-proxy mantém regras de rede nos nós. Nenhum deles faz o agendamento inicial dos Pods.

**Por que as outras estão erradas:** kubelet (A) roda no nó e executa os Pods já agendados. kube-controller-manager (C) reconcilia estado (ex.: número de réplicas), não escolhe o nó. kube-proxy (D) é responsável por rede (Service, etc.), não por scheduling.

**Referência:** [Kubernetes - kube-scheduler](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/)

---

### 4. Qual comando lista todos os Pods em todos os namespaces?

**A)** `kubectl get pods`  
**B)** `kubectl get pods -A`  
**C)** `kubectl get pods --namespace all`  
**D)** `kubectl list pods`  

**Resposta correta: B — kubectl get pods -A**

**Explicação:** A opção **-A** (ou **--all-namespaces**) faz o `kubectl get pods` listar Pods em todos os namespaces do cluster. Sem esse flag, apenas o namespace padrão (geralmente `default`) é considerado. A forma longa equivalente é `kubectl get pods --all-namespaces`. Isso é útil para administração e troubleshooting em clusters com vários namespaces.

**Por que as outras estão erradas:** `kubectl get pods` (A) lista só no namespace atual. `--namespace all` (C) não é um valor válido; "all" não é um namespace. `kubectl list pods` (D) não existe; o verbo correto é `get`.

**Referência:** [kubectl get](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_get/)

---

### 5. StatefulSet precisa de qual tipo de Service para a identidade de rede estável dos Pods?

**A)** ClusterIP  
**B)** NodePort  
**C)** LoadBalancer  
**D)** Headless Service (ClusterIP com clusterIP: None)  

**Resposta correta: D — Headless Service**

**Explicação:** O **StatefulSet** precisa de um **Headless Service** (Service com `clusterIP: None`) para dar a cada Pod uma identidade de rede estável e um nome DNS estável. Com headless, o DNS retorna os IPs dos Pods diretamente, e cada Pod do StatefulSet pode ser acessado por `<pod-name>.<headless-service>.<namespace>.svc.cluster.local`. Isso permite descoberta de pares e armazenamento estável (ex.: volumes PersistentVolume por Pod). ClusterIP normal expõe um único IP para o Service; NodePort e LoadBalancer expõem tráfego externo e não fornecem a identidade por Pod que o StatefulSet exige.

**Por que as outras estão erradas:** ClusterIP (A) padrão tem um IP virtual único e não expõe IPs individuais dos Pods. NodePort (B) e LoadBalancer (C) são para acesso externo e não definem a identidade de rede estável por Pod usada pelo StatefulSet.

**Referência:** [Kubernetes - StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/), [Headless Services](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services)

---

### 6. Quais são os "4Cs" da segurança cloud native (na ordem correta)?

**A)** Cluster, Cloud, Containers, Code  
**B)** Code, Container, Cluster, Cloud  
**C)** Compute, Cloud, Code, Containers  
**D)** Container, Cluster, Cloud, Compute  

**Resposta correta: B — Code, Container, Cluster, Cloud**

**Explicação:** Os **4Cs** da segurança cloud native são camadas que vão da mais interna à mais externa: **Code** (segurança do código e dependências), **Container** (imagem, runtime, configuração do contêiner), **Cluster** (configuração do Kubernetes, RBAC, políticas de rede), **Cloud** (ou datacenter — rede, IAM, hardening do host). Essa ordem reflete a ideia de que um problema em uma camada afeta as outras; a segurança deve ser considerada em todas.

**Por que as outras estão erradas:** As alternativas A, C e D alteram a ordem ou trocam um "C" (por exemplo, "Compute" em vez de "Code"), o que não corresponde ao modelo oficial dos 4Cs.

**Referência:** [Kubernetes - Security](https://kubernetes.io/docs/concepts/security/), CNCF Security Whitepaper

---

### 7. Qual destes NÃO é um tipo de Service no Kubernetes?

**A)** ClusterIP  
**B)** NodePort  
**C)** Ingress  
**D)** LoadBalancer  

**Resposta correta: C — Ingress**

**Explicação:** **Ingress** não é um tipo de Service. Os tipos de Service são: **ClusterIP** (padrão, IP interno no cluster), **NodePort** (expõe uma porta em cada nó), **LoadBalancer** (provisiona um load balancer externo quando suportado pelo cloud provider). **Ingress** é um recurso separado (objeto da API) que define regras de acesso HTTP/HTTPS a Services (roteamento, host, path, TLS). Um Ingress normalmente precisa de um *Ingress controller* (ex.: ingress-nginx) para funcionar.

**Por que as outras estão erradas:** ClusterIP (A), NodePort (B) e LoadBalancer (D) são os três tipos de Service definidos na API do Kubernetes.

**Referência:** [Kubernetes - Service](https://kubernetes.io/docs/concepts/services-networking/service/), [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

---

### 8. Qual componente roda em cada nó worker e garante que os contêineres dos Pods estejam em execução?

**A)** etcd  
**B)** kube-apiserver  
**C)** kubelet  
**D)** kube-scheduler  

**Resposta correta: C — kubelet**

**Explicação:** O **kubelet** é o agente que roda em cada nó (worker ou control plane quando o nó executa Pods). Ele recebe a lista de Pods destinados àquele nó (via API ou mecanismo estático) e garante que os contêineres desses Pods estejam rodando e saudáveis. Também monta volumes, executa health checks e reporta status ao control plane. etcd (A) é o armazenamento de chave-valor do control plane; kube-apiserver (B) é a API do cluster; kube-scheduler (D) apenas atribui Pods a nós e não roda nos workers.

**Por que as outras estão erradas:** etcd e kube-apiserver são componentes do control plane, não agentes por nó. kube-scheduler só escolhe o nó; não executa nada nos workers.

**Referência:** [Kubernetes - kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)

---

## KCNA — Container Orchestration & Networking

### 9. Sobre o modelo de rede do Kubernetes, qual afirmação é verdadeira?

**A)** Pods precisam de NAT para se comunicar com Pods em outros nós.  
**B)** Pods podem se comunicar com todos os outros Pods em qualquer nó sem NAT.  
**C)** Cada Pod compartilha o IP do nó onde roda.  
**D)** kubelet precisa do CoreDNS para falar com os Pods do seu nó.  

**Resposta correta: B — Pods podem se comunicar com todos os outros Pods em qualquer nó sem NAT**

**Explicação:** O modelo de rede do Kubernetes estabelece que **cada Pod recebe um IP único no cluster** e que **todos os Pods podem se comunicar entre si em qualquer nó sem NAT**. Isso simplifica portabilidade, service discovery e configuração. Os agentes no nó (kubelet, daemons) podem se comunicar com todos os Pods *daquele* nó. CoreDNS é usado para resolução DNS de Services e Pods, não como requisito para o kubelet falar com os Pods locais.

**Por que as outras estão erradas:** NAT não é exigido para pod-to-pod (A). Cada Pod tem seu próprio IP, não o do nó (C). kubelet não depende do CoreDNS para comunicação com Pods no mesmo nó (D).

**Referência:** [Kubernetes - Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/)

---

### 10. O que a Open Container Initiative (OCI) padroniza?

**A)** Apenas formato de imagem (image spec)  
**B)** Runtime e formato de imagem (e distribuição)  
**C)** Apenas runtime (runtime spec)  
**D)** Apenas orquestração  

**Resposta correta: B — Runtime e formato de imagem (e distribuição)**

**Explicação:** A **OCI** define especificações abertas para contêineres. As principais são: **Runtime Specification** (runtime) — como executar um "bundle" de contêiner (ex.: runc); **Image Specification** — formato de imagem (layers, config, manifest); e **Distribution Specification** — como distribuir imagens (push/pull). Isso garante interoperabilidade entre ferramentas (containerd, CRI-O, Docker, etc.). Orquestração (Kubernetes) não é escopo da OCI.

**Por que as outras estão erradas:** OCI cobre mais do que só imagem (A) ou só runtime (C). Orquestração (D) fica com Kubernetes e outros projetos, não com a OCI.

**Referência:** [Open Container Initiative](https://opencontainers.org/)

---

## KCNA — Cloud Native Architecture & Application Delivery

### 11. Quais são as duas partes principais de uma Service Mesh?

**A)** Master plane e worker node  
**B)** kube-scheduler e controller manager  
**C)** Data plane e control plane  
**D)** Discovery plane e data plane  

**Resposta correta: C — Data plane e control plane**

**Explicação:** Uma **Service Mesh** (ex.: Istio, Linkerd) tem duas partes: **Data plane** — proxies (sidecars ou por nó) que interceptam o tráfego entre serviços e aplicam políticas (retry, timeout, mTLS, métricas); **Control plane** — componentes que configuram e gerenciam os proxies (descoberta de serviços, certificados, políticas). "Master/worker" é terminologia do Kubernetes, não da mesh. "Discovery" faz parte das funções do control plane, não é um plano separado ao lado do data plane.

**Por que as outras estão erradas:** Master/worker (A) é conceito do Kubernetes. kube-scheduler e controller manager (B) são do Kubernetes, não da service mesh. Não existe "Discovery plane" como plano principal ao lado do data plane (D).

**Referência:** [CNCF - Service Mesh](https://www.cncf.io/blog/2017/04/26/cncf-survey-service-mesh/), documentação Istio/Linkerd

---

### 12. Em CI/CD, o que é "Continuous Integration" (CI)?

**A)** Integração manual de código de vários desenvolvedores, feita semanalmente.  
**B)** Integração frequente e automatizada de alterações de código de vários desenvolvedores em um repositório compartilhado.  
**C)** Deploy automático em produção a cada commit.  
**D)** Apenas execução de testes após o deploy.  

**Resposta correta: B — Integração frequente e automatizada de alterações de código de vários desenvolvedores em um repositório compartilhado**

**Explicação:** **Continuous Integration (CI)** é a prática de integrar com frequência as alterações de código de múltiplos desenvolvedores em um repositório compartilhado, de forma **automatizada**, com build e testes disparados a cada commit/merge. Objetivos: detectar erros cedo, manter o tronco estável e reduzir conflitos. CD (Continuous Delivery/Deployment) lida com entrega e implantação; CI foca em integração e validação contínua.

**Por que as outras estão erradas:** CI exige automação, não integração manual (A). Deploy automático em produção é CD/Continuous Deployment (C). Testes após deploy não definem CI; em CI os testes rodam na integração do código (D).

**Referência:** [Red Hat - What is CI/CD](https://www.redhat.com/en/topics/devops/what-is-ci-cd)

---

### 13. Qual métrica NÃO é um conceito fundamental em SRE (Site Reliability Engineering)?

**A)** SLO (Service Level Objective)  
**B)** SLI (Service Level Indicator)  
**C)** SLD (Service Level Definition)  
**D)** SLA (Service Level Agreement)  

**Resposta correta: C — SLD (Service Level Definition)**

**Explicação:** Em SRE, os conceitos fundamentais são: **SLI** (Service Level Indicator) — métrica que mede o nível do serviço (ex.: disponibilidade, latência); **SLO** (Service Level Objective) — alvo desejado para um SLI (ex.: 99,9% de disponibilidade); **SLA** (Service Level Agreement) — acordo com o cliente, geralmente com consequências se não cumprido. **SLD** não é um termo padrão na literatura SRE (Google SRE Book). "Service Level Definition" às vezes aparece em contextos genéricos, mas não compõe a tríade SLI/SLO/SLA.

**Por que as outras estão erradas:** SLO, SLI e SLA são os três pilares usados no Google SRE Book e em práticas cloud native de observabilidade.

**Referência:** Google SRE Book — Service Level Objectives

---

## KCNA — Observability

### 14. Qual projeto do ecossistema CNCF é amplamente usado para métricas e monitoramento em Kubernetes?

**A)** Fluentd  
**B)** Jaeger  
**C)** Prometheus  
**D)** Envoy  

**Resposta correta: C — Prometheus**

**Explicação:** **Prometheus** é o projeto de referência para **métricas** no ecossistema cloud native: coleta métricas por pull, armazena séries temporais e oferece PromQL para consultas e alertas. É comumente usado com Kubernetes (ServiceMonitor, Prometheus Operator). Fluentd (A) é para coleta de logs; Jaeger (B) para rastreamento distribuído (traces); Envoy (D) é proxy e parte do data plane de service mesh — não é focado em armazenamento de métricas.

**Por que as outras estão erradas:** Fluentd é log; Jaeger é tracing; Envoy é proxy. O KCNA enfatiza Prometheus no domínio de observabilidade.

**Referência:** [Prometheus](https://prometheus.io/), [CNCF Landscape](https://landscape.cncf.io/)

---

# Parte 2 — KCSA (Kubernetes and Cloud Native Security Associate)

Domínios: Overview of Cloud Native Security (14%), Kubernetes Security Fundamentals (22%), Kubernetes Cluster Component Security (22%), Kubernetes Threat Model (16%), Platform Security (16%), Compliance and Security Frameworks (10%).

---

## KCSA — Overview of Cloud Native Security

### 15. Na abordagem "Defense in Depth" (defesa em profundidade) em ambientes cloud native, o que se pretende?

**A)** Usar apenas um controle de segurança forte na camada de rede.  
**B)** Aplicar múltiplas camadas de controles de segurança (Code, Container, Cluster, Cloud) para que uma falha em uma camada não comprometa todo o sistema.  
**C)** Desabilitar a rede entre namespaces para aumentar a segurança.  
**D)** Usar apenas firewalls de perímetro.  

**Resposta correta: B — Aplicar múltiplas camadas de controles de segurança (Code, Container, Cluster, Cloud) para que uma falha em uma camada não comprometa todo o sistema**

**Explicação:** **Defense in Depth** significa aplicar **múltiplas camadas** de controles (alinhadas aos 4Cs: Code, Container, Cluster, Cloud) para que, se um controle falhar, outros ainda mitiguem o risco. Não se depende de um único ponto de proteção. No Kubernetes isso inclui: código seguro, imagens escaneadas, RBAC, NetworkPolicy, Pod Security, hardening do cluster e da infraestrutura.

**Por que as outras estão erradas:** Um único controle (A) ou só perímetro (D) contradiz defesa em profundidade. Desabilitar rede entre namespaces (C) pode ser parte de um controle, mas não define a estratégia inteira.

**Referência:** [Kubernetes - Security Checklist](https://kubernetes.io/docs/concepts/security/security-checklist/), 4Cs e Defense in Depth

---

## KCSA — Kubernetes Security Fundamentals

### 16. O que são os Pod Security Standards (PSS) no Kubernetes?

**A)** Um único nível (privileged) que permite qualquer configuração de Pod.  
**B)** Três níveis (privileged, baseline, restricted) que definem políticas de segurança para Pods, aplicáveis via Pod Security Admission.  
**C)** Políticas que aplicam apenas a namespaces do system.  
**D)** Substituição direta do NetworkPolicy.  

**Resposta correta: B — Três níveis (privileged, baseline, restricted) que definem políticas de segurança para Pods, aplicáveis via Pod Security Admission**

**Explicação:** Os **Pod Security Standards** definem três níveis: **privileged** (sem restrições), **baseline** (evita configurações conhecidas como problemáticas) e **restricted** (mais rígido, alinhado a boas práticas). Eles são aplicados pelo **Pod Security Admission** (PSA) por namespace (labels ou admission). Isso substitui o antigo PodSecurityPolicy (deprecated) e ajuda a evitar execução privilegiada, hostPath perigoso e outras configurações inseguras.

**Por que as outras estão erradas:** Privileged é um dos níveis, não o único (A). PSS podem ser usados em qualquer namespace (C). PSS/PSA tratam de segurança do Pod (containers, capabilities); NetworkPolicy trata de rede (D).

**Referência:** [Kubernetes - Pod Security Admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/)

---

### 17. Qual componente do Kubernetes é responsável por decidir *o que* um usuário ou ServiceAccount pode fazer após a autenticação?

**A)** Authenticator (ex.: tokens, client certs)  
**B)** RBAC (Role-Based Access Control)  
**C)** Admission Controller  
**D)** kubelet  

**Resposta correta: B — RBAC (Role-Based Access Control)**

**Explicação:** O **RBAC** é o mecanismo de **autorização** padrão no Kubernetes: define *quem* (Subject: User, Group, ServiceAccount) pode *fazer o quê* (verbos: get, list, create, delete, etc.) em *quais recursos* (pods, services, etc.) via **Role**/ **ClusterRole** e **RoleBinding**/ **ClusterRoleBinding**. Quem autentica são os authenticators (A); quem autoriza é o RBAC (B). Admission Controllers (C) validam/mutam requisições após a autorização; kubelet (D) não faz autorização na API.

**Por que as outras estão erradas:** Authenticator só identifica quem é (A). Admission Controller atua depois da autorização (C). kubelet não decide permissões de API (D).

**Referência:** [Kubernetes - RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

---

### 18. Para restringir tráfego de rede entre Pods (por exemplo, por namespace ou label), qual recurso do Kubernetes deve ser usado?

**A)** Pod Security Admission  
**B)** NetworkPolicy  
**C)** RBAC  
**D)** Secret  

**Resposta correta: B — NetworkPolicy**

**Explicação:** **NetworkPolicy** é o recurso da API que define regras de rede para Pods: quais ingress (entrada) e egress (saída) são permitidos (por pod selector, namespace, CIDR, portas). Assim é possível segmentar tráfego entre namespaces ou entre grupos de Pods. Pod Security Admission (A) trata de segurança do contêiner (capabilities, etc.), não de rede. RBAC (C) controla acesso à API. Secret (D) armazena dados sensíveis.

**Por que as outras estão erradas:** PSA não controla rede (A). RBAC controla chamadas à API, não pacotes entre Pods (C). Secret não define regras de rede (D).

**Referência:** [Kubernetes - NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

---

## KCSA — Kubernetes Cluster Component Security & Threat Model

### 19. Onde o Kubernetes armazena todos os dados do cluster (estado do API server, etc.)?

**A)** No kube-apiserver  
**B)** No etcd  
**C)** No kube-scheduler  
**D)** No kubelet  

**Resposta correta: B — etcd**

**Explicação:** O **etcd** é o armazenamento de chave-valor distribuído usado pelo Kubernetes para persistir todo o estado do cluster: objetos da API (Pods, Services, ConfigMaps, Secrets, etc.), descoberta e dados de liderança. O kube-apiserver é o único componente que escreve e lê no etcd. Por isso a segurança do etcd é crítica: criptografia em trânsito, restrição de acesso, backup e possível criptografia em repouso.

**Por que as outras estão erradas:** kube-apiserver (A) fala com o etcd, mas não é o armazenamento. kube-scheduler (C) e kubelet (D) não armazenam o estado global do cluster.

**Referência:** [Kubernetes - etcd](https://kubernetes.io/docs/concepts/overview/components/#etcd), [Security - etcd](https://kubernetes.io/docs/concepts/security/)

---

### 20. Um atacante que compromete um Pod pode tentar obter acesso a metadados do cloud provider (ex.: IAM) através de qual vetor?

**A)** Apenas via rede externa.  
**B)** Endpoint de metadados do nó (ex.: 169.254.169.254 em muitos clouds), acessível do Pod se não houver restrições.  
**C)** Apenas via etcd.  
**D)** Apenas via kube-apiserver.  

**Resposta correta: B — Endpoint de metadados do nó (ex.: 169.254.169.254 em muitos clouds), acessível do Pod se não houver restrições**

**Explicação:** Em muitos ambientes de cloud (AWS, GCP, Azure), o **endpoint de metadados** (ex.: `http://169.254.169.254`) no host expõe credenciais, IAM roles e outros metadados. Por padrão, um Pod pode acessar esse endpoint através do nó, o que permite **credential theft** se o Pod for comprometido. Boas práticas: usar network policies ou configurações do cloud (ex.: IMDSv2, bloqueio de metadados) para restringir ou impedir esse acesso.

**Por que as outras estão erradas:** O vetor principal em ambientes cloud é o endpoint de metadados no host (B). Rede externa (A), etcd (C) ou API (D) são outros vetores, mas a pergunta enfatiza o cenário típico de metadados do cloud.

**Referência:** [Kubernetes - Security Checklist](https://kubernetes.io/docs/concepts/security/security-checklist/), CIS Kubernetes Benchmark, cloud provider security docs

---

### 21. O que o CIS Kubernetes Benchmark fornece?

**A)** Apenas uma lista de ferramentas de scan.  
**B)** Recomendações de configuração de segurança para componentes do Kubernetes (control plane, etcd, kubelet, etc.) com níveis de rigor (Level 1 e 2).  
**C)** Apenas políticas de rede.  
**D)** Substituição oficial do RBAC.  

**Resposta correta: B — Recomendações de configuração de segurança para componentes do Kubernetes (control plane, etcd, kubelet, etc.) com níveis de rigor (Level 1 e 2)**

**Explicação:** O **CIS Kubernetes Benchmark** (Center for Internet Security) é um conjunto de **recomendações de configuração** para endurecer o Kubernetes: permissões de arquivos, flags do kube-apiserver, kubelet, etcd, kube-controller-manager, scheduler, etc. Há dois níveis: **Level 1** (prático, baixo impacto) e **Level 2** (mais rígido, para ambientes sensíveis). Ferramentas como kube-bench automatizam a verificação contra esse benchmark.

**Por que as outras estão erradas:** O benchmark são recomendações de configuração, não só uma lista de ferramentas (A). Ele cobre muito mais do que rede (C). Não substitui RBAC; complementa com hardening (D).

**Referência:** [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes)

---

## KCSA — Platform Security & Compliance

### 22. Para garantir que imagens de contêiner usadas no cluster não tenham vulnerabilidades conhecidas, qual prática é recomendada?

**A)** Usar apenas a imagem "latest".  
**B)** Escanear imagens em pipeline (CI) e no momento do deploy (admission), usar registries confiáveis e assinatura de imagens (ex.: cosign, notary).  
**C)** Desabilitar o image pull policy.  
**D)** Armazenar todas as imagens em um único registry sem verificação.  

**Resposta correta: B — Escanear imagens em pipeline (CI) e no momento do deploy (admission), usar registries confiáveis e assinatura de imagens (ex.: cosign, notary)**

**Explicação:** A **segurança da supply chain** de imagens inclui: **scan de vulnerabilidades** em CI e em admission (ex.: Trivy, Clair); uso de **registries confiáveis** e controle de acesso; **assinatura e verificação** de imagens (cosign, OCI image signing) para garantir integridade e origem. Admission controllers (ex.: Gatekeeper, Kyverno) podem bloquear imagens que não passem em política. "Latest" (A) é instável e não garante segurança; desabilitar pull policy (C) ou não verificar (D) aumenta risco.

**Por que as outras estão erradas:** "Latest" não é auditável e pode trazer vulnerabilidades (A). Desabilitar image pull (C) ou não verificar (D) piora a postura de segurança.

**Referência:** [Kubernetes - Security Checklist](https://kubernetes.io/docs/concepts/security/security-checklist/), Supply Chain Security (CNCF)

---

### 23. O que são os "4Cs" da segurança cloud native e por que a ordem importa?

**A)** São quatro ferramentas: Calico, Cilium, Containerd, CoreDNS.  
**B)** São quatro camadas de segurança (Code, Container, Cluster, Cloud) da aplicação para a infraestrutura; a ordem indica que uma falha em uma camada interna pode ser contida pelas externas se todas forem reforçadas.  
**C)** São quatro tipos de ataque: Cross-site, Container escape, Cluster compromise, Cloud breach.  
**D)** São quatro certificações: CKA, CKAD, CKS, KCNA.  

**Resposta correta: B — São quatro camadas de segurança (Code, Container, Cluster, Cloud) da aplicação para a infraestrutura; a ordem indica que uma falha em uma camada interna pode ser contida pelas externas se todas forem reforçadas**

**Explicação:** Os **4Cs** (Code, Container, Cluster, Cloud) são **camadas** de segurança da aplicação até a infraestrutura. A ordem mostra a progressão: vulnerabilidade no código pode ser mitigada por boas práticas em container (imagem, runtime), cluster (RBAC, NetworkPolicy, Pod Security) e cloud (rede, IAM, hardening). Reforçar todas as camadas implementa defesa em profundidade.

**Por que as outras estão erradas:** 4Cs não são ferramentas (A), tipos de ataque (C) ou certificações (D).

**Referência:** Kubernetes e CNCF security documentation, 4Cs model

---

### 24. Para auditoria de ações no cluster (quem fez o quê e quando), qual recurso do Kubernetes deve ser habilitado?

**A)** Apenas logs do kubelet.  
**B)** Audit logging do kube-apiserver, que registra eventos de API (quem, qual recurso, qual verbo, resultado).  
**C)** Apenas métricas do Prometheus.  
**D)** Apenas NetworkPolicy.  

**Resposta correta: B — Audit logging do kube-apiserver, que registra eventos de API (quem, qual recurso, qual verbo, resultado)**

**Explicação:** O **audit logging** do **kube-apiserver** grava um registro cronológico das requisições à API: usuário/ServiceAccount, recurso, verbo (get, create, delete, etc.), namespace, resultado (sucesso/falha). Políticas de auditoria definem o que logar (Metadata, Request, Response) e em que estágio (RequestReceived, ResponseStarted, ResponseComplete). Isso é essencial para compliance, detecção de abuso e resposta a incidentes.

**Por que as outras estão erradas:** Logs do kubelet (A) e métricas (C) não substituem o registro de quem chamou a API. NetworkPolicy (D) é para rede, não auditoria.

**Referência:** [Kubernetes - Audit](https://kubernetes.io/docs/tasks/debug-application-cluster/audit/)

---

### 25. Qual é a diferença entre multitenancy "soft" e "hard" em Kubernetes no contexto de segurança?

**A)** Não há diferença; são sinônimos.  
**B)** Soft: múltiplos times compartilham o cluster com isolamento lógico (namespaces, RBAC, NetworkPolicy). Hard: clusters separados por tenant para isolamento físico/administrativo.  
**C)** Soft usa apenas um namespace; hard usa vários namespaces.  
**D)** Hard é mais barato; soft é mais caro.  

**Resposta correta: B — Soft: múltiplos times compartilham o cluster com isolamento lógico (namespaces, RBAC, NetworkPolicy). Hard: clusters separados por tenant para isolamento físico/administrativo**

**Explicação:** Em **soft multitenancy**, vários tenants compartilham o mesmo cluster; o isolamento é feito por **namespaces**, **RBAC**, **NetworkPolicy**, quotas e políticas de segurança. Mais econômico, mas exige disciplina e hardening. Em **hard multitenancy**, cada tenant tem **cluster(s) dedicado(s)** — maior isolamento e conformidade, com custo e operação maiores. A escolha depende de requisitos de compliance e confiança entre tenants.

**Por que as outras estão erradas:** São modelos distintos (A). Soft não é "um namespace só" (C). Hard tende a ser mais caro por ter mais clusters (D).

**Referência:** Kubernetes multitenancy documentation, KCSA curriculum — Platform Security

---

### 26. Por que é recomendável não executar contêineres como root (UID 0) dentro do Pod?

**A)** Porque o Kubernetes não suporta usuários não-root.  
**B)** Porque reduz a superfície de ataque: em caso de comprometimento do processo, o atacante tem menos privilégios; alinha-se aos níveis restricted/baseline dos Pod Security Standards.  
**C)** Porque o kubelet exige que todos os contêineres rodem como root.  
**D)** Porque RBAC não funciona com contêineres não-root.  

**Resposta correta: B — Porque reduz a superfície de ataque: em caso de comprometimento do processo, o atacante tem menos privilégios; alinha-se aos níveis restricted/baseline dos Pod Security Standards**

**Explicação:** Executar como **root (UID 0)** dentro do contêiner amplia o impacto de um compromise: o atacante pode modificar arquivos, instalar pacotes ou explorar vulnerabilidades com mais facilidade. Rodar com **usuário não-root** (via `securityContext.runAsNonRoot`, `runAsUser`) limita privilégios e está alinhado aos **Pod Security Standards** (baseline/restricted). O Kubernetes suporta runAsUser/runAsNonRoot; o kubelet não exige root (B e C estão corretos apenas em parte; a razão principal é segurança).

**Por que as outras estão erradas:** Kubernetes suporta usuários não-root (A). kubelet não exige root (C). RBAC é independente do UID do processo no contêiner (D).

**Referência:** [Kubernetes - Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/), Pod Security Standards

---

# Resumo de referências

- **KCNA:** [CNCF KCNA](https://www.cncf.io/training/certification/kcna/), [GitHub cncf/curriculum (kcna)](https://github.com/cncf/curriculum/tree/master/kcna), [Kubernetes Docs](https://kubernetes.io/docs/)
- **KCSA:** [CNCF KCSA](https://www.cncf.io/training/certification/kcsa/), [KCSA Curriculum PDF](https://github.com/cncf/curriculum/blob/master/KCSA%20Curriculum.pdf), [Kubernetes Security](https://kubernetes.io/docs/concepts/security/), [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes)

*Documento criado para estudo. As provas reais podem incluir mais questões e variações; use a documentação oficial e o currículo CNCF como base.*
