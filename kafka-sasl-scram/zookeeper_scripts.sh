#!/usr/bin/env bash

docker exec -it zookeeper-1 echo stat | nc localhost 22181 | grep Mode
