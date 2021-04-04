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

format PE64 ;console
entry start

;include 'format/format.inc'
include 'win64a.inc'

section '.bss' readable writeable

STD_OUTPUT_HANDLE       = -11
argc    dq ?
argv    dq ?
envp    dq ?
sinfo   STARTUPINFO

section '.text' code readable executable

start:        
        ; get console standard handle
        stackPointer equ rsp
        Math.sub equ sub
        Math.add equ add
        SetVar equ mov
        paramSize equ 8
        QuadWord equ qword
        CallFunc equ call
        LoadEffectiveAddress equ lea
        
        GetStdHandle.paramCount equ 1
        GetStdHandle.nStdHandle equ rcx
        GetStdHandle.totalParamSize equ GetStdHandle.paramCount * paramSize
        GetStdHandle.returned equ rax

        ; reserve stack
        Math.sub stackPointer, GetStdHandle.totalParamSize
        
        SetVar GetStdHandle.nStdHandle, STD_OUTPUT_HANDLE
        CallFunc [GetStdHandle.func]
        
        ; clear stack
        Math.add stackPointer, GetStdHandle.totalParamSize
        ; out: rax handle

        WriteConsoleA.paramCount equ 5
        WriteConsoleA.totalParamSize equ WriteConsoleA.paramCount * paramSize
        WriteConsoleA.dwBytesWrittenPtr equ QuadWord[stackPointer + 4 * paramSize]
        WriteConsoleA.dwBytesWrittenRef equ r9
        WriteConsoleA.dwBytesToWrite equ r8d
        WriteConsoleA.lpBuffer equ rdx
        WriteConsoleA.hFile equ rcx
        
        ; write _data00 to console
        ; reserve stack
        Math.sub stackPointer, WriteConsoleA.totalParamSize  
        
        ; reserve stack
        ;Math.sub stackPointer, 8*4
        SetVar WriteConsoleA.dwBytesWrittenPtr, 0
        LoadEffectiveAddress WriteConsoleA.dwBytesWrittenRef, WriteConsoleA.dwBytesWrittenPtr
        SetVar WriteConsoleA.dwBytesToWrite, _data00_length
        LoadEffectiveAddress WriteConsoleA.lpBuffer, [_data00]
        SetVar WriteConsoleA.hFile, GetStdHandle.returned
        CallFunc [WriteConsoleA.func]
         ; clear stack
        Math.add stackPointer, WriteConsoleA.totalParamSize
        ; out: rax -1 on error
        
        ;sub     rsp,8*5 ; reserve stack «optimizing from previous function call»
        ;push    [rsp+3*8] ; _StartInfo
        ;mov     r9, 0 ; _DoWildCard 
        ;lea     r8d,[rsp+2*8] ; _Env
        ;lea     rdx,[rsp+8] ; _Argv
        ;lea     rcx,[rsp] ; _Argc
        ;call [__getmainargs]
        ;mov     rsi,[rdx]

        sub rsp, 30 ; 8(align) + 8(5th arg) + 32(shadow space)
        lea rcx, [argc]
        lea rdx, [argv]
        lea r8, [envp]
        mov r9, 0
        mov qword [rsp + 8*4], sinfo
        call [__getmainargs]
        mov rax, [argv]

        mov rcx, qword [argc]
        push rax rcx
        mov rbx, rcx

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
    GetStdHandle.func dq RVA _GetStdHandle
    WriteFile       dq RVA _WriteFile
    CreateFileA     dq RVA _CreateFileA
    WriteConsoleA.func   dq RVA _WriteConsoleA
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