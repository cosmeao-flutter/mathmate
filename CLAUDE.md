# Project Instructions

## CRITICAL: Approval & Communication Rules
- ALWAYS answer user questions BEFORE proceeding with any action
- If a tool call is rejected, STOP and ask the user why — do not retry or work around it
- NEVER push to remote without explicit user confirmation
- When user asks to wait for approval, WAIT — do not proceed until they respond
- If uncertain whether user approved, ask — do not assume approval
- NEVER ignore user feedback on rejected tool calls

## Commit Workflow
- ALWAYS show the proposed commit message and wait for user approval before committing
- NEVER commit without explicit user confirmation
- If user requests changes to the message, incorporate them before committing

## Allowed Commands
- `flutter test`, `flutter analyze`, `flutter doctor` — always OK to run without asking

## General Workflow
- Follow TDD approach: write tests first, then implement
- Run tests after implementation to verify
- Use iOS Simulator for app testing (not macOS or Chrome)

## Code Style
- Follow existing project patterns (Clean Architecture, BLoC/Cubit)
- All constants in `core/constants/`
- Repository pattern for persistence
