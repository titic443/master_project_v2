#!/bin/bash
# =============================================================================
# build_release.sh — Build flutter_test_gen_vX.X.X.zip from current source
# =============================================================================
# Usage:
#   ./build_release.sh 2.0.0      → builds flutter_test_gen_v2.0.0.zip
#   ./build_release.sh 2.1.0
# =============================================================================

set -e

VERSION="$1"

# ── Validate ──────────────────────────────────────────────────────────────────
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>  (e.g. $0 2.1.0)"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGE_NAME="flutter_test_gen_v${VERSION}"
OUT_DIR="$SCRIPT_DIR/$PACKAGE_NAME"
ZIP_FILE="$SCRIPT_DIR/${PACKAGE_NAME}.zip"
TOOL_BASE="$SCRIPT_DIR/flutter_test_gen_v2.0.0"   # source of Dockerfile / entrypoint

# ── Check source files exist ──────────────────────────────────────────────────
for f in \
  "$TOOL_BASE/Dockerfile" \
  "$TOOL_BASE/docker-entrypoint.sh" \
  "$TOOL_BASE/pubspec.yaml" \
  "$TOOL_BASE/pubspec.lock" \
  "$TOOL_BASE/run_tool.sh" \
  "$TOOL_BASE/INSTALL.md" \
  "$SCRIPT_DIR/tools/script_v2/generate_test_script.dart" \
  "$SCRIPT_DIR/webview/server.dart"; do
  if [ ! -f "$f" ]; then
    echo "❌ Missing required file: $f"
    exit 1
  fi
done

echo "📦 Building $PACKAGE_NAME ..."

# ── Clean output dir ──────────────────────────────────────────────────────────
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR/tools/script_v2"
mkdir -p "$OUT_DIR/webview"

# ── Copy infrastructure files (from v1.0.0 base) ─────────────────────────────
cp "$TOOL_BASE/Dockerfile"            "$OUT_DIR/"
cp "$TOOL_BASE/docker-entrypoint.sh"  "$OUT_DIR/"
cp "$TOOL_BASE/pubspec.yaml"          "$OUT_DIR/"
cp "$TOOL_BASE/pubspec.lock"          "$OUT_DIR/"
cp "$TOOL_BASE/run_tool.sh"           "$OUT_DIR/"

# ── Copy INSTALL.md with version replaced ─────────────────────────────────────
sed "s/v1\.0\.0/v${VERSION}/g" "$TOOL_BASE/INSTALL.md" > "$OUT_DIR/INSTALL.md"

# ── Copy LATEST tool scripts (exclude .ini planning files) ───────────────────
for dart_file in "$SCRIPT_DIR/tools/script_v2/"*.dart; do
  cp "$dart_file" "$OUT_DIR/tools/script_v2/"
done

# ── Copy LATEST webview files (exclude README.md, *.ini) ─────────────────────
for f in index.html main.js styles.css server.dart coverage_runner.dart; do
  if [ -f "$SCRIPT_DIR/webview/$f" ]; then
    cp "$SCRIPT_DIR/webview/$f" "$OUT_DIR/webview/"
  fi
done

# ── Create zip ────────────────────────────────────────────────────────────────
rm -f "$ZIP_FILE"
cd "$SCRIPT_DIR"
zip -r "$ZIP_FILE" "$PACKAGE_NAME/" \
  --exclude "*.DS_Store" \
  --exclude "__MACOSX/*" \
  --exclude "*.ini" \
  -q

# ── Summary ───────────────────────────────────────────────────────────────────
FILE_COUNT=$(unzip -l "$ZIP_FILE" | tail -1 | awk '{print $2}')
SIZE=$(du -sh "$ZIP_FILE" | cut -f1)

echo "✅ Done!"
echo "   File    : $ZIP_FILE"
echo "   Size    : $SIZE"
echo "   Entries : $FILE_COUNT files"
echo ""
echo "วิธีใช้:"
echo "   unzip ${PACKAGE_NAME}.zip"
echo "   cd $PACKAGE_NAME"
echo "   ./run_tool.sh /path/to/your_flutter_project"
