#!/bin/bash

uv tool install specify-cli --from git+https://github.com/github/spec-kit.git --force
vale sync

echo "Init .env file for environment variables"
if [ ! -f .env ]; then
    cp .env.example .env
    echo ".env file created from .env.example"
  else
    echo ".env file already exists"
fi
