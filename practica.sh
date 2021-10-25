# Creamos las carpetas necesarias para el correcto funcionamiento del programa

# Comprobamos que la carpeta AplicacionIsmael existe. Si no existe, la creamos.
if ! [ -d "AplicacionIsmael" ]; then
    echo "El directorio de la aplicación no existe. Va a crearse uno."
    mkdir "AplicacionIsmael"
fi

# Comprobamos que la carpeta AreaCli existe dentro de AplicacionIsmael. Si no existe, la creamos.
if ! [ -d "AplicacionIsmael/AreaCli" ]; then
    echo "El directorio del área de clientes no existe. Va a crearse uno."
    mkdir "AplicacionIsmael/AreaCli"
fi

# Comprobamos que la carpeta Ficheros existe dentro de AplicacionIsmael. Si no existe, la creamos.
if ! [ -d "AplicacionIsmael/Ficheros" ]; then
    echo "El directorio de ficheros no existe. Va a crearse uno."
    mkdir "AplicacionIsmael/Ficheros"
fi

function pulsa_para_continuar() {
    local temp
    echo
    read -n1 -r -p "Pulse cualquier tecla para continuar." temp
    return
}

function iniciar_sesion() {
    local iniciado=0 # Si vale 0 no se ha encontrado usuario. Si vale 1, se ha encontrado usuario.

    echo "█████████ INICIO DE SESIÓN ██████████"
    echo -n "       Usuario: "
    read login
    echo -n "       Contraseña: "
    read contrasenia
    echo "█████████████████████████████████████"

    local cadena=$login:$contrasenia

    grep -q $cadena 'AplicacionIsmael/Ficheros/Fusuarios' && iniciado=1

    return $iniciado
}

function menu_principal() {
    local correcto_menu_principal=1
    local variable_menu_principal=0
    while [ $correcto_menu_principal -eq 1 ]; do
        clear

        echo "██████████ MENÚ PRINCIPAL ███████████"
        echo "      Bienvenido/a," $login
        echo "       1. Área de clientes"
        echo "       2. Gestión de documentos"
        echo "       3. Gestión de informes"
        echo "       4. Ayuda"
        echo "       5. Salir"
        echo "█████████████████████████████████████"

        read variable_menu_principal
        case $variable_menu_principal in
        1)
            area_clientes
            ;;
        2)
            gestion_documentos
            ;;
        3)
            echo "Ha seleccionado gestión de informes"
            ;;
        4)
            echo "Ha seleccionado ayuda"
            ;;
        5)
            exit
            correcto_menu_principal=0
            ;;
        *)
            echo "Opción seleccionada incorrecta"
            correcto_menu_principal=1
            ;;
        esac

        echo "Abajo del todo en while menu_principal. El valor de correcto_menu_principal es: " $correcto_menu_principal
    done

    echo "Fin menu_principal"

    return
}

# ------------------- Area de clientes -------------------

# Función que permite la selección de las diferentes posibles opciones del área de clientes.
function area_clientes() {
    local correcto=1
    while [ $correcto -eq 1 ]; do
        clear

        echo "█████████ ÁREA DE CLIENTES ██████████"
        echo "       1. Alta de clientes"
        echo "       2. Modificación clientes"
        echo "       3. Baja cliente"
        echo "       4. Consulta cliente"
        echo "       5. Salir"
        echo "█████████████████████████████████████"

        local variable=0
        read variable
        case $variable in
        1)
            clear
            area_clientes_alta_clientes
            ;;
        2)
            clear
            area_clientes_modificacion_clientes
            ;;
        3)
            clear
            area_clientes_baja_cliente
            ;;
        4)
            clear
            area_clientes_consulta_cliente
            pulsa_para_continuar
            ;;
        5)
            correcto=0
            ;;
        *)
            echo "Opción seleccionada incorrecta"
            correcto=1
            ;;
        esac
    done

}

