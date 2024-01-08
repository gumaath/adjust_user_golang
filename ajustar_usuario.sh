#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Uso: $0 [caminho] [lojas|transportefront|transporteback|admin|maislog]"
    exit 1
fi

parametro=$2
caminho=$1

# Função para executar o comando em config.php
executar_comando_config() {
    case "$parametro" in
            "lojas")
                go run ~/development/adjust-user/adjust_user.go local.php "$usuario" "$novo_valor"
                ;;
            "admin" | "transportefront" | "transporteback")
                go run ~/development/adjust-user/adjust_user.go application.ini "$usuario" "$novo_valor"
                ;;
            "maislog")
                go run ~/development/adjust-user/adjust_user.go config.local.php "$usuario" "$novo_valor"
                ;;
            *)
                echo "Comando não reconhecido."
                ;;
        esac
}

# Pergunta pelos valores
read -p "Digite o valor para 'usuario': " usuario
read -p "Digite o valor para 'novo_valor': " novo_valor

# Verifica se o parâmetro é "lojas" ou "admin"
if [ "$parametro" == "lojas" ] || [ "$parametro" == "admin" ]; then
    # Executa o comando para pastas 1, 2, 3, 4 e 5
    for pasta in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28; do
        if [ -d $caminho/config/$pasta ]; then
            cd $caminho/config/$pasta || exit 1
            echo "Executando para a pasta $pasta"
            executar_comando_config
            cd - || exit 1
        fi
    done
# TRANSPORTE FRONT-END
elif [ "$parametro" == "transportefront" ]; then
    # Executa o comando apenas para a pasta config
    cd $caminho/application/configs || exit 1
    echo "Executando para a pasta configs"
    executar_comando_config
    cd - || exit 1
# TRANSPORTE BACK-END
elif [ "$parametro" == "transporteback" ]; then
    # Executa o comando apenas para a pasta config
    cd $caminho/config || exit 1
    echo "Executando para a pasta config"
    executar_comando_config
    cd - || exit 1
# MAISLOG
elif [ "$parametro" == "maislog" ]; then
    # Executa o comando apenas para a pasta config
    cd $caminho/application/configs || exit 1
    echo "Executando para a pasta configs"
    executar_comando_config
    cd - || exit 1
else
    echo "Parâmetro inválido. Use 'lojas' ou 'config'."
    exit 1
fi
