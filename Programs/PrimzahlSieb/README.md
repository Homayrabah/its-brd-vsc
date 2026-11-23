# PrimzahlSieb – Praktikumsaufgabe Woche 4

**Modul:** Grundlagen der Technischen Informatik (GTP), HAW Hamburg  
**Thema:** Einstieg in die effektive Nutzung von Kontrollstrukturen  
**Aufgabe:** Vorbereitung eines Assemblerprogramms zur Berechnung aller Primzahlen von 2 bis 1000.

## 1. Analyse der Aufgabenstellung

Gesucht sind alle **Primzahlen von 2 bis einschließlich 1000**. Eine Primzahl ist eine natürliche Zahl größer als 1, die nur durch 1 und sich selbst teilbar ist.

Verwendet wird das **Sieb des Eratosthenes**. Dabei kennzeichnen wir in einem Feld zunächst die Zahlen 2 bis 1000 als mögliche Primzahlen. Anschließend streichen wir schrittweise die Vielfachen jeder noch nicht gestrichenen Zahl, beginnend bei ihrem Quadrat. Übrig bleiben die Primzahlen.

Das Programm ist in zwei logische Teilfunktionen eingeteilt:

1. **Sieb:** Ermittelt für jede Zahl, ob sie eine Primzahl ist.
2. **Abspeichern:** Liest das Sieb und speichert die tatsächlichen Primzahlen in einem zweiten Feld.

**Aktueller Arbeitsstand:** Die Datei `main.s` enthält gemäß Aufgabenstellung **ausschließlich Kommentare** und noch keinen Assemblercode. Das vorliegende Konzept dient als Vorbereitung für die spätere Implementierung.

## 2. Algorithmus als Pseudocode

```text
KONSTANTE MAX = 1000
FELD sieb[0..1000] vom Typ Byte
FELD primzahlen[0..167] vom Typ 32-Bit-Ganzzahl

// Initialisierung
sieb[0] = 0
sieb[1] = 0
FÜR i VON 2 BIS MAX:
sieb[i] = 1

// Initialisierung
sieb[0] = 0
sieb[1] = 0
FÜR i VON 2 BIS MAX:
sieb[i] = 1

// Teilfunktion 1: Sieb
p = 2
SOLANGE p * p <= MAX:
WENN sieb[p] == 1:
vielfaches = p * p
SOLANGE vielfaches <= MAX:
sieb[vielfaches] = 0
vielfaches = vielfaches + p
p = p + 1```

**Wesentliche Kontrollstrukturen:** `FÜR`-Schleifen und `SOLANGE`-Schleifen für wiederholte Arbeit sowie `WENN`-Bedingungen, um bereits gestrichene Zahlen zu überspringen und nur Primzahlen zu speichern. In Assembler werden diese später unter anderem durch Vergleiche und Sprünge umgesetzt.

## 3. Warum startet das Streichen bei p²?

Bei `p = 5` beginnen wir bei `25` statt bei `10`. Denn `10 = 2 × 5`, `15 = 3 × 5` und `20 = 4 × 5` wurden bereits durch kleinere Primfaktoren gestrichen. Beim Streichen der Vielfachen von 11 beginnen wir mit `121 = 11 × 11`.

Die Siebphase kann enden, wenn `p × p > 1000`. Denn jede zusammengesetzte Zahl bis 1000 besitzt mindestens einen Primfaktor, der höchstens √1000 ≈ 31,62 ist. Die Zahl 31 wird noch geprüft; bei 32 endet die Schleife.

## 4. Speicheraufbau und Datentypen

### Feld 1 – `sieb`

- **Typ:** Array mit **1001 Bytes**, Index 0 bis 1000.
- **Werte:** `1` = bisher als prim markiert, `0` = keine Primzahl.
- **Wichtig:** Die Zahlen selbst sind **Feldindizes**, nicht Werte im Feld.

Beispiel **nach Abschluss des Siebs**:

