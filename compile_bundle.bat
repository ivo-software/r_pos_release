@echo off
set API_VERSION=1.102.1
set UI_VERSION=1.33.0
set WAITER_APP_VERSION=1.13.0(27)
set Q_MONITOR_APP_VERSION=1.1.1(35)
"C:\Program Files (x86)\NSIS\makensis.exe" /DOUTPUT_NAME="installer/r_pos_api_${LATEST_VERSION}.exe" /DLATEST_VERSION=%API_VERSION% /DINCLUDE_SQL=0 server\installer.nsi 
"C:\Program Files (x86)\NSIS\makensis.exe" /DOUTPUT_NAME="installer/r_pos_api_${LATEST_VERSION}_PgSQL_server.exe" /DLATEST_VERSION=%API_VERSION% /DINCLUDE_SQL=1 server\installer.nsi 

setlocal enabledelayedexpansion

rmdir /s /q "bundle"
mkdir "bundle"

set "api_server=server\installer\r_pos_api_%API_VERSION%.exe"
set "ui_client=client\R POS Setup %UI_VERSION%.exe"
set "waiter_app=waiter_app\r_pos_waiter_%WAITER_APP_VERSION%.apk"
set "q_monitor_app=q_monitor_app\r_pos_q_monitor_app_%Q_MONITOR_APP_VERSION%.apk"
set "api_server_with_pgsql=server\installer\r_pos_api_%API_VERSION%_PgSQL_server.exe"

for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do (
    set "year=%%c"
    set "month=%%a"
    set "day=%%b"
)
set "today=%day%.%month%.%year%"
set "today=%today:.=%"


set "zipfile_update_server=bundle\r_pos_server_%API_VERSION%.zip"
set "zipfile_update_client=bundle\r_pos_client_%UI_VERSION%.zip"
set "zipfile_full_setup=bundle\r_pos_server_%API_VERSION%_PgSQL_server.zip"
set "zipfile_apps=bundle\r_pos_apps_%today%.zip"

copy "%waiter_app%" "waiter_app\r_pos_waiter.latest.apk"
copy "%q_monitor_app%" "q_monitor_app\r_pos_q_monitor_app.latest.apk"

powershell -command "Compress-Archive -Path '%api_server%'  -DestinationPath '%zipfile_update_server%'"
powershell -command "Compress-Archive -Path '%ui_client%'  -DestinationPath '%zipfile_update_client%'"
powershell -command "Compress-Archive -Path '%waiter_app%', '%q_monitor_app%'  -DestinationPath '%zipfile_apps%'"
powershell -command "Compress-Archive -Path '%api_server_with_pgsql%' -DestinationPath '%zipfile_full_setup%'"

if errorlevel 1 (
    echo Error occurred while creating the zip file.
    exit /b 1
) else (
    echo Zip file "%zipfile_update_server%" created successfully.
    echo Zip file "%zipfile_update_client%" created successfully.
    echo Zip file "%zipfile_apps%" created successfully.
    echo Zip file "%zipfile_full_setup%" created successfully.
)

endlocal
