# Project Instructions

## Commit Workflow
- ALWAYS show the proposed commit message and wait for user approval before committing
- NEVER commit without explicit user confirmation
- If user requests changes to the message, incorporate them before committing

## General Workflow
- Follow TDD approach: write tests first, then implement
- Run tests after implementation to verify
- Use iOS Simulator for app testing (not macOS or Chrome)

## Code Style
- Follow existing project patterns (Clean Architecture, BLoC/Cubit)
- All constants in `core/constants/`
- Repository pattern for persistence
