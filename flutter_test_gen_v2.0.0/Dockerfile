# =============================================================================
# Flutter Test Generator — Docker Image
# =============================================================================
# Multi-stage build:
#   Stage 1 (pict-builder) : build Microsoft PICT binary from source
#   Stage 2 (final)        : Dart-only image + tool files + PICT binary
#
# NOTE: Flutter/Android SDK removed — test execution runs on the host machine
# via host_runner.dart (port 8089).  This container only runs Dart pipeline
# scripts: scan → datasets → PICT → test script generation.
#
# Usage:
#   docker build -t flutter_test_gen .
#   docker run -d --rm -p 8080:8080 -v $(pwd):/workspace flutter_test_gen
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
    && make -j1 \
    && PICT_BIN=$(find /pict -maxdepth 3 -type f \( -name "pict" -o -name "pict_cli" \) | head -1) \
    && echo "Found PICT binary at: $PICT_BIN" \
    && strip "$PICT_BIN" \
    && cp "$PICT_BIN" /pict_binary

# -----------------------------------------------------------------------------
# Stage 2: Final image — Dart only (no Flutter SDK needed)
# -----------------------------------------------------------------------------
FROM dart:stable

# Minimal system packages (no Flutter build deps)
RUN apt-get update && apt-get install -y \
    git curl \
    && rm -rf /var/lib/apt/lists/*

# Copy PICT binary from build stage
COPY --from=pict-builder /pict_binary /usr/local/bin/pict
RUN chmod +x /usr/local/bin/pict

# Copy tool files into image
WORKDIR /tool
COPY tools/script_v2/ ./tools/script_v2/
COPY webview/index.html           ./webview/index.html
COPY webview/main.js              ./webview/main.js
COPY webview/styles.css           ./webview/styles.css
COPY webview/server.dart          ./webview/server.dart
COPY webview/coverage_runner.dart ./webview/coverage_runner.dart

# Minimal pubspec for the tool — no Flutter deps (tool uses only dart: built-ins)
RUN printf 'name: flutter_test_gen_tool\nenvironment:\n  sdk: ">=3.5.0 <4.0.0"\n' \
    > pubspec.yaml && dart pub get

# Entrypoint script
COPY docker-entrypoint.sh /tool/entrypoint.sh
RUN chmod +x /tool/entrypoint.sh

EXPOSE 8080

# Run from /workspace (the mounted Flutter project)
WORKDIR /workspace
ENTRYPOINT ["/tool/entrypoint.sh"]
