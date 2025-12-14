set allow-duplicate-recipes := true
set allow-duplicate-variables := true
set positional-arguments := true

docker_compose := if `command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1 && echo "true" || echo "false"` == "true" { "docker compose" } else { "docker-compose" }
php_service := env("PROJECT_DOCKER_PHP_SERVICE", "php")
node_service := env("PROJECT_DOCKER_NODE_SERVICE", "node")
compose_args := env("PROJECT_DOCKER_COMPOSE_ARGS", "")
[private]
_compose_args := if compose_args != "" { compose_args + " " } else { "" }

# Print available recipes
[default]
help:
    @just --list

# Run docker compose
dc *args:
    {{ docker_compose }} {{ _compose_args }}{{ args }}

# Up
up *args:
    TERM=xterm-256color {{ docker_compose }} {{ _compose_args }}up {{ args }} || true

# Down
down *args:
    {{ docker_compose }} {{ _compose_args }}down {{ args }}

# Start
start *args:
    {{ docker_compose }} {{ _compose_args }}start {{ args }}

# Stop
stop *args:
    {{ docker_compose }} {{ _compose_args }}stop {{ args }}

# Restart
restart *args:
    {{ docker_compose }} {{ _compose_args }}stop -t 2 {{ args }}
    {{ docker_compose }} {{ _compose_args }}start {{ args }}

# Logs
logs *args:
    {{ docker_compose }} {{ _compose_args }}logs {{ args }}

# Exec
exec *args:
    #!/usr/bin/env bash
    if [ $# -eq 0 ]; then
        if ! {{ docker_compose }} {{ _compose_args }}ps -q 2>/dev/null | grep -q .; then
            echo "No services are currently running"
        else
            echo "Available services:"
            {{ docker_compose }} {{ _compose_args }}ps --services
        fi
    else
        {{ docker_compose }} {{ _compose_args }}exec "$@"
    fi

# PS
ps *args:
    {{ docker_compose }} {{ _compose_args }}ps {{ args }}

# Yarn
yarn *args:
    #!/usr/bin/env bash
    cd "{{ invocation_directory() }}"

    if [ ! -f "yarn.lock" ]; then
        echo "Error: yarn.lock not found"
        exit 1
    fi

    cd "{{ justfile_directory() }}"

    export YARN_CACHE_FOLDER="${YARN_CACHE_FOLDER:-$XDG_CACHE_HOME/yarn}"

    {{ docker_compose }} {{ _compose_args }}run --rm --no-deps \
      -e YARN_CACHE_FOLDER \
      -v "$YARN_CACHE_FOLDER:$YARN_CACHE_FOLDER" \
      {{ node_service }} yarn "$@"

# NPM
npm *args:
    #!/usr/bin/env bash
    cd "{{ invocation_directory() }}"

    if [ ! -f "package-lock.json" ]; then
        echo "Error: package-lock.json not found"
        exit 1
    fi

    cd "{{ justfile_directory() }}"

    export npm_config_cache="${npm_config_cache:-$XDG_CACHE_HOME/npm}"

    {{ docker_compose }} {{ _compose_args }}run --rm --no-deps \
      -e npm_config_cache \
      -v "$npm_config_cache:$npm_config_cache" \
      {{ node_service }} npm "$@"

# Composer
composer *args:
    #!/usr/bin/env bash
    export COMPOSER_HOME="${COMPOSER_HOME:-$XDG_CONFIG_HOME/composer}"
    export COMPOSER_CACHE_DIR="${COMPOSER_CACHE_DIR:-$XDG_CACHE_HOME/composer}"

    {{ docker_compose }} {{ _compose_args }}run --rm --no-deps \
      --env COMPOSER_HOME \
      --env COMPOSER_CACHE_DIR \
      -v "$COMPOSER_HOME":"$COMPOSER_HOME" \
      -v "$COMPOSER_CACHE_DIR":"$COMPOSER_CACHE_DIR" \
      {{ php_service }} \
      composer "$@"
