#!/usr/bin/env bash
set -euo pipefail

# ── Config ────────────────────────────────────────────────────────────────────
BACKEND_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE_FILE="$BACKEND_DIR/docker-compose.yml"

export PORT="${PORT:-8000}"

# ── Helpers ───────────────────────────────────────────────────────────────────
log() { echo "[run_tool] $*"; }
err() { echo "[run_tool] ERROR: $*" >&2; exit 1; }

require_docker() {
  command -v docker &>/dev/null || err "Docker is not installed or not in PATH"
  docker info &>/dev/null       || err "Docker daemon is not running"
}

# Auto-detect: prefer docker compose v2 plugin, fall back to docker-compose v1
COMPOSE_CMD=""
_detect_compose() {
  if [ -n "$COMPOSE_CMD" ]; then return; fi
  if docker compose version &>/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
  elif command -v docker-compose &>/dev/null; then
    COMPOSE_CMD="docker-compose"
  else
    err "Neither 'docker compose' nor 'docker-compose' found. Install Docker Desktop or docker-compose."
  fi
  log "Using: $COMPOSE_CMD"
}

compose() {
  _detect_compose
  (cd "$BACKEND_DIR" && $COMPOSE_CMD "$@")
}

# ── Commands ──────────────────────────────────────────────────────────────────
cmd_start() {
  require_docker
  log "Starting all services (mongodb + mongo-express + backend)..."
  compose up -d --build --remove-orphans
  log ""
  log "  API       → http://localhost:${PORT}"
  log "  API Docs  → http://localhost:${PORT}/docs"
  log "  Mongo UI  → http://localhost:8081"
  log ""
  log "Run './run_tool.sh logs' to follow logs."
}

cmd_stop() {
  require_docker
  log "Stopping all services..."
  compose down
  log "Stopped."
}

cmd_restart() {
  require_docker
  log "Restarting all services..."
  compose restart
  log "Restarted."
}

cmd_build() {
  require_docker
  log "Building backend image..."
  compose build backend
  log "Build complete."
}

cmd_logs() {
  require_docker
  local service="${2:-}"
  if [ -n "$service" ]; then
    compose logs -f "$service"
  else
    compose logs -f
  fi
}

cmd_status() {
  require_docker
  compose ps
}

cmd_shell() {
  require_docker
  log "Opening mongosh in mongodb container..."
  docker exec -it backend-mongodb mongosh "mongodb://localhost:27017/master_project_demo"
}

cmd_destroy() {
  require_docker
  log "WARNING: This will remove all containers AND the MongoDB data volume."
  read -r -p "Are you sure? [y/N] " confirm
  [[ "$confirm" =~ ^[yY]$ ]] || { log "Aborted."; exit 0; }
  compose down -v
  log "All containers and volumes removed."
}

cmd_help() {
  cat <<EOF
Usage: $(basename "$0") [COMMAND] [args]

Commands:
  start              Build images and start all services (default)
  stop               Stop and remove containers (data volume preserved)
  restart            Restart all running containers
  build              Rebuild backend image only
  logs [service]     Follow logs — optionally filter by service name
                       services: backend, mongodb, mongo-express
  status             Show running container status
  shell              Open mongosh inside the mongodb container
  destroy            Remove containers AND data volume (irreversible)
  help               Show this message

Environment:
  PORT               Host port for backend API (default: 8000)

Services & Ports:
  Backend API        http://localhost:\${PORT:-8000}
  API Docs (Swagger) http://localhost:\${PORT:-8000}/docs
  Mongo Express UI   http://localhost:8081

Examples:
  ./run_tool.sh
  ./run_tool.sh start
  ./run_tool.sh logs backend
  ./run_tool.sh logs mongodb
  ./run_tool.sh shell
  ./run_tool.sh stop
  PORT=9000 ./run_tool.sh start
EOF
}

# ── Entry point ───────────────────────────────────────────────────────────────
COMMAND="${1:-start}"

case "$COMMAND" in
  start)   cmd_start   ;;
  stop)    cmd_stop    ;;
  restart) cmd_restart ;;
  build)   cmd_build   ;;
  logs)    cmd_logs "$@" ;;
  status)  cmd_status  ;;
  shell)   cmd_shell   ;;
  destroy) cmd_destroy ;;
  help|--help|-h) cmd_help ;;
  *) err "Unknown command '${COMMAND}'. Run './run_tool.sh help' for usage." ;;
esac
