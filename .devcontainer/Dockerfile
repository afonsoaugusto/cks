# CKS Lab environment: base devcontainer + ferramentas do exame CKS
# Build: docker build -t cks-lab -f .devcontainer/Dockerfile .devcontainer
FROM mcr.microsoft.com/devcontainers/base:bullseye

ARG BIN_DIR=/usr/local/bin
ENV PATH="${BIN_DIR}:${PATH}"

# Dependências para scripts de instalação
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Instalação das ferramentas CKS (Trivy, kube-bench, kind, bom, yq, kubeconform)
COPY install-cks-tools.sh /tmp/install-cks-tools.sh
RUN chmod +x /tmp/install-cks-tools.sh && /tmp/install-cks-tools.sh && rm /tmp/install-cks-tools.sh

# Diretório de trabalho para labs (espelha /opt/course do simulador)
RUN mkdir -p /opt/course && chown -R vscode:vscode /opt/course 2>/dev/null || true
