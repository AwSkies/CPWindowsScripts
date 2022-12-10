@echo off
rem Preferences and initialization
color 0b
title CyberPatriot Windows Script
setlocal ENABLEDELAYEDEXPANSION
Rem Find location with LGPO.exe and cd to it (for if the file was selected to run as admin)
cd C:\Users
:: Since there should be only one location with LGPO.exe in it (the scripts folder dragged into the VM) it should only cd once
for /f "delims=" %%a in ('dir /s /b LGPO.exe') do (
    cd %%a\..
)

Rem Check if Command Prompt has admin permissions
echo Checking if Command Prompt has administrator permissions...
net sessions
if %ERRORLEVEL% neq 0 (
    echo This Command Prompt does not have administrator permissions. Right click the batch file and select "run as administrator".
    pause
    goto:eof
)
cls

echo ------------------------------------------------------------------------------------
echo *** Welcome to Sharon CyberPatriot Windows 10 and Server2019 script^^!             ***
echo *** Made by CaptainClumsy of team 14-3178 and 15-3557 of Sharon High School      ***
echo *** Use of this script for a CyberPatriot competition by anyone not on a Sharon  ***
echo ***     High School team is forbidden by CyberPatriot rules                      ***
echo *** In the following options, choose y for yes, n for no, and c to cancel script ***
echo ------------------------------------------------------------------------------------
echo:

rem Firewall
choice /c ync /m "Do you wish to enable firewall? "
if %ERRORLEVEL% equ 3 (
    echo Canceling...
    pause
    goto:eof
)
if %ERRORLEVEL% equ 2 echo Skipping firewall...
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Turning on firewall...                                                       ***
    netsh advfirewall set allprofiles state on
    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:
)

Rem Services
choice /c ync /m "Do you wish to disable any services? (Manual and automatic mode are available) "
if %ERRORLEVEL% equ 3 (
    echo Canceling...
    pause
    goto:eof
)
if %ERRORLEVEL% equ 2 echo Skipping services...
if %ERRORLEVEL% equ 1 (
    choice /c amc /m "Manual or automatic mode? (Manual mode steps through each service while automatic mode disables them all) "
    set /a mode=!ERRORLEVEL!
    if !mode! equ 3 (
        echo Skipping services... 
    ) else (
        set services=Telephony TapiSrv Tlntsvr tlntsvr p2pimsvc simptcp fax msftpsvc iprip ftpsvc RasMan RasAuto seclogon MSFTPSVC W3SVC SMTPSVC Dfs TrkWks MSDTC DNS ERSVC NtFrs MSFtpsvc helpsvc HTTPFilter IISADMIN IsmServ WmdmPmSN Spooler RDSessMgr RPCLocator RsoPProv ShellHWDetection ScardSvr Sacsvr Uploadmgr VDS VSS WINS WinHttpAutoProxySvc SZCSVC CscService hidserv IPBusEnum PolicyAgent SCPolicySvc SharedAccess SSDPSRV Themes upnphost nfssvc nfsclnt MSSQLServerADHelper
        echo ------------------------------------------------------------------------------------
        echo *** Managing services...                                                         ***
        Rem Automatic mode
        if !mode! equ 1 (
            for %%a in (!services!) do (
                echo Disabling %%a
                sc stop "%%a"
                sc config "%%a" start=disabled
            )
        Rem Manual mode
        ) else (
            for %%a in (!services!) do (
                choice /c yn /m "Do you wish to disable %%a? "
                if !ERRORLEVEL! equ 1 (
                    echo Disabling %%a...
                    sc stop "%%a"
                    sc config "%%a" start=disabled
                ) else (
                    echo Skipping %%a...
                )
            )
        )
        echo *** Finished                                                                     ***
        echo ------------------------------------------------------------------------------------
    )
)

