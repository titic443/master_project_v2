#!/bin/bash
# =============================================================================
# package_tool.sh — Flutter Test Generator Packaging Script
# =============================================================================
# สร้าง zip file สำหรับแจกจ่ายเครื่องมือไปยังเครื่องอื่น
#
# วิธีใช้:
#   chmod +x package_tool.sh
#   ./package_tool.sh
#
# Output: flutter_test_gen_<version>.zip
# =============================================================================

set -e

VERSION="1.0.0"
PACKAGE_NAME="flutter_test_gen_v${VERSION}"
OUTPUT_ZIP="${PACKAGE_NAME}.zip"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TMP_DIR="/tmp/${PACKAGE_NAME}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Flutter Test Generator — Packaging Tool"
echo "  Version: ${VERSION}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Clean up ───────────────────────────────────────────────────────────────────
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "📦 Collecting files..."

# ── 1. Core Docker files ───────────────────────────────────────────────────────
cp "$SCRIPT_DIR/Dockerfile"            "$TMP_DIR/Dockerfile"
cp "$SCRIPT_DIR/docker-entrypoint.sh"  "$TMP_DIR/docker-entrypoint.sh"
cp "$SCRIPT_DIR/pubspec.yaml"          "$TMP_DIR/pubspec.yaml"
cp "$SCRIPT_DIR/pubspec.lock"          "$TMP_DIR/pubspec.lock"
echo "  ✓ Docker files"

# ── 2. Tool scripts (script_v2) ───────────────────────────────────────────────
mkdir -p "$TMP_DIR/tools"
cp -r "$SCRIPT_DIR/tools/script_v2"   "$TMP_DIR/tools/script_v2"
echo "  ✓ Tool scripts (tools/script_v2)"

# ── 3. Web UI ─────────────────────────────────────────────────────────────────
mkdir -p "$TMP_DIR/webview"
cp "$SCRIPT_DIR/webview/index.html"         "$TMP_DIR/webview/index.html"
cp "$SCRIPT_DIR/webview/main.js"            "$TMP_DIR/webview/main.js"
cp "$SCRIPT_DIR/webview/styles.css"         "$TMP_DIR/webview/styles.css"
cp "$SCRIPT_DIR/webview/server.dart"        "$TMP_DIR/webview/server.dart"
cp "$SCRIPT_DIR/webview/coverage_runner.dart" "$TMP_DIR/webview/coverage_runner.dart"
echo "  ✓ Web UI (webview/)"

# ── 4. run_tool.sh (launcher script สำหรับ copy ไปยัง Flutter project) ────────
cp "$SCRIPT_DIR/run_tool.sh"           "$TMP_DIR/run_tool.sh"
chmod +x "$TMP_DIR/run_tool.sh"
chmod +x "$TMP_DIR/docker-entrypoint.sh"
echo "  ✓ run_tool.sh (launcher)"

# ── 5. INSTALL.md ─────────────────────────────────────────────────────────────
cp "$SCRIPT_DIR/INSTALL.md"            "$TMP_DIR/INSTALL.md" 2>/dev/null || true
echo "  ✓ INSTALL.md"

# ── Create zip ─────────────────────────────────────────────────────────────────
echo ""
echo "🗜  Creating zip..."
cd /tmp
zip -r "$SCRIPT_DIR/$OUTPUT_ZIP" "$PACKAGE_NAME" -x "*.DS_Store" -x "__pycache__/*"
rm -rf "$TMP_DIR"

ZIP_SIZE=$(du -sh "$SCRIPT_DIR/$OUTPUT_ZIP" | cut -f1)

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Packaging complete!"
echo ""
echo "   Output : $OUTPUT_ZIP"
echo "   Size   : $ZIP_SIZE"
echo ""
echo "📋 Package contents:"
echo "   flutter_test_gen_v${VERSION}/"
echo "   ├── Dockerfile              ← build Docker image"
echo "   ├── docker-entrypoint.sh"
echo "   ├── pubspec.yaml"
echo "   ├── pubspec.lock"
echo "   ├── run_tool.sh             ← copy ไปยัง Flutter project"
echo "   ├── tools/"
echo "   │   └── script_v2/          ← Dart scripts"
echo "   ├── webview/                ← Web UI"
echo "   └── INSTALL.md              ← คู่มือติดตั้ง"
echo ""
echo "📖 ดูวิธีติดตั้งใน INSTALL.md"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