# Función que permite dar de alta un cliente. Asigna como id el último que haya +1 y el directorio
# de dicho cliente será IDCLIENTE_Doc
function area_clientes_alta_clientes() {
    if ! [ -f AplicacionIsmael/Ficheros/Fclientes ]; then
        echo "$(tput setaf 1)No existe el fichero AplicacionIsmael/Ficheros/Fclientes. Va a crearse uno."
        echo -n "" >>AplicacionIsmael/Ficheros/Fclientes
    fi

    clear

    local id
    local nombre
    local apellidos
    local direccion
    local ciudad
    local provincia
    local pais
    local direccion
    local telefono
    local carpetadoc
    local activo

    # Asignación de id
    variable=$(sort -t ':' -n -r AplicacionIsmael/Ficheros/Fclientes | head -1 | cut -d ":" -f 1)
    id=$((variable + 1))

    echo -n "Introduzca nombre: "
    read nombre

    echo -n "Introduzca apellidos: "
    read apellidos

    echo -n "Introduzca direccion: "
    read direccion

    echo -n "Introduzca ciudad: "
    read ciudad

    echo -n "Introduzca provincia: "
    read provincia

    echo -n "Introduzca pais: "
    read pais

    echo -n "Introduzca telefono: "
    read telefono

    carpetadoc="$id""_Doc"
    mkdir "AplicacionIsmael/AreaCli/$carpetadoc"

    local cadena=$id:$nombre:$apellidos:$direccion:$ciudad:$provincia:$pais:$telefono:$carpetadoc:S

    echo -e $cadena >>AplicacionIsmael/Ficheros/Fclientes

    return
}

# Función que permite modificar un campo específico de un cliente dado.
function area_clientes_modificacion_clientes() {
    if [ -f AplicacionIsmael/Ficheros/Fclientes ]; then
        area_clientes_consulta_cliente

        local id_local
        echo -n "Introduzca el id del cliente que desea modificar: "
        read id_local

        local enc=0
        while IFS= read -r line; do
            IFS=':' read -ra VALUES <<<"$line"
            ## To pritn all values
            for i in "${VALUES[0]}"; do
                if [ $i == $id_local ] && [ ${VALUES[10]} == "S" ]; then
                    enc=1
                fi
            done
        done <AplicacionIsmael/Ficheros/Fclientes

        # Si hemos encontrado el cliente con el id introducido y está activo, entramos (es decir, enc=1)
        if [ $enc -eq 1 ]; then
            # Guardamos en el fichero temp la línea correspondiente al cliente seleccionado.
            local linea=0
            awk -v id_local_baja=$id_local -F ":" '{
            if($1==id_local_baja) {
                    printf $1
                    printf ":"
                    printf $2
                    printf ":"
                    printf $3
                    printf ":"
                    printf $4
                    printf ":"
                    printf $5
                    printf ":"
                    printf $6
                    printf ":"
                    printf $7
                    printf ":"
                    printf $8
                    printf ":"
                    printf $9
                    printf ":"
                    printf $10
                    tempprintf ":"
                    printf $11
                }
            }' AplicacionIsmael/Ficheros/Fclientes >temp

            read -r linea <temp                                                                                   # Leemos el fichero temp que contiene la línea a borrar.
            sed -i "\|$linea|d" AplicacionIsmael/Ficheros/Fclientes                                               # Borramos la línea del cliente seleccionado del fichero AplicacionIsmael/Ficheros/Fclientes.
            rm temp                                                                                               # Borramos el fichero temp.
            linea=${linea%?}                                                                                      # Quitamos la letra S del final de la variable linea.
            linea="$linea""N"                                                                                     # Añadimos N al final de linea.
            echo $linea >>AplicacionIsmael/Ficheros/Fclientes                                                     # Ponemos linea en el fichero AplicacionIsmael/Ficheros/Fclientes.
            sort -k1 -t':' AplicacionIsmael/Ficheros/Fclientes >tmp && mv tmp AplicacionIsmael/Ficheros/Fclientes # Ordenamos el fichero AplicacionIsmael/Ficheros/Fclientes
        fi
    else
        echo "$(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fclientes no existe."
        pulsa_para_continuar
    fi

    return
}

