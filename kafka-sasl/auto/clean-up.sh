#!/bin/bash
set -euf -o pipefail

cd "$(dirname "$0")/.." || exit

./auto/down.sh

echo "💣  Deleting volumes for a clean slate."

docker volume rm zk-sasl-data > /dev/null
docker volume rm zk-sasl-txn-logs > /dev/null
docker volume rm kafka-sasl-data > /dev/null
