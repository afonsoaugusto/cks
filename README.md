[![afonsoaugusto - cks](https://img.shields.io/static/v1?label=afonsoaugusto&message=cks&color=blue&logo=github)](https://github.com/afonsoaugusto/cks "Go to GitHub repo")
[![stars - cks](https://img.shields.io/github/stars/afonsoaugusto/cks?style=social)](https://github.com/afonsoaugusto/cks)
[![forks - cks](https://img.shields.io/github/forks/afonsoaugusto/cks?style=social)](https://github.com/afonsoaugusto/cks)

# Certified Kubernetes Security Specialist (CKS) Exam Curriculum

Uma publicação da **Cloud Native Computing Foundation (CNCF)**  
Website: [cncf.io](https://cncf.io)

---

## Visão Geral

Este documento fornece o esboço do currículo de Conhecimentos, Habilidades e Capacidades que um **Certified Kubernetes Security Specialist (CKS)** deve demonstrar.

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
