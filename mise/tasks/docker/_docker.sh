#!/usr/bin/env bash
# Shared docker-compose helpers for the docker:* tasks.
# NOT a task: kept non-executable so mise ignores it. Sourced, never run.
#
# Per-project overrides (set in the project's mise.toml [env]):
#   PROJECT_DOCKER_PHP_SERVICE   - php service name   (default: php)
#   PROJECT_DOCKER_NODE_SERVICE  - node service name  (default: node)
#   PROJECT_DOCKER_COMPOSE_ARGS  - extra compose flags, e.g.
#       "-f compose.override.yaml". Relative paths resolve against the
#       mise.toml dir (we cd there below), so no {{config_root}} needed.

# The dir mise was actually invoked from (e.g. a node app subdir). yarn/npm
# look here for lock files, matching just's invocation_directory(). Must come
# from MISE_ORIGINAL_CWD: tasks have no dir= directive, so $PWD already points
# at the global config root, not where you ran the command.
INVOCATION_DIR="${MISE_ORIGINAL_CWD:-$PWD}"

# Run every task from the project root (the mise.toml dir), so docker
# compose and relative override paths work the same whether invoked from
# the project root or any subdirectory.
# MISE_PROJECT_ROOT = nearest mise.toml up the tree; it falls back to the
# global config root ($HOME) when there is no project config.
cd "${MISE_PROJECT_ROOT:-$PWD}" || exit 1

# True if any of the named files exists in the current dir.
_docker_any() { local f; for f in "$@"; do [ -f "$f" ] && return 0; done; return 1; }

# Guard: these tasks only make sense inside a project that has its own
# mise.toml with a compose file beside it. Bail early with a clear message
# rather than running docker compose in the wrong (or global $HOME) dir.
if ! _docker_any mise.toml .mise.toml mise.local.toml; then
  echo "docker:* tasks: no project mise.toml in $PWD" >&2
  echo "  run these from inside a project that has its own mise.toml" >&2
  exit 1
fi
if ! _docker_any compose.yaml compose.override.yaml; then
  echo "docker:* tasks: no compose.yaml or compose.override.yaml in $PWD" >&2
  echo "  expected a compose file beside the project mise.toml" >&2
  exit 1
fi

# docker compose (v2 plugin) vs legacy docker-compose
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  DOCKER_COMPOSE=(docker compose)
else
  DOCKER_COMPOSE=(docker-compose)
fi

PHP_SERVICE="${PROJECT_DOCKER_PHP_SERVICE:-php}"
NODE_SERVICE="${PROJECT_DOCKER_NODE_SERVICE:-node}"

# Extra compose flags (e.g. "-f foo.yml -p name"); word-split like just did.
read -ra COMPOSE_ARGS <<< "${PROJECT_DOCKER_COMPOSE_ARGS:-}"

# Run docker compose with the configured flags + caller args.
dco() { "${DOCKER_COMPOSE[@]}" "${COMPOSE_ARGS[@]}" "$@"; }
