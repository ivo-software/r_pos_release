!include LogicLib.nsh
!define INSTALL_DIRECTORY "$PROGRAMFILES\R POS API Server"

Name "R POS API Server"
RequestExecutionLevel admin

InstallDir "${INSTALL_DIRECTORY}"

Icon "icon.ico"
OutFile "${OUTPUT_NAME}"

Section
    MessageBox MB_YESNO "Do you want to install R POS API Server?" IDYES +2 IDNO +1
    Quit
    SetOutPath "${INSTALL_DIRECTORY}"

    ; Create the installation directory
    CreateDirectory "${INSTALL_DIRECTORY}"

    ExecWait 'net stop "R POS API Server"'
    Sleep 5000

    ; Delete existing files if they exist
    IfFileExists "${INSTALL_DIRECTORY}\truncate_operations.sql" 0
        delete "${INSTALL_DIRECTORY}\truncate_operations.sql"

    IfFileExists "${INSTALL_DIRECTORY}\reset_license.bat" 0
        delete "${INSTALL_DIRECTORY}\reset_license.bat"

    IfFileExists "${INSTALL_DIRECTORY}\truncate_db.bat" 0
        delete "${INSTALL_DIRECTORY}\truncate_db.bat"
        
    IfFileExists "${INSTALL_DIRECTORY}\r_pos_api.exe" 0
        delete "${INSTALL_DIRECTORY}\r_pos_api.exe"

    ; Copy new files
    File "truncate_operations.sql"
    File "truncate_db.bat"
    File "reset_license.bat"
    File "nssm.exe"
    File "uninstall_r_pos_service.bat" 
    File "r_pos_api_${LATEST_VERSION}.exe" 
    Rename "${INSTALL_DIRECTORY}\r_pos_api_${LATEST_VERSION}.exe" "${INSTALL_DIRECTORY}\r_pos_api.exe"

    ; Check if .env file exists
    IfFileExists "${INSTALL_DIRECTORY}\.env" FileExists FileDoesNotExist

    FileExists:
        ; The file exists, so do nothing or handle it as needed
        Goto End

    FileDoesNotExist:
        File ".env"

    End:

    ; Create the 'media' directory if it doesn't exist
    IfFileExists "${INSTALL_DIRECTORY}\media\" 0 CreateMediaDirectory
    Goto MediaDirectoryExists

    CreateMediaDirectory:
        CreateDirectory "${INSTALL_DIRECTORY}\media"
    
    MediaDirectoryExists:

    ; Set up the service with nssm
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" stop "R POS API Server"'
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" remove "R POS API Server" confirm'
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" install "R POS API Server" "${INSTALL_DIRECTORY}\r_pos_api.exe"'
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" set "R POS API Server" AppDirectory "${INSTALL_DIRECTORY}"'
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" set "R POS API Server" AppStdout "${INSTALL_DIRECTORY}\r_pos_api.log"'
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" set "R POS API Server" AppStderr "${INSTALL_DIRECTORY}\r_pos_api.log"'
SectionEnd

!if ${INCLUDE_SQL} = 1
    Section 
        MessageBox MB_YESNO "Do you want to install PostgreSQL?" /SD IDYES IDNO +6        
        File "postgresql-14.12-2-windows-x64.exe"
        ExecWait '"${INSTALL_DIRECTORY}\postgresql-14.12-2-windows-x64.exe" --mode unattended --unattendedmodeui minimal --superpassword masterkey'
        Sleep 15000
        System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("PGPASSWORD", "masterkey").r0'
        ExecWait '"C:\Program Files\PostgreSQL\14\bin\psql.exe" -U postgres -c "CREATE DATABASE r_pos;"'
        MessageBox MB_YESNO "Do you want to install Redis Server?" /SD IDYES IDNO +6   
        CreateDirectory "${INSTALL_DIRECTORY}\redis-7.4.1"
        SetOutPath "${INSTALL_DIRECTORY}\redis-7.4.1"
        File /r "redis-7.4.1\*"
        ExecWait 'sc.exe create "RedisServer" binpath="${INSTALL_DIRECTORY}\redis-7.4.1\RedisService.exe" start=AUTO'
        ExecWait 'net start "RedisServer"'
        Sleep 5000
    SectionEnd
!endif

Section
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" restart "R POS API Server"'
SectionEnd
