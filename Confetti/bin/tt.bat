@echo off

setlocal

for /f %%x in ('tempfile1.bat') do set _TT_POSTEXEC=%%x.bat

call %~dp0\env.bat
ruby %~dp0\tt.rb %*

if exist %_TT_POSTEXEC% (
	call %_TT_POSTEXEC%
	del /q %_TT_POSTEXEC%
)
