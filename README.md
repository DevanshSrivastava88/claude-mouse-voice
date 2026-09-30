# claude-mouse-voice

Drive [Claude Code](https://code.claude.com)'s `/voice` dictation from your mouse's thumb buttons on Windows — no holding Space.

| Button | Where | Does |
|---|---|---|
| Back thumb (`XButton1`) | Windows Terminal | Click = start dictating. Click again = stop + press Enter |
| Forward thumb (`XButton2`) | Anywhere | 0–1 terminal windows → open a new Claude. 2+ → cycle between them |
| Right-click | Windows Terminal | Paste (Linux-style) |

Back/forward/right-click keep their normal behaviour in every other app.

## Why this works

Claude Code's voice mode is push-to-talk on **Space**. A terminal never sees key *release*, so Claude detects a "hold" from keyboard **auto-repeat**. A naive AutoHotkey remap sends Space down+up taps, which look like typing — hence the claim in [anthropics/claude-code#35411](https://github.com/anthropics/claude-code/issues/35411) that AHK can't trigger it.

The fix is to fake a *real* hold: send `{Space down}` every 30 ms (exactly what auto-repeat does) and a single `{Space up}` at the end.

## Setup

1. Install [AutoHotkey v2](https://www.autohotkey.com/): `winget install AutoHotkey.AutoHotkey`
2. In Claude Code run `/voice` once to enable voice mode (hold mode).
3. Double-click `claude-mouse-voice.ahk`.
4. Autostart: drop a shortcut to it in `shell:startup`.

Not sure which number your side buttons send? Click them on <https://unixpapa.com/js/testmouse.html> — `button=3` is `XButton1`, `button=4` is `XButton2`.

## Notes

- Windows Terminal only (`ahk_exe WindowsTerminal.exe`). Edit the `#HotIf` lines for another terminal.
- If focus leaves the terminal mid-dictation, Space is released automatically — it never sprays spaces into other apps.
- Enter fires the moment you click to stop. If your last word gets clipped, add a short `Sleep 200` before `SubmitPrompt()`.
- Forward-button launch uses `Claude Code.lnk` on your Desktop if present, otherwise `wt.exe claude`. Launches are debounced 10 s so spam-clicking can't stack empty windows.
- Every click is logged to `claude-mouse-voice.log` next to the script.
- Don't launch the script from inside a Claude Code tool shell — it dies with the session. Double-click it or use `explorer.exe claude-mouse-voice.ahk`.
