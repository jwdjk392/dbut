ECHO ================================
ECHO 사용가능한 DNS 서버 찾는중...
ECHO ================================
setlocal enabledelayedexpansion
set server[0].ip = "8.8.8.8"
set server[0].doh = "https://dns.google/dns-query"
set server[1].ip = "1.1.1.1"
set server[1].doh = "https://cloudflare-dns.com/dns-query"
set server[2].ip = "9.9.9.9"
set server[2].doh = "https://dns.quad9.net/dns-query"
FOR /L %%i IN (0, 1, 2) DO (
    CALL ECHO SERVER = %%server[%%i].ip%%

)