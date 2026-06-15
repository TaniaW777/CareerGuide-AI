import { app, BrowserWindow, ipcMain } from 'electron';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { exec, spawn } from 'node:child_process';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

let mainWindow: BrowserWindow | null;

process.env.APP_ROOT = path.join(__dirname, '..');
export const VITE_DEV_SERVER_URL = process.env['VITE_DEV_SERVER_URL'];
export const MAIN_DIST = path.join(process.env.APP_ROOT, 'dist-electron');
export const RENDERER_DIST = path.join(process.env.APP_ROOT, 'dist');

process.env.VITE_PUBLIC = VITE_DEV_SERVER_URL ? path.join(process.env.APP_ROOT, 'public') : RENDERER_DIST;

function createWindow() {
  mainWindow = new BrowserWindow({
    icon: path.join(process.env.VITE_PUBLIC, 'favicon.ico'),
    width: 1200,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, 'preload.mjs'),
      nodeIntegration: false,
      contextIsolation: true,
    },
  });

  mainWindow.setMenuBarVisibility(false);

  if (VITE_DEV_SERVER_URL) {
    mainWindow.loadURL(VITE_DEV_SERVER_URL)
  } else {
    mainWindow.loadFile(path.join(RENDERER_DIST, 'index.html'))
  }
}

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
    mainWindow = null
  }
})

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow()
  }
})

function checkAndInstallOllama() {
  exec('ollama --version', (error) => {
    if (error) {
      console.log('Ollama is not installed or not in PATH.');
      // In a real production app, we would download OllamaSetup.exe
      // and run it automatically or prompt the user.
      if (mainWindow) {
        mainWindow.webContents.send('ollama-status', 'not_installed');
      }
    } else {
      console.log('Ollama is installed. Pulling/running qwen2.5:7b...');
      if (mainWindow) {
        mainWindow.webContents.send('ollama-status', 'running');
      }
      
      const ollamaProcess = spawn('ollama', ['run', 'qwen2.5:7b'], { detached: true, stdio: 'ignore' });
      ollamaProcess.unref();
    }
  });
}

app.whenReady().then(() => {
  createWindow();
  checkAndInstallOllama();
});
