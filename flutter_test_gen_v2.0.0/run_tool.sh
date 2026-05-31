#!/bin/bash
# =============================================================================
# run_tool.sh — Flutter Test Generator helper script
# =============================================================================
# วิธีใช้: รันจาก directory ที่แตก zip ของเครื่องมือ
#
#   ./run_tool.sh /path/to/flutter_project   # ระบุ project path
#   ./run_tool.sh                            # ใช้ current directory เป็น project
#   ./run_tool.sh --build                    # build image ก่อนรัน
#   ./run_tool.sh --stop                     # หยุด container
#
# =============================================================================

IMAGE_NAME="flutter_test_gen"
CONTAINER_NAME="flutter_test_gen_server"
PORT=8080
URL="http://localhost:$PORT"

# TOOL_DIR คือ directory ที่ script นี้อยู่ (ที่แตก zip)
TOOL_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── Parse arguments ───────────────────────────────────────────────────────────
BUILD=false
STOP=false
PROJECT_DIR=""

for arg in "$@"; do
  case $arg in
    --build) BUILD=true ;;
    --stop)  STOP=true  ;;
    --*)     ;;                        # ignore unknown flags
    *)       PROJECT_DIR="$arg" ;;    # positional = flutter project path
  esac
done

# ถ้าไม่ได้ระบุ project path ให้ใช้ current directory
if [ -z "$PROJECT_DIR" ]; then
  PROJECT_DIR="$(pwd)"
fi

# resolve absolute path
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

# ── Stop container ─────────────────────────────────────────────────────────────
if [ "$STOP" = true ]; then
  echo "🛑 Stopping container..."
  docker stop $CONTAINER_NAME 2>/dev/null && echo "✅ Stopped" || echo "Container not running"
  exit 0
fi

# ── Validate tool directory ───────────────────────────────────────────────────
if [ ! -f "$TOOL_DIR/Dockerfile" ]; then
  echo ""
  echo "❌ ERROR: ไม่พบ Dockerfile ใน: $TOOL_DIR"
  echo "   กรุณารัน script นี้จาก directory ที่แตก flutter_test_gen_v1.0.0.zip"
  echo ""
  exit 1
fi

# ── Validate project directory ───────────────────────────────────────────────
if [ ! -f "$PROJECT_DIR/pubspec.yaml" ]; then
  echo ""
  echo "❌ ERROR: ไม่พบ pubspec.yaml ใน: $PROJECT_DIR"
  echo "   กรุณาระบุ path ของ Flutter project ที่ถูกต้อง"
  echo "   เช่น: ./run_tool.sh /path/to/your_flutter_project"
  echo ""
  exit 1
fi

# ── Build image ────────────────────────────────────────────────────────────────
if [ "$BUILD" = true ] || ! docker image inspect $IMAGE_NAME &>/dev/null; then
  echo "🔨 Building Docker image (this may take a few minutes on first run)..."
  docker build -t $IMAGE_NAME "$TOOL_DIR"
  echo "✅ Build complete"
fi

# ── Stop existing container if running ────────────────────────────────────────
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm   $CONTAINER_NAME 2>/dev/null || true

# ── Setup emulator ADB TCP proxy (socat: 0.0.0.0:5560 → 127.0.0.1:5555) ──────
# Find adb binary (not always in PATH on macOS)
ADB_BIN=""
for candidate in \
    "$(command -v adb 2>/dev/null)" \
    "$HOME/Library/Android/sdk/platform-tools/adb" \
    "/usr/local/bin/adb"; do
  if [ -x "$candidate" ]; then
    ADB_BIN="$candidate"
    break
  fi
done

if [ -n "$ADB_BIN" ] && command -v socat &>/dev/null; then
  echo "🔌 Setting up emulator ADB TCP proxy..."
  # Switch emulator to TCP ADB mode (port 5555 on emulator)
  "$ADB_BIN" tcpip 5555 2>/dev/null || true
  sleep 1
  # Reconnect on host via TCP so socat has something to forward to
  "$ADB_BIN" connect 127.0.0.1:5555 2>/dev/null || true
  # Kill any existing socat proxy on port 5560
  pkill -f "socat.*5560" 2>/dev/null || true
  sleep 0.5
  # Proxy: all-interfaces:5560 → localhost:5555
  socat TCP-LISTEN:5560,bind=0.0.0.0,reuseaddr,fork TCP:127.0.0.1:5555 &
  sleep 1
  echo "   ✓ ADB proxy ready: host.docker.internal:5560 → emulator:5555"
else
  echo "   ⚠ adb or socat not found — install socat with: brew install socat"
fi

# ── Run container ──────────────────────────────────────────────────────────────
echo "🚀 Starting Flutter Test Generator..."
echo "   Project : $PROJECT_DIR"
echo "   URL     : $URL"
echo ""

docker run --rm \
  --name $CONTAINER_NAME \
  -p $PORT:$PORT \
  -v "$PROJECT_DIR:/workspace" \
  $IMAGE_NAME &

# รอให้ server พร้อม
sleep 3

# เปิด browser อัตโนมัติ
if command -v open &>/dev/null; then
  open "$URL"          # macOS
elif command -v xdg-open &>/dev/null; then
  xdg-open "$URL"      # Linux
elif command -v start &>/dev/null; then
  start "$URL"         # Windows Git Bash
fi

# รอ container
wait
