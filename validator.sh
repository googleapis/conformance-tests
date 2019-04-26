#!/bin/bash

set -e

# Prerequisites:
# 1. golang compiler must be installed.
# 2. protoc must be installed.
# 3. protoc-gen-go must be installed.

# Generate Go files in a tmp directory so they're automatically git-ignored.
# They'll still be compiled.
rm -rf storage/v1/generated
mkdir -p storage/v1/generated
protoc --go_out=storage/v1/generated storage/v1/test.proto

go build storage/v1/validator.go
./validator .
