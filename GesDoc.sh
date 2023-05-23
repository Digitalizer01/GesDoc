# Creamos las carpetas necesarias para el correcto funcionamiento del programa

# Comprobamos que la carpeta Aplicacion existe. Si no existe, la creamos.
if ! [ -d "Aplicacion" ]; then
    echo "El directorio de la aplicación no existe. Va a crearse uno."
    mkdir "Aplicacion"
fi

# Comprobamos que la carpeta AreaCli existe dentro de Aplicacion. Si no existe, la creamos.
if ! [ -d "Aplicacion/AreaCli" ]; then
    echo "El directorio del área de clientes no existe. Va a crearse uno."
    mkdir "Aplicacion/AreaCli"
fi

# Comprobamos que la carpeta Ficheros existe dentro de Aplicacion. Si no existe, la creamos.
if ! [ -d "Aplicacion/Ficheros" ]; then
    echo "El directorio de ficheros no existe. Va a crearse uno."
    mkdir "Aplicacion/Ficheros"
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

    if ! [ -f "Aplicacion/Ficheros/Fusuarios" ]; then
        echo "El fichero Fusuarios no existe. Por favor, proporcione uno en Aplicacion/Ficheros/Fusuarios."
    else
        grep -q $cadena 'Aplicacion/Ficheros/Fusuarios' && iniciado=1
    fi

    return $iniciado
}

# Función que permite registrar las acciones de un usuario por el sistema. La función recibe 3 parámetros:
# Parámetro 1: acción del usuario.
#
# 1: Area cliente
#   1.1: Alta clientes										(cliente: 1) (documento: ---)
#   1.2: Modificación clientes								(cliente: 1) (documento: ---)
#   1.3: Baja clientes										(cliente: 1) (documento: ---)
#   1.4: Consulta clientes                                  (cliente: ---) (documento: ---)
#       1.4.1: Consulta clientes activos 					(cliente: varios) (documento: ---)
#       1.4.2: Consulta clientes no activos 				(cliente: varios) (documento: ---)
#   1.5: Salir del menú de clientes 						(cliente: ---) (documento: ---)
# 2: Gestión de documentos                                  (cliente: ---) (documento: ---)
#   2.1: Alta documentos 									(cliente: 1) (documento: 1)
#   2.2: Baja documentos 									(cliente: 1) (documento: 1)
#   2.3: Presentación documentos 							(cliente: 1) (documento: 1)
#   2.4: Consultas documentos                               (cliente: ---) (documento: ---)
#       2.4.1: Consulta de documentos de clientes 			(cliente: 1) (documento: varios)
#       2.4.2: Consulta de organismos de documento 			(cliente: 1) (documento: 1)
#   2.5: Salir menú de documentos 							(cliente: ---) (documento: ---)
# 3: Gestión de informes                                    (cliente: ---) (documento: ---)
#   3.1: Documentos de clientes 							(cliente: varios) (documento: varios)
#   3.2: Acciones de usuario dado 							(cliente: ---) (documento: ---)
#   3.3: Salir menú de informes 							(cliente: ---) (documento: ---)
# 4: Ayuda                                                  (cliente: ---) (documento: ---)
# 5: Salir de la aplicación                                 (cliente: ---) (documento: ---)
#
#
#
# Parámetro 2: si la operación es sobre un cliente en particular, se registrará el id de cliente.
#              Si es de varios clientes, se anotará "varios".Si la operación no es sobre
#              clientes, se anotará "---"
#
# Parámetro 3: si la operación es sobre un documento de un cliente en particular se registrará el id
#              de documento. Si es de varios clientes, se anotará "varios". Si la operación no es sobre
#              documentos, se anotará "---"
function fichero_operaciones() {
    # id_usuario:fecha:hora:operación:id_cliente:id_documento

    if [ $# == 3 ]; then
        local fecha=$(date +"%d/%m/%Y") # Tomamos la fecha.
        local hora=$(date +%H_%M)       # Tomamos la hora.
        echo $login:$fecha:$hora:$1:$2:$3 >>Aplicacion/Ficheros/Foperaciones
    fi

    return
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
            gestion_informes
            ;;
        4)
            clear

            echo "La opción 1 (Área de clientes) se encargará de todas las operaciones relacionadas con las
altas/bajas/modificaciones de los datos de los clientes. La opción 2 se encarga de la gestión de documentos de
los clientes. La opción 3 (Gestión de informes) permitirá la emisión de informes de la información que esta
aplicación gestiona. La opción 4 (Ayuda) mostrará ayuda de cada proceso que incluye. La opción 5 (Salir)
finaliza la aplicación."

            echo ""
            echo "Menú:"
            echo " 1: Area cliente
   1.1: Alta clientes
   1.2: Modificación clientes
   1.3: Baja clientes
   1.4: Consulta clientes
       1.4.1: Consulta clientes activos
       1.4.2: Consulta clientes no activos
   1.5: Salir del menú de clientes
 2: Gestión de documentos
   2.1: Alta documentos
   2.2: Baja documentos
   2.3: Presentación documentos
   2.4: Consultas documentos
       2.4.1: Consulta de documentos de clientes
       2.4.2: Consulta de organismos de documento
   2.5: Salir menú de documentos
 3: Gestión de informes
   3.1: Documentos de clientes
   3.2: Acciones de usuario dado
   3.3: Salir menú de informes
 4: Ayuda
 5: Salir de la aplicación"
            fichero_operaciones 4 --- ---

            pulsa_para_continuar
            ;;
        5)
            fichero_operaciones 5 --- ---
            exit
            correcto_menu_principal=0
            ;;
        *)
            echo "Opción seleccionada incorrecta"
            correcto_menu_principal=1
            ;;
        esac

    done

    return
}

