const { app, BrowserWindow, Menu, shell, globalShortcut } = require('electron');
const path = require('path');

// Windows DPI: render at native pixels so it stays crisp on 1080p/2K/4K
app.commandLine.appendSwitch('high-dpi-support', 'true');
app.commandLine.appendSwitch('enable-highdpi-support', 'true');

let win;

function createWindow() {
  win = new BrowserWindow({
    width: 1280,
    height: 760,
    minWidth: 800,
    minHeight: 500,
    backgroundColor: '#000000',
    title: 'Super Mario — 6 Stages',
    autoHideMenuBar: true,
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: true
    }
  });

  win.loadFile('index.html');

  // F11 → tam ekran
  win.webContents.on('before-input-event', (event, input) => {
    if (input.type === 'keyDown' && input.key === 'F11') {
      win.setFullScreen(!win.isFullScreen());
      event.preventDefault();
      return true;
    }
    if (input.type === 'keyDown' && (input.key === 'Escape' || input.code === 'Escape')) {
      if (win.isFullScreen()) win.setFullScreen(false);
    }
    if (input.type === 'keyDown' && input.key === 'F4' && input.control) {
      event.preventDefault();
      return true; // keep window open with Ctrl+F4; quit the game with ENTER
    }
  });
}

app.whenReady().then(() => {
  Menu.setApplicationMenu(null);
  createWindow();
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  app.quit();
});

// External links open in the default browser
app.on('web-contents-created', (e, contents) => {
  contents.setWindowOpenHandler(({ url }) => {
    if (url.startsWith('http')) shell.openExternal(url);
    return { action: 'deny' };
  });
});