rem Remote Desktop
choice /c ync /m "Do you wish to disable remote desktop? "
if %ERRORLEVEL% equ 3 (
    echo Canceling...
    pause
    goto:eof
)
if %ERRORLEVEL% equ 2 echo Skipping remote desktop...
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Disabling remote desktop...                                                  ***
    sc stop "TermService"
    sc config "TermService" start=disabled
    sc stop "SessionEnv"
    sc config "SessionEnv" start=disabled
    sc stop "UmRdpService"
    sc config "UmRdpService" start=disabled
    sc stop "RemoteRegistry"
    sc config "RemoteRegistry" start=disabled
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f
    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:
)

rem Registry keys
choice /c ync /m "Do you wish to manage registry keys? "
if %ERRORLEVEL% equ 3 (
    echo Canceling...
    pause
    goto:eof
)
if %ERRORLEVEL% equ 2 echo Skipping registry keys...
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Managing registry keys...                                                    ***
    reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AutoInstallMinorUpdates /t REG_DWORD /d 1 /f
    reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoUpdate /t REG_DWORD /d 0 /f
    reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AUOptions /t REG_DWORD /d 4 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 4 /f
    reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v DisableWindowsUpdateAccess /t REG_DWORD /d 0 /f
    reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v ElevateNonAdmins /t REG_DWORD /d 0 /f
    reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoWindowsUpdate /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\Internet Communication Management\Internet Communication" /v DisableWindowsUpdateAccess /t REG_DWORD /d 0 /f
    reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate /v DisableWindowsUpdateAccess /t REG_DWORD /d 0 /f
    echo Restrict CD ROM drive
    reg ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AllocateCDRoms /t REG_DWORD /d 1 /f
    echo Disallow remote access to floppy disks
    reg ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AllocateFloppies /t REG_DWORD /d 1 /f
    echo Disable auto Admin logon
    reg ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_DWORD /d 0 /f
    echo Clear page file, will take longer to shutdown
    reg ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f
    echo Prevent users from installing printer drivers 
    reg ADD "HKLM\SYSTEM\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers" /v AddPrinterDrivers /t REG_DWORD /d 1 /f
    echo Add auditing to Lsass.exe
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\LSASS.exe" /v AuditLevel /t REG_DWORD /d 00000008 /f
    echo Enable LSA protection
    reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v RunAsPPL /t REG_DWORD /d 00000001 /f
    echo Limit use of blank passwords
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v LimitBlankPasswordUse /t REG_DWORD /d 1 /f
    echo Auditing access of Global System Objects
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v auditbaseobjects /t REG_DWORD /d 1 /f
    echo Auditing Backup and Restore
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v fullprivilegeauditing /t REG_DWORD /d 1 /f
    echo Restrict Anonymous Enumeration #1
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v restrictanonymous /t REG_DWORD /d 1 /f
    echo Restrict Anonymous Enumeration #2
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v restrictanonymoussam /t REG_DWORD /d 1 /f
    echo Disable storage of domain passwords
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v disabledomaincreds /t REG_DWORD /d 1 /f
    echo Take away Anonymous user Everyone permissions
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v everyoneincludesanonymous /t REG_DWORD /d 0 /f
    echo Allow Machine ID for NTLM
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v UseMachineId /t REG_DWORD /d 0 /f
    echo Do not display last user on logon
    reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v dontdisplaylastusername /t REG_DWORD /d 1 /f
    echo Enable UAC
    echo UAC setting, prompt on Secure Desktop
    reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f
    echo Enable Installer Detection
    reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableInstallerDetection /t REG_DWORD /d 1 /f
    echo Disable undocking without logon
    reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v undockwithoutlogon /t REG_DWORD /d 0 /f
    echo Enable CTRL+ALT+DEL
    reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCAD /t REG_DWORD /d 0 /f
    echo Max password age
    reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\Netlogon\Parameters /v MaximumPasswordAge /t REG_DWORD /d 15 /f
    echo Disable machine account password changes
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\Netlogon\Parameters /v DisablePasswordChange /t REG_DWORD /d 1 /f
    echo Require strong session key
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\Netlogon\Parameters /v RequireStrongKey /t REG_DWORD /d 1 /f
    echo Require Sign/Seal
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\Netlogon\Parameters /v RequireSignOrSeal /t REG_DWORD /d 1 /f
    echo Sign Channel
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\Netlogon\Parameters /v SignSecureChannel /t REG_DWORD /d 1 /f
    echo Seal Channel
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\Netlogon\Parameters /v SealSecureChannel /t REG_DWORD /d 1 /f
    echo Set idle time to 45 minutes
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v autodisconnect /t REG_DWORD /d 45 /f
    echo Require Security Signature - Disabled pursuant to checklist
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v enablesecuritysignature /t REG_DWORD /d 0 /f
    echo Enable Security Signature - Disabled pursuant to checklist
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v requiresecuritysignature /t REG_DWORD /d 0 /f
    echo Clear null session pipes
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v NullSessionPipes /t REG_MULTI_SZ /d "" /f
    echo Restict Anonymous user access to named pipes and shares
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v NullSessionShares /t REG_MULTI_SZ /d "" /f
    echo Encrypt SMB Passwords
    reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanWorkstation\Parameters /v EnablePlainTextPassword /t REG_DWORD /d 0 /f
    echo Clear remote registry paths
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg\AllowedExactPaths /v Machine /t REG_MULTI_SZ /d "" /f
    echo Clear remote registry paths and sub-paths
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg\AllowedPaths /v Machine /t REG_MULTI_SZ /d "" /f
    echo Enable smart screen for IE8
    reg ADD "HKCU\Software\Microsoft\Internet Explorer\PhishingFilter" /v EnabledV8 /t REG_DWORD /d 1 /f
    echo Enable smart screen for IE9 and up
    reg ADD "HKCU\Software\Microsoft\Internet Explorer\PhishingFilter" /v EnabledV9 /t REG_DWORD /d 1 /f
    echo Disable IE password caching
    reg ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v DisablePasswordCaching /t REG_DWORD /d 1 /f
    echo Warn users if website has a bad certificate
    reg ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v WarnonBadCertRecving /t REG_DWORD /d 1 /f
    echo Warn users if website redirects
    reg ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v WarnOnPostRedirect /t REG_DWORD /d 1 /f
    echo Enable Do Not Track
    reg ADD "HKCU\Software\Microsoft\Internet Explorer\Main" /v DoNotTrack /t REG_DWORD /d 1 /f
    reg ADD "HKCU\Software\Microsoft\Internet Explorer\Download" /v RunInvalidSignatures /t REG_DWORD /d 1 /f
    reg ADD "HKCU\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_LOCALMACHINE_LOCKDOWN\Settings" /v LOCALMACHINE_CD_UNLOCK /t REG_DWORD /d 1 /f
    reg ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v WarnonZoneCrossing /t REG_DWORD /d 1 /f
    echo Show hidden files
    reg ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Hidden /t REG_DWORD /d 1 /f
    echo Disable sticky keys
    reg ADD "HKU\.DEFAULT\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f
    echo Show super hidden files
    reg ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSuperHidden /t REG_DWORD /d 1 /f
    echo Disable dump file creation
    reg ADD HKLM\SYSTEM\CurrentControlSet\Control\CrashControl /v CrashDumpEnabled /t REG_DWORD /d 0 /f
    echo Disable autoruns
    reg ADD HKCU\SYSTEM\CurrentControlSet\Services\CDROM /v AutoRun /t REG_DWORD /d 1 /f
    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:
)

