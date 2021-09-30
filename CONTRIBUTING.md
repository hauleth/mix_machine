# Contributing guidelines

## Commit messages

Commits in **MUST** follow [Conventional Commits][conv-commits] with these
values used as a `type` field:

- `ft` (not `feat`) for features
- `fix` for bug fixes
- `docs` for documentation changes
- `test` for expanding test suite
- `chore` for rest of maintenance tasks like CI changes

Scope **MUST** be omitted.

Subject **SHOULD** start with lowercase, but that is not strictly enforced.

Example of good commit message

```
ft: add formatter for Foo

Foo is format used by service XYZ

Close #42
```

PRs not conforming to that template will be automatically marked as
[`invalid/commit-messages`][inv-cm].

## Code style

Your code **MUST** be formatted with `mix format`. PRs containing non-conforming
code will be automatically marked as [`invalid/format`][inv-format].

Your code **MUST** pass `mix credo` check. PRs that will fail such test will be
automatically marked as [`invalid/credo`][inv-credo].

[conv-commits]: https://www.conventionalcommits.org/en/v1.0.0/
[inv-cm]: https://github.com/hauleth/mix_machine/labels/invalid%2Fcommit-messages
[inv-format]: https://github.com/hauleth/mix_machine/labels/invalid%2Fformat
[inv-credo]: https://github.com/hauleth/mix_machine/labels/invalid%2Fcredo
