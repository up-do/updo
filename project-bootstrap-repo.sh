#!/bin/bash

curl \
  -H 'Accept: application/vnd.github.v3.raw' \
  -sL https://raw.githubusercontent.com/cabalism/updo/refs/heads/trace/commit-url/bootstrap/repo-archive.mk \
  > project-bootstrap.mk

curl \
  -H 'Accept: application/vnd.github.v3.raw' \
  -sL https://raw.githubusercontent.com/cabalism/updo/refs/heads/trace/commit-url/bootstrap/bootstrap.mk \
  >> project-bootstrap.mk
