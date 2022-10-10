@echo off

rem Gets the administrators 
rem Works by echoing back the lines after the horizontal line and ingnoring the "command completed successfully message" 
rem Make sure the user names are only one word, since words after the first word are ignored

set "ready="
for /f %%a in ('net localgroup Administrators') do (
	if not defined ready (
        if %%a equ ------------------------------------------------------------------------------- (
            set ready=y
        )
    ) else (
        if %%a equ The (
            set "ready="
        ) else (
            echo %%a
        )
    )
)