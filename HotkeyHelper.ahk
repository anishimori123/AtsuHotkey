; ==============================================================
;  Hotkey Helper  -  version 1.2.0
;  Made with AutoHotkey v2 (free): https://www.autohotkey.com
;
;  Alt+N        Notepad  (open / bring to front / cycle windows)
;  Alt+E        Edge     (open / bring to front / cycle windows)
;  Alt+C        Chrome   (open / bring to front / cycle windows)
;  Alt+Z        Claude desktop app (open / bring to front / cycle windows)
;  Alt+1/2/3    Paste the text saved in templates\1.txt, 2.txt, 3.txt
;  Alt+Shift+H  Show the help page
;
;  Starts with Windows automatically. Right-click the tray icon >
;  "Stop Hotkey Helper" to turn it off (it will not come back after
;  a restart until you double-click this file again).
; ==============================================================

#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

global AppTitle    := "Hotkey Helper"
global TemplateDir := A_ScriptDir "\templates"
global StartupLink := A_Startup "\Hotkey Helper.lnk"

SetupTemplates()
EnableStartup()
SetupTrayMenu()
TrayTip("Running. Press Alt+Shift+H for help.", AppTitle)


; ---------------- Hotkeys ----------------

!n:: CycleApp("notepad.exe", "notepad.exe")
!e:: CycleApp("msedge.exe",  "msedge.exe")
!c:: CycleApp("chrome.exe",  "chrome.exe")
!z:: CycleApp("claude.exe",  ClaudeLaunchCmd())

!1:: PasteTemplate(1)
!2:: PasteTemplate(2)
!3:: PasteTemplate(3)

!+h:: ShowHelp()


; ---------------- Window cycling ----------------

; Press once  -> bring the app to the front (or open it if it is not running).
; Press again -> jump to the next window of the same app, in a loop.
CycleApp(exe, runCmd) {
    wins := GetAppWindows(exe)     ; newest-used window first

    if (wins.Length = 0) {
        try {
            Run(runCmd)
        } catch {
            MsgBox("Could not start " exe ".`nIs it installed on this PC?", AppTitle, "Icon!")
        }
        return
    }

    ; A fixed order (sorted by window ID) so cycling visits every window.
    fixed := SortNumbers(wins.Clone())
    active := WinExist("A")

    pos := 0
    for i, id in fixed {
        if (id = active) {
            pos := i
            break
        }
    }

    if (pos = 0)
        target := wins[1]                                 ; app not in front: show the last one used
    else
        target := fixed[Mod(pos, fixed.Length) + 1]       ; app in front: go to the next one

    ActivateWindow(target)
}

GetAppWindows(exe) {
    result := []
    for id in WinGetList("ahk_exe " exe) {
        if IsRealWindow(id)
            result.Push(id)
    }
    return result
}

; Skip invisible helper windows that browsers keep in the background.
IsRealWindow(id) {
    try {
        if (WinGetTitle(id) = "")
            return false
        if !(WinGetStyle(id) & 0x10000000)      ; WS_VISIBLE
            return false
        if (WinGetExStyle(id) & 0x80)           ; WS_EX_TOOLWINDOW
            return false
        return true
    } catch {
        return false
    }
}

ActivateWindow(id) {
    try {
        if (WinGetMinMax(id) = -1)              ; minimized
            WinRestore(id)
        WinActivate(id)
    }
}

; Find how to start the Claude desktop app on this PC.
; (It also brings Claude back if it is hiding in the tray near the clock.)
ClaudeLaunchCmd() {
    paths := [
        EnvGet("LOCALAPPDATA") "\AnthropicClaude\claude.exe",
        EnvGet("LOCALAPPDATA") "\Programs\Claude\Claude.exe",
        EnvGet("ProgramFiles") "\Claude\Claude.exe",
        A_Programs "\Claude.lnk",
        A_Programs "\Anthropic\Claude.lnk",
        A_ProgramsCommon "\Claude.lnk"
    ]
    for path in paths {
        if FileExist(path)
            return path
    }
    return "claude.exe"     ; last try: let Windows look for it
}

SortNumbers(arr) {
    loop arr.Length - 1 {
        i := A_Index + 1
        val := arr[i]
        j := i - 1
        while (j >= 1 && arr[j] > val) {
            arr[j + 1] := arr[j]
            j--
        }
        arr[j + 1] := val
    }
    return arr
}


; ---------------- Templates ----------------

SetupTemplates() {
    if !DirExist(TemplateDir)
        DirCreate(TemplateDir)
    loop 3 {
        file := TemplateDir "\" A_Index ".txt"
        if !FileExist(file)
            FileAppend("This is template " A_Index ". Right-click the tray icon > Edit template " A_Index " to change me.", file, "UTF-8")
    }
}

