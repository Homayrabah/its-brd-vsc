;************************************************
;* Beginn der globalen Daten *
;************************************************
                   AREA MyData, DATA, align = 2
Base
VariableA          DCW 0x1234
VariableB          DCW 0x4711

VariableC          DCD  0

MeinHalbwortFeld   DCW 0x22 , 0x3e , -52, 78 , 0x27 , 0x45

MeinWortFeld       DCD 0x12345678 , 0x9dca5986
                   DCD -872415232 , 1308622848
                   DCD 0x27000000
                   DCD 0x45000000

MeinTextFeld       DCB "ABab0123",0

                   EXPORT VariableA
                   EXPORT VariableB
                   EXPORT VariableC
                   EXPORT MeinHalbwortFeld
                   EXPORT MeinWortFeld
                   EXPORT MeinTextFeld

;***********************************************
;* Beginn des Programms *
;************************************************
    AREA |.text|, CODE, READONLY, ALIGN = 3
; ----- S t a r t des Hauptprogramms -----
                EXPORT main
                EXTERN initITSboard
main            PROC
                bl    initITSboard                 ; HW Initialisieren

; Laden von Konstanten in Register
; Eigener Test zu Anw-01:
; Ich habe den Wert 0x12 testweise auf 0x25 geaendert.
; Im Debugger habe ich danach R0 = 0x25 beobachtet.
; Das Ergebnis entsprach meiner Erwartung.
; Anschliessend habe ich den Originalwert 0x12 wiederhergestellt.
; Die Zahl 0x12 wird direkt in R0 gespeichert.
; Hexadezimal 0x12 entspricht dezimal 18.
; R0 enthaelt danach 0x00000012.
                mov   r0,#0x12                     ; Anw-01
; Die negative Zahl -128 wird in R1 gespeichert.
; Negative Zahlen werden im Zweierkomplement dargestellt.
; In 32 Bit entspricht -128 dem Wert 0xFFFFFF80.
                mov   r1,#-128                      ; Anw-02
			; Die Konstante 0x12345678 wird in R2 geladen.
; Der Assembler kann dafuer einen Speicherplatz
; fuer die Konstante anlegen (Literal Pool).
; Die tatsaechliche Anweisung kann man im
; Disassembly View kontrollieren.
; R2 enthaelt danach 0x12345678.	
                ldr   r2,=0x12345678                ; Anw-03

; Zugriff auf Variable
; Die Adresse von VariableA wird in R0 geladen.
; R0 enthaelt danach die Adresse und nicht den Wert.
; Beim Debuggen war diese Adresse 0x2000000C.
                ldr   r0,=VariableA                 ; Anw-04
; Es werden 16 Bit (2 Bytes) von der Adresse
; in R0 gelesen und in R1 gespeichert.
; VariableA enthaelt den Wert 0x1234.
; LDRH erweitert den Wert mit Nullen auf 32 Bit.
; R1 ist danach 0x00001234.
; Die Adresse in R0 bleibt unveraendert.	
                ldrh  r1,[r0]                       ; Anw-05
; LDR liest 32 Bit, also insgesamt 4 Bytes.
; VariableA und VariableB haben jeweils 2 Bytes.
; Dadurch werden beide Variablen zusammen gelesen.
; Wegen Little Endian steht danach
; 0x47111234 in R2.
; R0 bleibt unveraendert.				
                ldr   r2,[r0]                       ; Anw-06
