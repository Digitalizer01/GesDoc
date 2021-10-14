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

function iniciar_sesion() {
    local iniciado=0 # Si vale 0 no se ha encontrado usuario. Si vale 1, se ha encontrado usuario.

    echo "Introduzca los datos:"
    echo -n "Usuario: "
    read login

    echo -n "Contraseña: "
    read contrasenia

    local cadena=$login:$contrasenia

    grep -q $cadena 'Fusuarios' && iniciado=1

    return $iniciado
}

function menu_principal() {
    echo "1. Área de clientes"
    echo "2. Gestión de documentos"
    echo "3. Gestión de informes"
    echo "4. Ayuda"
    echo "5. Salir"
}

# ------------------- Area de clientes -------------------

function area_clientes() {
    local correcto=1
    while [ $correcto -eq 1 ]; do
        echo "1. Alta de clientes"
        echo "2. Modificación clientes"
        echo "3. Baja cliente"
        echo "4. Consulta cliente"
        echo "5. Salir"

        local variable=0
        read variable
        case $variable in
        1)
            area_clientes_alta_clientes
            correcto=0
            ;;
        2)
            area_clientes_modificacion_clientes
            correcto=0
            ;;
        3)
            area_clientes_baja_cliente
            correcto=0
            ;;
        4)
            area_clientes_consulta_cliente
            correcto=0
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

function area_clientes_alta_clientes() {
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

#function area_clientes_modificacion_clientes(){

#}

#function area_clientes_baja_cliente(){

#}

function area_clientes_consulta_cliente() {

    if ! [ -f "Fclientes" ]; then
        echo "El fichero de clientes no existe"
    else
        local activos=1 # Si activos=1, la consulta se hará de los clientes con activo=S. Si activo=0, la consulta se hará de los clientes con activo=N.

        local correcto=1
        while [ $correcto -eq 1 ]; do
            echo "¿Desea consultar los clientes activos o los no activos?"
            echo "Para seleccionar los activos, pulse S."
            echo "Para seleccionar los no activos, pulse N."
            read activos

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
    fi

    return
}

# --------------------------------------------------------

# ----------------- Gestión de documentos ----------------

function gestion_documentos() {
    echo "1. Alta de documento"
    echo "2. Baja documento"
    echo "3. Presentación de documento"
    echo "4. Consultas"
    echo "5. Salir"
}

# --------------------------------------------------------

iniciar_sesion

if [ $? -eq 1 ]; then
    echo
    echo "Bienvenido/a," $login

    menu_principal

    correcto_menu_principal=1
    while [ $correcto_menu_principal -eq 1 ]; do
        read variable_menu_principal
        case $variable_menu_principal in
        1)
            area_clientes
            correcto_menu_principal=0
            ;;
        2)
            gestion_documentos
            correcto_menu_principal=0
            ;;
        3)
            echo "Ha seleccionado gestión de informes"
            correcto_menu_principal=0
            ;;
        4)
            echo "Ha seleccionado ayuda"
            correcto_menu_principal=0
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
    done

else
    echo "Error. Usuario no encontrado."
fi
