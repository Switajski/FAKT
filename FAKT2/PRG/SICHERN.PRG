PROCEDURE sichern
* ------------ Bildschirmaufbau --------------------------------------
WOPEN(11,10,21,60)
SET COLOR TO &farb3
WBOX()
   ? "                     UWAGA   "
   ? "                 Prosze czekac  "
   ?
   ?   FILECOPY("e:\clo\sad_bw.xml","A:\sad_bw.xml")
   ?? "  bitow skopiowanych na dyskietke"
   ?
   ?
   ?  "           Nacisnij dowolny klawisz"
   INKEY(0)
WCLOSE()

RETURN