**NUME:** Busescu Catalin-Nicolae 
**GRUPA:** 322CD

# Prefix AST 

## Descrierea implementarii 

Am rezolvat aceasta tema folosind functiile `atoi` si `polish` pe care le-am 
adaugat scheletului.

1. Functia *atoi*  
	+ Primeste ca parametru un string. 
	+ Verifica posibilitatea unui numar negativ prin compararea primului caracter cu - . In acest caz salveaza valoarea -1 in registrul `ecx`, valoarea din `ecx` va fi 1 in caz contrar .Semnul se adauga la final prin inmultire `imul eax, ecx`.
	+ Parcurge sirul caracter cu caracter verificand daca fiecare se afla in 0-9.  
2. Functia *polish* 
	+ Primeste ca parametru un `struct Node*`.
	+ Parcurge arborele in mod recursiv. 
	+ Verifica pozititia in arbore prin `or ebx, ecx`, in `ebx` se afla un pointer la copilul stang si in `ecx` la cel drept. Operatia intoarce zero doar daca ambii nu exista, caz in care trebuie apelat `atoi`.
	+ Daca nodul are copii calculeaza valorile expresiilor din subarbori prin apel recursiv, la final valoarea din subarborele stang aflandu-se in eax si cea din cel drept in ebx.
	+ In acest caz functia calculeaza rezultatul expresiei prin efectuarea operatiei specificate in `node->data`, `node` fiind nodul curent. Functia determina operata intr-o maniera similara instructiunii *switch* din limbajul C.  
