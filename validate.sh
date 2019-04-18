#!/bin/bash

set -e

# Prerequisites:
# - curl in the path
# - unzip in the path
# - .NET Core SDK installed


# Protobuf installation
# Note: while we could just assume that protoc is in the path, we also
# need the well-known type protos.
rm -rf tmp
mkdir tmp
cd tmp
curl -sSL https://www.nuget.org/api/v2/package/Google.Protobuf.Tools/3.7.0 --output protobuf.zip
unzip -q -d protobuf protobuf.zip
# Work out which protoc binary to run based on platform
case "$OSTYPE" in
  linux*)
    declare -r PROTOC=$PWD/protobuf/tools/linux_x64/protoc
    ;;
  darwin*)
    declare -r PROTOC=$PWD/protobuf/tools/macosx_x64/protoc
    ;;
  win* | msys* | cygwin*)
    declare -r PROTOC=$PWD/protobuf/tools/windows_x64/protoc.exe
    ;;
  *)
    echo "Unknown OSTYPE: $OSTYPE"
    exit 1
esac
chmod +x $PROTOC
cd ..


# Generate C# files in a tmp directory so they're automatically git-ignored.
# They'll still be compiled.
rm -rf storage/v1/validation/tmp
mkdir storage/v1/validation/tmp
$PROTOC -I tmp/protobuf/tools -I storage/v1 --csharp_out=storage/v1/validation/tmp storage/v1/test.proto

dotnet build -v quiet storage/v1/validation
dotnet run -p storage/v1/validation -- storage/v1/*.json
