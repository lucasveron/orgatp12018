#include "plotFunctions.h"

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

void mips32_plot(param_t * parms) {
	initFile(parms->fp);
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
	for (y = 0, ci = parms->UL_im;
		     y < parms->y_res;
		     ++y, ci -= parms->d_im) {
			for (x = 0, cr = parms->UL_re;
			     x < parms->x_res;
			     ++x, cr += parms->d_re) {
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

				return ;
			}

			rdo = putch(' ');
			if (rdo != OKEY) {
				closeFile();

				return ;
			}
		}

		// Aca finaliza el for interno, recorrido en y
		rdo = putch('\n');

		if (rdo != OKEY) {
			closeFile();

			return ;
		}
	}

	flush();
	closeFile();
}
