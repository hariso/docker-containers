#!/bin/bash
set -euf -o pipefail

cd "$(dirname "$0")/.." || exit

./auto/down.sh

echo "💣  Deleting volumes for a clean slate."

docker rm zk-tls-sasl-data > /dev/null
docker rm zk-tls-sasl-txn-logs > /dev/null
docker rm kafka-tls-sasl-data > /dev/null