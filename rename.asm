; *******************************************************************
; *** This software is copyright 2004 by Michael H Riley          ***
; *** You have permission to use, modify, copy, and distribute    ***
; *** this software so long as this copyright notice is retained. ***
; *** This software may not be used in commercial applications    ***
; *** without express written permission from the author.         ***
; *******************************************************************

include    bios.inc
include    kernel.inc

           org     2000h
begin:     br      start
           eever
           db      'Written by Michael H. Riley',0

start:
           lda     ra                  ; move past any spaces
           smi     ' '
           lbz     start
           dec     ra                  ; move back to non-space character
           ldn     ra                  ; get character
           lbnz    good                ; jump if non-zero
           sep     scall               ; otherwise display usage
           dw      o_inmsg
           db      'Usage: rename source dest',10,13,0
           ldi     0ah
           sep     sret                ; and return to os
good:      ghi     ra                  ; copy argument address to rf
           phi     rf
           glo     ra
           plo     rf
loop1:     lda     rf                  ; look for first less <= space
           smi     33
           bdf     loop1
           ghi     rf                  ; make copy of 2nd filename start
           phi     rc
           glo     rf
           plo     rc
           dec     rf                  ; backup to char
           ldi     0                   ; need proper termination
           str     rf
           inc     rf                  ; now find end of 2nd filename
loop_3:    lda     rf                  ; move past any spaces
           smi     ' '
           lbz     loop_3
           dec     rf                  ; move back to non-space character
           ldn     rf                  ; get character
           lbnz    loop2               ; jump if non-zero
           sep     scall               ; otherwise display usage
           dw      o_inmsg
           db      'Usage: rename source dest',10,13,0
           ldi     0ah
           sep     sret                ; and return to os
loop2:     lda     rf                  ; look for first less <= space
           smi     33
           bdf     loop2
           dec     rf                  ; backup to char
           ldi     0                   ; need proper termination
           str     rf
           ghi     ra                  ; get source filename
           phi     rf
           glo     ra
           plo     rf
           sep     scall               ; rename the file
           dw      o_rename
           bnf     renamed             ; jump if file was opened
           ldi     high errmsg         ; get error message
           phi     rf
           ldi     low errmsg
           plo     rf
           sep     scall               ; display it
           dw      o_msg
           ldi     0ffh
           sep     sret
renamed:   ldi     0
           sep     sret                ; return to os

errmsg:    db      'File not found',10,13,0

endrom:    equ     $

           end     begin
