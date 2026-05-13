@echo off
title Castro Catering Booking System

echo Starting Castro Catering Booking System...
echo Please wait...

:: Get the folder where this .bat file lives (the project folder)
set PROJECT_PATH=%~dp0
:: Remove trailing backslash
set PROJECT_PATH=%PROJECT_PATH:~0,-1%

:: Start IIS Express on plain HTTP (no SSL needed for local demo)
:: Use 32-bit IIS Express to match the 32-bit setup.exe launcher
if exist "C:\Program Files (x86)\IIS Express\iisexpress.exe" (
    start "" "C:\Program Files (x86)\IIS Express\iisexpress.exe" /path:"%PROJECT_PATH%" /port:8080 /clr:v4.0 /trace:error
) else (
    start "" "C:\Program Files\IIS Express\iisexpress.exe" /path:"%PROJECT_PATH%" /port:8080 /clr:v4.0 /trace:error
)

:: Wait 3 seconds for IIS Express to start
timeout /t 3 /nobreak >nul

:: Open the browser using plain http
start "" "http://localhost:8080/Pages/LoginSignup.aspx"

echo.
echo System is running at http://localhost:8080/Pages/LoginSignup.aspx
echo Close this window to stop the server.
echo.
pause
