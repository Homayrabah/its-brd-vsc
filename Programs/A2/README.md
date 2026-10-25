# GTP – Praktikumsaufgabe Woche 2

## 1. Ziel der Aufgabe

In dieser Aufgabe lerne ich, wie der Prozessor Daten aus dem Speicher lädt, in Registern verändert und wieder speichert. Dabei untersuche ich verschiedene Assembler-Befehle.

## 2. Ausgangssituation

Im Programm gibt es folgende Werte:

- VariableA = 0xBEEF
- VariableB = 0x1234
- ConstByteA = 0xAFFE
- VariableC = 0x0000 (neu hinzugefügt)

Der STM32 verwendet Little Endian. Das bedeutet, dass das niederwertige Byte zuerst im Speicher steht.

Beispiel: 0xBEEF wird als EF BE gespeichert.

## 3. Untersuchung von Anw01 bis Anw06

Die folgenden Werte habe ich aus dem Code berechnet.

**Anw01 – LDR R0, =VariableA**

Die Adresse von VariableA wird in R0 geladen.

**Anw02 – LDRB R2, [R0]**

Das erste Byte wird in R2 geladen.

R2 = 0xEF

**Anw03 – LDRB R3, [R0,#1]**

Das zweite Byte wird in R3 geladen.

R3 = 0xBE

**Anw04 – LSL R2, #8**

R2 wird um 8 Bits nach links verschoben.

R2 = 0xEF00

**Anw05 – ORR R2, R3**

Die beiden Werte werden mit OR verbunden.

R2 = 0xEFBE

**Anw06 – STRH R2, [R0]**

R2 wird in VariableA gespeichert. Die Bytes ändern sich von EF BE zu BE EF.

R0 enthält bei allen sechs Schritten die Adresse von VariableA. Der Speicher bleibt bis Anw05 unverändert.

## 4. VariableC – 0xAFFE

Ich habe VariableC hinzugefügt, um den Wert 0xAFFE in der Reihenfolge AF FE zu speichern.

Normalerweise würde Little Endian FE AF speichern.

Mit LSL und LSR habe ich die Bytes verschoben und mit ORR verbunden:

0x00AF OR 0xFE00 = 0xFEAF

Mit STRH wird das Ergebnis gespeichert. Im Speicher stehen dann AF FE.

## 5. VariableB – 0x1234

Der Wert 0x1234 soll im Speicher als 12 34 stehen.

Dafür habe ich den Wert für R7 auf 0x21DE geändert.

Mit ADD wird gerechnet:

0x1234 + 0x21DE = 0x3412

Das Ergebnis wird in R6 gespeichert. Mit STRH wird es in VariableB geschrieben. Im Speicher stehen dann 12 34.

## 6. Probleme und Ergebnis

Am Anfang wurde mein Projekt automatisch als A2ASM erstellt. Ich habe es in A2 umbenannt und die Projektdateien angepasst.

Der Build war erfolgreich: 2 succeeded, 0 failed.

Die Werte habe ich bisher aus dem Code berechnet. Die Überprüfung mit dem Debugger auf dem ITS-Board steht noch aus.