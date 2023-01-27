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
    echo �訡��: �� ��⠭����� Git
    start "" "https://git-scm.com/downloads"
    goto end
)

if not exist ".git\" (
    goto CloneRepo
) else (
    goto UpdateRepo
)

:CloneRepo
    echo ������ ���� ९������ � �ࢥ�
    rd /s /q %maps_dir%
    git clone %maps_url% %maps_dir%
    if not ERRORLEVEL 0 (
        echo �訡�� �裡 � �ࢥ஬
        goto end
    )
    
    echo �����㥬 ����� � ९����ਥ� �� �������� � ⥪���� �����
    xcopy /i /s /h /e /y %maps_dir%\.git .\.git
    if not ERRORLEVEL 0 (
        echo �訡�� ����஢���� ����� .git 
        goto end
    )
    
    echo ����塞 �६���� ᮧ������ ��������
    rd /s /q %maps_dir%
    if not ERRORLEVEL 0 (
        echo �訡�� 㤠����� �६����� ����� sas.maps 
        goto end
    )
    goto UpdateRepo
 
:UpdateRepo
    echo ������塞 䠩�� �� ��᫥���� ���ᨨ
    git fetch --all --verbose
    git clean -d -x --force --exclude="%ubk%"
    git reset --hard origin/master
    goto end
    
:end
    pause