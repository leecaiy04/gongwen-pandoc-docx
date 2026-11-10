@echo off
setlocal
set "SCRIPT_DIR=%~dp0"

where py >nul 2>nul
if %errorlevel%==0 (
  py -3 "%SCRIPT_DIR%markdown-to-gongwen-docx.py" %*
  exit /b %errorlevel%
)

where python >nul 2>nul
if %errorlevel%==0 (
  python "%SCRIPT_DIR%markdown-to-gongwen-docx.py" %*
  exit /b %errorlevel%
)

where node >nul 2>nul
if %errorlevel%==0 (
  node "%SCRIPT_DIR%markdown-to-gongwen-docx.mjs" %*
  exit /b %errorlevel%
)

echo 需要 Python 3 或 Node.js 运行转换器，并且需要安装 Pandoc。 1>&2
exit /b 127