# ------------------- Area de clientes -------------------

# id_cliente:nombre:apellidos:dirección:ciudad:provincia:país:dni:teléfono:carpetadoc:activo

# Función que permite la selección de las diferentes posibles opciones del área de clientes.
function area_clientes() {
    fichero_operaciones 1 --- ---

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
            fichero_operaciones 1.5 --- ---
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
    if ! [ -f Aplicacion/Ficheros/Fclientes ]; then
        echo "No existe el fichero Aplicacion/Ficheros/Fclientes. Va a crearse uno."
        echo -n "" >>Aplicacion/Ficheros/Fclientes
    fi

    clear

    local id
    local nombre
    local apellidos
    local direccion
    local ciudad
    local provincia
    local pais
    local dni
    local direccion
    local telefono
    local carpetadoc
    local activo

    # Asignación de id
    variable=$(sort -t ':' -n -r Aplicacion/Ficheros/Fclientes | head -1 | cut -d ":" -f 1)
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

    echo -n "Introduzca DNI: "
    read dni

    echo -n "Introduzca telefono: "
    read telefono

    carpetadoc="$id""_Doc"
    mkdir "Aplicacion/AreaCli/$carpetadoc"                                                         # Creamos la carpeta del cliente.
    local cadena=$id:$nombre:$apellidos:$direccion:$ciudad:$provincia:$pais:$dni:$telefono:$carpetadoc:S # Cadena referida al cliente
    echo -e $cadena >>Aplicacion/Ficheros/Fclientes                                                # Guardamos la cadena anterior en el fichero Fclientes

    fichero_operaciones 1.1 $id ---

    return
}

# Función que permite modificar un campo específico de un cliente dado.
function area_clientes_modificacion_clientes() {
    if [ -f Aplicacion/Ficheros/Fclientes ]; then
        area_clientes_consulta_cliente_activos

        local id_local
        echo -n "Introduzca el id del cliente que desea modificar: "
        read id_local

        local nombre=0
        local apellidos=0
        local direccion=0
        local ciudad=0
        local provincia=0
        local pais=0
        local dni=0
        local telefono=0
        local carpetadoc=0
        local activo=0

        local linea_cliente_original=0
        local linea_cliente_nueva=0

        local enc=0
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

                    # Guardamos en linea_cliente_original todos los datos del cliente antes de modificarse.
                    linea_cliente_original=$id_local:$nombre:$apellidos:$direccion:$ciudad:$provincia:$pais:$dni:$telefono:$carpetadoc:$activo
                fi
            done
        done <Aplicacion/Ficheros/Fclientes

        # Si hemos encontrado el cliente con el id introducido y está activo, entramos (es decir, enc=1)
        if [ $enc -eq 1 ]; then

            clear

            echo "████████ MODIFICAR CLIENTES █████████"
            echo "       1. Nombre"
            echo "       2. Apellidos"
            echo "       3. Dirección"
            echo "       4. Ciudad"
            echo "       5. Provincia"
            echo "       6. País"
            echo "       7. DNI"
            echo "       8. Teléfono"
            echo "█████████████████████████████████████"

            local variable=0
            read variable
            case $variable in
            1)
                clear
                echo -n "Introduzca el nuevo nombre: "
                read nombre
                ;;
            2)
                clear
                echo -n "Introduzca los nuevos apellidos: "
                read apellidos
                ;;
            3)
                clear
                echo -n "Introduzca la nueva dirección: "
                read direccion
                ;;
            4)
                clear
                echo -n "Introduzca la nueva ciudad: "
                read ciudad
                ;;
            5)
                clear
                echo -n "Introduzca la nueva provincia: "
                read provincia
                ;;
            6)
                clear
                echo -n "Introduzca el nuevo país: "
                read pais
                ;;
            7)
                clear
                echo -n "Introduzca el nuevo DNI: "
                read dni
                ;;
            8)
                clear
                echo -n "Introduzca el nuevo teléfono: "
                read telefono
                ;;
            *)
                echo "Opción seleccionada incorrecta"
                correcto=1
                ;;
            esac

            # Guardamos en linea_cliente_nueva todos los datos del cliente después de modificarse.
            linea_cliente_nueva=$id_local:$nombre:$apellidos:$direccion:$ciudad:$provincia:$pais:$dni:$telefono:$carpetadoc:$activo
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
            }' Aplicacion/Ficheros/Fclientes >Aplicacion/Ficheros/temp

            # Leemos el fichero temp que contiene la línea a borrar.
            read -r linea <Aplicacion/Ficheros/temp
            # Borramos la línea del cliente seleccionado del fichero Aplicacion/Ficheros/Fclientes.
            sed -i "\|$linea|d" Aplicacion/Ficheros/Fclientes
            # Borramos el fichero temp.
            rm Aplicacion/Ficheros/temp
            # Guardamos en linea el cliente después de la modificación.
            linea=$linea_cliente_nueva
            # Ponemos linea en el fichero Aplicacion/Ficheros/Fclientes.
            echo $linea >>Aplicacion/Ficheros/Fclientes
            # Ordenamos el fichero Aplicacion/Ficheros/Fclientes
            sort -k1 -t':' Aplicacion/Ficheros/Fclientes >Aplicacion/Ficheros/temp && mv Aplicacion/Ficheros/temp Aplicacion/Ficheros/Fclientes

            fichero_operaciones 1.2 $id_local $id_local ---
        else
            echo "El cliente indicado no existe."
            fichero_operaciones 1.2 --- ---
        fi
    else
        echo "El fichero Aplicacion/Ficheros/Fclientes no existe."
        fichero_operaciones 1.2 --- ---
        pulsa_para_continuar
    fi

    return
}

