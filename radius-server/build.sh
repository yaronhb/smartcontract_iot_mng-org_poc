#!/bin/bash
docker build --build-arg raddb="raddb-tls" -t my-radius-image -f Dockerfile .
