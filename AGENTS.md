# AI Agent Guidelines for procfs_rb

This project is a Ruby GEM designed to provide a programmatic interface for browsing and analyzing the `/proc` filesystem on Linux.

## Project Context
- **Purpose:** Provide an idiomatic Ruby wrapper for Linux procfs.
- **Tech Stack:**
  - Ruby >= 3.2.0
  - Minitest (Testing)
  - RuboCop (Linting/Styling)
  - RBS (Type signatures)
- **Hosting:** Primary development and CI/CD on GitLab; mirrored on GitHub.

## Coding Standards
- **Idiomatic Ruby:** Follow the Ruby Style Guide.
- **Linting:** All code must pass `bundle exec rubocop`.
- **Typing:** Update `.rbs` files in the `sig/` directory when adding new public methods.
- **Error Handling:** Do not swallow exceptions; provide meaningful custom error classes for procfs-specific failures (e.g., missing files in `/proc`).
- **Documentation:** Use YARD style comments for public API methods.

## Testing Requirements
- **Framework:** Minitest.
- **Coverage:** New features must include tests. Run `rake test` to verify.
- **Environment:** Tests expect a Linux environment with a populated `/proc` filesystem.

## Tooling
- `rake test`: Run all tests.
- `bundle exec rubocop`: Run linting.
- `bundle exec reek`: Run code smell analysis.
- `bin/console`: Interactive console for exploration.

## Workflow
- **Branching:** Feature Branch workflow.
- **Commits:** Follow Conventional Commits.
- **Verification:** Always run linting and tests before proposing a change.
