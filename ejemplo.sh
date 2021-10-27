function fichero_operaciones() {
	# id_usuario:fecha:hora:operación:id_cliente:id_documento

	if [ $# == 3 ]; then
		local fecha=$(date +"%d/%m/%Y") # Tomamos la fecha.
		local hora=$(date +%H)          # Tomamos la hora
		echo $login:$fecha:$hora:$1:$2:$3 >>AplicacionIsmael/Ficheros/Foperaciones
	fi

	return
}

# Función que permite registrar las acciones de un usuario por el sistema. La función recibe 3 parámetros:
# Parámetro 1: acción del usuario.
#
# 1: Area cliente
#   1.1: Alta clientes										(cliente: 1) (documento: ---)
#   1.2: Modificación clientes								(cliente: 1) (documento: ---)
#   1.3: Baja clientes										(cliente: 1) (documento: ---)
#   1.4: Consulta clientes
#       1.4.1: Consulta clientes activos 					(cliente: varios) (documento: ---)
#       1.4.2: Consulta clientes no activos 				(cliente: varios) (documento: ---)
#   1.5: Salir del menú de clientes 						(cliente: ---) (documento: ---)
# 2: Gestión de documentos
#   2.1: Alta documentos 									(cliente: 1) (documento: 1)
#   2.2: Baja documentos 									(cliente: 1) (documento: 1)
#   2.3: Presentación documentos 							(cliente: 1) (documento: 1)
#   2.4: Consultas
#       2.4.1: Consulta de documentos de clientes 			(cliente: 1) (documento: varios)
#       2.4.2: Consulta de organismos de documento 			(cliente: 1) (documento: 1)
#   2.5: Salir menú de documentos 							(cliente: ---) (documento: ---)
# 3: Gestión de informes
#   3.1: Documentos de clientes 							(cliente: 1) (documento: varios)
#   3.2: Acciones de usuario dado 							(cliente: ---) (documento: ---)
#   3.3: Salir menú de informes 							(cliente: ---) (documento: ---)
#
# Parámetro 2: si la operación es sobre un cliente en particular, se registrará el id de cliente.
#              Si es de varios clientes, se anotará "varios".Si la operación no es sobre
#              clientes, se anotará "---"
#
# Parámetro 3: si la operación es sobre un documento de un cliente en particular se registrará el id
#              de documento. Si es de varios clientes, se anotará "varios". Si la operación no es sobre
#              documentos, se anotará "---"

id=9

fichero_operaciones 1.1 $id ---
