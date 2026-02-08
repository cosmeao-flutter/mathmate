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

## Search Scope Rules
- NEVER search from root (`/`) or broad system paths
- Limit Glob, Grep, and Bash search commands to these directories:
  - **Project directory** — primary search scope for all code tasks
  - **`~/.pub-cache/hosted/pub.dev/`** — only when inspecting dependency source code
  - **`~/.claude/`** — memory files, plans, project settings
  - **Flutter SDK path** — only when checking framework source (find via `which flutter`)
- If you need to inspect a package, go directly to `~/.pub-cache/hosted/pub.dev/<package-name>-<version>/`
- Prefer Glob/Grep tools over Bash `find`/`grep` commands

## Code Style
- Follow existing project patterns (Clean Architecture, BLoC/Cubit)
- All constants in `core/constants/`
- Repository pattern for persistence
