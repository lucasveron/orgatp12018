#include "utilityFunctions.h"

character convertIntToCharacter(unsigned int number) {
	// Se va a usar solo con numeros positivos
	character oneCharacter;
	oneCharacter.length = 0;
	// Inicializo el array de char's.
	int i = 0;
	if (number == 0) {
		/*
		 * Ascii = Nro
		 * 48 = 0
		 */
		oneCharacter.data[i] = 48;
		i ++;
	} else {
		int rest = 0;
		// Divido por 10, porque esta en base 10
		// Me deja el numero invertido
		while (i < MAX_LENGTH_CHARACTER && number != 0) {
			rest = number % 10;

			/*
			 * Ascii = Nro
			 * 48 = 0
			 * 57 = 9
			 */
			oneCharacter.data[i] = rest + 48;

			number /= 10;
			i ++;
		}
	}

	oneCharacter.length = i;

	if (oneCharacter.length == 1) {
		return oneCharacter;
	}

	// Invierto el nro
	double middle = (double)oneCharacter.length / 2;
	i = 0;
	int last = oneCharacter.length - 1;
	while(i < middle && last >= middle) {
		char firstCharacter = oneCharacter.data[i];
		char lastCharacter = oneCharacter.data[last];

		oneCharacter.data[i] = lastCharacter;
		oneCharacter.data[last] = firstCharacter;

		i ++;
		last --;
	}

	return oneCharacter;
}

