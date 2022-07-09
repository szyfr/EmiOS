@echo off

set commitText=%1
set commitTag=%2

clear

git add *
git commit -m %commitText%

if "%commitTag%"=="-p" git push -u origin master