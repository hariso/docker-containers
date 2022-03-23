#!/usr/bin/env bash

export KAFKA_SASL_SCRAM_SECRETS_DIR=$PWD/secrets
docker-compose up -d
