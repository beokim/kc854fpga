# kc854fpga

This is a recreation of a KC85/4 in VHDL. This computer is the last member of a series of homecomputers
from former East Germany: KC85/2, KC85/3 and KC85/4

They were all based on the Z80 and its peripherials (CTC/PIO) and a lot TTL logic. 

See https://en.wikipedia.org/wiki/KC_85 for more info.

Unfortunately almost none of its documentation or programms are available in english. For this reason i 
will continue in german after the break.

This design was tested on Terasic DE1 (Cyclone II) and Spartan 3 Starter (Spartan 3 xc3s400).

---

## Beschreibung
### CPU
- T80 mit Erweiterung um RETI hinauszuführen
- Takt 1,77305MHz (Abweichung zum Originaltakt von 1,7734476MHz)

### RAM
- 64 kB (CPU) + 64 kB (Video) + 32kB für Roms
- Bänke entsprechen einem Standard-KC85/4

### ROM
- 16kB Bootrom mit gepacktem CAOS 4.2+Basic 

### Video
- 320x256 => 960*768
- Ausgabe auf 1024x768@60Hz
- Scanlines zuschaltbar (SW1)
- Blinkeffekte (soweit möglich für das andere Videotiming) z.B. für Digger
- für Spartan 3 einfaches Dithering bei Farben mit halber Helligkeit

### Keyboard
- Nachbau der originalen Tastatur
- Steuerung über PS/2
- Sondertasten werden auf Funktionstasten gemappt

### Module
- M003 mit rudimentärer SIO für Datenübertragung eingebaut (reicht für Keyboard und Datenübertragung)
- Kanal 2 ist an die serielle Schnittstelle angeschlossen
- Achtung: Steuerleitungen für Hardwareflusskontrolle fehlen! Baudrate nicht zu stark erhöhen
- Flip-/Flop für Takthalbierung im M003 abschaltbar (SW2) dann standardmäßig 2400 Baud

## Bedienung
- Serielle Schnittstelle korrekt initialsiern (8n1 1200/2400 Baud)
- Upload von KCC-Files z.B. mit Shellscript (Cygwin)
- Bespielscript im Ordner <tape>

## ToDo's
- SDCard-Reader (?)
- D004 (?)
- Hires-Grafikmodus
- mehr Programme testen
- verschluckte Tastendrücke in Digger untersuchen
- besseres Upload-Programm auf PC-Seite (?)
- Timing-Constraints für Spartan3 überarbeiten
- Button für Warmstart