rem Import Policies
choice /c ync /m "Do you wish to import GPOs? "
if %ERRORLEVEL% equ 3 (
    echo Canceling...
    pause
    goto:eof
)
if %ERRORLEVEL% equ 2 echo Skipping GPOs...
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Importing policies from policies folder...                                   ***
    .\LGPO.exe /g .\Policies /v
    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:
)

rem Guest and Admin
choice /c ync /m "Do you wish to disable guest and admin accounts? "
if %ERRORLEVEL% equ 3 (
    echo Canceling...
    pause
    goto:eof
)
if %ERRORLEVEL% equ 2 echo Skipping guest and admin accounts...
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Disabling guest and admin accounts...                                        ***
    net user administrator /active:no
    net user guest /active:no
    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:
)

Rem User Audit
choice /c ync /m "Do you wish to perform a user audit? "
if %ERRORLEVEL% equ 3 (
    echo Canceling...
    pause
    goto:eof
)
if %ERRORLEVEL% equ 2 echo Skipping user audit...
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Performing user audit...                                                     ***

    set usersfile=authorizedusers.txt
    choice /c yn /m "Do you wish to remove unauthorized users and add missing users? (Authorized users should be listed in !usersfile!) "
    if !ERRORLEVEL! equ 2 echo Skipping authorized user check...
    if !ERRORLEVEL! equ 1 (
        echo Reading !usersfile!
        Rem Make sure the authorized user file has something in it
        set /a lines=0
        for /f "tokens=*" %%i in (!usersfile!) do (
            set /a lines+=1
        )
        echo Done.
        echo:
        Rem Dissallow removing every user on the computer
        if !lines! equ 0 (
            echo There are no users listed in !usersfile!. Please put the authorized users in and try again.
        ) else (
            echo Authorized users:
            type !usersfile!
            echo:
            echo:
            
            Rem Delete unauthorized users
            echo Deleting unauthorized users and enabling authorized ones...
            Rem Loops through each user on the computer
            set "unauthorizedadminsexist="
            for /f "delims=" %%a in ('cscript //NoLogo .\GetLocalUsers.vbs') do (
                Rem Loops through each line (user) in file
                set "useradmin="
                for /f "tokens=*" %%i in (!usersfile!) do (
                    if %%a equ %%i (
                        set seen[%%a]=y
                        set useradmin=y
                        net user %%a /active:yes
                    )
                )
                if not defined useradmin (
                    if !USERNAME! equ %%a (
                        echo Skipping current user %%a...
                        echo:
                    ) else (
                        set unauthorizedadminsexist=y
                        echo Deleting user: %%a...
                        net user %%a /delete
                    )
                )
            )
            Rem Case in which no unauthorized users were deleted
            if not defined unauthorizedadminsexist (
                echo No unauthorized users found.
            ) else (
                echo Done.
            )
            echo:

            Rem Add authorized users not made yet
            echo Adding missing users...
            set "missingadminsexist="
            for /f "tokens=*" %%a in (!usersfile!) do (
                if not defined seen[%%a] (
                    set missingadminsexist=y
                    echo Adding missing user: %%a
                    net user %%a q1W@e3R$t5Y^u7I*o9 /add
                )
            )
            if not defined missingadminsexist (
                echo No missing users found.
            ) else (
                echo Done.
            ) 
        )
    )

    set adminsfile=admins.txt
    choice /c yn /m "Do you wish to remove unauthorized admins and add missing ones? (Administrators should be listed in !adminsfile!) "
    if !ERRORLEVEL! equ 2 echo Skipping admins check...
    if !ERRORLEVEL! equ 1 (
        echo Reading !adminsfile!...
        Rem Make sure the admins file has something in it
        set /a lines=0
        for /f "tokens=*" %%i in (!adminsfile!) do (
            set /a lines+=1
        )
        echo Done.
        echo:
        Rem Dissallow removing every admin
        if !lines! equ 0 (
            echo There are no users listed in !adminsfile!. Please put the admins in and try again.
        ) else (
            echo Administrators:
            type !adminsfile!
            echo:
            echo:
            
            Rem Delete unauthorized admins
            echo Deleting unauthorized admins...
            Rem Loops through each admin
            set "unauthorizedadminsexist="
            for /f "delims=" %%a in ('admins.bat') do (
                Rem Loops through each line (user) in file
                set "useradmin="
                for /f "tokens=*" %%i in (!adminsfile!) do (
                    if %%a equ %%i (
                        set seen[%%a]=y
                        set useradmin=y
                    )
                )
                if not defined useradmin (
                    if !USERNAME! equ %%a (
                        echo Skipping current user %%a...
                        echo:
                    ) else (
                        set unauthorizedadminsexist=y
                        echo Removing user %%a from Administrators...
                        net localgroup Administrators "%%a" /delete
                    )
                )
            )
            Rem Case in which no unauthorized admins were deleted
            if not defined unauthorizedadminsexist (
                echo No unauthorized admins found.
            ) else (
                echo Done.
            )
            echo:

            Rem Add authorized admins not yet admin
            echo Adding missing admins...
            set "missingadminsexist="
            for /f "tokens=*" %%a in (!adminsfile!) do (
                if not defined seen[%%a] (
                    set missingadminsexist=y
                    echo Adding missing admin: %%a
                    net localgroup Administrators "%%a" /add
                )
            )
            if not defined missingadminsexist (
                echo No missing admins found.
            ) else (
                echo Done.
            ) 
        )
    )

    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:
)

