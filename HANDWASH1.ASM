;         ▄ ▄ ▄     ▀      ▀      ▀              ▀      ▀      ▀     ▄ ▄ ▄
;      ▀▄▒▀▄▒█▓█▄ ▄▒▓▒▄  ▄▒▓▒▄  ▄▒▓▒▄ ▀ ▀ ▀ ▀  ▄▒▓▒▄  ▄▒▓▒▄  ▄▒▓▒▄ ▄█▓█▒▄▀▒▄▀
;    ▀▄▒▄▄▄▀▄▄▀▓▀▄▓▄▀▄▓▄▄▓▄▀▄▓▄▄▓▄▀▄▓▄█▄█▄█▄█▄▄▓▄▀▄▓▄▄▓▄▀▄▓▄▄▓▄▀▄▓▄▀▓▀▄▄▀▄▄▄▒▄▀
;  ▀▄▄█▀█▀▄▄▀     ▀   ▀  ▀   ▀  ▀   ▀ █▀▄▀▄▀▄▀ ▀   ▀  ▀   ▀  ▀   ▀     ▀▄▄▀█▀█▄▄▀
;  ░▒██▓█▄                                                                ▄█▓██▒░
;  ░▒██▓█▄                                                                ▄█▓██▒░
;  ▒▓█▓ ▀        ▌| HANDWASH1 ▐ - quicksilv3r - 2021                       ▀ ▓█▓▒
;  ░▓█                                                                        █▓░
;  ░░▓                      ▓        ▓▓      ▓▓        ▓                      ▓░░
;   ░▒▓                    ▓▒▓      ▓▒▒▓    ▓▒▒▓      ▓▒▓                    ▓▒░
;   ░░▒▓     ▒▓▓    ▓▓▓▓ ▒▓▒░▒▓    ▓▒░░▒▓  ▓▒░░▒▓    ▓▒░▒▓▒ ▓▓▓▓    ▓▓▒     ▓▒░░
;   ░▒░▒▓  ▓▒▓░▒▓  ▓▒░▒▓▓▓▒░ ░▒▓  ▓▒░  ░▒▓▓▒░  ░▒▓  ▓▒░ ░▒▓▓▓▒░▒▓  ▓▒░▓▒▓  ▓▒░▒░
;    ░▒░▒▓▒░░  ░▒▓▒░░ ░▒░▒░   ░▒▓▓▒░    ░▓▒░    ░▒▓▓▒░   ░▒░▒░ ░░▒▓▒░  ░░▒▓▒░▒░
;     ░ ▒░▒░    ░▒░ ░  ░ ░     ░▒▒░      ░░      ░▒▒░     ░ ░  ░ ░▒░    ░▒░▒ ░
;        ▒░      ░              ░░                ░░              ░      ░▒
;         ░                                                              ░

include 'format/format.inc'

format PE64 console
entry start

STD_OUTPUT_HANDLE       = -11

section '.text' code readable executable

start:
        sub     rsp,8*7         ; reserve stack for API use and make stack dqword aligned
        mov     rcx,STD_OUTPUT_HANDLE
        call    [GetStdHandle]
        mov     rcx,rax
        lea     rdx,[_data00]
        mov     r8d,_data00_length
        lea     r9,[rsp+4*8]
        mov     qword[rsp+4*8],0
        call    [WriteFile]
        mov     ecx,eax
        call    [ExitProcess]

section '.data' data readable writeable
    ; This message will get displayed every October 15
    _data00 db "Happy Global Handwashing Day!!!",13,10,13,10
            db "In the spirit of Handwashing Day,"            
            db "this utility reminds you to wash your hands.",13,10,0
    _data00_length = $ - _data00
    _note   db "[HANDWASH1]",0
            db "∙ « quicksilv3r » ∙'21",0    

section '.idata' import data readable writeable
    dd      0,0,0,RVA kernel_name,RVA kernel_table
    dd      0,0,0,0,0

kernel_table:
    ExitProcess     dq RVA _ExitProcess
    GetStdHandle    dq RVA _GetStdHandle
    WriteFile       dq RVA _WriteFile
                    dq 0

kernel_name     db 'KERNEL32.DLL',0
user_name       db 'USER32.DLL',0

_ExitProcess    db 0,0,'ExitProcess',0
_GetStdHandle   db 0,0,'GetStdHandle',0
_WriteFile      db 0,0,'WriteFile',0    