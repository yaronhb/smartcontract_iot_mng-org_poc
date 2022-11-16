#!/bin/bash
docker run --rm -d --name my-radius -p 1812-1813:1812-1813/udp my-radius-image -X
