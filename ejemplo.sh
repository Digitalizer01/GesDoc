echo -n "Introduzca el id del cliente que desea modificar: "
read id_local

nombre=0
apellidos=0
direccion=0
ciudad=0
provincia=0
pais=0
dni=0
telefono=0
carpetadoc=0
activo=0

linea_cliente_original=0

enc=0
while IFS= read -r line; do
	IFS=':' read -ra VALUES <<<"$line"
	## To pritn all values
	for i in "${VALUES[0]}"; do
		if [ $i == $id_local ] && [ ${VALUES[10]} == "S" ]; then
			enc=1
			# id_local es id_cliente
			nombre=${VALUES[1]}
			apellidos=${VALUES[2]}
			direccion=${VALUES[3]}
			ciudad=${VALUES[4]}
			provincia=${VALUES[5]}
			pais=${VALUES[6]}
			dni=${VALUES[7]}
			telefono=${VALUES[8]}
			carpetadoc=${VALUES[9]}
			activo=${VALUES[10]}

			linea_cliente_original=$id_local:$nombre:$apellidos:$direccion:$ciudad:$provincia:$pais:$dni:$telefono:$carpetadoc:$activo
		fi
	done
done <AplicacionIsmael/Ficheros/Fclientes

sed -i "\|$linea_cliente_original|d" AplicacionIsmael/Ficheros/Fclientes
