login="hola"
if [ -f Fdocumento ]; then
	id_documento=0
	echo -n "Introduzca el id del documento que desea presentar a un organismo: "
	read id_documento

	# Buscamos si el documento está presentado. Si lo está, enc=1.
	# Si no, enc=0.
	enc=0
	while IFS= read -r line; do
		IFS=':' read -ra VALUES <<<"$line"
		## To pritn all values
		for i in "${VALUES[0]}"; do
			if [ $i == $id_local ] && [ ${VALUES[10]} == "S" ]; then
				enc=1
			fi
		done
	done <FpresenDoc

	# Si hemos encontrado el documento con el id introducido, borramos la línea correspondiente
	# a dicho documento en Fdocumento
	if ! [ $enc -eq 1 ]; then

		# Mostramos los organismos.

		id_organismo=0
		echo -n "Introduzca el id del organismo al que quiere presentar el documento: "
		read id_organismo

		enc2=0
		while IFS= read -r line; do
			IFS=':' read -ra VALUES <<<"$line"
			## To pritn all values
			for i in "${VALUES[0c]}"; do
				if [ $i == $id_organismo ]; then
					enc2=1
				fi
			done
		done <Forganismos

		if [ $enc2 -eq 1 ]; then

			motivo_presentacion=0
			echo "Introduzca el motivo de la presentación:"
			read motivo_presentacion

			comunidad_autonoma=0
			echo -n "Introduzca la comunidad autónoma donde se presenta: "
			read comunidad_autonoma

			poblacion=0
			echo -n "Introduzca la población donde se realiza la presentación: "
			read poblacion

			cadena=$login:$id_cliente:$id_documento:$id_organismo:$motivo_presentacion:$comunidad_autonoma:$poblacion:$fecha
			echo -e $cadena >>FpresenDoc

		else
			echo "No existe el organismo introducido."
		fi
	else
		echo "El documento ya ha sido presentado."
	fi

else
	echo "El fichero Fdocumento no existe."
	pulsa_para_continuar
fi
