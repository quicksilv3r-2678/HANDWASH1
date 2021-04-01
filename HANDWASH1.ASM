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
        ; get console standard handle
        sub     rsp,8 ; reserve stack
        mov     rcx,STD_OUTPUT_HANDLE
        call    [GetStdHandle]
        ;add     rsp,8 ; clear stack
        ; out: rax handle

        ; write _data00 to console
        ;sub     rsp,8*5 ; reserve stack «optimizing from previous function call»
        sub     rsp,8*4 ; reserve stack
        mov     qword[rsp+4*8],0 ; init dwBytesWritten to 0        
        lea     r9,[rsp+4*8] ; &dwBytesWritten
        mov     r8d,_data00_length ; dwBytesToWrite
        lea     rdx,[_data00] ; DataBuffer
        mov     rcx,rax ; hFile «stdout handle»
        call    [WriteConsoleA]
        ;add     rsp,8*5 ; clear stack
        ; out: rax -1 on error
        
        ;sub     rsp,8*5 ; reserve stack «optimizing from previous function call»
        push    [rsp+3*8] ; _StartInfo
        mov     r9, 0 ; _DoWildCard 
        lea     r8d,[rsp+2*8] ; _Env
        lea     rdx,[rsp+8] ; _Argv
        lea     rcx,[rsp] ; _Argc
        call [__getmainargs]        
        mov     rsi,[rdx]
        add     rsp,8*5 ; clear stack

        ; exit
        mov     ecx,0 ; uExitCode
        call    [ExitProcess]


; ≡≡≡≡≡≡≡≡≡≡≡ DATA SECTION ≡≡≡≡≡≡≡≡≡≡≡
section '.data' data readable writeable
    ; This message will get displayed every October 15
    _data00 db "Happy Global Handwashing Day!!!",13,10,13,10
            db "In the spirit of Handwashing Day,"            
            db "this utility reminds you to wash your hands.",13,10,0
    _data00_length = $ - _data00
    _note   db "[HANDWASH1]",0
            db "∙ « quicksilv3r » ∙'21",0    

; ≡≡≡≡≡≡≡≡≡≡≡ IMPORT SECTION ≡≡≡≡≡≡≡≡≡≡≡
section '.idata' import data readable writeable
    
; ≡≡≡ array of IMAGE_IMPORT_DESCRIPTOR structures ≡≡≡
    dd      0,0,0,RVA kernel_name,RVA kernel_table
    dd      0,0,0,RVA msvcrt_name,RVA msvcrt_table
    dd      0,0,0,0,0
; ≡≡≡

; ≡≡≡ array of IMAGE_THUNK_DATA structures ≡≡≡
kernel_table:
    ExitProcess     dq RVA _ExitProcess
    GetStdHandle    dq RVA _GetStdHandle
    WriteFile       dq RVA _WriteFile
    CreateFileA     dq RVA _CreateFileA
    WriteConsoleA   dq RVA _WriteConsoleA
                    dq 0
msvcrt_table:    
    __getmainargs   dq RVA ___getmainargs
                    dq 0
; ≡≡≡

kernel_name     db 'KERNEL32.DLL',0
;user_name       db 'USER32.DLL',0
msvcrt_name     db 'MSVCRT.DLL',0

; IMAGE_IMPORT_BY_NAME structure
_ExitProcess    db 0,0,'ExitProcess',0
_GetStdHandle   db 0,0,'GetStdHandle',0
_WriteFile      db 0,0,'WriteFile',0
_CreateFileA    db 0,0,'CreateFileA',0
_WriteConsoleA  db 0,0,'WriteConsoleA',0
___getmainargs  db 0,0,'__getmainargs',0