# Función que permite dar de baja un cliente, es decir, poner el campo activo a N.
function area_clientes_baja_cliente() {
    if [ -f Aplicacion/Ficheros/Fclientes ]; then
        area_clientes_consulta_cliente_activos

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
        done <Aplicacion/Ficheros/Fclientes

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
            }' Aplicacion/Ficheros/Fclientes >Aplicacion/Ficheros/temp

            # Leemos el fichero temp que contiene la línea a borrar.
            read -r linea <Aplicacion/Ficheros/temp
            # Borramos la línea del cliente seleccionado del fichero Aplicacion/Ficheros/Fclientes.
            sed -i "\|$linea|d" Aplicacion/Ficheros/Fclientes
            # Borramos el fichero temp.
            rm Aplicacion/Ficheros/temp
            # Quitamos la letra S del final de la variable linea.
            linea=${linea%?}
            # Añadimos N al final de linea.
            linea="$linea""N"
            # Ponemos linea en el fichero Aplicacion/Ficheros/Fclientes.
            echo $linea >>Aplicacion/Ficheros/Fclientes
            # Ordenamos el fichero Aplicacion/Ficheros/Fclientes
            sort -k1 -t':' Aplicacion/Ficheros/Fclientes >tmp && mv tmp Aplicacion/Ficheros/Fclientes

            fichero_operaciones 1.3 $id_local ---

        else
            echo "Cliente no encontrado."
            fichero_operaciones 1.3 --- ---
            pulsa_para_continuar
        fi

    else
        echo "El fichero Aplicacion/Ficheros/Fclientes no existe."
        fichero_operaciones 1.3 --- ---
        pulsa_para_continuar
    fi

    return
}

function area_clientes_consulta_cliente_activos() {
    if [ -f Aplicacion/Ficheros/Fclientes ]; then
        # Activos

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
        }' Aplicacion/Ficheros/Fclientes

        fichero_operaciones 1.4.1 varios ---
    else
        echo "El fichero Aplicacion/Ficheros/Fclientes no existe."
        fichero_operaciones 1.4.1 --- ---
    fi

    return
}

function area_clientes_consulta_cliente_no_activos() {

    if [ -f Aplicacion/Ficheros/Fclientes ]; then
        # No activos
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
        }' Aplicacion/Ficheros/Fclientes

        fichero_operaciones 1.4.2 varios ---
    else
        echo "El fichero Aplicacion/Ficheros/Fclientes no existe."
        fichero_operaciones 1.4.2 --- ---
    fi

    return
}

# Función que muestra todos los clientes. Puede seleccionarse si desean verse los activos o
# los no activos.
function area_clientes_consulta_cliente() {

    if [ -f Aplicacion/Ficheros/Fclientes ]; then
        local activos=1 # Si activos=1, la consulta se hará de los clientes con activo=S. Si activo=0, la consulta se hará de los clientes con activo=N.

        local correcto=1
        while [ $correcto -eq 1 ]; do
            echo "████████ CONSULTAR CLIENTES █████████"
            echo "       1. Clientes activos"
            echo "       2. Clientes no activos"
            echo "█████████████████████████████████████"

            read activos
            clear

            case $activos in
            1)
                area_clientes_consulta_cliente_activos
                correcto=0
                ;;
            2)
                area_clientes_consulta_cliente_no_activos
                correcto=0
                ;;
            *)
                echo "Opción seleccionada incorrecta"
                correcto=1
                ;;
            esac
        done
    else
        echo "El fichero Aplicacion/Ficheros/Fclientes no existe."
    fi

    return
}

# --------------------------------------------------------

# ----------------- Gestión de documentos ----------------

