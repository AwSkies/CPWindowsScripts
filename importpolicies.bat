echo "Importing policies from policies folder..."
@echo off
cd %~dp0
copy LGPO.exe C:\Windows\System32

lgpo.exe /g Policies /v
echo "Finished"
pause