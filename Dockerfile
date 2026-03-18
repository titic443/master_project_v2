# =============================================================================
# Flutter Test Generator — Docker Image
# =============================================================================
# Multi-stage build:
#   Stage 1 (pict-builder) : build Microsoft PICT binary from source
#   Stage 2 (final)        : Dart + Flutter + tool files + PICT binary
#
# Usage:
#   docker build -t flutter_test_gen .
#   docker run -it --rm -p 8080:8080 -v $(pwd):/workspace flutter_test_gen
# =============================================================================

# -----------------------------------------------------------------------------
# Stage 1: Build PICT from source (Linux/ARM64 compatible)
# -----------------------------------------------------------------------------
FROM debian:bookworm-slim AS pict-builder

RUN apt-get update && apt-get install -y \
    git build-essential cmake \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/microsoft/pict.git /pict --depth 1 \
    && cd /pict \
    && cmake -DCMAKE_BUILD_TYPE=Release . \
    && make -j$(nproc) \
    && strip pict

# -----------------------------------------------------------------------------
# Stage 2: Final image — Dart + Flutter + tool
# -----------------------------------------------------------------------------
FROM dart:stable

# Install system dependencies for Flutter
RUN apt-get update && apt-get install -y \
    git curl unzip xz-utils zip \
    libglu1-mesa clang cmake ninja-build pkg-config \
    libgtk-3-dev liblzma-dev libstdc++-12-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter SDK
ENV FLUTTER_HOME=/flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME \
    --branch stable --depth 1 --no-tags \
    && $FLUTTER_HOME/bin/flutter precache \
        --no-ios --no-android --no-fuchsia \
    && $FLUTTER_HOME/bin/flutter --version

ENV PATH="$FLUTTER_HOME/bin:${PATH}"

# Copy PICT binary from build stage
COPY --from=pict-builder /pict/pict /usr/local/bin/pict
RUN chmod +x /usr/local/bin/pict

# Copy tool files into image
WORKDIR /tool
COPY tools/script_v2/ ./tools/script_v2/
COPY webview/index.html  ./webview/index.html
COPY webview/main.js     ./webview/main.js
COPY webview/styles.css  ./webview/styles.css
COPY webview/server.dart ./webview/server.dart
COPY webview/coverage_runner.dart ./webview/coverage_runner.dart

# Pre-fetch Dart dependencies using the project's pubspec
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get

# Entrypoint script
COPY docker-entrypoint.sh /tool/entrypoint.sh
RUN chmod +x /tool/entrypoint.sh

EXPOSE 8080

# Run from /workspace (the mounted Flutter project)
WORKDIR /workspace
ENTRYPOINT ["/tool/entrypoint.sh"]