# Función que muestra todos los organismos del fichero Forganimos
function mostrar_organismos() {
    if [ -f Aplicacion/Ficheros/Forganismos ]; then

        printf "\e[4m%-10s\e[0m" "Id"               # Valor 1
        printf "\e[4m%-70s\e[0m" "Nombre organismo" # Valor 2
        printf "\n"

        awk -F ":" '{
        printf "%-10s", $1
        printf "%-70s", $2
        printf "\n"
    }' Aplicacion/Ficheros/Forganismos

    else
        echo "El fichero Aplicacion/Ficheros/Forganismos no existe."
    fi
}

# Función que recibe un id de cliente y devuelve si existe o no.
# Parámetro 1: id_cliente
# Salida: 0 si no existe. 1 si sí existe.
function existe_cliente() {

    # Recorremos el fichero de clientes para averiguar si existe o no.

    local enc=0
    local id_cliente=$1

    while IFS= read -r line; do
        IFS=':' read -ra VALUES <<<"$line"
        ## To pritn all values
        for i in "${VALUES[0]}"; do
            if [ ${VALUES[0]} == $id_cliente ]; then
                enc=1
            fi
        done
    done <Aplicacion/Ficheros/Fclientes

    return $enc
}

# Función que recibe un id de documento y devuelve si existe o no.
# Parámetro 1: id_documento
# Salida: 0 si no existe. 1 si sí existe.
function existe_documento() {

    # Recorremos el fichero de documentos para averiguar si existe o no.

    local enc=0
    local id_documento=$1

    while IFS= read -r line; do
        IFS=':' read -ra VALUES <<<"$line"
        ## To pritn all values
        for i in "${VALUES[0]}"; do
            if [ ${VALUES[1]} == $id_documento ]; then
                enc=1
            fi
        done
    done <Aplicacion/Ficheros/Fdocumento

    return $enc
}

# Función que recibe un parámetro id_cliente y determina si el cliente está activo o no.
# Parámetro 1: id_cliente
# Salida: 0 si el cliente está inactivo. 1 si el cliente está activo.
function cliente_activo() {

    # Recorremos el fichero de clientes para encontrar el que tenemos
    # por parámetro y comprobar si está activo o no.

    local activo=0
    local id_cliente=$1

    while IFS= read -r line; do
        IFS=':' read -ra VALUES <<<"$line"
        ## To pritn all values
        for i in "${VALUES[0]}"; do
            if [ ${VALUES[0]} == "$id_cliente" ]; then
                if [ ${VALUES[10]} == "S" ]; then
                    activo=1
                fi
            fi
        done
    done <Aplicacion/Ficheros/Fclientes

    return $activo
}

# Función que recibe por parámetro el id de un documento y devuelve si está asociado a un cliente activo o no.
# Parámetro 1: id_documento
# Salida: 0 si el cliente es inactivo. 1 si el cliente es activo.
function documento_pertenece_cliente_activo() {

    local id_documento=$1
    local id_cliente_documento=0
    local activo=0

    # Vamos a recorrer el fichero Fdocumentos para encontrar el id del cliente asociado al
    # fichero que hemos pasado por parámetros.

    while IFS= read -r line && [ $activo -eq 0 ]; do
        IFS=':' read -ra VALUES <<<"$line"
        ## To pritn all values
        for i in "${VALUES[0]}"; do
            id_cliente_documento=${VALUES[0]}

            cliente_activo $id_cliente_documento

            if [ $? -eq 1 ]; then
                activo=1
            fi
        done
    done <Aplicacion/Ficheros/Fdocumento

    return $activo
}

# Función que muestra todos los documentos del fichero Fdocumento
function mostrar_documentos() {
    if [ -f Aplicacion/Ficheros/Fdocumento ]; then

        printf "\e[4m%-20s\e[0m" "Id cliente"   # Valor 1
        printf "\e[4m%-20s\e[0m" "Id documento" # Valor 2
        printf "\e[4m%-70s\e[0m" "Descripción"  # Valor 3
        printf "\e[4m%-11s\e[0m" "Fecha"        # Valor 4
        printf "\n"

        # Leemos todos los documentos que haya en Fdocumentos, pero solo se mostrarán los que contengan
        # un id de cliente que esté activo.
        # Recorreremos el fichero de documentos. Por cada documento, comprobaremos que el id de cliente
        # se encuentre en el fichero temp_clientes_activos. Si lo está, lo mostraremos.
        local id_cliente_documento=0
        local id_documento=0
        local descripcion=0
        local fecha=0

        local id_cliente_fclientes=0
        while IFS= read -r line; do
            IFS=':' read -ra VALUES <<<"$line"
            ## To pritn all values
            for i in "${VALUES[2]}"; do
                id_cliente_documento=${VALUES[0]}
                id_documento=${VALUES[1]}
                descripcion=${VALUES[2]}
                fecha=${VALUES[3]}

                # Recorremos el fichero de clientes para ver si el id de cliente del documento
                # coincide con que dicho cliente está activo.

                documento_pertenece_cliente_activo $id_cliente_documento
                local cliente_activo=$?

                if [ $cliente_activo -eq 1 ]; then
                    printf "$id_cliente_documento"
                    printf "%-18s $id_documento"
                    printf "%-18s $descripcion"
                    printf "%-60s $fecha"
                    printf "\n"
                fi

            done

        done <Aplicacion/Ficheros/Fdocumento

    else

        echo "El fichero Aplicacion/Ficheros/Fdocumento no existe."
    fi
}

