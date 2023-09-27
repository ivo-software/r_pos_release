set LATEST_APP_VERSION=1.15.0
"C:\Program Files (x86)\NSIS\makensis.exe" /DOUTPUT_NAME="installer/r_pos_api_setup_${LATEST_VERSION}.exe" /DLATEST_VERSION=%LATEST_APP_VERSION% /DINCLUDE_SQL=0 installer.nsi 
"C:\Program Files (x86)\NSIS\makensis.exe" /DOUTPUT_NAME="installer/r_pos_api_setup_${LATEST_VERSION}_with_PgSQL.exe" /DLATEST_VERSION=%LATEST_APP_VERSION% /DINCLUDE_SQL=1 installer.nsi 