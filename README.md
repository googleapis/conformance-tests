# Google APIs Conformance Tests

This repository is used to host a collection of conformance tests
for Google API client libraries. Conformance tests are mainly used by
Google APIs Github Organization repositories for language client libraries.

## Conformance Test Specification

While some per-API, per-language work will always be required for
consuming the conformance tests, this can be minimized by each
API abiding by the same conventions:

- Each API's tests are entirely within a directory of the form
`{api-name}/{api-version}`. Example: [storage/v1](https://github.com/googleapis/conformance-tests/blob/main/storage/v1)
- A .proto file specifies the format of the test cases. Example:
[Firestore tests](https://github.com/googleapis/conformance-tests/blob/main/firestore/v1/proto/google/cloud/conformance/firestore/v1/tests.proto)
- Test cases are specified as a set of inputs and expected outputs, and are
defined in .json files. Example: [Firestore test case](https://github.com/googleapis/conformance-tests/blob/main/firestore/v1/testcase/create-nosplit.json)

### Proto conventions

The test protos should live in a subdirectory hierarchy beginning
with `proto` within the API-specific directory. Further
subdirectories should reflect the proto package name of the tests,
which should start with `google.cloud.conformance` and reflect the
API name and version. For example, the Firestore v1 test protos are
in the `google.cloud.conformance.firestore.v1` proto package, and
are in a directory of
[firestore/v1/proto/google/cloud/conformance/firestore/v1](https://github.com/googleapis/conformance-tests/tree/main/firestore/v1/proto/google/cloud/conformance/firestore/v1).

Note: while the directory structure here ends up being very deep, it
means we follow the proto convention, which makes importing protos
from each other simpler.

The test protos may refer to protos within the production API. There
is no versioning applied to these imports; it's assumed that it's
always sufficient to take the head of the main branch in
https://github.com/googleapis/googleapis.

Each API should have a `TestFile` message containing repeated fields
of specific test types, such as `ReadTest` and `WriteTest`. This
allows for extensibility as further tests are developed.

Each specific test message should have a `description` field of type
`string`. When running tests, these should be used as reported test names.

### JSON conventions

Each JSON file in the API directory should be the JSON
representation of a `TestFile` message. Conceptually, each JSON file
is parsed as a `TestFile`, then all the `TestFile` messages are
merged together to form a single `TestFile` containing all the tests.

This provides flexibility for the test author, in terms of how the
tests are spread across files. Strategies include:

- One JSON file per test
- One JSON file per feature
- One single JSON file for all tests

This approach still leaves consumers in a simple situation:

- Common code can be written to read all files to produce a complete
test suite
- Each file can be validated as a `TestFile`, making the validation code
simple

Each test should have a populated `description` field with a value
which is unique within that API.

### Validator

Each set of tests should come with a validator to ensure that the
JSON files conform with the proto specification. The validator
should be written in Go in the API-specific directory, in a file
called `validator.go`. This should be invoked from the
[.kokoro/validator.sh](https://github.com/googleapis/conformance-tests/tree/main/.kokoro/validator.sh)
script which is executed as part of continuous integration.

In most cases you don't need to know Go in order to write a
validator: simply copy an existing validator and edit it to reflect
the name and version of the API you're writing tests for.

## Consuming tests

Conformance test runners must be implemented per language, per client (for
clients that have conformance tests defined here). These runners must do the
minimal work to translate a conformance test specified here into a testcase
that inputs the given input data and asserts based on the given assertion.

Generally, conformance tests are accessed as [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
in the repositories. However, copy-pasting the tests may also be a reasonable
approach, though it is prone to scalability and maintainability issues.