# Función que muestra el menú referido al apartado de Gestión de documentos
function gestion_documentos() {
    fichero_operaciones 2 --- ---

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

# Función para crear un documento en el directorio de un cliente dado.
# El documento tendrá como nombre su id.
# Parámetro 1: id_cliente (para encontrar la dirección del directorio del cliente)
# Parámetro 2: id_documento (para el nombre del documento)
function crear_documento() {
    direccion="Aplicacion/AreaCli/$id_cliente""_Doc/$id_documento"
    touch $direccion
}

# Función que da de alta un documento en el fichero Fdocumento.
# Se crea un fichero en blanco con el nombre de su id de documento en el directorio del cliente
# indicado.
function gestion_documentos_alta_documento() {
    # Comprobamos que el fichero Aplicacion/Ficheros/Fclientes existe. Si no, no podemos
    # dar de alta un documento.
    if [ -f Aplicacion/Ficheros/Fclientes ]; then
        # Comprobamos que el fichero Aplicacion/Ficheros/Fdocumento exista. Si no, lo creamos.
        if ! [ -f Aplicacion/Ficheros/Fdocumento ]; then
            echo "No existe el fichero Aplicacion/Ficheros/Fdocumento. Va a crearse uno."
            echo -n "" >>Aplicacion/Ficheros/Fdocumento
        fi

        area_clientes_consulta_cliente_activos # Mostramos los clientes.

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
        done <Aplicacion/Ficheros/Fclientes

        # Comprobamos que el cliente especificado existe. Si no, muestra un
        # mensaje de error.
        if [ $enc -eq 1 ]; then
            # Asignación de id_documento
            local variable=$(sort -t ':' -k 2 -n -r Aplicacion/Ficheros/Fdocumento | head -1 | cut -d ":" -f 2)
            local id_documento=$((variable + 1))

            echo -n "Introduzca una descripción: "
            read descripcion

            local fecha=$(date +"%d/%m/%Y") # Tomamos la fecha.
            echo $fecha

            local cadena=$id_cliente:$id_documento:$descripcion:$fecha
            echo -e $cadena >>Aplicacion/Ficheros/Fdocumento # Añadimos la línea al fichero Aplicacion/Ficheros/Fdocumento

            crear_documento $id_cliente $id_documento # Creamos el documento en el directorio del cliente. El fichero tiene como nombre su id.
            fichero_operaciones 2.1 $id_cliente $id_documento
        else
            fichero_operaciones 2.1 --- ---
            echo "El cliente especificado no existe."
            pulsa_para_continuar
        fi
    else
        fichero_operaciones 2.1 --- ---
        echo "No existe el fichero Aplicacion/Ficheros/Fclientes, no puede dar de alta documentos."
        pulsa_para_continuar
    fi

    return
}

# Función que permite borrar el documento indicado del cliente indicado de su directorio correspondiente.
# Parámetro 1: id_cliente
# Parámetro 2: id_documento
function borrar_documento() {

    local id_cliente=$1
    local id_documento=$2
    local cadena="Aplicacion/AreaCli/$id_cliente""_Doc/$id_documento"

    rm $cadena

    return
}
# Función que da de baja un documento del fichero Fdocumento eliminando la línea referida
# a dicho documento.
function gestion_documentos_baja_documento() {
    if [ -f Aplicacion/Ficheros/Fdocumento ]; then
        mostrar_documentos

        local id_documento=0
        echo -n "Introduzca el id del documento que desea dar de baja: "
        read id_documento

        local esta_activo=0
        documento_pertenece_cliente_activo $id_documento
        esta_activo=$?

        if [ $esta_activo -eq 1 ]; then
            local enc=0

            # Si el fichero Aplicacion/Ficheros/FpresenDoc existe, comprobamos que exista el id del documento que queremos
            # eliminar. Si existe, significa que no lo podemos eliminar porque está presentado.
            # Si no existe, puede eliminarse el documento.
            # Si el ficher Aplicacion/Ficheros/FpresenDoc no existe, puede eliminarse directamente el documento.
            if [ -f Aplicacion/Ficheros/FpresenDoc ]; then
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
                done <Aplicacion/Ficheros/FpresenDoc

            else
                enc=0
            fi

            # Si no hemos encontrado el documento con el id introducido o no existe el fichero Aplicacion/Ficheros/FpresenDoc,
            # borramos la línea correspondiente a dicho documento en Aplicacion/Ficheros/Fdocumento
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
            }' Aplicacion/Ficheros/Fdocumento >Aplicacion/Ficheros/temp

                read -r linea <Aplicacion/Ficheros/temp                      # Leemos el fichero temp que contiene la línea a borrar.
                local id_cliente=$(cut -d ":" -f 1 Aplicacion/Ficheros/temp) # Obtenemos el id de cliente de la línea.

                sed -i "\|$linea|d" Aplicacion/Ficheros/Fdocumento # Borramos la línea del documento seleccionado del fichero Aplicacion/Ficheros/Fdocumento.
                rm Aplicacion/Ficheros/temp                        # Borramos el ficher temp.
                borrar_documento $id_cliente $id_documento
                fichero_operaciones 2.1 $id_cliente $id_documento
            else
                fichero_operaciones 2.2 --- ---
                echo "El documento indicado no existe o ha sido presentado ya."
                pulsa_para_continuar
            fi
        else
            echo "El documento indicado pertenece a un usuario inactivo"
            fichero_operaciones 2.2 --- ---
            pulsa_para_continuar
        fi

    else

        fichero_operaciones 2.2 --- ---
        echo "El fichero Aplicacion/Ficheros/Fdocumento no existe."
        pulsa_para_continuar
    fi

    return

}

