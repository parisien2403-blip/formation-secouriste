@echo off
title Bilan Secouriste
cd /d "%~dp0"
echo.
echo  Ouvrez sur le telephone (meme Wi-Fi) :
echo  https://VOTRE-IP:8443/
echo.
echo  Ou sur ce PC : demarrez le serveur du projet suivi-mission
echo  et copiez ce dossier dans suivi-mission/formation-secouriste-site/
echo.
start "" "http://localhost:8080/"
pause
