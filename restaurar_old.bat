@echo off
color 09

echo.
echo       _.-- ,.--.                          
echo     .'   .'    /                          
echo     ^| @       ^|'..--------._                          
echo    /      \._/              '.                          
echo   /  .-.-                     \                          
echo  (  /    \                     \                          
echo   \\      '.                  ^| #                          
echo    \\       \   -.           /                          
echo     :\       ^|    )._____.'   \                          
echo      "       ^|   /  \  ^|  \    )                          
echo              ^|   ^|./'  :__ \.-'                          
echo              '--'     
echo ==========================================
echo          Assistente de restauracao
echo          Para o banco Postgresql
echo                 Versao 1.0
echo ==========================================
echo.

echo.

echo Path do arquivo de entrada: %cd%
echo Alterando path
cd %~dp0
echo Path atual: %cd%
echo Caminho "%~0"

if "%~1"=="" (
    echo Arquivo nao informado.
    echo Arraste o arquivo .backup para esse arquivo.
    pause
    exit
) else (
    echo Arquivo a restaurar: "%~1"
)

set locase=for /L %%n in (1 1 2) do if %%n==2 ( for %%# in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do set "result=!result:%%#=%%#!") ELSE setlocal enableDelayedExpansion ^& set result=

set /p nomebanco= "Digite o nome do banco: " 

%locase%%nomebanco%


echo Confira se o nome esta certo '%result%'
echo.
echo Digite qualquer tecla para continuar
pause >nul

echo Verificando se existe o banco de dados

for /f %%a in ('psql -XtA -U postgres -c "select exists(SELECT datname FROM pg_catalog.pg_database WHERE lower(datname) = lower('%result%'))"') do set existe=%%a
if "%existe%"=="t" (
    echo O banco de dados '%result%' existe. Tenha em mente que o banco será sobrescrito
    pause
) else (
    echo O banco de dados '%result%' nao existe.
)


echo Criando banco de dados...
psql -U postgres -c "CREATE DATABASE %result%"

echo Alterando encoding para latin1
psql -U postgres -c "update pg_database set encoding = pg_char_to_encoding('LATIN1') where datname = '%result%'";

echo Restaurando o backup
pg_restore -c -h localhost -p 5432 -U postgres -d %nomebanco% -v "%~1"

echo Processo finalizado.
pause 
