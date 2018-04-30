#ifndef FILEFUNCTIONS_H_
#define FILEFUNCTIONS_H_

#include <stdio.h>
#include <unistd.h>

#include "utilityFunctions.h"

#define MAX_BUFFER   100
#define TRUE 		 0
#define FALSE 		 1

enum State {
	 OKEY = 0, ERROR_FILE = 1, ERROR_MEMORY = 2, ERROR_WRITE = 3
};

extern void initFile(FILE * file);

extern int loadFileDescriptor();

extern void closeFile();

extern int writeBufferInOFile(char * bufferToLoad, int quantityCharactersInBufferToLoad);

extern void loadDataInBuffer(char character);

extern int putch(char character);

extern int flush();

extern int writeHeader(unsigned int sizeY, unsigned int sizeX, unsigned int shades);


#endif /* FILEFUNCTIONS_H_ */
