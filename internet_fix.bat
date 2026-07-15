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
ECHO 인터넷 접속 복구 도구 By 배정완 v1.0.1
ECHO ================================
ECHO 면책조항: 제작자는 이 프로그램으로 발생하는 여러 결과를 책임지지 않습니다. 이 프로그램은 교육적 목적으로 제작되었습니다.
ECHO ================================
ECHO 작동원리:
ECHO * unlocker에 의해 수정된 DNS 설정을 기본값 (자동 설정)으로 복구합니다.
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
NETSH DNS ADD ENCRYPTION SERVER=8.8.8.8 DOHTEMPLATE=https://dns.google/dns-query autoupgrade=no udpfallback=no
NETSH INTERFACE IPV4 DELETE DNSSERVER "Wi-Fi" all
NETSH INTERFACE IPV4 SET DNSSERVER "Wi-Fi" source=dhcp
IPCONFIG /FLUSHDNS
IPCONFIG /ALL
ECHO ================================
ECHO 설정값을 적용하였습니다.
ECHO ================================

:END
PAUSE