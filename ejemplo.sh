function area_clientes_consulta_cliente() {
	if [ -f AplicacionIsmael/Ficheros/Fclientes ]; then
		local activos=1 # Si activos=1, la consulta se hará de los clientes con activo=S. Si activo=0, la consulta se hará de los clientes con activo=N.

		local correcto=1
		while [ $correcto -eq 1 ]; do
			echo "¿Desea consultar los clientes activos o los no activos?"
			echo "Para seleccionar los activos, pulse S."
			echo "Para seleccionar los no activos, pulse N."
			read activos
			clear

			case $activos in
			S) # Activos

				printf "\e[4m%-10s\e[0m" "Id"          # Valor 1
				printf "\e[4m%-15s\e[0m" "Nombre"      # Valor 2
				printf "\e[4m%-17s\e[0m" "Apellidos"   # Valor 3
				printf "\e[4m%-31s\e[0m" "Dirección"   # Valor 4
				printf "\e[4m%-16s\e[0m" "Ciudad"      # Valor 5
				printf "\e[4m%-25s\e[0m" "Provincia"   # Valor 6
				printf "\e[4m%-25s\e[0m" "País"        # Valor 7
				printf "\e[4m%-14s\e[0m" "DNI"         # Valor 8
				printf "\e[4m%-15s\e[0m" "Teléfono"    # Valor 9
				printf "\e[4m%-17s\e[0m" "Carpeta Doc" # Valor 10
				printf "\e[4m%-10s\e[0m" "Activo"      # Valor 11
				printf "\n"

				awk -F ":" '{
                    if($11=="S") {
                        printf "%-10s", $1
                        printf "%-15s", $2
                        printf "%-17s", $3
                        printf "%-30s", $4
                        printf "%-16s", $5
                        printf "%-25s", $6
                        printf "%-24s", $7
                        printf "%-14s", $8
                        printf "%-14s", $9
                        printf "%-17s", $10
                        printf "%-10s", $11
                        printf "\n"
                    }
                }' AplicacionIsmael/Ficheros/Fclientes

				correcto=0
				;;
			N)                                      # No activos
				printf "\e[4m%-10s\e[0m" "Id"          # Valor 1
				printf "\e[4m%-15s\e[0m" "Nombre"      # Valor 2
				printf "\e[4m%-17s\e[0m" "Apellidos"   # Valor 3
				printf "\e[4m%-31s\e[0m" "Dirección"   # Valor 4
				printf "\e[4m%-16s\e[0m" "Ciudad"      # Valor 5
				printf "\e[4m%-25s\e[0m" "Provincia"   # Valor 6
				printf "\e[4m%-25s\e[0m" "País"        # Valor 7
				printf "\e[4m%-14s\e[0m" "DNI"         # Valor 8
				printf "\e[4m%-15s\e[0m" "Teléfono"    # Valor 9
				printf "\e[4m%-17s\e[0m" "Carpeta Doc" # Valor 10
				printf "\e[4m%-10s\e[0m" "Activo"      # Valor 11
				printf "\n"

				awk -F ":" '{
                    if($11=="N") {
                        printf "%-10s", $1
                        printf "%-15s", $2
                        printf "%-17s", $3
                        printf "%-30s", $4
                        printf "%-16s", $5
                        printf "%-25s", $6
                        printf "%-24s", $7
                        printf "%-14s", $8
                        printf "%-14s", $9
                        printf "%-17s", $10
                        printf "%-10s", $11
                        printf "\n"
                    }
                }' AplicacionIsmael/Ficheros/Fclientes
				correcto=0
				;;
			*)
				echo "Opción seleccionada incorrecta"
				correcto=1
				;;
			esac
		done
	else
		echo "$(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fclientes no existe."
	fi

	return
}

if [ -f AplicacionIsmael/Ficheros/Fclientes ]; then

	if [ -f AplicacionIsmael/Ficheros/Fdocumento ]; then

		area_clientes_consulta_cliente

		local id_cliente=0
		echo -n "Introduza el id del cliente que desea consultar: "
		read id_cliente

		# Vamos a imprimir todos los documentos asociados al cliente elegido.

		awk -v id_cliente_local=$id_cliente -F ":" '{
		if($1==id_cliente_local) {
				printf $1
				printf ":"
				printf $2
				printf ":"
				printf $3
				printf ":"
				printf $4
			}
		}' AplicacionIsmael/Ficheros/Fdocumento >AplicacionIsmael/Ficheros/temp

		# Comprobamos si el fichero temp está vacío o no.
		# Si está vacío, mostraremos el mensaje correspondiente.
		# Si no lo está, mostraremos los datos de los documentos.
		if ! [ -s AplicacionIsmael/Ficheros/temp ]; then
			echo "No dispone de documentos asociados."
		else
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
			}' AplicacionIsmael/Ficheros/temp
		fi

		rm AplicacionIsmael/Ficheros/temp

	else
		echo "$(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fdocumento no existe."
	fi

else
	echo "$(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fclientes no existe."
fi

return
