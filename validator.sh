#!/bin/bash

set -e

# Prerequisites:
# 1. golang compiler must be installed and in PATH.
# 2. protoc must be installed.
# 3. Install protoc-gen-go.
go get -d -u github.com/golang/protobuf/protoc-gen-go
go install github.com/golang/protobuf/protoc-gen-go

## Storage ##
pushd storage/v1
# Generate Go files in a tmp directory so they're automatically git-ignored.
# They'll still be compiled.
rm -rf generated
mkdir generated
protoc --go_out=generated test.proto

go build validator.go
./validator .
popd
## End of Storage ##