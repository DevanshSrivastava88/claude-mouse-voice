# BACKLOG

- [x] Scroll wheel drops text into the Claude prompt — SOLVED 2026-10-02: not the script. `"tui": "fullscreen"` in `~/.claude/settings.json` made Windows Terminal send wheel as ↑/↓ (prompt history). Removed the setting.
- [ ] Wheel scroll "glitching" in normal (non-fullscreen) mode, reported 2026-10-12. Not the script. Ask devansh: idle vs while spinner runs? jump/flicker/slow? Then fix WT or Claude side.
- [x] Launcher runs `claude --chrome` (shortcut + fallback) — 2026-10-12
- [x] Middle-click (Ctrl+C) verified live 2026-10-01 — stops answer / clears prompt.
- [ ] Measure start gap (click -> /voice recording live) with `claude --debug`; only tune HoldSpace if the gap is ours.
- [ ] (README synced to script 2026-10-15, `245ce3f`) Note in README: dropouts mid-dictation = Claude bug anthropics/claude-code #96440, not the script.
- [ ] If last dictated word gets clipped on send, add `Sleep 200` before `SubmitPrompt()`.
- [ ] Optional: share on r/ClaudeAI / open a new anthropics/claude-code issue (#35411, #34305 are locked).

- [ ] 2026-10-13: back thumb typed spaces = Claude voice got switched OFF in ~/.claude/settings.json (voice.enabled + voiceEnabled false). Flipped on. If it recurs, find what flips it (likely `/voice` toggle persists off).
- [ ] Optional: script checks settings.json voice flag on start, beeps if off
