             

           ;THIS IS ir obstruction  detector
           
           ;P2.0 = BUZZ
           
           ;P2 = DISP DATA
           ;P3.2 = RS
           ;P3.3 = R/W
           ;P3.2 = EN
           
           ;P1.0 = SENSOR
           
  
  ORG 0
  LJMP START
  ORG 0050H



START: 
       CLR P1.1
       CLR P1.2

       
       LCALL LCDINI
       
       LCALL SEC 
       
       
        MOV DPTR,#0900H
        LCALL TLINE
        MOV DPTR,#0910H
        LCALL BLINE
       
        LCALL SSEC


;********* READ STATUS   ***********        
MAIN:   SETB P1.1
        CLR P1.2

        
        MOV DPTR,#0920H
        LCALL TLINE
        MOV DPTR,#0930H
        LCALL BLINE
        
XXCC:   LCALL SEC
        
        ;SETB P1.2
        LCALL IRCHK
        CJNE R0,#01H,MAIN
        
        MOV DPTR,#0940H
        LCALL TLINE
        MOV DPTR,#0950H
        LCALL BLINE
        
        SETB P1.2
        LCALL SSEC
        LCALL SEC
        CLR P1.1
        LCALL SSEC
        LJMP XXCC

;**************************************        

IRCHK:  MOV R0,#00H      
        ;SETB P1.1
        LCALL DEL

KX0:    JB P1.0,KX1
        LCALL DDEL
        JB P1.0,KX0
        
KX1:    LCALL SEC
        LCALL SEC
        JB P1.0,KX2
        LCALL DDEL
        JB P1.0,KX1

KX2:    JB P1.0,KX3
        LCALL DDEL
        JB P1.0,KX2
        
        MOV R0,#01H
        ;CLR P1.1
        RET
        
KX3:    MOV R0,#00H
        ;CLR P1.1
        RET

;----------------------
;******************************

DDEL:    MOV R5,#04H
EDR:     mov r4,#FFH
         djnz r4,$
         djnz r5,EDR
         RET     
;********** LCD INI ****************
LCDINI:      
        CLR P3.2
      
        CLR P3.2  
        CLR P3.3
        MOV P2,#30H
        LCALL WRI

        CLR P3.2  
        CLR P3.3
        MOV P2,#30H
        LCALL WRI

        CLR P3.2  
        CLR P3.3
        
        MOV P2,#30H
        LCALL WRI
      
        CLR P3.2  
        CLR P3.3
        MOV P2,#38H
        LCALL WRI


        CLR P3.2  
        CLR P3.3
        MOV P2,#01H
        LCALL WRI

        CLR P3.2  
        CLR P3.3
        MOV P2,#01H
        LCALL WRI

        CLR P3.2  
        CLR P3.3
        MOV P2,#01H
        LCALL WRI
      
        CLR P3.2  
        CLR P3.3
        MOV P2,#02H
        LCALL WRI
      

        CLR P3.2  
        CLR P3.3
        MOV P2,#0CH
        LCALL WRI
      
        CLR P3.2  
        CLR P3.3
        MOV P2,#1CH
        LCALL WRI
      
        CLR P3.2  
        CLR P3.3
        MOV P2,#38H
        LCALL WRI
      
        CLR P3.2  
        CLR P3.3
        MOV P2,#06H
        LCALL WRI
      
        CLR P3.2  
        CLR P3.3
        MOV P2,#01H
        LCALL WRI
        
        RET
;----------------------------
TLINE:   CLR P3.2  
         CLR P3.3
         MOV P2,#80H
         LCALL WRI
         MOV R7,#00H

TKL:     CLR A
         MOVC A,@A+DPTR
         MOV P2,A
         LCALL WRD
         INC DPTR
         INC R7
         CJNE R7,#10H,TKL
         RET
;-----------------------------

BLINE:   CLR P3.2  
         CLR P3.3
         MOV P2,#C0H
         LCALL WRI
         MOV R7,#00H
BKL:         
         CLR A
         MOVC A,@A+DPTR
         MOV P2,A
         LCALL WRD
         INC DPTR
         INC R7
         CJNE R7,#10H,BKL
         RET

;******** INSTRUCTION /DATA WRITE *********

WRI:   SETB P3.4
       MOV R0,#FFH
       DJNZ R0,$
       CLR P3.4
       MOV R0,#FFH
       DJNZ R0,$
       
       RET

WRD:   SETB P3.2 ; REGISTER
       CLR P3.3  ;READ WRITE
       SETB P3.4 ;ENABLE
       MOV R0,#FFH
       DJNZ R0,$
       CLR P3.4
       CLR P3.3
       CLR P3.2
       RET
;******************************


DEL:        MOV R7,#FFH
            DJNZ R7,$
            RET
DEL1:       MOV R7,#FFH
            DJNZ R7,$
            RET


SEC:        MOV R5,#0AH
 M1:        MOV R6,#FFH
 M2:        MOV R7,#FFH
 M3:        DJNZ R7,M3
            DJNZ R6,M2
            DJNZ R5,M1
            RET

SSEC:        MOV R5,#1FH
 SM1:        MOV R6,#FFH
 SM2:        MOV R7,#FFH
 SM3:        DJNZ R7,SM3
            DJNZ R6,SM2
            DJNZ R5,SM1
            RET
;***************************

       
       ORG 0900H
      ;************  1 LINE
      
      DB '  EYE BLINK     '
      DB '  SENSOR DETECT '
      
      DB ' NORMAL OK      '
      DB ' PLEASE PROCEED '
      
      DB ' ATTENTION PL.  '
      DB '  TAKE CARE     '
      
      ;-------------------------------
      END;



;AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA  
