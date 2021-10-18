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

    grep -q $cadena 'Fusuarios' && iniciado=1

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
    if ! [ -f Fclientes ]; then
        echo "No existe el fichero Fclientes. Va a crearse uno."
        echo -n "" >>Fclientes
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
    variable=$(sort -t ':' -n -r Fclientes | head -1 | cut -d ":" -f 1)
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

    echo -e $cadena >>Fclientes

    return
}

# Función que permite modificar un campo específico de un cliente dado.
function area_clientes_modificacion_clientes() {
    if [ -f Fclientes ]; then
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
        done <Fclientes

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
            }' Fclientes >temp

            read -r linea <temp                               # Leemos el fichero temp que contiene la línea a borrar.
            sed -i "\|$linea|d" Fclientes                     # Borramos la línea del cliente seleccionado del fichero Fclientes.
            rm temp                                           # Borramos el fichero temp.
            linea=${linea%?}                                  # Quitamos la letra S del final de la variable linea.
            linea="$linea""N"                                 # Añadimos N al final de linea.
            echo $linea >>Fclientes                           # Ponemos linea en el fichero Fclientes.
            sort -k1 -t':' Fclientes >tmp && mv tmp Fclientes # Ordenamos el fichero Fclientes
        fi
    else
        echo "El fichero Fclientes no existe."
        pulsa_para_continuar
    fi

    return
}

# Función que permite dar de baja un cliente, es decir, poner el campo activo a N.
function area_clientes_baja_cliente() {
    if [ -f Fclientes ]; then
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
        done <Fclientes

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
            }' Fclientes >temp

            read -r linea <temp                               # Leemos el fichero temp que contiene la línea a borrar.
            sed -i "\|$linea|d" Fclientes                     # Borramos la línea del cliente seleccionado del fichero Fclientes.
            rm temp                                           # Borramos el fichero temp.
            linea=${linea%?}                                  # Quitamos la letra S del final de la variable linea.
            linea="$linea""N"                                 # Añadimos N al final de linea.
            echo $linea >>Fclientes                           # Ponemos linea en el fichero Fclientes.
            sort -k1 -t':' Fclientes >tmp && mv tmp Fclientes # Ordenamos el fichero Fclientes
        else
            echo "Cliente no encontrado."
        fi

    else
        echo "El fichero Fclientes no existe."
        pulsa_para_continuar
    fi

    return
}

# Función que muestra todos los clientes. Puede seleccionarse si desean verse los activos o
# los no activos.
function area_clientes_consulta_cliente() {
    if [ -f Fclientes ]; then
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
                }' Fclientes

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
                }' Fclientes
                correcto=0
                ;;
            *)
                echo "Opción seleccionada incorrecta"
                correcto=1
                ;;
            esac
        done
    else
        echo "El fichero Fclientes no existe."
    fi

    return
}

# --------------------------------------------------------

# ----------------- Gestión de documentos ----------------

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
            echo "Opción seleccionada incorrecta"
            correcto=1
            ;;
        esac
    done
}

function gestion_documentos_alta_documento() {
    # Comprobamos que el fichero Fclientes existe. Si no, no podemos
    # dar de alta un documento.
    if [ -f Fclientes ]; then
        # Comprobamos que el fichero Fdocumento exista. Si no, lo creamos.
        if ! [ -f Fdocumento ]; then
            echo "No existe el fichero Fdocumento. Va a crearse uno."
            echo -n "" >>Fdocumento
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
        done <Fclientes

        # Comprobamos que el cliente especificado existe. Si no, muestra un
        # mensaje de error.
        if [ $enc -eq 1 ]; then
            # Asignación de id_documento
            local variable=$(sort -t ':' -n -r Fdocumento | head -1 | cut -d ":" -f 2)
            local id_documento=$((variable + 1))

            echo -n "Introduzca una descripción: "
            read descripcion

            local fecha=$(date +"%d/%m/%Y") # Tomamos la fecha.
            echo $fecha

            local cadena=$id_cliente:$id_documento:$descripcion:$fecha

            echo -e $cadena >>Fdocumento # Añadimos la línea al fichero Fdocumento
        else
            echo "El cliente especificado no existe."
            pulsa_para_continuar
        fi
    else
        echo "No existe el fichero Fclientes, no puede dar de alta documentos."
        pulsa_para_continuar
    fi

    return
}

function gestion_documentos_baja_documento() {
    if [ -f Fdocumento ]; then
        local id_documento=0
        echo -n "Introduzca el id del documento que desea dar de baja: "
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
        done <FpresenDoc

        # Si hemos encontrado el documento con el id introducido, borramos la línea correspondiente
        # a dicho documento en Fdocumento
        if [ $enc -eq 1 ]; then
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
                    printf ":"
                    printf $5
                    printf ":"
                    printf $6
                    printf ":"
                    printf $7
                    printf ":"
                    printf $8
                }
            }' Fdocumento >temp

            read -r linea <temp            # Leemos el fichero temp que contiene la línea a borrar.
            sed -i "\|$linea|d" Fdocumento # Borramos la línea del documento seleccionado del fichero Fdocumento.
            rm temp                        # Borramos el ficher temp.
        else
            echo "Documento no encontrado."
        fi

    else
        echo "El fichero Fdocumento no existe."
        pulsa_para_continuar
    fi

    return
}

function mostrar_organismos() {
    if [ -f Forganismos ]; then

        printf "\e[4m%-10s\e[0m" "Id"               # Valor 1
        printf "\e[4m%-70s\e[0m" "Nombre organismo" # Valor 2
        printf "\n"

        awk -F ":" '{
        printf "%-10s", $1
        printf "%-70s", $2
        printf "\n"
    }' Forganismos

    else
        echo "El fichero Forganismos no existe."
    fi
}

function gestion_documentos_presentacion_documento() {

}

# --------------------------------------------------------

clear
iniciar_sesion

if [ $? -eq 1 ]; then
    echo
    echo "Bienvenido/a," $login

    menu_principal

else

    echo "Error. Usuario no encontrado."
fi
