"""UserPromptSubmit hook: spoken "slash <skill>" -> tell Claude to invoke that skill.

Voice dictation types "Slash caveman commit." as words, so Claude Code never sees
a real /command. Accepts slash / forward slash / backslash / a literal / or \\.
"""
import json
import re
import sys

PATTERN = re.compile(
    r"^\s*(?:forward\s+slash|back\s*slash|slash|/|\\)[\s,.:-]*([A-Za-z][\w :-]*?)[\s.,!?]*$",
    re.IGNORECASE,
)
# Built-in CLI commands: a hook can't run these, only the user typing them can.
BUILTINS = {"clear", "compact", "voice", "model", "exit", "quit", "resume", "config", "cost", "help", "login", "logout"}


def main():
    prompt = json.load(sys.stdin).get("prompt", "")
    m = PATTERN.match(prompt)
    if not m or prompt.lstrip().startswith("/") and " " not in prompt.strip():
        return  # real typed /command already handled natively
    spoken = m.group(1).strip()
    if len(spoken.split()) > 4:
        return  # a sentence that happens to start with "slash", not a command
    first = spoken.split()[0].lower()
    if first in BUILTINS:
        msg = (f'User spoke "slash {spoken}" by voice. /{first} is a built-in CLI command you cannot run; '
               f"tell them in one line to type /{first} (or Ctrl+L to just redraw the screen if it was clear).")
    else:
        msg = (f'User spoke a slash command by voice: "slash {spoken}". Treat it exactly like typing '
               f"/<skill>: pick the skill from the available-skills list whose name best matches "
               f'"{spoken}" (spaces may stand for - or :), and invoke it NOW via the Skill tool before anything else. '
               f"If nothing matches reasonably, list the 3 closest skill names.")
    print(json.dumps({"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": msg}}))


if __name__ == "__main__":
    main()
