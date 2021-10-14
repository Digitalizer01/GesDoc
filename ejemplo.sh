<<<<<<< HEAD
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
=======
while IFS= read -r line; do
    IFS=':' read -ra VALUES <<<"$line"

    ## To pritn all values
    for i in "${VALUES[@]}"; do
        echo -n $i "           "
    done
    echo
done <Fclientes
>>>>>>> c76b4f09d6d1e24c632635e46633bb204e8988f9
