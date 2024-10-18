#!/bin/bash 

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$HOME/.npm-global/bin/:$HOME/.cargo/bin:$(go env GOPATH)/bin:$PATH