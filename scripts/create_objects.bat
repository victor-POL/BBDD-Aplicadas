@echo off
set PGPASSWORD=unlam

for %%f in (C:\Users\pc-vic\Desktop\BBDD-Aplicadas\scripts\*.sql) do (
    echo Ejecutando %%f
    psql -U postgres -d Com2900G11 -h localhost -f %%f >> C:\Users\pc-vic\Desktop\BBDD-Aplicadas\scripts\log.txt 2>&1
)