# Función que presenta un documento de Fdocumento a un organismo que está en Forganismos
# No puede presentarse un documento dos veces al mismo organismos, pero sí presentarse
# a varios organismos.
function gestion_documentos_presentacion_documento() {
    # id_usuario:id_cliente:id_documento:id_organismo:motivo_presentación:comunidad_autónoma:población:fecha
    if [ -f Aplicacion/Ficheros/Fdocumento ]; then
        if [ -f Aplicacion/Ficheros/Fclientes ]; then

            area_clientes_consulta_cliente_activos

            local id_cliente=0
            echo -n "Introduzca el id del cliente que desea presentar un documento: "
            read id_cliente

            cliente_activo $id_cliente

            if [ $? -eq 1 ]; then
                if ! [ -f Aplicacion/Ficheros/FpresenDoc ]; then
                    echo "No existe el fichero Aplicacion/Ficheros/FpresenDoc. Va a crearse uno."
                    echo -n "" >Aplicacion/Ficheros/FpresenDoc
                fi

                # Buscamos si el documento está presentado. Si lo está, enc=1.
                # Si no, enc=0.
                local enc_cliente=0
                while IFS= read -r line; do
                    IFS=':' read -ra VALUES <<<"$line"
                    ## To pritn all values
                    for i in "${VALUES[0]}"; do
                        if [ ${VALUES[0]} == $id_cliente ]; then
                            if [ ${VALUES[10]} == "S" ]; then
                                enc_cliente=1
                            fi
                        fi
                    done
                done <Aplicacion/Ficheros/FpresenDoc

                mostrar_documentos

                local id_documento=0
                echo -n "Introduzca el id del documento que desea presentar a un organismo: "
                read id_documento

                existe_documento $id_documento

                if [ $? -eq 1 ]; then
                    local esta_activo=0
                    documento_pertenece_cliente_activo $id_documento
                    esta_activo=$?

                    if [ $esta_activo -eq 1 ]; then
                        # Buscamos si el documento está presentado. Si lo está, enc=1.
                        # Si no, enc=0.
                        local enc=0
                        while IFS= read -r line; do
                            IFS=':' read -ra VALUES <<<"$line"
                            ## To pritn all values
                            for i in "${VALUES[0]}"; do
                                if [ $i == $id_local ]; then
                                    enc=1
                                fi
                            done
                        done <Aplicacion/Ficheros/FpresenDoc

                        # Si hemos encontrado el documento con el id introducido, borramos la línea correspondiente
                        # a dicho documento en Aplicacion/Ficheros/Fdocumento
                        if ! [ $enc -eq 1 ]; then

                            # Mostramos los organismos.
                            mostrar_organismos

                            local id_organismo=0
                            echo -n "Introduzca el id del organismo al que quiere presentar el documento: "
                            read id_organismo

                            cantidad_organismos=($(sort -t ':' -k 1 -n -r Aplicacion/Ficheros/Forganismos | head -1 | cut -d ":" -f 1))

                            if [ $cantidad_organismos -ge $id_organismo ] && [ $id_organismo -ge 1 ]; then
                                local enc2=0
                                while IFS= read -r line; do
                                    IFS=':' read -ra VALUES <<<"$line"
                                    ## To pritn all values
                                    for i in "${VALUES[0]}"; do
                                        if [ $i == $id_organismo ]; then
                                            enc2=1
                                        fi
                                    done
                                done <Aplicacion/Ficheros/Forganismos

                                # Comprobamos que no hayamos presentado anteriormente el documento al mismo organismo
                                # Si se presentó antes a ese mismo organismo, enc3=1
                                # Si no, enc3=0
                                local enc3=0
                                while IFS= read -r line; do
                                    IFS=':' read -ra VALUES <<<"$line"
                                    ## To pritn all values
                                    for i in "${VALUES[3]}"; do
                                        if [ $i == $id_organismo ] && [ $id_cliente == ${VALUES[1]} ]; then
                                            enc3=1
                                        fi
                                    done
                                done <Aplicacion/Ficheros/FpresenDoc

                                if ! [ $enc3 -eq 1 ]; then
                                    # Si no se ha presentado al mismo organismo anteriormente
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
                                    # Guardamos en el fichero FpresenDoc la línea asociada a la presentación del documento indicado.
                                    echo -e $cadena >>Aplicacion/Ficheros/FpresenDoc
                                    fichero_operaciones 2.3 $id_cliente $id_documento

                                else
                                    fichero_operaciones 2.3 --- ---
                                    echo "El documento especificado ya se ha presentado a ese mismo organismo."
                                    pulsa_para_continuar
                                fi
                            else
                                fichero_operaciones 2.3 --- ---
                                echo "El organismo indicado no existe."
                                pulsa_para_continuar
                            fi

                        else
                            fichero_operaciones 2.3 --- ---
                            echo "El documento ya ha sido presentado."
                            pulsa_para_continuar
                        fi
                    else
                        echo "El documento indicado pertenece a un usuario inactivo"
                        fichero_operaciones 2.3 --- ---
                        pulsa_para_continuar
                    fi
                else
                    fichero_operaciones 2.3 --- ---
                    echo "El documento indicado no existe."
                    pulsa_para_continuar
                fi

            else
                fichero_operaciones 2.3 --- ---
                echo "El cliente indicado está inactivo."
                pulsa_para_continuar
            fi

        else

            fichero_operaciones 2.3 --- ---
            echo "El fichero de clientes no existe."
        fi

    else
        fichero_operaciones 2.3 --- ---
        echo "El fichero Aplicacion/Ficheros/Fdocumento no existe."
    fi

    return
}

