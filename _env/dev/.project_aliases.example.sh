#!/bin/bash

# =================================================================
# Docker & Application Aliases
# =================================================================
DOCKER_NETWORK_NAME="vortex_vortex-network"

alias pa="docker exec -it vortex-api"
alias pa.logs="docker compose logs -f vortex-api"
alias pa.up="docker compose up -d"
alias pa.shell="pa sh"
alias pa.stats="docker compose stats"
alias pa.aliases="cat .project_aliases.sh"

# =================================================================
# PHP Tooling Aliases
# =================================================================
alias pa.php="pa php"
alias pa.composer="pa composer"
alias pa.lint="pa.composer lint"
alias pa.check="pa.composer analyze"
alias pa.test="pa.composer test"
alias pa.test-w="pa.composer test:watch"
alias pa.test-cover="pa.composer test:coverage"

# =================================================================
# Goose Migration Aliases
# =================================================================
alias pa.goose="g goose"
alias pa.migration="gs up"
alias pa.m-down="gs down"
alias pa.m-reset="gs reset"
alias pa.m-create="gs create"

# =================================================================
# NATS Tooling Aliases
# =================================================================
alias gnats-box="docker run -it --rm --network ${DOCKER_NETWORK_NAME} natsio/nats-box"

gnats-get() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: gnats-get <stream_name> <sequence_id>"
    return 1
  fi
  docker run --rm --network ${DOCKER_NETWORK_NAME} natsio/nats-box \
    nats stream get "$1" "$2" -s nats://nats-0:4222
}

gnats-last() {
  if [ -z "$1" ]; then
    echo "Usage: gnats-last <stream_name> [number_of_messages]"
    return 1
  fi
  local stream_name=$1
  local count=${2:-1}
  local info_output=$(docker run --rm --network ${DOCKER_NETWORK_NAME} natsio/nats-box nats stream info "$stream_name" --json -s nats://nats-0:4222 2>/dev/null)
  if [ -z "$info_output" ]; then
    echo "Error: Could not get info for stream '$stream_name'."
    return 1
  fi
  local last_seq=$(echo "$info_output" | grep -o '"last_seq": *[0-9]*' | awk '{print $2}')
  if [ -z "$last_seq" ] || [ "$last_seq" -eq 0 ]; then
    echo "Stream '$stream_name' is empty."
    return 0
  fi
  local start_seq=$((last_seq - count + 1))
  if [ "$start_seq" -lt 1 ]; then
    start_seq=1
  fi
  echo "--> Fetching last $count message(s) from stream '$stream_name' (sequences $last_seq down to $start_seq)..."
  local script=""
  for i in $(seq "$last_seq" -1 "$start_seq"); do
    script+="nats stream get '$stream_name' '$i' -s nats://nats-0:4222;"
    if [ "$i" -ne "$start_seq" ]; then
      script+="echo '--------------------------------------------------';"
    fi
  done
  docker run -it --rm --network ${DOCKER_NETWORK_NAME} /bin/sh -c "$script"
}

gnats-purge() {
    if [ -z "$1" ]; then
        echo "Usage: gnats-purge <stream_name>"
        return 1
    fi
    echo "--> Purging all messages from stream '$1'..."
    docker run --rm --network ${DOCKER_NETWORK_NAME} natsio/nats-box \
        nats stream purge "$1" -f -s nats://nats-0:4222
}

gnats-consumer() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: gnats-consumer <stream_name> <consumer_name>"
        return 1
    fi
    echo "--> Getting info for consumer '$2' on stream '$1'..."
    docker run -it --rm --network ${DOCKER_NETWORK_NAME} natsio/nats-box \
        nats consumer info "$1" "$2" -s nats://nats-0:4222
}
