#!/bin/bash
set -euf -o pipefail

cd "$(dirname "$0"..)" || exit

docker-compose run --rm --name=kafka-tools-tls kafka-tools-tls "$@"
