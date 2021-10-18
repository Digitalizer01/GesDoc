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
