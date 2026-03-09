@echo off
setlocal
title SRI Hash Generator v1.0.0

:: Enable ANSI color support
for /f %%a in ('powershell -NoProfile -Command "[char]27"') do set "ESC=%%a"
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "CYAN=%ESC%[96m"
set "WHITE=%ESC%[97m"
set "DIM=%ESC%[90m"
set "RESET=%ESC%[0m"

echo.
set /p URL=%YELLOW%Paste file URL here: %RESET%
if "%URL%"=="" (
    echo.
    echo %RED%ERROR: No URL entered!%RESET%
    echo Please run again and enter a valid URL.
    pause >nul
    exit /b 1
)
echo.
echo %DIM%Downloading from:%RESET%
echo %WHITE%%URL%%RESET%
echo.
curl --ssl-no-revoke -L "%URL%" -o sri.tmp 2>curl_error.txt
if NOT %ERRORLEVEL%==0 (
    echo.
    echo %RED%ERROR: Download failed!%RESET%
    echo Be sure the URL is correct and reachable.
    echo %DIM%Details from curl:%RESET%
    type curl_error.txt
    del curl_error.txt
    echo.
    pause
    exit /b 1
)
del curl_error.txt
echo %GREEN%Download succeeded!%RESET%
echo.
echo %YELLOW%Calculating hashes...%RESET%
echo.
powershell -NoProfile -Command "$h256=(Get-FileHash 'sri.tmp' -Algorithm SHA256).Hash; $h384=(Get-FileHash 'sri.tmp' -Algorithm SHA384).Hash; $h512=(Get-FileHash 'sri.tmp' -Algorithm SHA512).Hash; $b256=[byte[]] -split ($h256 -replace '..','0x$& '); $b384=[byte[]] -split ($h384 -replace '..','0x$& '); $b512=[byte[]] -split ($h512 -replace '..','0x$& '); Write-Output ('%ESC%[90msha256-%ESC%[0m%ESC%[97m'+[Convert]::ToBase64String($b256)+'%ESC%[0m'); Write-Output ('%ESC%[90msha384-%ESC%[0m%ESC%[97m'+[Convert]::ToBase64String($b384)+'%ESC%[0m'); Write-Output ('%ESC%[90msha512-%ESC%[0m%ESC%[97m'+[Convert]::ToBase64String($b512)+'%ESC%[0m')"
del sri.tmp
echo.
echo %CYAN%=====================================%RESET%
echo %GREEN%             Finished!%RESET%
echo %CYAN%=====================================%RESET%
echo.
echo %DIM%Press any key to exit.%RESET%
pause >nul