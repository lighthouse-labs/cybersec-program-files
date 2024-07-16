net stop MpsSvc
net start MpsSvc
net stop MpsSvc
net start MpsSvc

@echo off
set loopcount=10
:loop
C:\Users\Administrator\curl-8.0.1_7-win64-mingw\curl-8.0.1_7-win64-mingw\bin\curl 192.168.1.1/precy.txt >> dump.txt
set /a loopcount=loopcount-1
if %loopcount%==0 goto exitlopp
goto loop
:exitloop
pause