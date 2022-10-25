
# README

<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

O objetivo da ferramenta é acrescentar à planilha de controle existente, a nova demanda recebida, sinalizando duplicidades, quando houver.

Resumo: Atualiza a planilha de controle e gera uma mensagem, caso seja necessário, sinalizando duplicidade de solicitação de elementar (verifica se na planilha de controle o elementar já havia sido solicitado e retorna o número da CI onde ele foi solicitado – coluna A: Origem). Caso a coluna de elementar esteja vazia, realiza essa verificação através do Item externo e, em casos em que ambos estejam vazias, sinaliza que a planilha não tem o elementar e o externo.


## Como utilizar a ferramenta?

1.Abrir o arquivo ‘Projeto.R’

2.Aguardar inicialização do RStudio (IDE)

3.Rodar o script ‘Run.R’

4.Fechar o projeto no RStudio (don’t save!)


Output: Controle-Geral.xlsx


## Demonstração

![](demo.gif)

## Dev

Você pode obter a versão de desenvolvimento do pacote através do seguinte comando:

``` r
devtools::install_github('wfaquieri/controleGeral')
```

## Description

Package: controleGeral

Title: Controle geral de solicitações.

Version: 0.0.0.9000

Authors@R: 
    person("Winicius", "Faquieri", "winicius.faquieri@fgv.br", role = c("aut", "cre"), comment = c(ORCID = "YOUR-ORCID-ID"))
           
Description: Atualiza a planilha de controle geral de solicitações.

License: MIT + file LICENSE
    
Encoding: UTF-8

Roxygen: list(markdown = TRUE)

RoxygenNote: 7.2.1
