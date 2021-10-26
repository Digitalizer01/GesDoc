# Función que muestra todos los documentos del fichero Fdocumento
function mostrar_documentos() {
	echo "$#"
}

mostrar_documentos
array=($(cut -f 1 -d ":" AplicacionIsmael/Ficheros/Fclientes))

echo "Elementos del array: " ${array[*]}

for ((i = 0; i < ${#array[*]}; i++)); do
	echo "Posición $i: " ${array[i]}
done

echo "Cantidad de elementos del array: " ${#array[*]}
