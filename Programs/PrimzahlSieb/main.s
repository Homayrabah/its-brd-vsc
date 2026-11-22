// Praktikumsaufgabe 4 – PrimzahlSieb
// Thema: Effektive Nutzung von Kontrollstrukturen
// Ziel: Alle Primzahlen im Intervall 2 bis 1000 mit dem Sieb des Eratosthenes finden.
// ACHTUNG: In dieser Datei stehen absichtlich nur Kommentare, noch kein Assemblercode.
//
// 1. Speicher vorbereiten
// - Feld "sieb" für die Indizes 0 bis 1000 vorsehen (1001 Elemente, je 1 Byte).
// - Bedeutung: 1 = Zahl ist noch als Primzahl möglich; 0 = keine Primzahl.
// - Ein zweites Feld "primzahlen" vorsehen, das die gefundenen Zahlen speichert.
//   Für 2 bis 1000 gibt es 168 Primzahlen; bei 32-Bit-Zahlen: 168 * 4 Byte.
// - Variablen/Zähler für p (aktuelle mögliche Primzahl), vielfaches,
//   anzahlPrimzahlen und index bereithalten.
//
// 2. Feld initialisieren
// - sieb[0] = 0 und sieb[1] = 0 setzen, weil 0 und 1 keine Primzahlen sind.
// - Für alle Indizes 2 bis 1000: sieb[index] = 1 setzen.
//
// 3. Teilfunktion SIEB: Vielfache streichen
// - Mit p = 2 beginnen.
// - Solange p * p <= 1000 gilt:
//   - Falls sieb[p] = 1 (p ist noch nicht gestrichen):
//     - Bei vielfaches = p * p anfangen.
//     - Solange vielfaches <= 1000 gilt:
//       - sieb[vielfaches] = 0 setzen (nicht prim).
//       - vielfaches um p erhöhen.
//   - p um 1 erhöhen und erneut prüfen.
// - Begründung: Kleinere Vielfache als p*p wurden bereits durch kleinere
//   Primfaktoren gestrichen. Nach p = 31 muss nicht weiter gesiebt werden,
//   denn 32*32 > 1000.
//
// 4. Teilfunktion ABSPEICHERN: Primzahlen sammeln
// - anzahlPrimzahlen = 0 setzen.
// - Alle Zahlen index = 2 bis 1000 der Reihe nach durchgehen.
// - Wenn sieb[index] = 1 ist:
//   - Die Zahl index in primzahlen[anzahlPrimzahlen] speichern.
//   - anzahlPrimzahlen um 1 erhöhen.
// - Danach enthält das zweite Feld alle Primzahlen in aufsteigender Reihenfolge.
//
// 5. Ergebnis / Kontrolle
// - Erwartet werden 168 Primzahlen, die erste ist 2, die letzte ist 997.
// - Die spätere Assembler-Version soll die hier beschriebenen Bedingungen,
//   Schleifen und Speicherzugriffe umsetzen.
