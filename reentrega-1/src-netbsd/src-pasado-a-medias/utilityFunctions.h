#ifndef UTILITYFUNCTIONS_H_
#define UTILITYFUNCTIONS_H_


#include <stdio.h>
#include <stdlib.h>


#define MAX_LENGTH_CHARACTER	11

// Se usa para transformar un int en una cadena de caracteres.
/*
 * En C se tiene:
 * int
 *   bytes = 4
 *   Máximo = 2,147,483,647 (4,294,967,295 cuando es unsigned)
 *   Mínimo = -2,147,483,648 (0 cuando es unsigned)
 * Entonces reservo 11 bytes (10 numeros + 1 signo, si es negativo).
 */
typedef struct character {
	char data [MAX_LENGTH_CHARACTER];
	int length;
} character;

extern character convertIntToCharacter(unsigned int number);

#endif /* UTILITYFUNCTIONS_H_ */
