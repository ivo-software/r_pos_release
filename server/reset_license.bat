@echo off
setlocal

echo "This script will delete current license"
pause

set "url=http://localhost:8001/api/system/license/generate_empty_license/"
curl -X POST -H "Content-Type: application/json" "%url%"

endlocal
pause