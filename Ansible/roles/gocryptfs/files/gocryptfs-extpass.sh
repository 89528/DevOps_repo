#!/bin/bash

if [ -n "$1" ]; then
  echo "$1"
elif [[ -n "${GOCRYPTFS_PASSWORD}" ]]; then
  echo "${GOCRYPTFS_PASSWORD}"
else
  systemd-ask-password "GoCryptFS:"
fi
