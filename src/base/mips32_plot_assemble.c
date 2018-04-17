#include <debug.h>
#include <stdio.h>
#include <unistd.h>
#include <defs.h>
#include <param.h>

#define MAX_LENGTH_CHARACTER	11
#define MAX_BUFFER   100
#define TRUE 		 0
#define FALSE 		 1

enum State {
	 OKEY = 0, ERROR_FILE = 1, ERROR_MEMORY = 2, ERROR_WRITE = 3
	 //, INCORRECT_QUANTITY_PARAMS = 1, INCORRECT_MENU = 2, ERROR_FILE = 3, ERROR_MEMORY = 4, ERROR_PARAM = 5, ERROR_FORMAT = 6
};

FILE * fileOutput;
int ofd;
char * buffer;
int quantityCharactersInBuffer = 0;

int loadFileDescriptor() {
	if (fileOutput == NULL) {
		fprintf(stderr, "[Error] No se ha especificado archivo de salida.\n");
		return ERROR_FILE;
	}

    ofd = fileno(fileOutput);

    return OKEY;
}

void closeFile() {
	if (ofd == 1) {
        fileOutput = NULL;
		return;
	}

	if (fileOutput != NULL) {
		int result = fclose(fileOutput);
		if (result == EOF) {
			fprintf(stderr, "[Warning] El archivo de output no pudo ser cerrado correctamente.\n");
		}

        fileOutput = NULL;
	}
}

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

character convertIntToCharacter(unsigned int value) {
	character ch;
	ch.length = 0;

	// Inicializo el array de char's.
	int i;
	for (i = 0; i < MAX_LENGTH_CHARACTER; i++) {
		ch.data[i] = '\0';
	}

	sprintf(ch.data, "%d", value);

	int finish = FALSE;
	i = 0;
	while (i < 20 && finish == FALSE) {
		if (ch.data[i] == '\0') {
			finish = TRUE;
		} else {
			ch.length ++;
		}

		i ++;
	}

	return ch;
}

int writeBufferInOFile(char * bufferToLoad, int quantityCharactersInBufferToLoad) {
    if (fileOutput == NULL || quantityCharactersInBufferToLoad <= 0) {
		return OKEY;
	}

	int completeDelivery = FALSE;
	int bytesWriteAcum = 0;
	int bytesToWrite = quantityCharactersInBufferToLoad;
	while (completeDelivery == FALSE) {
		int bytesWrite = write(ofd, bufferToLoad + bytesWriteAcum, bytesToWrite);
		if (bytesWrite < 0) {
			fprintf(stderr, "[Error] Hubo un error al escribir en el archivo. \n");
			return ERROR_WRITE;
		}

		bytesWriteAcum += bytesWrite;
		bytesToWrite = quantityCharactersInBufferToLoad - bytesWriteAcum;

		if (bytesToWrite <= 0) {
			completeDelivery = TRUE;
		}
	}

	return OKEY;
}

int writeHeader(unsigned int sizeY, unsigned int sizeX, unsigned int shades) {
	character chY = convertIntToCharacter(sizeY);
	character chX = convertIntToCharacter(sizeX);

    int quantityCharactersInBufferToLoad = 9 + chX.length + chY.length;
    char * bufferToLoad = (char *) malloc(quantityCharactersInBufferToLoad *sizeof(char));
    if (bufferToLoad == NULL) {
        fprintf(stderr, "[Error] Hubo un error de asignacion de memoria (bufferToLoad). \n");
        return ERROR_MEMORY;
    }

    bufferToLoad[0] = 'P';
    bufferToLoad[1] = '2';
    bufferToLoad[2] = '\n';

    int idx = 3;
    int i;
    for (i = 0; i < chY.length; i++) {
        bufferToLoad[idx] = chY.data[i];
        idx ++;
    }

    bufferToLoad[idx] = ' ';

    idx ++;
    for (i = 0; i < chX.length; i++) {
        bufferToLoad[idx] = chX.data[i];
        idx ++;
    }

    bufferToLoad[idx] = '\n';
    idx ++;
    bufferToLoad[idx] = '2';
    idx ++;
    bufferToLoad[idx] = '5';
    idx ++;
    bufferToLoad[idx] = '5';
    idx ++;
    bufferToLoad[idx] = '\n';

    int rdoWrite = writeBufferInOFile(bufferToLoad, quantityCharactersInBufferToLoad);
    free(bufferToLoad);

    if (rdoWrite != OKEY) {
        closeFile();

        return ERROR_WRITE;
    }

    return OKEY;
}

