# Hotkey Helper (Windows 10)

A small free app that runs quietly near the clock and gives you shortcuts:

| Keys | What happens |
|---|---|
| Alt + N | Notepad: open it, bring it to the front, or press again to cycle windows |
| Alt + E | Microsoft Edge: same idea |
| Alt + C | Google Chrome: same idea |
| Alt + Z | Claude desktop app: same idea |
| Alt + 1 / 2 / 3 | Paste the text saved in `templates\1.txt`, `2.txt`, `3.txt` |
| Alt + Shift + H | Show the help page |

Cost: **free**. It uses AutoHotkey v2, a free program.

---

## Install (one time, about 5 minutes)

### Step 1 – Install AutoHotkey v2
1. Open your browser and go to **https://www.autohotkey.com**
2. Click the big **Download** button, then choose **Download v2.0**.
   (Pick **v2**, not v1. This script only works with v2.)
3. Open the file you downloaded (it's in your **Downloads** folder).
4. If Windows asks "Do you want to allow this app to make changes?", click **Yes**.
5. Click **Install**. When it finishes, close the window.

**Success looks like:** the installer says it's done. Nothing else happens yet, and that's normal.

### Step 2 – Put the app folder somewhere safe
1. Unzip `HotkeyHelper.zip` (right-click it, choose **Extract All…**, then click **Extract**).
2. Move the `HotkeyHelper` folder to your **Documents** folder.
   (Keep `HotkeyHelper.ahk` and the `templates` folder together.)

### Step 3 – Start it
1. Open the `HotkeyHelper` folder.
2. Double-click **HotkeyHelper.ahk**.

**Success looks like:** a small green **H** icon appears near the clock (bottom-right) and a little message says "Running. Press Alt+Shift+H for help."
If you don't see the icon, click the small **^** arrow next to the clock. Hidden icons live there.

### Step 4 – Nothing! It starts by itself
From now on, Hotkey Helper starts automatically every time your PC starts.
**Success looks like:** after a restart, the green **H** icon is back near the clock without you doing anything.

---

## Change your templates
1. Right-click the green **H** icon.
2. Click **Edit template 1** (or 2, or 3). Notepad opens.
3. Type your text and press **Ctrl + S** to save.
4. Click anywhere you can type and press **Alt + 1**. Your text appears.

## Turn it off
1. Right-click the green **H** icon.
2. Click **Stop Hotkey Helper**, then click **Yes**.

It stays off, even after a restart.
To turn it back on, double-click **HotkeyHelper.ahk** again. It will start with Windows again from then on.

---

## Good to know
- **Cycling switches windows, not tabs.** Three Chrome windows means Alt+C rotates through all three. Tabs inside one window are not cycled.
- **Alt shortcuts take over.** While this runs, Alt+N / E / C / 1 / 2 / 3 do *our* actions in every app. Click **Stop Hotkey Helper** to get the original shortcuts back.
- **"Run as administrator" apps:** pasting and switching may not work in apps opened as administrator. This is a Windows safety rule.
- **Claude app:** Alt+Z needs the Claude desktop app installed (free download at https://claude.ai/download). If Claude is hiding in the tray near the clock, Alt+Z brings it back.
- **Moving the folder?** Stop Hotkey Helper first, move the folder, then double-click `HotkeyHelper.ahk` in its new place. That updates the startup link.
- **Templates are plain text** saved as UTF-8, so Japanese text works.

## Files
```
HotkeyHelper\
  HotkeyHelper.ahk   <- the app (double-click to run)
  templates\1.txt    <- template for Alt+1
  templates\2.txt    <- template for Alt+2
  templates\3.txt    <- template for Alt+3
  README.md          <- this file
  CHANGELOG.md       <- history of changes
```