# Función que permite dar de baja un cliente, es decir, poner el campo activo a N.
function area_clientes_baja_cliente() {
    if [ -f AplicacionIsmael/Ficheros/Fclientes ]; then
        area_clientes_consulta_cliente

        local id_local
        echo -n "Introduzca el id del cliente que desea dar de baja: "
        read id_local

        local enc=0
        while IFS= read -r line; do
            IFS=':' read -ra VALUES <<<"$line"
            ## To pritn all values
            for i in "${VALUES[0]}"; do
                if [ $i == $id_local ] && [ ${VALUES[10]} == "S" ]; then
                    enc=1
                fi
            done
        done <AplicacionIsmael/Ficheros/Fclientes

        # Si hemos encontrado el cliente con el id introducido y está activo, entramos (es decir, enc=1)
        if [ $enc -eq 1 ]; then
            # Guardamos en el fichero temp la línea correspondiente al cliente seleccionado.
            local linea=0
            awk -v id_local_baja=$id_local -F ":" '{
            if($1==id_local_baja) {
                    printf $1
                    printf ":"
                    printf $2
                    printf ":"
                    printf $3
                    printf ":"
                    printf $4
                    printf ":"
                    printf $5
                    printf ":"
                    printf $6
                    printf ":"
                    printf $7
                    printf ":"
                    printf $8
                    printf ":"
                    printf $9
                    printf ":"
                    printf $10
                    printf ":"
                    printf $11
                }
            }' AplicacionIsmael/Ficheros/Fclientes >temp

            read -r linea <temp                                                                                   # Leemos el fichero temp que contiene la línea a borrar.
            sed -i "\|$linea|d" AplicacionIsmael/Ficheros/Fclientes                                               # Borramos la línea del cliente seleccionado del fichero AplicacionIsmael/Ficheros/Fclientes.
            rm temp                                                                                               # Borramos el fichero temp.
            linea=${linea%?}                                                                                      # Quitamos la letra S del final de la variable linea.
            linea="$linea""N"                                                                                     # Añadimos N al final de linea.
            echo $linea >>AplicacionIsmael/Ficheros/Fclientes                                                     # Ponemos linea en el fichero AplicacionIsmael/Ficheros/Fclientes.
            sort -k1 -t':' AplicacionIsmael/Ficheros/Fclientes >tmp && mv tmp AplicacionIsmael/Ficheros/Fclientes # Ordenamos el fichero AplicacionIsmael/Ficheros/Fclientes
        else
            echo "(tput setaf 1)Cliente no encontrado."
        fi

    else
        echo "$(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fclientes no existe."
        pulsa_para_continuar
    fi

    return
}

# Función que muestra todos los clientes. Puede seleccionarse si desean verse los activos o
# los no activos.
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
            N)                                         # No activos
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
                echo "(tput setaf 1)Opción seleccionada incorrecta"
                correcto=1
                ;;
            esac
        done
    else
        echo "$(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fclientes no existe."
    fi

    return
}

# --------------------------------------------------------

# ----------------- Gestión de documentos ----------------

# Función que muestra todos los organismos del fichero Forganimos
function mostrar_organismos() {
    if [ -f AplicacionIsmael/Ficheros/Forganismos ]; then

        printf "\e[4m%-10s\e[0m" "Id"               # Valor 1
        printf "\e[4m%-70s\e[0m" "Nombre organismo" # Valor 2
        printf "\n"

        awk -F ":" '{
        printf "%-10s", $1
        printf "%-70s", $2
        printf "\n"
    }' AplicacionIsmael/Ficheros/Forganismos

    else
        echo "(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Forganismos no existe."
    fi
}

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

# Función que muestra el menú referido al apartado de Gestión de documentos
function gestion_documentos() {
    local correcto=1
    while [ $correcto -eq 1 ]; do
        clear

        echo "███████ GESTIÓN DE DOCUMENTOS ███████"
        echo "       1. Alta de documento"
        echo "       2. Baja documento"
        echo "       3. Presentación de documento"
        echo "       4. Consultas"
        echo "       5. Salir"
        echo "█████████████████████████████████████"

        local variable=0
        read variable
        case $variable in
        1)
            clear
            gestion_documentos_alta_documento
            ;;
        2)
            clear
            gestion_documentos_baja_documento
            ;;
        3)
            clear
            gestion_documentos_presentacion_documento
            ;;
        4)
            clear
            gestion_documentos_consultas
            local temp
            echo
            read -n1 -r -p "Pulse cualquier tecla para continuar." temp
            ;;
        5)
            correcto=0
            ;;
        *)
            echo "(tput setaf 1)Opción seleccionada incorrecta"
            correcto=1
            ;;
        esac
    done
}

