Uzduotis:

Reikia sukurti bash skriptą, kuris archyvuotų apache access logų POST arba GET eilutes į failą, kuris papildomai 
būtų sukompresintas jūsų home direktorijoje tokia struktūra: 

/home/vartotojas/log/2012-10-09/log_12h_15min.log.tar.gz, kur failo varde yra laikas valanos ir minutės. 

Papildomai parašyti cron darbo eilutę, kuri būtų vygdoma, kiekvienos valandos 25 minutę tarp 08h ir 19h kas antrą pirmadienį.

Bonus užduotis ištrinti senus logus (kuriuos sukurė jūsų programa), kurie yra sukurti ankščiau nei prieš valandą. 
(hint: galima panaudoti "find -delete" komandą).
