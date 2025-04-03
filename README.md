# Competitie de Informatica Online

Acest proiect este o aplicație de tip client-server care simulează o competiție de informatică online. Sistemul permite distribuirea problemelor, trimiterea soluțiilor, evaluarea automată și afișarea clasamentului în timp real.

## Funcționalități

- Comunicarea client-server prin socket-uri TCP
- Gestionarea conexiunilor multiple prin multithreading
- Evaluarea automată a soluțiilor transmise de participanți
- Stocarea persistentă a datelor cu ajutorul SQLite
- Comenzi simple pentru clienți (REGISTER, LOGIN, SUBMIT, etc.)
- Clasamente live și notificări către toți participanții

## Tehnologii

- **C (POSIX)**: programare rețea și multitasking
- **Socket-uri BSD**: conexiune TCP fiabilă între client și server
- **Multithreading (pthreads)**: gestionare concurentă a mai multor clienți
- **SQLite**: gestionare a utilizatorilor, problemelor și scorurilor

## Structură

- `server.c` – gestionează conexiunile, evaluează soluții, comunică cu baza de date
- `client.c` – trimite comenzi către server și primește răspunsuri
- `database.db` – baza de date SQLite
- `documentatie.pdf` – explicație detaliată a arhitecturii

## Cum se folosește

1. Compilează serverul și clientul:

```bash
gcc -o server server.c -lpthread -lsqlite3
gcc -o client client.c
```

2. Pornește serverul:

```bash
./server
```

3. Pornește unul sau mai mulți clienți în terminale separate:

```bash
./client
```

## Exemple de comenzi

- `REGISTER nume_utilizator`
- `LOGIN nume_utilizator`
- `START_CONTEST 30` (doar pentru admin)
- `GET_PROBLEM`
- `SUBMIT_SOLUTION solutie.c`
- `GET_SCOREBOARD`
- `QUIT`

## Posibile Extensii

- Suport pentru evaluarea paralelă a soluțiilor
- Interfață grafică pentru administratori
- Analiză statistică a performanței participanților

## Autor

Proiect realizat de **Ioan Virlescu**  
Universitatea Alexandru Ioan Cuza, Facultatea de Informatică