int loadDataInBuffer(char character) {
    if (buffer == NULL) {
        buffer = (char *) malloc(MAX_BUFFER *sizeof(char));
        if (buffer == NULL) {
            fprintf(stderr, "[Error] Hubo un error de asignacion de memoria (buffer). \n");
            return ERROR_MEMORY;
        }

        quantityCharactersInBuffer = 0;
    }

	buffer[quantityCharactersInBuffer] = character;
	quantityCharactersInBuffer++;

    return OKEY;
}

int putch(char character) {
	if (quantityCharactersInBuffer < MAX_BUFFER) {
		return loadDataInBuffer(character);
	}

	int rdo = writeBufferInOFile(buffer, quantityCharactersInBuffer);
	if (rdo != OKEY) {
		return rdo;
	}

	quantityCharactersInBuffer = 0;
	return loadDataInBuffer(character);
}

int flush() {
	if (quantityCharactersInBuffer > 0) {
		return writeBufferInOFile(buffer, quantityCharactersInBuffer);
	}

	return OKEY;
}

int loadPixelBrightness(unsigned int pixelBrightness) {
	character ch = convertIntToCharacter(pixelBrightness);

    int rdo = OKEY;
    int i;
    for (i = 0; i < ch.length; i++) {
        rdo = putch(ch.data[i]);

        if (rdo != OKEY) {
            return rdo;
        }
    }

    return rdo;
}

void freeBuffer() {
	if (buffer != NULL) {
		free(buffer);
		buffer = NULL;
	}
}

void mips32_plot_assemble(param_t *parms) {
	fileOutput = parms->fp;
	int rdo = loadFileDescriptor();
	if (rdo != OKEY) {
		return ;
	}

	float cr, ci;
	float zr, zi;
	float tr, ti;
	float absz;
	int x, y;
	int c;

	/* Header PGM. */
	rdo = writeHeader((unsigned)parms->y_res, (unsigned)parms->x_res, (unsigned)(parms->shades - 1));
	if (rdo != OKEY) {
		return ;
	}

	/* 
	 * Barremos la region rectangular del plano complejo comprendida
	 * entre (parms->UL_re, parms->UL_im) y (parms->LR_re, parms->LR_im).
	 * El parametro de iteracion es el punto (cr, ci).
	 */
	for (x = 0, cr = parms->UL_re;
				     x < parms->x_res;
				     ++x, cr += parms->d_re) {
		for (y = 0, ci = parms->UL_im;
				 y < parms->y_res;
				 ++y, ci -= parms->d_im) {
			zr = cr;
			zi = ci;

			/*
			 * Determinamos el nivel de brillo asociado al punto
			 * (cr, ci), usando la formula compleja recurrente
			 * f = f^2 + s.
			 */
			for (c = 0; c < parms->shades; ++c) {
				if ((absz = zr*zr + zi*zi) >= 4.0f)
					break;

				tr = parms->s_re + zr * zr - zi * zi;
				ti = parms->s_im + zr * zi * 2.0f;

				zr = tr;
				zi = ti;
			}

			// Guardo brillo del pixel
			rdo = loadPixelBrightness((unsigned)c);
			if (rdo != OKEY) {
				closeFile(parms->fp);
				freeBuffer();

				return ;
			}

			rdo = putch(' ');
			if (rdo != OKEY) {
				closeFile();
				freeBuffer();

				return ;
			}
		}

		// Aca finaliza el for interno, recorrido en y
		rdo = putch('\n');

		if (rdo != OKEY) {
			closeFile();
			freeBuffer();

			return ;
		}
	}

	flush();
	closeFile();
	freeBuffer();
}