# Función que muestra todos los documentos asociados a un cliente dado.
function gestion_documentos_consultas_cliente_dado() {
    if [ -f Aplicacion/Ficheros/Fclientes ]; then

        if [ -f Aplicacion/Ficheros/Fdocumento ]; then

            area_clientes_consulta_cliente_activos

            local id_cliente=0
            echo -n "Introduza el id del cliente que desea consultar: "
            read id_cliente

            cliente_activo $id_cliente

            if [ $? -eq 1 ]; then
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
                        printf "\n"
                    }
                }' Aplicacion/Ficheros/Fdocumento >Aplicacion/Ficheros/temp

                # Comprobamos si el fichero temp está vacío o no.
                # Si está vacío, mostraremos el mensaje correspondiente.
                # Si no lo está, mostraremos los datos de los documentos.
                if ! [ -s Aplicacion/Ficheros/temp ]; then
                    fichero_operaciones 2.4.1 $id_cliente ---
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
                }' Aplicacion/Ficheros/temp
                fi

                rm Aplicacion/Ficheros/temp
                fichero_operaciones 2.4.1 $id_cliente "varios"
            else
                fichero_operaciones 2.4.1 --- ---
                echo "El cliente introducido está inactivo."
            fi

        else

            fichero_operaciones 2.4.1 --- ---
            echo "El fichero Aplicacion/Ficheros/Fdocumento no existe."
        fi

    else
        fichero_operaciones 2.4.1 --- ---
        echo "El fichero Aplicacion/Ficheros/Fclientes no existe."
    fi

    pulsa_para_continuar

    return

}

# Función que muestra los organismos asociados a un documento.
function gestion_documentos_consultas_organismos() {
    if [ -f Aplicacion/Ficheros/Fdocumento ]; then
        mostrar_documentos

        local id_documento=0
        echo -n "Introduzca el id del documento que desea consultar los organismos a los que se ha presentado: "
        read id_documento

        documento_pertenece_cliente_activo $id_documento

        if [ $? -eq 1 ]; then
            # Si el fichero Aplicacion/Ficheros/FpresenDoc existe, comprobamos que exista el id del documento que queremos
            # consultar. Si existe, consultamos su id de organismo.
            if [ -f Aplicacion/Ficheros/FpresenDoc ]; then
                # id_usuario:id_cliente:id_documento:id_organismo:motivo_presentación:comunidad_autónoma:población:fecha
                # Buscamos si el documento está presentado.
                # Si no, enc=0.

                printf "\e[4m%-10s\e[0m" "Id"               # Valor 1
                printf "\e[4m%-70s\e[0m" "Nombre organismo" # Valor 2
                printf "\n"

                local id_organismo=0
                local id_cliente=0
                while IFS= read -r line; do
                    IFS=':' read -ra VALUES <<<"$line"
                    ## To pritn all values
                    for i in "${VALUES[2]}"; do
                        if [ $i == $id_documento ]; then
                            id_organismo=${VALUES[3]}
                            id_cliente=${VALUES[1]}
                            # Si no hemos encontrado el documento con el id introducido o no existe el fichero Aplicacion/Ficheros/FpresenDoc,
                            # mostramos el organismo al que se ha presentado el documento.
                            # Guardamos en el fichero temp la línea correspondiente al cliente seleccionado.

                            # id_organismo:nombre_organismo

                            awk -v id_local_organismo=$id_organismo -F ":" '{
                            if($1==id_local_organismo) {
                                    printf "%-10s", $1
                                    printf "%-70s", $2
                                    printf "\n"
                                }
                            }' Aplicacion/Ficheros/Forganismos >Aplicacion/Ficheros/temp

                            # Comprobamos si el documento está presentado a organismos o no.
                            if ! [ -s Aplicacion/Ficheros/temp ]; then
                                echo "El documento indicado no está presentado a ningún organismo."
                            else
                                awk -F ":" '{
                                printf "%-10s", $1
                                printf "%-70s", $2
                                printf "\n"
                            }' Aplicacion/Ficheros/temp
                            fi
                            rm Aplicacion/Ficheros/temp
                        fi
                    done
                done <Aplicacion/Ficheros/FpresenDoc

                fichero_operaciones 2.4.2 $id_cliente $id_documento
            fi

        else
            fichero_operaciones 2.4.2 --- ---
            echo "El documento introducido pertenece a un cliente inactivo o no se ha presentado todavía a un organismo."
        fi

    else

        fichero_operaciones 2.4.2 --- ---
        echo "El fichero Aplicacion/Ficheros/Fdocumento no existe."
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
    fichero_operaciones 2.5 --- ---

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
            gestion_documentos_consultas_cliente_dado
            ;;

        2)
            clear
            gestion_documentos_consultas_organismos
            ;;
        3)
            fichero_operaciones 2.5 --- ---
            correcto=0
            ;;
        *)
            echo "Opción seleccionada incorrecta"
            correcto=1
            ;;
        esac
    done
}
# --------------------------------------------------------

