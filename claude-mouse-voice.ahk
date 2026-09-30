#Requires AutoHotkey v2.0
#SingleInstance Force
; XButton1 (back) = click to start Claude Code /voice, click again to stop + press Enter. Windows Terminal only.
;   Fakes a real held key: repeated Space DOWN (like keyboard auto-repeat), one Space UP at the end.
; RButton = paste clipboard. Windows Terminal only.
; MButton (wheel click) = clear prompt (Ctrl+C). Windows Terminal only. 2s cooldown so it can't double-tap-quit Claude.
; XButton2 (forward) = 0-1 terminal windows -> open new Claude via desktop shortcut; 2+ -> cycle them. Global.

global talking := false
LOGFILE := A_ScriptDir "\claude-mouse-voice.log"
LAUNCHER := A_Desktop "\Claude Code.lnk"  ; your own shortcut if you have one, else falls back to `wt claude`

#HotIf WinActive("ahk_exe WindowsTerminal.exe")
XButton1::ToggleTalk()
RButton::Send "^v"  ; Linux-style right-click paste (Claude's TUI swallows WT's native right-click)
MButton::ClearPrompt()
#HotIf
XButton2::NextClaude()  ; global: works from any app

ToggleTalk() {
    global talking := !talking
    Log(talking ? "start" : "stop")
    if talking {
        SetTimer(HoldSpace, 30)
    } else {
        SetTimer(HoldSpace, 0)
        Send "{Space up}"
        SubmitPrompt()  ; user times the 2nd click themselves -> send right away
    }
}

HoldSpace() {
    global talking
    if !WinActive("ahk_exe WindowsTerminal.exe") {  ; focus left the terminal -> release, don't spray spaces elsewhere
        talking := false
        SetTimer(HoldSpace, 0)
        Send "{Space up}"
        Log("focus lost, released")
        return
    }
    Send "{Space down}"
}

SubmitPrompt() {
    if WinActive("ahk_exe WindowsTerminal.exe") {  ; never fire Enter into another app
        Send "{Enter}"
        Log("enter")
    }
}

ClearPrompt() {
    static last := 0
    if A_TickCount - last < 2000  ; Ctrl+C twice on an empty box quits Claude -> swallow fast repeats
        return
    last := A_TickCount
    Send "^c"
    Log("clear")
}

NextClaude() {
    static lastLaunch := 0
    wins := WinGetList("ahk_exe WindowsTerminal.exe")  ; z-order, top first
    if wins.Length > 1 {
        active := WinExist("A")
        target := 0
        for hwnd in wins
            if hwnd != active
                target := hwnd  ; ends on the bottom-most one -> repeated clicks rotate through all
        WinActivate(target)
        Log("cycle")
    } else if A_TickCount - lastLaunch > 10000 {  ; 0-1 windows -> open a new one; debounce so spam can't stack empties
        lastLaunch := A_TickCount
        Run(FileExist(LAUNCHER) ? LAUNCHER : "wt.exe claude")
        Log("launch")
    }
}

Log(msg) {
    FileAppend(FormatTime(, "HH:mm:ss") " " msg "`n", LOGFILE)
}
