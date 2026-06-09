#!/bin/bash
# =============================================================================
# run_tool.sh — Flutter Test Generator helper script
# =============================================================================
# วิธีใช้: รันจาก directory ที่แตก zip ของเครื่องมือ
#
#   ./run_tool.sh /path/to/flutter_project                      # ระบุ project path
#   ./run_tool.sh                                               # ใช้ current directory เป็น project
#   ./run_tool.sh --build                                       # build image ก่อนรัน
#   ./run_tool.sh --stop                                        # หยุด container และ host runner
#   ./run_tool.sh /path/to/flutter_project --api-key=AIza...   # ระบุ Gemini API key
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
API_KEY=""

for arg in "$@"; do
  case $arg in
    --build)     BUILD=true ;;
    --stop)      STOP=true  ;;
    --api-key=*) API_KEY="${arg#--api-key=}" ;;
    --*)         ;;                        # ignore unknown flags
    *)           PROJECT_DIR="$arg" ;;    # positional = flutter project path
  esac
done

# ถ้าไม่ได้ระบุ project path ให้ใช้ current directory
if [ -z "$PROJECT_DIR" ]; then
  PROJECT_DIR="$(pwd)"
fi

# resolve absolute path
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

# ── Stop container and host runner ────────────────────────────────────────────
if [ "$STOP" = true ]; then
  echo "Stopping Flutter Test Generator..."
  docker stop $CONTAINER_NAME 2>/dev/null && echo "Docker container stopped" || echo "Container not running"
  pkill -f "dart.*host_runner.dart" 2>/dev/null && echo "Host runner stopped" || echo "Host runner not running"
  exit 0
fi

# ── Validate tool directory ───────────────────────────────────────────────────
if [ ! -f "$TOOL_DIR/Dockerfile" ]; then
  echo ""
  echo "ERROR: Dockerfile not found in: $TOOL_DIR"
  echo "   Please run this script from the extracted flutter_test_gen zip directory"
  echo ""
  exit 1
fi

# ── Validate project directory ───────────────────────────────────────────────
if [ ! -f "$PROJECT_DIR/pubspec.yaml" ]; then
  echo ""
  echo "ERROR: pubspec.yaml not found in: $PROJECT_DIR"
  echo "   Please provide the path to your Flutter project"
  echo "   e.g.: ./run_tool.sh /path/to/your_flutter_project"
  echo ""
  exit 1
fi

# ── Build image ────────────────────────────────────────────────────────────────
if [ "$BUILD" = true ] || ! docker image inspect $IMAGE_NAME &>/dev/null; then
  echo "Building Docker image (this may take a few minutes on first run)..."
  docker build --platform linux/arm64 -t $IMAGE_NAME "$TOOL_DIR" || { echo "Docker build failed"; exit 1; }
  echo "Build complete"
fi

# ── Stop existing container and host runner if running ────────────────────────
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm   $CONTAINER_NAME 2>/dev/null || true
pkill -f "dart.*host_runner.dart" 2>/dev/null || true

# ── Start Flutter Test Generator ──────────────────────────────────────────────
echo "Starting Flutter Test Generator..."
echo "   Project : $PROJECT_DIR"
[ -n "$API_KEY" ] && echo "   API Key : (provided via --api-key)"
echo "   URL     : $URL"
echo ""

# รัน Docker container แบบ detached (ไม่ตายเมื่อปิด terminal)
_ENV_ARGS=()
[ -n "$API_KEY" ] && _ENV_ARGS+=(-e "GEMINI_API_KEY=$API_KEY")

docker run -d --rm \
  --platform linux/arm64 \
  --name $CONTAINER_NAME \
  -p $PORT:$PORT \
  -v "$PROJECT_DIR:/workspace" \
  "${_ENV_ARGS[@]}" \
  $IMAGE_NAME

# รัน host runner บน HOST แบบ background (รับ flutter test requests จาก Docker)
nohup dart run "$TOOL_DIR/webview/host_runner.dart" "$PROJECT_DIR" \
  > /tmp/flutter_test_gen_host_runner.log 2>&1 &

echo "Started!"
echo "   Host runner log : /tmp/flutter_test_gen_host_runner.log"
echo ""

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

echo "To stop: ./run_tool.sh --stop"