| Index (= Zahl) | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `sieb[index]` | 0 | 0 | 1 | 1 | 0 | 1 | 0 | 1 | 0 | 0 | 0 | 1 |

### Feld 2 – `primzahlen`

- **Typ:** Array mit **168 vorreservierten 32-Bit-Ganzzahlen** (je 4 Bytes).
- **Werte:** Die tatsächlichen Primzahlen, aufsteigend sortiert.
- **Speicherbedarf:** 168 × 4 = **672 Bytes**.

| Speicherindex | 0 | 1 | 2 | 3 | 4 | ... | 167 |
|---|---|---|---|---|---|---|---|
| `primzahlen[index]` | 2 | 3 | 5 | 7 | 11 | ... | 997 |

Die konkrete Speicherdarstellung und zulässige Datendirektiven werden in den nächsten Praktikumsterminen an die verwendete Assemblerumgebung angepasst. Die Größen hier sind ein **konzeptioneller Vorschlag**.

### Weitere Variablen

| Name | Zweck | Datentyp (konzeptionell) |
|---|---|---|
| `p` | Momentan geprüfter Primzahlkandidat | Integer |
| `vielfaches` | Gerade zu streichender Feldindex | Integer |
| `i` | Laufindex beim Initialisieren und Abspeichern | Integer |
| `anzahlPrimzahlen` | Anzahl gefundener Primzahlen und Schreibindex | Integer |
| `MAX` | Obergrenze 1000 | Konstante |

### Grafische Speicherskizze (schematisch)

```text
                 SPEICHER
+-------------------------------------------+
| sieb: 1001 × 1 Byte                       |
| Index:  0  1  2  3  4  5  6  7  ...  1000 |
| Inhalt: 0  0  1  1  0  1  0  1  ...  0    |
+-------------------------------------------+
                     |
                     | Alle Indizes mit Wert 1
                     v
+-------------------------------------------+
| primzahlen: 168 × 4 Byte                  |
| Index:    0   1   2   3   4 ... 167       |
| Inhalt:   2   3   5   7  11 ... 997       |
+-------------------------------------------+
| p | vielfaches | i | anzahlPrimzahlen     |
+-------------------------------------------+
```

*Die Zeichnung zeigt logische Speicherbereiche, keine festgelegten physischen Speicheradressen.*

## 5. Beispiel mit den Zahlen 2 bis 30

1. Zuerst sind 2 bis 30 als mögliche Primzahlen markiert.
2. Bei **2** streichen wir 4, 6, 8, 10, ... 30.
3. Bei **3** streichen wir ab 9 die Zahlen 9, 12, 15, ... 30.
4. Bei **4** passiert nichts: Die 4 ist bereits gestrichen.
5. Bei **5** streichen wir ab 25 die Zahl 25, 30 wäre schon gestrichen.
6. Bei **6** endet die Siebschleife, da 6 × 6 > 30.
7. Übrig bleiben **2, 3, 5, 7, 11, 13, 17, 19, 23, 29**.

## 6. Kontrolle des Ergebnisses

Bei einer späteren Ausführung prüfen wir insbesondere:

- Die **1** wird nicht als Primzahl ausgegeben.
- **4, 9, 25, 121** werden als nicht prim markiert.
- **2, 3, 5, 7, 11, 997** bleiben als Primzahlen markiert.
- Das Ergebnis enthält **168 Primzahlen**.
- Keine Zahl außerhalb des Bereichs 2 bis 1000 wird in das zweite Feld geschrieben.

## 7. Offene Punkte / noch nicht gelöste Aufgaben

Die folgenden Punkte sind **noch nicht implementiert**, da zunächst ausdrücklich nur ein Konzept gefordert ist:

- **Assembler-Umsetzung** der Schleifen und Bedingungen – muss an den im Praktikum verwendeten Befehlssatz angepasst werden.
- **Konkrete Speicherreservierung und Byte-/Wort-Zugriffe** – die genaue Assemblersyntax und Speicherorganisation sind zu klären.
- **Test in der Assemblerumgebung** – erst nach der Umsetzung ausführbar.