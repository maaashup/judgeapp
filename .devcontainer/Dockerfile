FROM mcr.microsoft.com/devcontainers/typescript-node:22

RUN corepack enable

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get -y install --no-install-recommends git curl unzip xz-utils zip libglu1-mesa \
  && rm -rf /var/lib/apt/lists/*

ENV FLUTTER_ROOT=/opt/flutter
ENV PATH=${PATH}:${FLUTTER_ROOT}/bin
RUN git clone --depth 1 -b stable https://github.com/flutter/flutter.git ${FLUTTER_ROOT} \
  && chown -R node:node ${FLUTTER_ROOT} \
  && su node -c "flutter precache"