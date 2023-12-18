#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Uso: $0 [lojas|config]"
    exit 1
fi

parametro=$1

# Função para executar o comando em config.php
executar_comando_config() {
    go run ~/development/adjust-user/adjust_user.go config.php "$usuario" "$novo_valor"
}

# Pergunta pelos valores
read -p "Digite o valor para 'usuario': " usuario
read -p "Digite o valor para 'novo_valor': " novo_valor

# Verifica se o parâmetro é "loja"
if [ "$parametro" == "lojas" ]; then
    # Executa o comando para pastas 1, 2, 3, 4 e 5
    for pasta in 1 2 3 4 5; do
        cd config/$pasta || exit 1
        echo "Executando para a pasta $pasta"
        executar_comando_config
        cd - || exit 1
    done
elif [ "$parametro" == "config" ]; then
    # Executa o comando apenas para a pasta config
    cd config || exit 1
    echo "Executando para a pasta config"
    executar_comando_config
    cd - || exit 1
else
    echo "Parâmetro inválido. Use 'loja' ou 'config'."
    exit 1
fi
