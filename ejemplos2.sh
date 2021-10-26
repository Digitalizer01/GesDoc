local motivo_presentacion=0
echo -n "Introduzca el motivo de la presentación: "
read motivo_presentacion

local comunidad_autonoma=0
echo -n "Introduzca la comunidad autónoma donde se presenta: "
read comunidad_autonoma

local poblacion=0
echo -n "Introduzca la población donde se realiza la presentación: "
read poblacion

local fecha=$(date +"%d/%m/%Y") # Tomamos la fecha.

cadena=$login:$id_cliente:$id_documento:$id_organismo:$motivo_presentacion:$comunidad_autonoma:$poblacion:$fecha
echo -e $cadena >>AplicacionIsmael/Ficheros/FpresenDoc
echo $cadena
pulsa_para_continuar
