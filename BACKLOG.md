# BACKLOG

- [ ] Scroll wheel sometimes drops text into the Claude prompt — probably wheel → ↑/↓ arrows recalling old prompts. Confirm what the text is before fixing.
- [x] Middle-click (Ctrl+C) verified live 2026-10-01 — stops answer / clears prompt.
- [ ] Measure start gap (click -> /voice recording live) with `claude --debug`; only tune HoldSpace if the gap is ours.
- [ ] Note in README: dropouts mid-dictation = Claude bug anthropics/claude-code #96440, not the script.
- [ ] If last dictated word gets clipped on send, add `Sleep 200` before `SubmitPrompt()`.
- [ ] Optional: share on r/ClaudeAI / open a new anthropics/claude-code issue (#35411, #34305 are locked).