# ------------------ Gestión de informes -----------------

# Función que muestra el menú de la gestión de informes.
# Opción 1: muestra todos los documentos asociados a todos los clientes.
# Opción 2: muestra todas las acciones de un usuario dado.
function gestion_informes() {
    fichero_operaciones 3 --- ---

    local correcto=1
    while [ $correcto -eq 1 ]; do
        clear

        echo "████████ GESTIÓN DE INFORMES ████████"
        echo "       1. Documentos de clientes"
        echo "       2. Acciones de usuarios"
        echo "       3. Salir"
        echo "█████████████████████████████████████"

        local variable=0
        read variable
        case $variable in
        1)
            clear
            gestion_informes_documentos_clientes
            ;;
        2)
            clear
            gestion_informes_acciones_usuarios
            pulsa_para_continuar
            ;;
        3)
            fichero_operaciones 3.3 --- ---
            correcto=0
            ;;
        *)
            echo "Opción seleccionada incorrecta"
            correcto=1
            ;;
        esac
    done

    return
}

# Función que muestra todos los documentos asociados a todos los clientes.
function gestion_informes_documentos_clientes() {
    if [ -f Aplicacion/Ficheros/Fclientes ]; then
        if [ -f Aplicacion/Ficheros/Fdocumento ]; then

            local id_cliente=0

            # Imprimimos la información del cliente

            array=($(cut -f 1 -d ":" Aplicacion/Ficheros/Fclientes))

            for ((i = 0; i < ${#array[*]}; i++)); do
                id_cliente=${array[i]}

                # Guardamos en el fichero temp la información referida al cliente i.
                awk -v id_cliente_local=$id_cliente -F ":" '{
                    if($1==id_cliente_local && $11=="S") {
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
                        printf "\n"
                    }
                }' Aplicacion/Ficheros/Fclientes >Aplicacion/Ficheros/temp

                # Si el fichero temp está vacío, el cliente no cumple los requisitos
                # para ser mostrado.
                # Si no está vacío, cumple los requisitos.

                if [ -s Aplicacion/Ficheros/temp ]; then

                    # Vamos a imprimir la información del cliente con id i
                    # si es activo.
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

                    awk -v id_cliente_local=$id_cliente -F ":" '{
                    if($1==id_cliente_local && $11=="S") {
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
                    }' Aplicacion/Ficheros/Fclientes

                    # Vamos a imprimir todos los documentos asociados al cliente i.
                    printf "\e[4m%-20s\e[0m" "Id cliente"   # Valor 1
                    printf "\e[4m%-20s\e[0m" "Id documento" # Valor 2
                    printf "\e[4m%-70s\e[0m" "Descripción"  # Valor 3
                    printf "\e[4m%-11s\e[0m" "Fecha"        # Valor 4
                    printf "\n"

                    awk -v id_cliente_local=$id_cliente -F ":" '{
                    if($1==id_cliente_local) {
                            printf "%-20s", $1
                            printf "%-20s", $2
                            printf "%-70s", $3
                            printf "%-11s", $4
                            printf "\n"
                        }
                    }' Aplicacion/Ficheros/Fdocumento

                    rm Aplicacion/Ficheros/temp
                    printf "\n"

                fi

            done
            fichero_operaciones 3.1 "varios" "varios"

        else
            fichero_operaciones 3.1 --- ---
            echo "El fichero Aplicacion/Ficheros/Fdocumento no existe."
        fi

    else
        fichero_operaciones 3.1 --- ---
        echo "El fichero Aplicacion/Ficheros/Fclientes no existe."
    fi

    pulsa_para_continuar

    return
}

# Función que permite mostrar la traza de los usuario por la aplicación.
function gestion_informes_acciones_usuarios() {
    if [ -f Aplicacion/Ficheros/Foperaciones ]; then
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
        done <Aplicacion/Ficheros/Foperaciones

    else
        echo "El fichero Aplicacion/Ficheros/Foperaciones no existe."
    fi

    return
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
