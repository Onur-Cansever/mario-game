@echo off
setlocal
cd /d "%~dp0"
set CSC_IDENTITY_AUTO_DISCOVERY=false

echo ============================================
echo   SUPER MARIO - EXE BUILD
echo   (run this script after you change the code)
echo ============================================
echo.

where node >nul 2>nul
if not errorlevel 1 goto node_ok
REM fallback: if node is not on PATH, try known locations
set "NODEDIR=%LOCALAPPDATA%\hermes\tools\node-26.7.0-win32-x64"
if not exist "%NODEDIR%\node.exe" for %%D in ("%LOCALAPPDATA%\hermes\tools\node-*") do if exist "%%~D\node.exe" set "NODEDIR=%%~D"
if not exist "%NODEDIR%\node.exe" goto node_fail
set "PATH=%NODEDIR%;%PATH%"
echo   Note: Node not found on PATH, using %NODEDIR%
goto node_ok
:node_fail
echo ERROR: Node.js not found - not on PATH.
echo Install Node.js, reopen this window and try again.
pause
exit /b 1
:node_ok

echo [1/4] Installing dependencies (first run ~1 min, fast afterwards)...
set /A NPMTRY=0
:npm_retry
call npm install --no-audit --no-fund
if not errorlevel 1 goto npm_ok
set /A NPMTRY+=1
if %NPMTRY% GEQ 3 goto fail
echo   ...npm failed (network/lock?), retrying in 5 s (%NPMTRY%/3)
timeout /t 5 >nul
goto npm_retry
:npm_ok

echo [2/4] Preparing Electron...
if exist "node_modules\electron\dist\electron.exe" goto electron_ok
node node_modules\electron\install.js >nul 2>nul
if exist "node_modules\electron\dist\electron.exe" goto electron_ok
echo   ...fallback: extracting cached zip manually
call :extract_cached_zip
if exist "node_modules\electron\dist\electron.exe" goto electron_ok
goto fail
:electron_ok

echo [3/4] Building the exe (~2 min)...
call npx electron-builder --win portable || goto fail

echo [4/4] Copying the exe into this folder...
copy /y "dist\SuperMario-6Stages.exe" "SuperMario-6Stages.exe" >nul || goto fail

echo.
echo ============================================
echo   DONE! SuperMario-6Stages.exe has been updated
echo   (right next to this script)
echo ============================================
pause
exit /b 0

:fail
echo.
echo ERROR: Build failed.
echo Close and re-run if needed (transient network/lock errors
echo usually pass on the second try). For persistent errors see the
echo ERROR messages above.
pause
exit /b 1

REM ---- fallback: extract the zip from %LOCALAPPDATA%\electron\Cache with 7za ----
:extract_cached_zip
set "EV="
for /f "delims=" %%V in ('node -p "require('./node_modules/electron/package.json').version" 2^>nul') do set "EV=%%V"
if "%EV%"=="" exit /b 1
set "ZIP="
for /f "delims=" %%F in ('dir /b /s "%LOCALAPPDATA%\electron\Cache\electron-v%EV%-win32-x64.zip" 2^>nul') do set "ZIP=%%F"
if "%ZIP%"=="" (
  echo   ...zip not in cache, downloading
  set "ZIP=node_modules\.electron-zip.tmp"
  del "%ZIP%" 2>nul
  curl -L -o "%ZIP%" "https://github.com/electron/electron/releases/download/v%EV%/electron-v%EV%-win32-x64.zip" >nul 2>nul
  if errorlevel 1 exit /b 1
)
set "_7ZA=node_modules\7zip-bin\win\x64\7za.exe"
if not exist "%_7ZA%" set "_7ZA=node_modules\7zip-bin\win\arm64\7za.exe"
if not exist "%_7ZA%" exit /b 1
rmdir /s /q "node_modules\electron\dist" 2>nul
"%_7ZA%" x -y -bd -o"node_modules\electron\dist" "%ZIP%" >nul 2>nul
if not exist "node_modules\electron\dist\electron.exe" exit /b 1
> "node_modules\electron\path.txt" echo electron.exe
if /i "%ZIP%"=="node_modules\.electron-zip.tmp" del "%ZIP%" 2>nul
exit /b 0
