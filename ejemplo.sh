# Función que permite mostrar la traza de los usuario por la aplicación.
function gestion_informes_acciones_usuarios() {
	if [ -f AplicacionIsmael/Ficheros/Foperaciones ]; then
		# id_usuario:fecha:hora:operación:id_cliente:id_documento

		printf "\e[4m%-20s\e[0m" "Usuario"      # Valor 1
		printf "\e[4m%-20s\e[0m" "Fecha"        # Valor 2
		printf "\e[4m%-20s\e[0m" "Hora"         # Valor 3
		printf "\e[4m%-40s\e[0m" "Operación"    # Valor 4
		printf "\e[4m%-20s\e[0m" "Id cliente"   # Valor 5
		printf "\e[4m%-20s\e[0m" "Id documento" # Valor 6
		printf "\n"

		local enc=0
		while IFS= read -r line; do
			IFS=':' read -ra VALUES <<<"$line"
			## To pritn all values
			for i in "${VALUES[0]}"; do
				printf "%-20s" "${VALUES[0]}"
				printf "%-20s" "${VALUES[1]}"
				printf "%-20s" "${VALUES[2]}"

				case ${VALUES[3]} in
				"1")
					printf "%-40s" "Area cliente"
					;;
				"1.1")
					printf "%-40s" "Alta clientes"
					;;
				"1.2")
					printf "%-40s" "Modificacion clientes"
					;;
				"1.3")
					printf "%-40s" "Baja cliente"
					;;
				"1.4")
					printf "%-40s" "Consulta clientes"
					;;
				"1.4.1")
					printf "%-40s" "Consulta clientes activos"
					;;
				"1.4.2")
					printf "%-40s" "Consulta clientes no activos"
					;;
				"1.5")
					printf "%-40s" "Salir del menu de clientes"
					;;
				"2")
					printf "%-40s" "Gestion de documentos"
					;;
				"2.1")
					printf "%-40s" "Alta documentos"
					;;
				"2.2")
					printf "%-40s" "Baja documentos"
					;;
				"2.3")
					printf "%-40s" "Presentacion documentos"
					;;
				"2.4")
					printf "%-40s" "Consultas documentos"
					;;
				"2.4.1")
					printf "%-40s" "Consulta de documentos de clientes"
					;;
				"2.4.2")
					printf "%-40s" "Consulta de organismos de documento"
					;;
				"2.5")
					printf "%-40s" "Salir menu de documentos"
					;;
				"3")
					printf "%-40s" "Gestion de informes"
					;;
				"3.1")
					printf "%-40s" "Documentos de clientes"
					;;
				"3.2")
					printf "%-40s" "Acciones de usuario dado"
					;;
				"3.3")
					printf "%-40s" "Salir menu de informes"
					;;
				"4")
					printf "%-40s" "Ayuda"
					;;
				"5")
					printf "%-40s" "Salir de la apliacion"
					;;
				esac

				printf "%-20s" "${VALUES[4]}"
				printf "%-20s" "${VALUES[5]}"
				printf "\n"
			done
		done <AplicacionIsmael/Ficheros/Foperaciones

	else
		echo "(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Foperaciones no existe."
	fi

	return
}

gestion_informes_acciones_usuarios
