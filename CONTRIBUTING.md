# Contributing to procfs_rb

Thank you for contributing to `procfs_rb`! This gem provides a Ruby interface to the Linux `/proc` filesystem.

## Development Workflow

### 1. Setup
Ensure you are on a Linux system. Install dependencies:
```bash
bundle install
```

### 2. Feature Branching
We use a feature branch workflow. Please create a new branch for every change:
- `feat/description` for new features.
- `fix/description` for bug fixes.
- `docs/description` for documentation updates.

### 3. Coding Standards
- **Style:** We use RuboCop for linting. Run `bundle exec rubocop` to check your code.
- **Types:** We use RBS for type signatures. Please update `sig/procfs_rb.rbs` accordingly.
- **Commits:** We follow [Conventional Commits](https://www.conventionalcommits.org/). 
  - Example: `feat: add memory info parsing` or `fix: resolve nil value in cpu_stats`

### 4. Testing
All contributions must include tests.
- Run tests using: `rake test`
- Ensure that your changes do not decrease test coverage.

### 5. Submission
1. Push your branch to GitLab.
2. Create a Merge Request (MR) on GitLab (the primary repository).
3. Provide a clear description of the change and the motivation behind it.

## Repository Structure
- `lib/`: Core logic.
- `sig/`: RBS type signatures.
- `test/`: Minitest suite.
- `bin/`: Helper scripts.
