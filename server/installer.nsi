!include LogicLib.nsh
!define INSTALL_DIRECTORY "$PROGRAMFILES\Chayxanshik API Server"

Name "Chayxanshik API Server"
RequestExecutionLevel admin

InstallDir "${INSTALL_DIRECTORY}"

Icon "icon.ico"
OutFile "${OUTPUT_NAME}"

Section
    SetOutPath "${INSTALL_DIRECTORY}"

    ;create the installation directory
    CreateDirectory "${INSTALL_DIRECTORY}"

    ExecWait 'net stop "Chayxanshik API Server"'
    Sleep 5000
    IfFileExists "${INSTALL_DIRECTORY}\chayxanshik.exe" 0
        delete "${INSTALL_DIRECTORY}\chayxanshik.exe"

    File "nssm.exe"
    File "chayxanshik_${LATEST_VERSION}.exe" 
    Rename "${INSTALL_DIRECTORY}\chayxanshik_${LATEST_VERSION}.exe" "${INSTALL_DIRECTORY}\chayxanshik.exe"

    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" stop "Chayxanshik API Server"'
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" remove "Chayxanshik API Server" confirm'
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" install "Chayxanshik API Server" "${INSTALL_DIRECTORY}\chayxanshik.exe"'
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" set "Chayxanshik API Server" AppDirectory "${INSTALL_DIRECTORY}"'
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" set "Chayxanshik API Server" AppStdout "${INSTALL_DIRECTORY}\chayxanshik.log"'
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" set "Chayxanshik API Server" AppStderr "${INSTALL_DIRECTORY}\chayxanshik.log"'
SectionEnd

!if ${INCLUDE_SQL} = 1
    Section 
        File "postgresql-14.6-1-windows-x64.exe"
        ExecWait '"${INSTALL_DIRECTORY}\postgresql-14.6-1-windows-x64.exe" --mode unattended --unattendedmodeui minimal --superpassword masterkey'
        Sleep 15000
        System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("PGPASSWORD", "masterkey").r0'
        ExecWait '"C:\Program Files\PostgreSQL\14\bin\psql.exe" -U postgres -c "CREATE DATABASE chayxanshik;'
        Sleep 5000
    SectionEnd
!endif

Section
    ExecWait '"${INSTALL_DIRECTORY}\nssm.exe" restart "Chayxanshik API Server"'
SectionEnd