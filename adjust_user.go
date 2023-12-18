package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	// Verifica se o número correto de argumentos foi fornecido
	if len(os.Args) < 4 {
		fmt.Println("Uso: go run programa.go arquivo.txt novo_valor novo_valor_teste2")
		os.Exit(1)
	}

	// Obtém os argumentos da linha de comando
	nomeArquivo := os.Args[1]
	novoValorUsuarioTeste := os.Args[2]
	novoValorUsuarioTeste2 := os.Args[3]

	// Lê o conteúdo do arquivo
	conteudoArquivo, err := lerArquivo(nomeArquivo)
	if err != nil {
		fmt.Printf("Erro ao ler o arquivo: %v\n", err)
		os.Exit(1)
	}

	// Atualiza os valores de usuario.teste e usuario.teste2
	novoConteudo := atualizarValor(conteudoArquivo, "usuario.teste =", novoValorUsuarioTeste)
	novoConteudo = atualizarValor(novoConteudo, "usuario.teste2 =", novoValorUsuarioTeste2)

	// Escreve o novo conteúdo de volta no arquivo
	err = escreverArquivo(nomeArquivo, novoConteudo)
	if err != nil {
		fmt.Printf("Erro ao escrever no arquivo: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("Valores atualizados com sucesso: usuario.teste = %s, usuario.teste2 = %s\n", novoValorUsuarioTeste, novoValorUsuarioTeste2)
}

func lerArquivo(nomeArquivo string) (string, error) {
	arquivo, err := os.Open(nomeArquivo)
	if err != nil {
		return "", err
	}
	defer arquivo.Close()

	var conteudo string
	scanner := bufio.NewScanner(arquivo)
	for scanner.Scan() {
		conteudo += scanner.Text() + "\n"
	}

	return conteudo, scanner.Err()
}

func escreverArquivo(nomeArquivo string, conteudo string) error {
	arquivo, err := os.Create(nomeArquivo)
	if err != nil {
		return err
	}
	defer arquivo.Close()

	writer := bufio.NewWriter(arquivo)
	_, err = writer.WriteString(conteudo)
	if err != nil {
		return err
	}

	return writer.Flush()
}

func atualizarValor(conteudo, chave, novoValor string) string {
	linhas := strings.Split(conteudo, "\n")
	for i, linha := range linhas {
		if strings.Contains(linha, chave) {
			// Encontrou a linha com a chave desejada, atualiza o valor
			linhas[i] = strings.Replace(linha, strings.Split(linha, "=")[1], " \""+novoValor+"\"", -1)
			break
		}
	}

	// Reconstroi o conteúdo com a linha atualizada
	return strings.Join(linhas, "\n")
}
