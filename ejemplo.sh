while IFS= read -r line; do
    IFS=':' read -ra VALUES <<<"$line"

    ## To pritn all values
    for i in "${VALUES[@]}"; do
        echo -n $i "           "
    done
    echo
done <Fclientes
