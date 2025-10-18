**Context.** Implementați, în x86 Assembly (sintaxă AT&T), un modul simplificat de gestiune a unui dispozitiv de stocare pentru un „mini-sistem de operare”. Tema are două variante: memorie **unidimensională (1D)** și **bidimensională (2D)**. Evaluarea se face automat, pe baza formatului de intrare/ieșire.

## Specificații comune
- Capacitatea dispozitivului: **8 MB**, împărțită în blocuri de **8 kB**.
- **Un singur fișier per bloc.** Un fișier ocupă **cel puțin 2 blocuri**.
- Fisierele trebuie stocate **contiguu**; dacă nu se poate, operația de stocare eșuează.
- Identificare fișiere prin **descriptor (ID) unic** în **[1..255]** (max. 255 fișiere distincte).
- Operații suportate (prin STDIN):
  - **ADD** – „plasează” un fișier de o anumită dimensiune (kB) pe primul interval liber (first-fit).
  - **GET** – întoarce intervalul de blocuri în care e salvat un fișier.
  - **DELETE** – eliberează blocurile ocupate de un fișier (marcate cu `0`).
  - **DEFRAG** – compactează stocarea, eliminând golurile conform regulilor de mai jos.
- Pentru exemplificare/testare, enunțul folosește o **reprezentare simplificată**: tratează un bloc de 8 kB ca **8 B** (1 Byte) și aplică aceeași conversie memoriei, ca să fie ușor de demonstrat rezultatele în listări.

## Varianta 1 – Memorie unidimensională (1D)
- Memoria este modelată ca **o secvență liniară de blocuri**.
- **ADD**: găsește **primul interval liber** suficient de lung (parcurgere stânga→dreapta); dacă nu există, întoarce `(0, 0)`.
- **GET**: întoarce `(start, end)` pentru descriptorul căutat sau `(0, 0)` dacă nu există.
- **DELETE**: blochează intervalul ocupat de descriptor la `0` (eliberat).
- **DEFRAG**: rearanjează fișierele pentru a fi **compacte de la blocul 0**, fără goluri între ele.

## Varianta 2 – Memorie bidimensională (2D)
- Dispozitivul este o **matrice de blocuri**; o secțiune contiguă este considerată **pe linii**.
- **GET**: întoarce intervalul **`((startX, startY), (endX, endY))`** al fișierului sau `((0,0), (0,0))` dacă nu există.
- **ADD**: găsește **primul interval valid** (row-wise) unde încape fișierul; dacă nu se poate, întoarce `((0,0), (0,0))`.
- **DELETE**: eliberează blocurile fișierului (setează la `0`).
- **DEFRAG**: compactează astfel încât fișierele să fie **lipite** în matrice, iar **golurile să fie mutate în colțul dreapta-jos**.

## I/O (rezumat)
- Intrare: număr de operații `N`, apoi pentru fiecare operație cod și argumente:
  - `1` (ADD) → un `adds`, apoi `adds` perechi `(descriptor dim_kB)`
  - `2` (GET) → `descriptor`
  - `3` (DELETE) → `descriptor`
  - `4` (DEFRAG) → fără argumente
- Ieșire: intervalele cerute de operații (conform 1D sau 2D), ori `(0, 0)` / `((0,0),(0,0))` în caz de eșec/inexistent.

