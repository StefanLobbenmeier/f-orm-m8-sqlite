# Contributing

## Creating your PR

Before creating a PR, be sure to run the following from the root of the project:
1. `dartfmt -w .`: formats all Dart code throughout the repository.
2. `dartanalyzer lib/`: run static analysis on the project's library code and ensure there are no failures
and warnings. Lints are *okay*, but fixing lint issues is preferrable to leaving them.
3. `dart test/all_tests.dart`: runs all the tests for the project. Make sure all tests pass so the Pull Request can be accepted
