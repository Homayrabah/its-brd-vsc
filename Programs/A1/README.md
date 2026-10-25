# GTP – Praktikumsaufgabe 1
**Thema:** Einführung in die VSCode-IDE und Assemblerprogrammierung

## 1. Ziel der Aufgabe

In dieser Aufgabe sollte ein vorhandenes Assemblerprogramm für das ITS-Board untersucht und optimiert werden. Dabei ging es auch darum, den Umgang mit VS Code, dem Build-Prozess und dem Debugger kennenzulernen.

## 2. Ausgangssituation

Als Grundlage wurde die Datei `main_w1.s` verwendet und in das Projekt `A1ASM` übernommen.

Das ursprüngliche Programm enthält acht `STRB`-Anweisungen, mit denen die LEDs nacheinander ein- und ausgeschaltet werden.

## 3. Durchführung und Optimierung

Zuerst habe ich den ursprünglichen Code untersucht und den gewünschten Endzustand anhand der Anweisungen bestimmt.

Anschließend habe ich die nicht mehr benötigten `MOV`-Anweisungen auskommentiert und die acht `STRB`-Anweisungen durch zwei ersetzt.

Dafür habe ich folgende Bitmasken verwendet:

- `0x03` zum Einschalten von D08 und D09
- `0xC0` zum Ausschalten von D14 und D15

Der optimierte Programmabschnitt:

```asm
MOV  R0, #0x03
MOV  R1, #0xC0

STRB R0, [R6]
STRB R1, [R7]

b .
```

Damit wird der gewünschte Endzustand direkt eingestellt, ohne die LEDs vorher mehrfach umzuschalten.

## 4. Ergebnisse

Das optimierte Programm konnte erfolgreich übersetzt werden.

**Build-Ergebnis:** `2 succeeded, 0 failed`

Sowohl die Debug- als auch die Release-Version wurden erstellt.

Der erwartete Endzustand laut Programm ist:

| LED | Zustand |
|---|---|
| D08 | EIN |
| D09 | EIN |
| D14 | AUS |
| D15 | AUS |

Dieser Zustand wurde bisher noch nicht auf dem ITS-Board überprüft.

## 5. Probleme und offene Fragen

**Problem 1 – Assemblerfehler**

Beim ersten Build wurde die Anweisung `b.` nicht erkannt. Nach der Korrektur zu `b .` konnte das Programm erfolgreich übersetzt werden.

**Problem 2 – Debugger-Verbindung**

Das ST-Link-Gerät wird von macOS über USB erkannt. Allerdings zeigt pyOCD die Meldung:

`No available debug probes are connected`

Deshalb konnten die Registerinhalte und die LED-Zustände noch nicht mit dem Debugger untersucht werden.

**Offene Fragen:**

- Wie lässt sich die Verbindung zwischen pyOCD und ST-Link herstellen?
- Wie kann ich die Registerinhalte während der Programmausführung kontrollieren?
- Stimmen die Kommentare zu den LED-Zuständen mit dem tatsächlichen Verhalten des Boards überein?

## 6. Fazit

Die Optimierung wurde umgesetzt und das Programm erfolgreich kompiliert. Die Anzahl der `STRB`-Anweisungen wurde von acht auf zwei reduziert.

Die praktische Überprüfung mit Breakpoints und Registeranzeige steht noch aus und soll im Praktikum durchgeführt werden.git remote -v