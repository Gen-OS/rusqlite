#!/bin/bash

if [ -z "$GENOS_REPO_TOKEN" ]; then
    echo "GENOS_REPO_TOKEN is not set. Please set it to your GenOS repo token."
    exit 1
fi

# check if the ~/.cargo/config file already contains the token `genos`
if grep -q "genos" ~/.cargo/config; then
    echo "GenOS repo is already set up."
    exit 0
fi

echo "Setting up GenOS repo..."
mkdir -p ~/.cargo
echo "[registries.genos]" >> ~/.cargo/config.toml
echo "token = \"Bearer $GENOS_REPO_TOKEN\"" >> ~/.cargo/config.toml
echo "index = \"sparse+https://genos.jfrog.io/artifactory/api/cargo/genos-cargo-local/index/\"" >> ~/.cargo/config.toml
echo "credential-provider = \"cargo:token\"" >> ~/.cargo/config.toml
