@echo off

setx path "%path%;C:\opscode\chef\bin;C:\opscode\chef\embedded\bin

schtasks.exe /delete /tn "chef_client" /f
C:\Windows\System32\schtasks.exe /CREATE /SC MINUTE /MO 60 /TN "Chef_Client" /TR C:\chef\Chef_Agent_Task.bat /RU "NT AUTHORITY\LOCAL SERVICE"
del c:\temp\Chef_Client /f /q
net localgroup "Administrators" "NT AUTHORITY\LOCAL SERVICE" /add
C:\opscode\chef\bin\chef-client
pause
