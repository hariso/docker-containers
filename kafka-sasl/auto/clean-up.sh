#!/bin/bash
set -euf -o pipefail

cd "$(dirname "$0")/.." || exit

./auto/down.sh

echo "💣  Deleting volumes for a clean slate."

docker rm zk-sasl-data > /dev/null
docker rm zk-sasl-txn-logs > /dev/null
docker rm kafka-sasl-data > /dev/null