#!/bin/bash
# =============================================================================
# run_tool.sh — Flutter Test Generator helper script
# =============================================================================
# วิธีใช้: รัน script นี้จาก root ของ Flutter project ที่ต้องการ test
#
#   chmod +x run_tool.sh
#   ./run_tool.sh              # รัน container และเปิด browser อัตโนมัติ
#   ./run_tool.sh --build      # build image ก่อนรัน
#   ./run_tool.sh --stop       # หยุด container
# =============================================================================

IMAGE_NAME="flutter_test_gen"
CONTAINER_NAME="flutter_test_gen_server"
PORT=8080
URL="http://localhost:$PORT"

# ── Parse arguments ───────────────────────────────────────────────────────────
BUILD=false
STOP=false
for arg in "$@"; do
  case $arg in
    --build) BUILD=true ;;
    --stop)  STOP=true  ;;
  esac
done

# ── Stop container ─────────────────────────────────────────────────────────────
if [ "$STOP" = true ]; then
  echo "🛑 Stopping container..."
  docker stop $CONTAINER_NAME 2>/dev/null && echo "✅ Stopped" || echo "Container not running"
  exit 0
fi

# ── Build image ────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ "$BUILD" = true ] || ! docker image inspect $IMAGE_NAME &>/dev/null; then
  echo "🔨 Building Docker image (this may take a few minutes on first run)..."
  docker build -t $IMAGE_NAME "$SCRIPT_DIR"
  echo "✅ Build complete"
fi

# ── Stop existing container if running ────────────────────────────────────────
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm   $CONTAINER_NAME 2>/dev/null || true

# ── Run container ──────────────────────────────────────────────────────────────
echo "🚀 Starting Flutter Test Generator..."
echo "   Project : $(pwd)"
echo "   URL     : $URL"
echo ""

docker run -it --rm \
  --name $CONTAINER_NAME \
  -p $PORT:$PORT \
  -v "$(pwd):/workspace" \
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
