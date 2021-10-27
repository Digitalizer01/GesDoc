function fichero_operaciones() {
	# id_usuario:fecha:hora:operación:id_cliente:id_documento

	if [ $# == 3 ]; then
		local fecha=$(date +"%d/%m/%Y") # Tomamos la fecha.
		local hora=$(date +%H)          # Tomamos la hora
		echo $login:$fecha:$hora:$1:$2:$3 >>AplicacionIsmael/Ficheros/Foperaciones
	fi

	return
}

fichero_operaciones 1 2 3