PasteTemplate(n) {
    file := TemplateDir "\" n ".txt"
    if !FileExist(file) {
        TrayTip(n ".txt was not found.", AppTitle)
        return
    }
    text := FileRead(file, "UTF-8")
    if (text = "") {
        TrayTip(n ".txt is empty. Nothing to paste.", AppTitle)
        return
    }

    saved := ClipboardAll()     ; remember what you had copied
    A_Clipboard := ""
    A_Clipboard := text
    if !ClipWait(1) {
        A_Clipboard := saved
        TrayTip("Could not use the clipboard. Try again.", AppTitle)
        return
    }
    Send("^v")
    Sleep(300)                  ; give the app time to paste
    A_Clipboard := saved        ; put your old clipboard back
}

EditTemplate(n) {
    SetupTemplates()
    Run('notepad.exe "' TemplateDir "\" n '.txt"')
}


; ---------------- Tray menu (icon near the clock) ----------------

SetupTrayMenu() {
    A_IconTip := AppTitle " - Alt+Shift+H for help"
    tray := A_TrayMenu
    tray.Delete()
    tray.Add("Help  (Alt+Shift+H)", ShowHelp)
    tray.Add()
    tray.Add("Edit template 1", (*) => EditTemplate(1))
    tray.Add("Edit template 2", (*) => EditTemplate(2))
    tray.Add("Edit template 3", (*) => EditTemplate(3))
    tray.Add("Open templates folder", (*) => Run(TemplateDir))
    tray.Add()
    tray.Add("Reload", (*) => Reload())
    tray.Add("Stop Hotkey Helper", StopApp)
    tray.Default := "Help  (Alt+Shift+H)"
}

; Running = ON: make sure Windows starts it again after a restart.
EnableStartup() {
    try FileCreateShortcut(A_ScriptFullPath, StartupLink, A_ScriptDir, , AppTitle)
}

; Stop = OFF: remove from startup and quit. Double-click the .ahk file to turn it back on.
StopApp(*) {
    answer := MsgBox("Stop Hotkey Helper?`n`nAll hotkeys turn off, and it will NOT start again when the PC restarts.`nTo turn it back on later, double-click HotkeyHelper.ahk.", AppTitle, "YesNo Icon?")
    if (answer != "Yes")
        return
    try FileDelete(StartupLink)
    ExitApp()
}


; ---------------- Help page ----------------

ShowHelp(*) {
    static helpGui := 0
    if helpGui {
        helpGui.Show()
        return
    }

    helpGui := Gui("+AlwaysOnTop", AppTitle " - Help")
    helpGui.SetFont("s11", "Segoe UI")
    helpGui.AddText("w560", HelpText())
    btn := helpGui.AddButton("w100 Default", "Close")
    btn.OnEvent("Click", (*) => helpGui.Hide())
    helpGui.OnEvent("Escape", (*) => helpGui.Hide())
    helpGui.Show()
}

HelpText() {
    return "
    (
SWITCH APPS
  Alt + N   Notepad
  Alt + E   Microsoft Edge
  Alt + C   Google Chrome
  Alt + Z   Claude desktop app

  - Not open yet?  It opens.
  - Hidden behind other windows or minimized?  It comes to the front.
  - Several windows open?  Keep pressing to jump to the next one.
    Stop when you see the one you want.
  (It switches WINDOWS, not the tabs inside one window.)

PASTE TEMPLATES
  Alt + 1   Paste the text from 1.txt
  Alt + 2   Paste the text from 2.txt
  Alt + 3   Paste the text from 3.txt

  To change a template:
  1. Right-click the green "H" icon near the clock.
  2. Click "Edit template 1" (or 2, or 3).
  3. Type your text, then press Ctrl + S to save.
  The next Alt + 1 pastes the new text right away.
  Your normal copied text is kept safe and put back after pasting.

HELP
  Alt + Shift + H   Show this page.  Press Esc to close it.

TRAY ICON (green "H" near the clock, right-click it)
  Reload              -  restart Hotkey Helper.
  Stop Hotkey Helper  -  turn everything off.  It stays off, even
                         after a restart, until you double-click
                         HotkeyHelper.ahk again.

STARTS BY ITSELF
  While it is on, Hotkey Helper starts automatically every time
  the PC starts.  You don't need to do anything.

NOTE
  While Hotkey Helper runs, these Alt shortcuts replace the same
  shortcuts inside other apps.  Choose Stop to get them back.
    )"
}
