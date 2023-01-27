@echo off

set ubk=Update.bk.cmd

if not "%1"=="run" (
    copy /y "%~0" %ubk%
    %ubk% run
    del /f /q %ubk%
)

set maps_dir=sas.maps
set maps_url="http://parasite.kicks-ass.org:3000/sasgis/maps.git"

git version

echo Return code: %ERRORLEVEL%

if ERRORLEVEL 9009 (
    echo Ошибка: Не установлен Git
    start "" "https://git-scm.com/downloads"
    goto end
)

if not exist ".git\" (
    goto CloneRepo
) else (
    goto UpdateRepo
)

:CloneRepo
    echo Делаем клон репозитория с сервера
    rd /s /q %maps_dir%
    git clone %maps_url% %maps_dir%
    if not ERRORLEVEL 0 (
        echo Ошибка связи с сервером
        goto end
    )
    
    echo Копируем папку с репозиторием из подпапки в текущую папку
    xcopy /i /s /h /e /y %maps_dir%\.git .\.git
    if not ERRORLEVEL 0 (
        echo Ошибка копирования папки .git 
        goto end
    )
    
    echo Удаляем временно созданную подпапку
    rd /s /q %maps_dir%
    if not ERRORLEVEL 0 (
        echo Ошибка удаления временной папки sas.maps 
        goto end
    )
    goto UpdateRepo
 
:UpdateRepo
    echo Обновляем файлы до последней версии
    git fetch --all --verbose
    git clean -d -x --force --exclude="%ubk%"
    git reset --hard origin/master
    goto end
    
:end
    pause