rem User Passwords
choice /c ync /m "Do you wish to change all user passwords to a secure password? (Excludes current user) "
if %ERRORLEVEL% equ 3 (
    echo Canceling...
    pause
    goto:eof
)
if %ERRORLEVEL% equ 2 echo Skipping user passwords...
if %ERRORLEVEL% equ 1 (
    echo ------------------------------------------------------------------------------------
    echo *** Changing password of every user to "q1W@e3R$t5Y^u7I*o9"...                   ***
    for /f "delims=" %%a in ('cscript //NoLogo .\GetLocalUsers.vbs') do (
        if !USERNAME! equ %%a (
            echo Skipping current user %%a...
            echo:
        ) else (
            echo Changing password of %%a...
            net user %%a q1W@e3R$t5Y^u7I*o9
        )
    )
    echo *** Finished                                                                     ***
    echo ------------------------------------------------------------------------------------
    echo:
)

Rem Disallowed Media Files
choice /c ync /m "Do you wish to remove disallowed media files? (Manual and automatic mode are available) "
if %ERRORLEVEL% equ 3 (
    echo Canceling...
    pause
    goto:eof
)
if %ERRORLEVEL% equ 2 echo Skipping disallowed media files...
if %ERRORLEVEL% equ 1 (
    choice /c amc /m "Manual or automatic mode? (Manual mode steps through each file type and file while automatic mode disables them all) (MANUAL MODE IS HIGHLY RECOMMENDED AS YOU WILL NOT ACCIDENTALLY DELETE IMAGES/MEDIA USED BY APPLICATIONS) "
    set /a mode=!ERRORLEVEL!
    if !mode! equ 3 (
        echo Skipping disallowed media files... 
    ) else (
        set filetypes=mp3 mov mp4 avi mpg mpeg flac m4a flv ogg gif png jpg jpeg
        cd C:\Users
        echo ------------------------------------------------------------------------------------
        echo *** Deleting disallowed media file types...                                      ***
        Rem Automatic mode
        if !mode! equ 1 (
            :: %%i = file extension
            for %%i in (!filetypes!) do (
                echo Deleting all .%%i files...
                :: %%a = individual file
                for /f "delims=" %%a in ('dir /s /b *.%%i') do (
                    echo Deleting %%a...
                    del "%%a"
                )
            )
        Rem Manual mode
        ) else (
            :: %%i = file extension
            for %%i in (!filetypes!) do (
                choice /c yn /m "Do you wish to delete .%%i files? "
                if !ERRORLEVEL! equ 1 (
                    echo Deleting .%%i files...
                    :: %%a = individual file
                    for /f "delims=" %%a in ('dir /s /b *.%%i') do (
                        choice /c yno /m "Do you wish to delete %%a? "
                        if !ERRORLEVEL! equ 1 (
                            echo Deleting %%a...
                            del "%%a"
                        ) else (
                            if !ERRORLEVEL! equ 2 (
                                echo Skipping %%a...
                            ) else (
                                explorer.exe %%a\..
                            )
                        )
                    )
                ) else (
                    echo Skipping .%%i files...
                )
            )
        )
        echo *** Finished                                                                     ***
        echo ------------------------------------------------------------------------------------
    )
)

echo ------------------------------------------------------------------------------------
echo *** End of script                                                                ***
echo *** Good luck^^!                                                                   ***
echo ------------------------------------------------------------------------------------
echo:

pause
