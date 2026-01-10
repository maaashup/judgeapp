FROM mcr.microsoft.com/devcontainers/typescript-node:20

RUN corepack enable
RUN npm install -g @ionic/cli

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get -y install --no-install-recommends git \
  && rm -rf /var/lib/apt/lists/*