; Der Wert aus R2 wird in VariableC gespeichert.
; Die Zieladresse berechnet sich aus R0 plus
; der Differenz VariableC - VariableA.
; Es werden 32 Bit (4 Bytes) geschrieben.
; VariableC enthaelt danach 0x47111234.
; R0 und R2 werden dabei nicht veraendert.			
                str   r2,[r0,#VariableC-VariableA]  ; Anw-07

; Zugriff auf Felder (Speicherzellen)
; Die Anfangsadresse von MeinHalbwortFeld
; wird in R0 geladen.
; Das Feld hat 6 Elemente mit jeweils 2 Bytes.
; Die Anfangsadresse war beim Debuggen 0x20000014.
; Es wird hier noch kein Feldelement gelesen.
                ldr   r0,=MeinHalbwortFeld          ; Anw-08
; Das erste Element (Index 0) wird gelesen.
; LDRH liest 16 Bit von der Adresse in R0.
; Der Wert 0x22 wird in R1 gespeichert.
; R0 bleibt unveraendert.				
                ldrh  r1,[r0]                       ; Anw-09
; Der Offset 2 bedeutet: 2 Bytes weitergehen.
; Da jedes Element 2 Bytes hat, kommen wir
; zum zweiten Element mit dem Index 1.
; Dieses Element hat den Wert 0x3E.
; R2 enthaelt danach 0x0000003E.
; R0 wird nicht veraendert.				
                ldrh  r2,[r0,#2]                    ; Anw-10
; Die Dezimalzahl 10 wird in R3 gespeichert.
; Hexadezimal entspricht das 0xA.
; R3 wird danach als Offset benutzt.				
                mov   r3,#10                        ; Anw-11
; Die Adresse wird aus R0 + R3 berechnet.
; R3 enthaelt 10, also gehen wir 10 Bytes weiter.
; Jedes Element hat 2 Bytes.
; 10 / 2 = 5, also wird Element mit Index 5 gelesen.
; Dort steht der Wert 0x45.
; Dieser Wert wird in R4 gespeichert.
; R0 und R3 bleiben unveraendert.				
                ldrh  r4,[r0,r3]                    ; Anw-12
; R0 wird zuerst um 2 Bytes erhoeht.
; Das Ausrufezeichen ! bedeutet Writeback:
; Die neue Adresse wird in R0 gespeichert.
; R0 zeigt danach auf Element mit Index 1.
; Von dieser Adresse werden 16 Bit gelesen.
; R5 enthaelt danach 0x0000003E.
                ldrh  r5,[r0,#2]!                   ; Anw-13
; R0 wird nochmals um 2 Bytes erhoeht.
; Danach zeigt R0 auf Element mit Index 2.
; Dieses Element enthaelt die Zahl -52.
; Als 16-Bit-Zweierkomplement ist das 0xFFCC.
; LDRH liest ohne Vorzeichen.
; Deshalb wird der Wert auf 32 Bit mit Nullen erweitert.
; R6 enthaelt danach 0x0000FFCC.				
                ldrh  r6,[r0,#2]!                   ; Anw-14
; R0 wird wieder um 2 Bytes erhoeht.
; Mit ! wird die neue Adresse in R0 gespeichert.
; R0 zeigt danach auf Element mit Index 3.
; STRH schreibt die unteren 16 Bit von R6
; in dieses Element.
; Der alte Wert 78 (0x004E) wird ueberschrieben.
; Der neue Wert ist 0xFFCC.	
; R6 bleibt unveraendert.			
                strh  r6,[r0,#2]!                   ; Anw-15

; Addition und Subtraktion von unsigned / signed Integer-Werten
; Die Anfangsadresse von MeinWortFeld wird
; in R0 geladen.
; Das Feld besteht aus 6 Elementen.
; Jedes Element hat 32 Bit, also 4 Bytes.
                ldr  r0,=MeinWortFeld               ; Anw-16
; Das erste 32-Bit-Element wird gelesen.
; Es hat den Wert 0x12345678.
; Dieser Wert wird in R1 gespeichert.
; R0 bleibt unveraendert.				
                ldr  r1,[r0]                        ; Anw-17
; Das zweite Element wird mit Offset 4 gelesen.
; Da jedes Element 4 Bytes hat, ist das Index 1.
; Der Wert 0x9DCA5986 wird in R2 gespeichert.
; R0 bleibt unveraendert.				
                ldr  r2,[r0,#4]                     ; Anw-18
; Die Inhalte von R1 und R2 werden addiert.
; Das 32-Bit-Ergebnis wird in R3 gespeichert.
; R3 enthaelt danach 0xAFFEAFFE.
; Das S bedeutet, dass die Statusflags
; N, Z, C und V aktualisiert werden.
; N=1: Das hoechste Bit des Ergebnisses ist 1.
; Z=0: Das Ergebnis ist nicht Null.
; C=0: Kein Carry aus Bit 31.
; V=0: Kein Signed Overflow.
; Signed und Unsigned sind beide darstellbar.				
                adds r3,r1,r2                       ; Anw-19
		
; Das dritte Element wird mit Offset 8 gelesen.
; Sein Wert ist -872415232.
; Als 32-Bit-Muster entspricht das 0xCC000000.
; Der Wert wird in R4 gespeichert.
; R0 bleibt unveraendert.				

                ldr  r4,[r0,#8]                     ; Anw-20
; Das vierte Element wird mit Offset 12 gelesen.
; Der Wert 1308622848 entspricht 0x4E000000.
; Dieser Wert wird in R5 gespeichert.
; R0 bleibt unveraendert.				
                ldr  r5,[r0,#12]                    ; Anw-21
; R5 wird von R4 subtrahiert: R4 - R5.
; Das 32-Bit-Ergebnis wird in R6 gespeichert.
; R6 enthaelt danach 0x7E000000.
; Das rechnerische Signed-Ergebnis ist
; -2181038080 und liegt ausserhalb
; des 32-Bit-Signed-Bereichs.
; Deshalb gibt es einen Signed Overflow.
; V=1: Signed Overflow.
; C=1: Kein Borrow bei der Unsigned-Subtraktion.
; N=0: Das hoechste Ergebnisbit ist 0.
; Z=0: Das Ergebnis ist nicht Null.
; Signed: Nicht Ok, Unsigned: Ok.				
                subs r6,r4,r5                       ; Anw-22
; Das fuenfte Element wird gelesen.
; Der Offset ist 16 Bytes, also Index 4.
; R7 enthaelt danach 0x27000000.
; R0 bleibt unveraendert.
                ldr  r7,[r0,#16]                    ; Anw-23
; Das sechste Element wird gelesen.
; Der Offset ist 20 Bytes, also Index 5.
; R8 enthaelt danach 0x45000000.
; R0 bleibt unveraendert.				
                ldr  r8,[r0,#20]                    ; Anw-24
 ;R8 wird von R7 subtrahiert: R7 - R8.
; R9 enthaelt danach das Ergebnis 0xE2000000.
; Als Signed-Zahl entspricht das -503316480.
; Dieses Signed-Ergebnis ist darstellbar.
; Als Unsigned-Subtraktion ist das Ergebnis
; negativ und es entsteht ein Borrow.
; V=0: Kein Signed Overflow.
; C=0: Borrow ist aufgetreten.
; N=1: Das hoechste Ergebnisbit ist 1.
; Z=0: Das Ergebnis ist nicht Null.
; Signed: Ok, Unsigned: Nicht Ok.				
                subs r9,r7,r8                       ; Anw-25
; Das Programm springt immer wieder zur Marke forever.
; Dadurch entsteht eine Endlosschleife.
; Das Programm bleibt an dieser Stelle.
forever         b   forever                         ; Anw-26
                ENDP
                END