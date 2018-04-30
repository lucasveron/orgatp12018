#ifndef PLOTFUNCTIONS_H_
#define PLOTFUNCTIONS_H_

#include <stdio.h>
#include <unistd.h>
#include <param.h>

#include "utilityFunctions.h"
#include "fileFunctions.h"

extern int loadPixelBrightness(unsigned int pixelBrightness);

extern void mips32_plot(param_t * parms);


#endif /* PLOTFUNCTIONS_H_ */
