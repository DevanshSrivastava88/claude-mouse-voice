# Relaunch claude-mouse-voice.ahk if it died (run every 5 min by Task Scheduler, no window).
# ponytail: checks any AutoHotkey64.exe with this script on its command line; no logging.
import os, subprocess

AHK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "claude-mouse-voice.ahk")
out = subprocess.run(
    ["wmic", "process", "where", "name='AutoHotkey64.exe'", "get", "CommandLine"],
    capture_output=True, text=True, creationflags=0x08000000,
).stdout
if "claude-mouse-voice.ahk" not in out:
    os.startfile(AHK)
