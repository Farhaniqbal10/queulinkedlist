@echo off
SET THEFILE=d:\if\semester2\strukturdata\antrian\antrian.exe
echo Linking %THEFILE%
c:\dev-pas\bin\ldw.exe  D:\IF\semester2\strukturdata\antrian\rsrc.o -s   -b base.$$$ -o d:\if\semester2\strukturdata\antrian\antrian.exe link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
