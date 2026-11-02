# Cobertura observada — M19

Fonte: 20 traces reais em tdd/refactor/traces/ e log tdd/refactor.txt. Execucao do integrante em 02/11/2026; 20 PASS, 0 FAIL, exit 0 visivel na captura.

A analise abaixo e de comandos/decisoes observados por xtrace e resultados dos testes. Nao foi executado kcov e nao se declara cobertura automatica de linhas. Uma linha Bash pode conter varios comandos. Os filtros internos do jq nao sao instrumentados por xtrace.

| Caminho | Casos | Ocorrencias do comando de saida |
|---|---|---:|
| Alias C++ | C01, C14-C16, C18 | 5 |
| Alias C | C02 | 1 |
| Aliases Python | C03, C17 | 2 |
| Padrao | Demais entradas presentes | 11 |

Quatro de quatro ramos do case observados. Os sete aliases possuem entradas exercitadas. A guarda de argumento tem ambos os resultados: continua nos 19 casos com argumento; retorna 2 em TDD01. C06 demonstra que argumento vazio nao e argumento ausente.
MC/DC nao se aplica: a guarda possui uma condicao simples e o case nao e uma expressao booleana composta.

Os arquivos brutos registram caminhos temporarios e linhas da revisao executada. As linhas da fase Green diferem das do Refactor; esta analise utiliza somente os traces posteriores ao Refactor.
