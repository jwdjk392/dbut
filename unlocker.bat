@ECHO OFF
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

COLOR 17
CLS
:INIT
ECHO ================================
ECHO 디벗 차단 해제 도구 By 배정완 v1.0.1
ECHO ================================
ECHO 면책조항: 제작자는 이 프로그램으로 발생하는 여러 결과를 책임지지 않습니다. 이 프로그램은 교육적 목적으로 제작되었습니다.
ECHO ================================
ECHO 작동원리:
ECHO * PC 보안 케어 서비스 (PCBoanCare Service)를 삭제합니다.
ECHO * DNS 설정을 변경합니다.
ECHO.
ECHO 경고: 삭제한 PC 보안케어 서비스는 복구할 수 없습니다.
ECHO ================================
ECHO 이 프로그램이 실행이 완료되면 자동으로 컴퓨터를 재부팅합니다. 중요한 자료가 있는 경우 지금 저장해주십시오.
ECHO 선택지에 응답하려면 Y (YES) 혹은 N (NO)를 키보드에서 누르면 됩니다.
ECHO ================================
PAUSE
CHOICE /T 30 /D N /M "위 사항에 동의하십니까"
IF %ERRORLEVEL% == 1 (
    GOTO CONTINUE
) ELSE (
    ECHO 계속 진행하려면 동의해야합니다.
    GOTO END
)

:CONTINUE
CLS
ECHO 동의 확인됨. 작업을 시작합니다.
ECHO ================================
ECHO 작업 진행중 PC 상태에 따라 일부 오류 메시지가 표시될 수 있습니다.
ECHO ================================
ECHO STEP 1. DNS 설정 변경

CHOICE /M "이 작업을 실행하시겠습니까"
IF %ERRORLEVEL% == 1 (
    GOTO CONTINUE2
) ELSE (
    ECHO 이 작업을 실행하지 않고 건너뜁니다. 필요한 경우 이 프로그램을 다시 실행해 조작을 진행할 수 있습니다.
    GOTO SKIP
)

:CONTINUE2
ECHO ================================
NETSH DNS SET GLOBAL DOH=YES
NETSH INTERFACE IPV4 DELETE DNSSERVER "Wi-Fi" all
NETSH DNS ADD ENCRYPTION SERVER=8.8.8.8 DOHTEMPLATE=https://dns.google/dns-query autoupgrade=yes udpfallback=no
NETSH INTERFACE IPV4 SET DNSSERVER "Wi-Fi" static 8.8.8.8 primary
IPCONFIG /FLUSHDNS
IPCONFIG /ALL
COPY internet_fix.bat %USERPROFILE%\Desktop
ECHO ================================
ECHO 설정값을 적용하였습니다. 정상적으로 적용되었다면 위쪽의 무선 LAN 어댑터 Wi-Fi 항목 아래에 DNS 서버 8.8.8.8 / DoH: https://dns.google/dns-query가 표시되어야합니다.
ECHO 만약 설정 이후 인터넷 연결이 작동하지 않는다면 바탕화면의 internet_fix.bat을 실행하십시오.
PAUSE

:SKIP
ECHO ================================
ECHO STEP 2. PC 보안케어 제거

CHOICE /M "이 작업을 실행하시겠습니까"
IF %ERRORLEVEL% == 1 (
    GOTO CONTINUE3
) ELSE (
    ECHO 이 작업을 실행하지 않고 건너뜁니다. 필요한 경우 이 프로그램을 다시 실행해 조작을 진행할 수 있습니다.
    GOTO END
)


:CONTINUE3
SC DELETE "PCBoanCare Service"
SC QUERY "PCBoanCare Service"
ECHO ================================
ECHO PC 보안케어 서비스를 삭제했습니다. 이 프로그램이 중지되려면 재부팅이 필요합니다.

ECHO PC 보안케어 서비스 제거를 완료하려면 다시 시작해야합니다.
CHOICE /T 30 /D Y /M "지금 다시 시작하시겠습니까? (응답하지 않을경우 30초 후 자동으로 다시 시작됩니다.)"
IF %ERRORLEVEL% == 1 (
    SHUTDOWN /S /T 0
)
:END
PAUSE