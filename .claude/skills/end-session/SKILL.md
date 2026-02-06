---
name: end-session
description: End a coding session and update documentation
user-invocable: true
---

# End Session

Wrap up the current coding session for MathMate.

## Instructions

1. **Run all tests** to verify everything passes:
   ```bash
   flutter test
   ```

2. **Update TODO.md**:
   - Mark completed items with `[x]`
   - Add any new work completed this session
   - Update test counts if changed
   - Set "Notes for Next Session" with priority items

3. **Update lib/docs.md** if needed:
   - Add documentation for any new classes/functions
   - Update test coverage section if test counts changed
   - Update project structure if files were added

4. **Update categories.md** if needed:
   - Update level for any category that progressed (e.g., "Not covered" → "In Progress" → "Medium")
   - Update Details column with new specifics learned
   - Update the detailed category section ("What we did" bullets) if work was done in that area

5. **Provide session summary**:
   - What was accomplished
   - Current test count and status
   - What's next (from TODO.md)

Do NOT make any code changes - only update documentation files.
