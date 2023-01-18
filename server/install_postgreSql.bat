echo "НЕ ЗАКРЫВАЙТЕ ЭТО ОКНО, ОНО ЗАКРОЕТСЯ ПО ОКОНЧАНИЮ УСТАНОВКИ"
echo off
.\postgresql-14.6-1-windows-x64 --mode unattended --unattendedmodeui minimal --superpassword masterkey
set PGPASSWORD=masterkey
echo SELECT 'CREATE DATABASE chayxanshik' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'chayxanshik')\gexec |"%ProgramFiles%\PostgreSQL\14\bin\psql.exe" -U postgres