# solve sudoku 

Acest program este scris in FreePascal si va rezolva matrici sudoku 9x9 din fisiere 
  
# Folosire:
Puteti folosi varianta compilata de mine `program` a fost compilat cu
`Free Pascal Compiler version 2.6.2-8 [2014/01/22] for x86_64         
Copyright (c) 1993-2012 by Florian Klaempfl and others        
Target OS: Linux for x86-64     `     

sau puteti compila codul sursa.


 Scop :
 Rezolvarea matricilor sudoku

 Fisierul este de contine pe fiecare linie o linie a matrici, elementele de pe linie sunt separate pintr-un spatiu, locurile goale sunt semnalate cu 0
    
   
 Urmatoarele obtiuni sunt disponibile :  
`  -f  `
`  -?  `
`  --help      `   : afiseaza ajutor
  


# Exemplu 

### Fisierul de intrare 
2 5 8 7 3 0 9 4 1  
6 0 9 8 2 4 3 0 7  
4 0 7 0 1 5 2 6 0  
3 9 5 2 7 0 4 0 6  
0 6 2 4 0 8 1 0 5  
8 4 0 6 5 0 7 2 9  
1 8 4 3 6 9 5 7 2  
0 7 0 1 4 2 0 9 3  
9 2 3 5 8 7 6 1 4   
  
    
    a  
### Va produce   
 Citim fisierul : examples/input.txt
   2    5    8    7    3    6    9    4    1   
   6    1    9    8    2    4    3    5    7   
   4    3    7    9    1    5    2    6    8   
   3    9    5    2    7    1    4    8    6   
   7    6    2    4    9    8    1    3    5   
   8    4    1    6    5    3    7    2    9   
   1    8    4    3    6    9    5    7    2   
   5    7    6    1    4    2    8    9    3   
   9    2    3    5    8    7    6    1    4   
  
  
Acest program considera fiecare element al matrici un nod intr-un graf cu 81 de elemente, legaturile dintre noduri sunt bazate pe faptul daca acele noduri se influineteaza unele pe altele. Folosint acest model, aplicam metoda Backtraking in functie de numarul de valori pe care un nod le poate lua, incepem cu elementele care au numarul cel mai mic de valori posibile ( valorile fiind restrictionate de nodurile care au o influienta asupra nodurilor ).
  
Programul va afisa "Nu are solutie", in cazul in care nu exista solutii pentru matrice.
