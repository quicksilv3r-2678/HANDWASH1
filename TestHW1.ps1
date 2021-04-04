<# 
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░ Invoke-Hw1 / HANDWASH1 t3st scr1pt
░░ j00 must set -textFilePath or befαll l4mers' wrath!
░░ Also be sure to set $Env:INCLUDE to location of format.inc
░░ for fasmg.
░░
░░ Exαmpl3 usagε                                              
░░ PS «c0d3 f0ld3r»\HANDWASH1> $env:INCLUDE = "c:\\fasmg\\examples\\x86\\include"
░░ PS «c0d3 f0ld3r»\HANDWASH1> . .\TestHW1.ps1
░░ PS> Invoke-Hw1 $Env:windir\\System32\\slmgr.vbs
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
 #>
 Function Invoke-Hw1 {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$textFilePath
    )    

    $textFileName = Split-Path $textFilePath -leaf
    Copy-Item "$textFilePath" -Destination .\$textFileName
    fasm.exe HANDWASH1.ASM HANDWASH1.EXE
    .\HANDWASH1.exe $textFileName    
}
