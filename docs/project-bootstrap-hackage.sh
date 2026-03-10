#!/bin/bash

curl \
  -H 'Accept: application/vnd.github.v3.raw' \
  -sL https://raw.githubusercontent.com/cabalism/updo/refs/heads/main/bootstrap/hackage.mk \
  > project-bootstrap.mk

curl \
  -H 'Accept: application/vnd.github.v3.raw' \
  -sL https://raw.githubusercontent.com/cabalism/updo/refs/heads/main/bootstrap/bootstrap.mk \
  >> project-bootstrap.mk
