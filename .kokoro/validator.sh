#!/bin/bash
# Copyright 2019, Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

# cd github/conformance-tests

# Prerequisites:
# 1. golang compiler must be installed and in PATH.
# 2. protoc must be installed.

# Install protoc-gen-go.
go get -d -u github.com/golang/protobuf/protoc-gen-go
go install github.com/golang/protobuf/protoc-gen-go

# Clone googleapis (head of master) into /tmp so that tests can refer
# to production protos
pushd ${TMP:-/tmp}
rm -rf googleapis || true
git clone https://github.com/googleapis/googleapis.git --depth 1
declare -r googleapis=${TMP:-/tmp}/googleapis
popd

function storage() {
  pushd storage/v1
  # Generate Go files in a tmp directory so they're automatically git-ignored.
  # They'll still be compiled.
  rm -rf generated
  mkdir generated
  protoc \
    -I /go/include \
    -I proto \
    --go_out=generated \
    google/cloud/conformance/storage/v1/tests.proto

  go build validator.go
  ./validator .
  popd
}


function firestore() {

  go get google.golang.org/genproto/...

  pushd firestore/v1
  # Generate Go files in a tmp directory so they're automatically git-ignored.
  # They'll still be compiled.
  rm -rf generated
  mkdir generated

  protoc \
    -I /go/include \
    -I $googleapis \
    -I proto \
    --go_out=generated \
    google/cloud/conformance/firestore/v1/tests.proto

  go build validator.go
  ./validator .
  popd
}

function bigtable() {
  pushd bigtable/v2
  # Generate Go files in a tmp directory so they're automatically git-ignored.
  # They'll still be compiled.
  rm -rf generated
  mkdir generated
  protoc \
    -I /go/include \
    -I $googleapis \
    -I proto \
    --go_out=generated \
    google/cloud/conformance/bigtable/v2/tests.proto

  go build validator.go
  ./validator .
  popd
}

function main() {
  storage
  firestore
  bigtable
}

main
