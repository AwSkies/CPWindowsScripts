@echo off
rem Preferences
color 0b

echo ------------------------------------------------------------------------------------
echo *** Welcome to Sharon CyberPatriot Windows 10 and Server2019 script!             ***
echo ------------------------------------------------------------------------------------
echo:

rem Guest and Admin
choice /c ync /m "Do you wish to disable guest and admin accounts? "
if %ERRORLEVEL% equ 3 goto:eof
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Disabling guest and admin accounts...                                        ***
    net user administrator /active:no
    net user guest /active:no
    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:
)

rem Firewall
choice /c ync /m "Do you wish to enable firewall? "
if %ERRORLEVEL% equ 3 goto:eof
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Turning on firewall...                                                       ***
    netsh advfirewall set allprofiles state on
    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:
)

rem Telnet
choice /c ync /m "Do you wish to disable Telnet? "
if %ERRORLEVEL% equ 3 goto:eof
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Disabling Telnet                                                             ***
    DISM /online /disable-feature /featurename:TelnetClient
    DISM /online /disable-feature /featurename:TelnetClient
    sc stop "TlntSvr"
    sc config "TlntSvr" start = disabled
    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:
)

rem Remote Desktop
choice /c ync /m "Do you wish to disable remote desktop? "
if %ERRORLEVEL% equ 3 goto:eof
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Disabling remote desktop...                                                  ***
    sc stop "TermService"
    sc config "TermService" start = disabled
    sc stop "SessionEnv"
    sc config "SessionEnv" start = disabled
    sc stop "UmRdpService"
    sc config "UmRdpService" start = disabled
    sc stop "RemoteRegistry"
    sc config "RemoteRegistry" start = disabled
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f
    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:
)

rem Import Policies
choice /c ync /m "Do you wish to import GPOs? "
if %ERRORLEVEL% equ 3 goto:eof
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Importing policies from policies folder...                                   ***
    .\LGPO.exe /g .\Policies /v
    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:

)

rem User Audit
choice /c ync /m "Do you wish to perform a user audit? This includes changing passwords of every user and removing all users not in authorizedusers.txt. "
if %ERRORLEVEL% equ 3 goto:eof
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Reading authorized users                                                     ***
    set /a i = 0
    for /f %%user in ("authorizedusers.txt") do (
        call /a i += 1
        call echo %%i%%
        call set users[%%i%%] = %%user
        call set n = %%i%%
    )
    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:
)
pause