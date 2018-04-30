#include "fileFunctions.h"

FILE * fileOutput;
int ofd;
char buffer[MAX_BUFFER];
int quantityCharactersInBuffer = 0;

void initFile(FILE * file) {
	fileOutput = file;
}

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

void loadDataInBuffer(char character) {
	buffer[quantityCharactersInBuffer] = character;
	quantityCharactersInBuffer++;
}

int putch(char character) {
	if (quantityCharactersInBuffer < MAX_BUFFER) {
		loadDataInBuffer(character);
		return OKEY;
	}

	int rdo = writeBufferInOFile(buffer, quantityCharactersInBuffer);
	if (rdo != OKEY) {
		return rdo;
	}

	quantityCharactersInBuffer = 0;
	loadDataInBuffer(character);

	return OKEY;
}

int flush() {
	if (quantityCharactersInBuffer > 0) {
		return writeBufferInOFile(buffer, quantityCharactersInBuffer);
	}

	return OKEY;
}

int writeHeader(unsigned int sizeY, unsigned int sizeX, unsigned int shades) {
	character chY = convertIntToCharacter(sizeY);
	character chX = convertIntToCharacter(sizeX);
	character chShades = convertIntToCharacter(shades);

    int quantityCharactersInBufferToLoad = 6 + chX.length + chY.length + chShades.length;
    char bufferToLoad [quantityCharactersInBufferToLoad];

    bufferToLoad[0] = 'P';
    bufferToLoad[1] = '2';
    bufferToLoad[2] = '\n';

    int idx = 3;
    int i;
    for (i = 0; i < chX.length; i++) {
		bufferToLoad[idx] = chX.data[i];
		idx ++;
	}

	bufferToLoad[idx] = ' ';

	idx ++;
	for (i = 0; i < chY.length; i++) {
		bufferToLoad[idx] = chY.data[i];
		idx ++;
	}

    bufferToLoad[idx] = '\n';

    idx ++;
    for (i = 0; i < chShades.length; i++) {
		bufferToLoad[idx] = chShades.data[i];
		idx ++;
	}

    bufferToLoad[idx] = '\n';

    int rdoWrite = writeBufferInOFile(bufferToLoad, quantityCharactersInBufferToLoad);

    if (rdoWrite != OKEY) {
        closeFile();

        return ERROR_WRITE;
    }

    return OKEY;
}
