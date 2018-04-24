#!/bin/bash

echo "##############################################################################"
echo "########################## Tests automaticos  ################################"
echo "##############################################################################"


#DIRECTORIO=/root1
#echo "El directorio ${DIRECTORIO} existe"

echo "Se guardaran los archivos resultantes de los tests en el directorio ./outputs-automatic-tests"

if [ -d "./outputs-automatic-tests" ]
then
   echo "El directorio ./outputs-automatic-tests existe, por lo tanto se elimina su contenido."
   rm -r outputs-automatic-tests/*
else
   echo "El directorio ./outputs-automatic-tests no existe, por lo tanto se creara."
   mkdir outputs-automatic-tests
fi


echo "###----------###    COMIENZA la generacion de imagenes automaticamente.    ###----------###"

./tp1 -r 50x50 --center 0.5+0.5i -w 25 --height 10 --output ./outputs-automatic-tests/prueba1.pgm
echo "Se genero el archivo prueba1.pgm, para lo cual se especifico center, w, height, s y output."

./tp1 --resolution 70x70 -c 0.5+0.5i --width 10 -H 30 -o ./outputs-automatic-tests/prueba2.pgm
echo "Se genero el archivo prueba2.pgm, para lo cual se especifico resolution, c, width, H y o."

./tp1 -c 0.5+0.5025863i --width 5 -H 8 -o ./outputs-automatic-tests/prueba3.pgm
echo "Se genero el archivo prueba3.pgm, para lo cual se especifico c, width, H y o."

./tp1 --resolution 100x300 --width 10 -H 5 -o ./outputs-automatic-tests/prueba4.pgm
echo "Se genero el archivo prueba4.pgm, para lo cual se especifico resolution, width, H y o."

./tp1 --resolution 50x30 -c 0.7+0.9i -H 5 -o ./outputs-automatic-tests/prueba5.pgm
echo "Se genero el archivo prueba5.pgm, para lo cual se especifico resolution, c, H y o."

./tp1 --resolution 69x35 -c -0.956+0.15236i --width 3 -o ./outputs-automatic-tests/prueba6.pgm
echo "Se genero el archivo prueba6.pgm, para lo cual se especifico resolution, c, width y o."

./tp1 --resolution 54x67 -c -0.956+0.15236i --width 3 --height 10 -o ./outputs-automatic-tests/prueba7.pgm
echo "Se genero el archivo prueba6.pgm, para lo cual se especifico resolution, c, width, height y o."

./tp1 --resolution 35X52 -c -0.5201-0.15236i --width 3 --height 5 -o - > ./outputs-automatic-tests/outputStdout.pgm
echo "Se ejecuto con salida estandar, que se redirecciono al archivo outputStdout.pgm, para lo cual se especifico resolution, c, width, height y o (stdout, como - )."

./tp1 -o ./outputs-automatic-tests/uno.pgm
echo "Se genero el archivo uno.pgm, para lo cual se especifico o."

./tp1 -c 0.282-0.007i -w 0.005 -H 0.005 -o ./outputs-automatic-tests/dos.pgm
echo "Se genero el archivo dos.pgm, para lo cual se especifico c, w, H y o."

echo "###----------###    FIN de la generacion de imagenes automaticamente.    ###----------###"

echo "###------------------------------------------------------------------------###"
echo "###------------------------------------------------------------------------###"
echo "###------------------------------------------------------------------------###"

echo "###----------###    COMIENZA la validacion de los parametros.    ###----------###"

varError=$(./tp1 -r 54x45d 2>&1)
if [ "$varError" = "[Error] La resolucion especificada es incorrecta." ]
 then 
  echo "./tp1 -r 54x45d corrio ...... [OK]";
else
 echo "./tp1 -r 54x45d corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi

varError=$(./tp1 -r 54A45 2>&1)
if [ "$varError" = "[Error] La resolucion especificada es incorrecta." ];
 then echo "./tp1 -r 54A45 corrio ....... [OK]";
else
 echo "./tp1 -r 54A45 corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi

varError=$(./tp1 -r -133x23 2>&1)
if [ "$varError" = "[Error] La resolucion especificada es incorrecta." ];
 then echo "./tp1 -r -133x23 corrio ..... [OK]";
else
 echo "./tp1 -r -133x23 corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi

varError=$(./tp1 -c 896-233 2>&1)
if [ "$varError" = "[Error] Formato incorrecto del numero complejo para el centro." ];
 then echo "./tp1 -c 896-233 corrio ..... [OK]";
else
 echo "./tp1 -c 896-233 corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi

varError=$(./tp1 -c i33-33 2>&1)
if [ "$varError" = "[Error] Formato incorrecto del numero complejo para el centro." ];
 then echo "./tp1 -c i33-33 corrio ...... [OK]";
else
 echo "./tp1 -c i33-33 corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi

varError=$(./tp1 -c 3d4+56i 2>&1)
if [ "$varError" = "[Error] Formato incorrecto del numero complejo para el centro." ];
 then echo "./tp1 -c 3d4+56i corrio ..... [OK]";
else
 echo "./tp1 -c 3d4+56i corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi

varError=$(./tp1 -w -31 2>&1)
if [ "$varError" = "[Error] Formato incorrecto para el ancho." ];
 then echo "./tp1 -w -31 corrio ......... [OK]";
else
 echo "./tp1 -w -31 corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi

varError=$(./tp1 -w 3e 2>&1)
if [ "$varError" = "[Error] Formato incorrecto para el ancho." ];
 then echo "./tp1 -w 3e corrio .......... [OK]";
else
 echo "./tp1 -w 3e corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi

varError=$(./tp1 -H -5.25 2>&1)
if [ "$varError" = "[Error] Formato incorrecto para el alto." ];
 then echo "./tp1 -H -5.25 corrio ....... [OK]";
else
 echo "./tp1 -H -5.25 corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi

varError=$(./tp1 -H 3e 2>&1)
if [ "$varError" = "[Error] Formato incorrecto para el alto." ];
 then echo "./tp1 -H 3e corrio .......... [OK]";
else
 echo "./tp1 -H 3e corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi

varError=$(./tp1 -o uno. 2>&1)
if [ "$varError" = "[Error] Extension incorrecta para el archivo de salida." ];
 then echo "./tp1 -o uno. corrio ........ [OK]";
else
 echo "./tp1 -o uno. corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi

varError=$(./tp1 -o uno.txt 2>&1)
if [ "$varError" = "[Error] Extension incorrecta para el archivo de salida." ];
 then echo "./tp1 -o uno.txt corrio ..... [OK]";
else
 echo "./tp1 -o uno.txt corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi

varError=$(./tp1 -o uno.pgm23 2>&1)
if [ "$varError" = "[Error] Extension incorrecta para el archivo de salida." ];
 then echo "./tp1 -o uno.pgm23 corrio ... [OK]";
else
 echo "./tp1 -o uno.pgm23 corrio con ERROR!!! - Resultado obtenido: ";
 echo $varError
fi


echo "###----------###    FIN de la validacion de los parametros.    ###----------###"

echo "###############################################################################"
echo "########################## FIN Tests automaticos  #############################"
echo "###############################################################################"
