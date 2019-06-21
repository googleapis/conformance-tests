# Cross-Language Tests for Google Firestore Clients

A common set of test cases to verify behavior of Firestore Clients.

- `proto`: the protobuffers defining the test format.

- `testcase`: the tests.
   - `*.json`: a single test in json serialized format, the schema of the json matches that of the 
     proto definition in `proto`.
