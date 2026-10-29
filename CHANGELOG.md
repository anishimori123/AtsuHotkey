# Changelog

## 1.1.0 — 2026-10-28 (about 10 minutes)

**What changed**
- Starts with Windows automatically every time it runs (no setting needed).
- Tray menu: "Exit" and "Start with Windows" replaced by one **Stop Hotkey Helper** option. It asks "Are you sure?", removes the app from startup, and quits.
- Help page and README updated to match.

**Why**
- Atsushi wanted it to keep running after a PC restart unless he stops it from the icon.

## 1.0.0 — 2026-10-28 (about 20 minutes)

**What changed**
- First version.
- Alt+N / Alt+E / Alt+C: open, bring to front, or cycle windows of Notepad, Edge and Chrome.
- Alt+1 / 2 / 3: paste text from `templates\1.txt`, `2.txt`, `3.txt`. Your clipboard is restored afterward.
- Alt+Shift+H: help window.
- Tray menu: Help, Edit templates, Open templates folder, Start with Windows, Reload, Exit.

**Why**
- Faster switching between the apps Atsushi uses most, and quick reuse of text he types often.
- Built with AutoHotkey v2 because it is free and made for hotkeys.
