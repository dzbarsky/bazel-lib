@rem @generated by @aspect_bazel_lib//lib/private:diff_test.bzl
@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
set MF=%RUNFILES_MANIFEST_FILE:/=\\%
set PATH=%SYSTEMROOT%\\system32
set F1={file1}
set F2={file2}
if "!F1:~0,9!" equ "external/" (set F1=!F1:~9!) else (set F1=!TEST_WORKSPACE!/!F1!)
if "!F2:~0,9!" equ "external/" (set F2=!F2:~9!) else (set F2=!TEST_WORKSPACE!/!F2!)
for /F "tokens=2* usebackq" %%i in (`findstr.exe /l /c:"!F1! " "%MF%"`) do (
  set RF1=%%i
  set RF1=!RF1:/=\\!
)
if "!RF1!" equ "" (
  if "%RUNFILES_MANIFEST_ONLY%" neq "1" if exist "%RUNFILES_DIR%\\%F1%" (
    set RF1="%RUNFILES_DIR%\\%F1%"
  ) else (
    if exist "{file1}" (
      set RF1="{file1}"
    )
  )
  if "!RF1!" neq "" (    set RF1=!RF1:/=\\!
  ) else (
    echo>&2 ERROR: !F1! not found
    exit /b 1
  )
)
for /F "tokens=2* usebackq" %%i in (`findstr.exe /l /c:"!F2! " "%MF%"`) do (
  set RF2=%%i
  set RF2=!RF2:/=\\!
)
if "!RF2!" equ "" (
  if "%RUNFILES_MANIFEST_ONLY%" neq "1" if exist "%RUNFILES_DIR%\\%F2%" (
    set RF2="%RUNFILES_DIR%\\%F2%"
  ) else (
    if exist "{file2}" (
      set RF2="{file2}"
    )
  )
  if "!RF2!" neq "" (    set RF2=!RF2:/=\\!
  ) else (
    echo>&2 ERROR: !F2! not found
    exit /b 1
  )
)
set DF1=0
set DF2=0
if exist "!RF1!\\*" (
  set DF1=1
)
if exist "!RF2!\\*" (
  set DF2=1
)
if %DF1% equ 1 (
  if %DF2% equ 0 (
    echo>&2 ERROR: Cannot compare directory "{file1}" and a file "{file2}"
    exit /b 1
  )
)
if %DF1% equ 0 (
  if %DF2% equ 1 (
    echo>&2 ERROR: Cannot compare file "{file1}" and a directory "{file2}"
    exit /b 1
  )
)
set DFX=0
if %DF1% equ 1 (
  if %DF2% equ 1 (
    set DFX=1
  )
)
if %DFX% equ 1 (
  for /f "delims=" %%F in (
    'echo "."^&forfiles /s /p "!RF1!" /m "*" /c "cmd /c echo @relpath"'
  ) do (
    if not exist "!RF2!\\%%~F" (
      echo>&2 FAIL: file "%%~F" exists in "{file1}" and not in "{file2}". {fail_msg}
      GOTO fail
    )
    if not exist "!RF1!\\%%~F\\*" (
      fc.exe /B "!RF1!\\%%~F" "!RF2!\\%%~F" 2>NUL 1>NUL
      if !ERRORLEVEL! neq 0 (
        if !ERRORLEVEL! equ 1 (
          echo>&2 FAIL: files "{file1}\\%%~F" and "{file2}\\%%~F" differ. {fail_msg}
          GOTO fail
        ) else (
          fc.exe /B "!RF1!\\%%~F" "!RF2!\\%%~F"
          GOTO fail
        )
      )
    )
  )
  for /f "delims=" %%F in (
    'echo "."^&forfiles /s /p "!RF2!" /m "*" /c "cmd /c echo @relpath"'
  ) do (
    if not exist "!RF1!\\%%~F" (
      echo>&2 FAIL: file "%%~F" exists in "{file2}" and not in "{file1}". {fail_msg}
      GOTO fail
    )
  )
) else (
  fc.exe /B "!RF1!" "!RF2!" 2>NUL 1>NUL
  if %ERRORLEVEL% neq 0 (
    if %ERRORLEVEL% equ 1 (
      echo>&2 FAIL: files "{file1}" and "{file2}" differ. {fail_msg}
      exit /b 1
    ) else (
      fc.exe /B "!RF1!" "!RF2!"
      exit /b %errorlevel%
    )
  )
)
exit /b 0

:fail
exit /b 1