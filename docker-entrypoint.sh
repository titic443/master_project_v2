#!/bin/bash
# =============================================================================
# docker-entrypoint.sh
# =============================================================================
# รันภายใน container เมื่อเริ่มต้น
#
# หน้าที่:
#   1. ตรวจสอบว่า /workspace คือ Flutter project จริง
#   2. Copy web assets (webview/) ไปยัง /workspace (เพื่อ serve static files)
#   3. Symlink PICT binary ให้ใช้งานได้จาก ./pict
#   4. รัน dart pub get ใน /workspace
#   5. Start server
# =============================================================================
set -e

WORKSPACE=/workspace
TOOL_DIR=/tool

# ── 1. ตรวจสอบ Flutter project ───────────────────────────────────────────────
if [ ! -f "$WORKSPACE/pubspec.yaml" ]; then
  echo ""
  echo "❌ ERROR: ไม่พบ pubspec.yaml ใน $WORKSPACE"
  echo "   กรุณา mount Flutter project ของคุณด้วย:"
  echo "   docker run -v /path/to/your/project:/workspace ..."
  echo ""
  exit 1
fi

echo "✅ Flutter project found: $(grep '^name:' $WORKSPACE/pubspec.yaml)"

# ── 2. Copy web assets ไปยัง /workspace/webview/ ─────────────────────────────
# server.dart serve static files จาก webview/ relative to CWD (/workspace)
if [ ! -d "$WORKSPACE/webview" ]; then
  echo "📁 Copying web assets to workspace..."
  cp -r "$TOOL_DIR/webview" "$WORKSPACE/webview"
else
  echo "📁 Web assets already in workspace (skipping copy)"
fi

# ── 3. Copy tools ไปยัง /workspace/tools/ ────────────────────────────────────
if [ ! -d "$WORKSPACE/tools/script_v2" ]; then
  echo "🔧 Copying tool scripts to workspace..."
  mkdir -p "$WORKSPACE/tools"
  cp -r "$TOOL_DIR/tools/script_v2" "$WORKSPACE/tools/script_v2"
else
  echo "🔧 Tool scripts already in workspace (skipping copy)"
fi

# ── 4. Symlink PICT binary ───────────────────────────────────────────────────
# generator_pict.dart ใช้ ./pict (relative path)
if [ ! -f "$WORKSPACE/pict" ]; then
  ln -s /usr/local/bin/pict "$WORKSPACE/pict"
  echo "🔗 PICT binary linked"
fi

# ── 5. dart pub get ใน workspace ─────────────────────────────────────────────
echo "📦 Running dart pub get..."
cd "$WORKSPACE"
dart pub get --no-example 2>&1 | tail -3

# ── 6. Start server ──────────────────────────────────────────────────────────
echo ""
echo "🚀 Starting Flutter Test Generator..."
echo "   Open http://localhost:8080 in your browser"
echo ""

exec dart run "$TOOL_DIR/webview/server.dart"
