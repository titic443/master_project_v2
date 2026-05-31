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
    && PICT_BIN=$(find /pict -maxdepth 3 -type f \( -name "pict" -o -name "pict_cli" \) | head -1) \
    && echo "Found PICT binary at: $PICT_BIN" \
    && strip "$PICT_BIN" \
    && cp "$PICT_BIN" /pict_binary

# -----------------------------------------------------------------------------
# Stage 2: Final image — Dart + Flutter + tool
# -----------------------------------------------------------------------------
FROM dart:stable

# Install system dependencies for Flutter + Java (required for Android SDK)
RUN apt-get update && apt-get install -y \
    git curl unzip xz-utils zip \
    libglu1-mesa clang cmake ninja-build pkg-config \
    libgtk-3-dev liblzma-dev libstdc++-12-dev \
    openjdk-17-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

# Install Android SDK command-line tools
ENV ANDROID_SDK_ROOT=/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && curl -fsSL \
        "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" \
        -o /tmp/cmdtools.zip \
    && unzip -q /tmp/cmdtools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools \
           ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm /tmp/cmdtools.zip

ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/build-tools/34.0.0:${PATH}"

RUN yes | sdkmanager --licenses > /dev/null 2>&1 \
    && sdkmanager "platform-tools" "build-tools;34.0.0" "platforms;android-34"

# Install Flutter SDK (with Android support)
ENV FLUTTER_HOME=/flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME \
    --branch stable --depth 1 \
    && $FLUTTER_HOME/bin/flutter config --android-sdk ${ANDROID_SDK_ROOT} \
    && $FLUTTER_HOME/bin/flutter precache --no-ios --no-fuchsia \
    && yes | $FLUTTER_HOME/bin/flutter doctor --android-licenses > /dev/null 2>&1 || true \
    && $FLUTTER_HOME/bin/flutter --version

ENV PATH="$FLUTTER_HOME/bin:${PATH}"

# Copy PICT binary from build stage
COPY --from=pict-builder /pict_binary /usr/local/bin/pict
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
RUN flutter pub get

# Entrypoint script
COPY docker-entrypoint.sh /tool/entrypoint.sh
RUN chmod +x /tool/entrypoint.sh

EXPOSE 8080

# Run from /workspace (the mounted Flutter project)
WORKDIR /workspace
ENTRYPOINT ["/tool/entrypoint.sh"]
