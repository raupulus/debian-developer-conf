

## En caso de no recibir parámetros, saldrá
if [[ $# = 0 ]]; then
    echo 'no hay parámetros'
    return 1
fi
