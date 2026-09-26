# Super Mario — 6 Stages

A single-file retro Mario platform game. Runs at any resolution (1080p / 2K / 4K),
has fullscreen support, procedurally generated music and per-channel sound controls.

## Running

- **`SuperMario-6Stages.exe`** — double-click and play (portable, no install needed).
- Or double-click **`index.html`** to play in a browser (**F** for fullscreen).
- Press **ENTER** or **SPACE** to start.

> Note: browser security requires a first keypress (ENTER) before audio starts.

## Controls

| Key | Action |
|------|--------|
| ← → / A D | Move left / right |
| SPACE / ↑ / W | Jump (hold = jump higher) |
| ↓ + SPACE | Drop through platform / go under a block |
| **F** | Toggle **fullscreen** |
| **M** | Music on / off |
| **N** | Sound effects on / off |
| **+ / −** | Music volume up / down |
| R | Restart the current stage |
| ENTER / SPACE | Start / restart |

The control bar at the top of the window also toggles music / SFX / fullscreen and
adjusts the music volume.

## Features

- **6 stages:** Meadows → Stone Town → Forest Road → Bridges → Mountain Path → Castle.
- **Dynamic resolution:** scales to the window; crisp on 1080p and 2K, aspect ratio
  preserved with letterbox bars.
- **Fullscreen:** `F` key or the "⛶ Fullscreen" button.
- **Music + SFX:** 3 procedural stage tracks (Web Audio) plus jump / coin / stomp
  effects; music and SFX can be toggled separately, music volume is adjustable.

## Gameplay

- Stomp Goombas to defeat them (hitting one from the side costs a life).
- Collect coins for points.
- Falling in pits costs a life; lose all 3 and it's GAME OVER.
- Reach the flag at the end of a stage to advance.
- Finish all 6 stages to win; your total score is shown.

## Files

- `SuperMario-6Stages.exe` — **the ready-to-run game** (portable, single file).
- `index.html` — the game itself (all code in one file).
- `build-exe.bat` — **rebuilds the exe after you change the code** (see below).
- `main.js`, `package.json` — Electron sources used to build the exe.
- `README.md` — this file.

> Note: `SuperMario-6Stages.exe` is unsigned. If Windows shows a
> "Unknown publisher" warning, click **More info → Run anyway**.

## Rebuilding the exe after code changes

1. Edit `index.html` (game) or `main.js` (window / theme).
2. Double-click **`build-exe.bat`**.
3. In ~3-4 minutes `SuperMario-6Stages.exe` in this folder is updated automatically.

Under the hood: `npm install` → prepares Electron (downloads and extracts the
binary if missing) → `electron-builder --win portable` (unsigned) → copies the
exe into this folder. On failure it shows which step stopped and waits.

Requirements: Node.js (npm) and an internet connection. If you delete
`node_modules`, the script recreates it (first build takes a little longer).
