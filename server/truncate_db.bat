@echo off
setlocal

echo "This script will delete all sale and warehouse operations"
pause

set PGHOST=localhost
set PGPORT=5432
set PGDATABASE=r_pos
set PGUSER=postgres

set SQLFILE=.\truncate_operations.sql

"C:\Program Files\PostgreSQL\14\bin\psql.exe" -h %PGHOST% -p %PGPORT% -U %PGUSER% -d %PGDATABASE% -f %SQLFILE%

endlocal
pause