# Función que da de alta un documento en el fichero Fdocumento
function gestion_documentos_alta_documento() {
    # Comprobamos que el fichero AplicacionIsmael/Ficheros/Fclientes existe. Si no, no podemos
    # dar de alta un documento.
    if [ -f AplicacionIsmael/Ficheros/Fclientes ]; then
        # Comprobamos que el fichero AplicacionIsmael/Ficheros/Fdocumento exista. Si no, lo creamos.
        if ! [ -f AplicacionIsmael/Ficheros/Fdocumento ]; then
            echo "$(tput setaf 1)No existe el fichero AplicacionIsmael/Ficheros/Fdocumento. Va a crearse uno."
            echo -n "" >>AplicacionIsmael/Ficheros/Fdocumento
        fi

        area_clientes_consulta_cliente # Mostramos los clientes.

        local id_cliente=0
        echo -n "Introduzca el id del cliente al que desea vincular el documento: "
        read id_cliente

        local enc=0
        while IFS= read -r line; do
            IFS=':' read -ra VALUES <<<"$line"
            ## To pritn all values
            for i in "${VALUES[0]}"; do
                if [ $i == $id_cliente ] && [ ${VALUES[10]} == "S" ]; then
                    enc=1
                fi
            done
        done <AplicacionIsmael/Ficheros/Fclientes

        # Comprobamos que el cliente especificado existe. Si no, muestra un
        # mensaje de error.
        if [ $enc -eq 1 ]; then
            # Asignación de id_documento
            local variable=$(sort -t ':' -k 2 -n -r AplicacionIsmael/Ficheros/Fdocumento | head -1 | cut -d ":" -f 2)
            local id_documento=$((variable + 1))

            echo -n "Introduzca una descripción: "
            read descripcion

            local fecha=$(date +"%d/%m/%Y") # Tomamos la fecha.
            echo $fecha

            local cadena=$id_cliente:$id_documento:$descripcion:$fecha

            echo -e $cadena >>AplicacionIsmael/Ficheros/Fdocumento # Añadimos la línea al fichero AplicacionIsmael/Ficheros/Fdocumento
        else
            echo "(tput setaf 1)El cliente especificado no existe."
            pulsa_para_continuar
        fi
    else
        echo "$(tput setaf 1)No existe el fichero AplicacionIsmael/Ficheros/Fclientes, no puede dar de alta documentos."
        pulsa_para_continuar
    fi

    return
}

# Función que da de baja un documento del fichero Fdocumento eliminando la línea referida
# a dicho documento.
function gestion_documentos_baja_documento() {
    if [ -f AplicacionIsmael/Ficheros/Fdocumento ]; then
        mostrar_documentos

        local id_documento=0
        echo -n "Introduzca el id del documento que desea dar de baja: "
        read id_documento

        local enc=0

        # Si el fichero AplicacionIsmael/Ficheros/FpresenDoc existe, comprobamos que exista el id del documento que queremos
        # eliminar. Si existe, significa que no lo podemos eliminar porque está presentado.
        # Si no existe, puede eliminarse el documento.
        # Si el ficher AplicacionIsmael/Ficheros/FpresenDoc no existe, puede eliminarse directamente el documento.
        if [ -f AplicacionIsmael/Ficheros/FpresenDoc ]; then
            # id_usuario:id_cliente:id_documento:id_organismo:motivo_presentación:comunidad_autónoma:población:fecha
            # Buscamos si el documento está presentado. Si lo está, enc=1.
            # Si no, enc=0.
            while IFS= read -r line; do
                IFS=':' read -ra VALUES <<<"$line"
                ## To pritn all values
                for i in "${VALUES[2]}"; do
                    if [ $i == $id_documento ]; then
                        enc=1
                    fi
                done
            done <AplicacionIsmael/Ficheros/FpresenDoc

        else
            enc=0
        fi

        # Si no hemos encontrado el documento con el id introducido o no existe el fichero AplicacionIsmael/Ficheros/FpresenDoc,
        # borramos la línea correspondiente a dicho documento en AplicacionIsmael/Ficheros/Fdocumento
        if [ $enc -eq 0 ]; then
            # Guardamos en el fichero temp la línea correspondiente al cliente seleccionado.
            local linea=0
            awk -v id_local_baja=$id_documento -F ":" '{
            if($2==id_local_baja) {
                    printf $1
                    printf ":"
                    printf $2
                    printf ":"
                    printf $3
                    printf ":"
                    printf $4
                }
            }' AplicacionIsmael/Ficheros/Fdocumento >temp

            read -r linea <temp # Leemos el fichero temp que contiene la línea a borrar.
            echo "Línea encontrada: " $linea
            sed -i "\|$linea|d" AplicacionIsmael/Ficheros/Fdocumento # Borramos la línea del documento seleccionado del fichero AplicacionIsmael/Ficheros/Fdocumento.
            rm temp                                                  # Borramos el ficher temp.
        else
            echo "Documento no encontrado."
            pulsa_para_continuar
        fi

    else
        echo "(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fdocumento no existe."
        pulsa_para_continuar
    fi

    return

}

