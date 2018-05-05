#!/bin/bash

echo "##############################################################################"
echo "########################## Tests automaticos  ################################"
echo "##############################################################################"
echo
echo "Se guardaran los archivos resultantes de los tests en el directorio ./outputs-automatic-tests"

if [ -d "./outputs-automatic-tests" ]
then
   echo "El directorio ./outputs-automatic-tests existe, por lo tanto se elimina su contenido."
   rm -r outputs-automatic-tests/*
else
   echo "El directorio ./outputs-automatic-tests no existe, por lo tanto se creara."
   mkdir outputs-automatic-tests
fi

echo
echo "################ Comienza la generacion de imagenes automaticamente ##########"
echo

./tp1 -r 50x50 --center 0.5+0.5i -w 25 --height 10 --output ./outputs-automatic-tests/prueba1.pgm -m mips32
echo "Se genero el archivo prueba1.pgm, para lo cual se especifico center, w, height, s y output."

./tp1 --resolution 70x70 -c 0.5+0.5i --width 10 -H 30 -o ./outputs-automatic-tests/prueba2.pgm -m mips32
echo "Se genero el archivo prueba2.pgm, para lo cual se especifico resolution, c, width, H y o."

./tp1 -r 10x10 -c 0.5+0.5025863i --width 5 -H 8 -o ./outputs-automatic-tests/prueba3.pgm -m mips32
echo "Se genero el archivo prueba3.pgm, para lo cual se especifico c, width, H y o."

./tp1 --resolution 100x300 --width 10 -H 5 -o ./outputs-automatic-tests/prueba4.pgm -m mips32
echo "Se genero el archivo prueba4.pgm, para lo cual se especifico resolution, width, H y o."

./tp1 --resolution 50x30 -c 0.7+0.9i -H 5 -o ./outputs-automatic-tests/prueba5.pgm -m mips32
echo "Se genero el archivo prueba5.pgm, para lo cual se especifico resolution, c, H y o."

./tp1 --resolution 69x35 -c -0.956+0.15236i --width 3 -o ./outputs-automatic-tests/prueba6.pgm -m mips32
echo "Se genero el archivo prueba6.pgm, para lo cual se especifico resolution, c, width y o."

./tp1 --resolution 54x67 -c -0.956+0.15236i --width 3 --height 10 -o ./outputs-automatic-tests/prueba7.pgm -m mips32
echo "Se genero el archivo prueba7.pgm, para lo cual se especifico resolution, c, width, height y o."

./tp1 --resolution 35x52 -c -0.5201-0.15236i --width 3 --height 5 -m mips32 -o - > ./outputs-automatic-tests/outputStdout.pgm
echo "Se ejecuto con salida estandar, que se redirecciono al archivo outputStdout.pgm, para lo cual se especifico resolution, c, width, height y o (stdout, como - )."

./tp1 -o -r 20x20 ./outputs-automatic-tests/uno.pgm -m mips32
echo "Se genero el archivo uno.pgm, para lo cual se especifico o."

./tp1 -r 20x20 -c 0.282-0.007i -w 0.005 -H 0.005 -o ./outputs-automatic-tests/dos.pgm -m mips32
echo "Se genero el archivo dos.pgm, para lo cual se especifico c, w, H y o."

./tp1 -r 20x20 -m mips32 -o ./outputs-automatic-tests/unoMips32.pgm -m mips32
echo "Se genero el archivo unoMips32.pgm, para lo cual se especifico m y o"
echo
echo "################ Comparacion de metodos de ejecucion #########################"
echo

echo "Generación de imagen estandar 10x10 ..."
./tp1 -r 10x10 -m mips32 -o ./outputs-automatic-tests/comp_mips32_1.pgm
./tp1 -r 10x10 -m generic -o ./outputs-automatic-tests/comp_generic_1.pgm

varDiff=$(diff ./outputs-automatic-tests/comp_mips32_1.pgm ./outputs-automatic-tests/comp_generic_1.pgm 2>&1)
if [ "$varDiff" = "" ];
 then echo "Ejecucion test diff 1 .............................. [OK]";
else
 echo "Ejecucion test diff 1 .............................. [ERROR] - Resultado obtenido: ";
 echo $varDiff
fi

echo
echo "Generación de imagen estandar 100x100 ..."
./tp1 -r 50x50 -m mips32 -o ./outputs-automatic-tests/comp_mips32_2.pgm
./tp1 -r 50x50 -m generic -o ./outputs-automatic-tests/comp_generic_2.pgm

varDiff=$(diff ./outputs-automatic-tests/comp_mips32_2.pgm ./outputs-automatic-tests/comp_generic_2.pgm 2>&1)
if [ "$varDiff" = "" ];
 then echo "Ejecucion test diff 2 .............................. [OK]";
else
 echo "Ejecucion Diff .............................. [ERROR] - Resultado obtenido: ";
 echo $varDiff
fi

echo
echo "Generación de imagen estandar 255x255 ..."
./tp1 -r 255x255 -m mips32 -o ./outputs-automatic-tests/comp_mips32_3.pgm
./tp1 -r 255x255 -m generic -o ./outputs-automatic-tests/comp_generic_3.pgm

varDiff=$(diff ./outputs-automatic-tests/comp_mips32_3.pgm ./outputs-automatic-tests/comp_generic_3.pgm 2>&1)
if [ "$varDiff" = "" ];
 then echo "Ejecucion test diff 3 .............................. [OK]";
else
 echo "Ejecucion Diff .............................. [ERROR] - Resultado obtenido: ";
 echo $varDiff
fi

echo
echo "##############################################################################"
echo "######################## Fin tests automaticos  ##############################"
echo "##############################################################################"
