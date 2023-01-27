@echo off
hg incoming "https://bitbucket.org/sas_team/sas.plus.maps/"
::echo %ERRORLEVEL%
IF ERRORLEVEL 9009 goto NoHg
IF ERRORLEVEL 255 goto CloneRepo
IF ERRORLEVEL 2 goto err
IF ERRORLEVEL 1 goto noupdates
IF ERRORLEVEL 0 goto ok
IF ERRORLEVEL -1 goto CloneRepo

goto err

:ok
        echo ����ࠥ� ��������� �� ९������
        hg pull "https://bitbucket.org/sas_team/sas.plus.maps/" -u -f
        IF ERRORLEVEL 1 goto err
        IF NOT ERRORLEVEL 0 goto err
	for /R /D %%d in (*.zmp) do rd /q %%d 2> nul
        goto end
:CloneRepo
	rd /s /q sas.plus.maps
	echo ������ ���� ९������ � �ࢥ�
	hg clone "https://bitbucket.org/sas_team/sas.plus.maps/" sas.plus.maps
        IF NOT ERRORLEVEL 0 goto err
	echo �����㥬 ����� � ९����ਥ� �� �������� � ⥪���� �����
	move /Y sas.plus.maps\.hg .\.hg
        IF NOT ERRORLEVEL 0 goto errMoveHg
	echo ����塞 �६���� ᮧ������ ��������
	rd /s /q sas.plus.maps
        IF NOT ERRORLEVEL 0 goto errRemoveTemp
	echo ������塞 䠩�� �� ��᫥���� ���ᨨ
	hg update -c
        goto end
:noupdates
        echo ��� ����� ���������
        goto end
:err
        echo �訡�� �裡 � �ࢥ஬
        goto end
:errMoveHg
        echo �訡�� ��६�饭�� ����� .hg 
        goto end
:errRemoveTemp
        echo �訡�� 㤠����� �६����� ����� sas.plus.maps 
        goto end
:NoHg
        echo �� ��⠭����� Mercurial
        goto end
:end
pause