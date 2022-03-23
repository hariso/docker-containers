#!/bin/bash
set -euf -o pipefail

cd "$(dirname "$0")/.." || exit

./auto/down.sh

echo "💣  Deleting volumes for a clean slate."

docker volume rm zk-sasl-scram-data > /dev/null
docker volume rm zk-sasl-scram-txn-logs > /dev/null
docker volume rm kafka-sasl-scram-data > /dev/null