# Función que presenta un documento de Fdocumento a un organismo que está en Forganismos
function gestion_documentos_presentacion_documento() {
    # id_usuario:id_cliente:id_documento:id_organismo:motivo_presentación:comunidad_autónoma:población:fecha
    if [ -f AplicacionIsmael/Ficheros/Fdocumento ]; then
        if [ -f AplicacionIsmael/Ficheros/Fclientes ]; then

            area_clientes_consulta_cliente

            local id_cliente=0
            echo -n "Introduzca el id del cliente que desea presentar un documento: "
            read id_cliente

            if ! [ -f AplicacionIsmael/Ficheros/FpresenDoc ]; then
                echo "No existe el fichero AplicacionIsmael/Ficheros/FpresenDoc. Va a crearse uno."
                echo -n "" >AplicacionIsmael/Ficheros/FpresenDoc
            fi

            # Buscamos si el documento está presentado. Si lo está, enc=1.
            # Si no, enc=0.
            local enc_cliente=0
            while IFS= read -r line; do
                IFS=':' read -ra VALUES <<<"$line"
                ## To pritn all values
                for i in "${VALUES[0]}"; do
                    if [ ${VALUES[10]} == $id_cliente ] && [ ${VALUES[10]} == "S" ]; then
                        enc_cliente=1
                    fi
                done
            done <AplicacionIsmael/Ficheros/FpresenDoc

            mostrar_documentos

            local id_documento=0
            echo -n "Introduzca el id del documento que desea presentar a un organismo: "
            read id_documento

            # Buscamos si el documento está presentado. Si lo está, enc=1.
            # Si no, enc=0.
            local enc=0
            while IFS= read -r line; do
                IFS=':' read -ra VALUES <<<"$line"
                ## To pritn all values
                for i in "${VALUES[0]}"; do
                    if [ $i == $id_local ] && [ ${VALUES[10]} == "S" ]; then
                        enc=1
                    fi
                done
            done <AplicacionIsmael/Ficheros/FpresenDoc

            # Si hemos encontrado el documento con el id introducido, borramos la línea correspondiente
            # a dicho documento en AplicacionIsmael/Ficheros/Fdocumento
            if ! [ $enc -eq 1 ]; then

                # Mostramos los organismos.
                mostrar_organismos

                local id_organismo=0
                echo -n "Introduzca el id del organismo al que quiere presentar el documento: "
                read id_organismo

                local enc2=0
                while IFS= read -r line; do
                    IFS=':' read -ra VALUES <<<"$line"
                    ## To pritn all values
                    for i in "${VALUES[0]}"; do
                        if [ $i == $id_organismo ]; then
                            enc2=1
                        fi
                    done
                done <AplicacionIsmael/Ficheros/Forganismos

                if [ $enc2 -eq 1 ]; then

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

                else
                    echo "(tput setaf 1)No existe el organismo introducido."
                    pulsa_para_continuar
                fi
            else
                echo "El documento ya ha sido presentado."
                pulsa_para_continuar
            fi
        else
            echo "(tput setaf 1)El fichero de clientes no existe."
            pulsa_para_continuar
        fi

    else
        echo "(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fdocumento no existe."
        pulsa_para_continuar
    fi

    pulsa_para_continuar

    return
}

