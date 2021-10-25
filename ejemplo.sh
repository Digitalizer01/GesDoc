# Función que muestra todos los documentos del fichero Fdocumento
function mostrar_documentos() {
	if [ -f AplicacionIsmael/Ficheros/Fdocumento ]; then

		printf "\e[4m%-20s\e[0m" "Id cliente"   # Valor 1
		printf "\e[4m%-20s\e[0m" "Id documento" # Valor 2
		printf "\e[4m%-70s\e[0m" "Descripción"  # Valor 3
		printf "\e[4m%-11s\e[0m" "Fecha"        # Valor 4
		printf "\n"

		awk -F ":" '{
        printf "%-20s", $1
        printf "%-20s", $2
        printf "%-70s", $3
        printf "%-11s", $4
        printf "\n"
        }' AplicacionIsmael/Ficheros/Fdocumento

	else
		echo "(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fdocumento no existe."
	fi
}

if [ -f AplicacionIsmael/Ficheros/Fdocumento ]; then
	mostrar_documentos

	id_documento=0
	echo -n "Introduzca el id del documento que desea dar de baja: "
	read id_documento

	# Si el fichero AplicacionIsmael/Ficheros/FpresenDoc existe, comprobamos que exista el id del documento que queremos
	# consultar. Si existe, consultamos su id de organismo.
	if [ -f AplicacionIsmael/Ficheros/FpresenDoc ]; then
		# id_usuario:id_cliente:id_documento:id_organismo:motivo_presentación:comunidad_autónoma:población:fecha
		# Buscamos si el documento está presentado.
		# Si no, enc=0.
		id_organismo=0
		while IFS= read -r line; do
			IFS=':' read -ra VALUES <<<"$line"
			## To pritn all values
			for i in "${VALUES[2]}"; do
				if [ $i == $id_documento ]; then
					id_organismo=${VALUES[3]}

					# Si no hemos encontrado el documento con el id introducido o no existe el fichero AplicacionIsmael/Ficheros/FpresenDoc,
					# mostramos el organismo al que se ha presentado el documento.
					# Guardamos en el fichero temp la línea correspondiente al cliente seleccionado.

					# id_organismo:nombre_organismo

					awk -v id_local_organismo=$id_organismo -F ":" '{
					if($1==id_local_organismo) {
							printf $1
							printf ":"
							printf $2
						}
					}' AplicacionIsmael/Ficheros/Forganismos
				fi
			done
		done <AplicacionIsmael/Ficheros/FpresenDoc
	fi

else

	echo "(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fdocumento no existe."
	pulsa_para_continuar
fi