# Función que muestra todos los documentos asociados a cada cliente del fichero Fclientes
function gestion_documentos_consultas_cliente() {
    if [ -f AplicacionIsmael/Ficheros/Fclientes ]; then

        if [ -f AplicacionIsmael/Ficheros/Fdocumento ]; then

            while IFS= read -r line; do
                IFS=':' read -ra VALUES <<<"$line"
                ## To pritn all values
                for i in "${VALUES[0]}"; do
                    if [ ${VALUES[10]} == "S" ]; then
                        printf "\e[4m%-10s\e[0m" "Id"        # Valor 1
                        printf "\e[4m%-15s\e[0m" "Nombre"    # Valor 2
                        printf "\e[4m%-17s\e[0m" "Apellidos" # Valor 3
                        printf "\n"

                        printf "%-10s" ${VALUES[0]}
                        printf "%-15s" ${VALUES[1]}
                        printf "%-17s" ${VALUES[2]}
                        printf "\n"

                        local id_cliente=${VALUES[0]}

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

                    fi

                    printf "\n"

                done
            done <AplicacionIsmael/Ficheros/Fclientes

            rm AplicacionIsmael/Ficheros/temp

        else
            echo "$(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fdocumento no existe."
        fi

    else
        echo "$(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fclientes no existe."
    fi

    pulsa_para_continuar

    return
}

# Función que muestra todos los documentos asociados a un cliente dado.
function gestion_documentos_consultas_cliente_dado() {
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

    pulsa_para_continuar

    return

}

function gestion_documentos_consultas_organismos() {
    if [ -f AplicacionIsmael/Ficheros/Fdocumento ]; then
        mostrar_documentos

        local id_documento=0
        echo -n "Introduzca el id del documento que desea consultar los organismos a los que se ha presentado: "
        read id_documento

        # Si el fichero AplicacionIsmael/Ficheros/FpresenDoc existe, comprobamos que exista el id del documento que queremos
        # consultar. Si existe, consultamos su id de organismo.
        if [ -f AplicacionIsmael/Ficheros/FpresenDoc ]; then
            # id_usuario:id_cliente:id_documento:id_organismo:motivo_presentación:comunidad_autónoma:población:fecha
            # Buscamos si el documento está presentado.
            # Si no, enc=0.

            printf "\e[4m%-10s\e[0m" "Id"               # Valor 1
            printf "\e[4m%-70s\e[0m" "Nombre organismo" # Valor 2
            printf "\n"

            local id_organismo=0
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
                                printf "%-10s", $1
                                printf "%-70s", $2
                                printf "\n"
                            }
                        }' AplicacionIsmael/Ficheros/Forganismos
                    fi
                done
            done <AplicacionIsmael/Ficheros/FpresenDoc
        fi

    else

        echo "(tput setaf 1)El fichero AplicacionIsmael/Ficheros/Fdocumento no existe."
    fi

    pulsa_para_continuar

    return
}

# Función que muestra el menú asociado a la opción de la consulta de documentos.
# Opción 1: documentos por cliente
#   - Opción 1: muestra todos los documentos asociados a cada cliente del fichero Fclientes
#   - Opción 2: muestra todos los documentos asociados a un cliente dado.
# Opción 2: organismos con documentos
function gestion_documentos_consultas() {
    local correcto=1
    while [ $correcto -eq 1 ]; do
        clear

        echo "██████ CONSULTAS DE DOCUMENTOS ██████"
        echo "       1. Documentos por cliente"
        echo "       2. Organismos con documentos"
        echo "       3. Salir"
        echo "█████████████████████████████████████"

        local variable=0
        read variable
        case $variable in
        1)
            clear

            local correcto_2=1
            while [ $correcto_2 -eq 1 ]; do
                clear

                echo "███████ DOCUMENTOS POR CLIENTE ██████"
                echo "       1. Sin elegir cliente"
                echo "       2. Eligiendo cliente"
                echo "       3. Salir"
                echo "█████████████████████████████████████"

                local variable_2=0
                read variable_2
                case $variable_2 in
                1)
                    clear
                    gestion_documentos_consultas_cliente
                    ;;
                2)
                    clear
                    gestion_documentos_consultas_cliente_dado
                    ;;
                3)
                    correcto_2=0
                    ;;
                *)
                    echo "(tput setaf 1)Opción seleccionada incorrecta"
                    correcto_2=1
                    ;;
                esac
            done

            ;;

        2)
            clear
            gestion_documentos_consultas_organismos
            ;;
        3)
            correcto=0
            ;;
        *)
            echo "(tput setaf 1)Opción seleccionada incorrecta"
            correcto=1
            ;;
        esac
    done
}

# --------------------------------------------------------

clear
iniciar_sesion

if [ $? -eq 1 ]; then
    echo
    echo "Bienvenido/a," $login

    menu_principal

else

    echo "(tput setaf 1)Error. Usuario no encontrado."
fi
