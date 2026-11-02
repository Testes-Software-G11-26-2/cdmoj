# Cobertura observada — M21

Fonte: 26 traces reais em tdd/refactor/traces/ e log tdd/refactor.txt. Execucao do integrante em 02/11/2026; 26 PASS, 0 FAIL, exit 0 visivel na captura.

A analise abaixo e de comandos/decisoes observados por xtrace e resultados dos testes. Nao foi executado kcov e nao se declara cobertura automatica de linhas. Uma linha Bash pode conter varios comandos. Os filtros internos do jq nao sao instrumentados por xtrace.

A auxiliar _lang_uses_platform_floor e o metodo sao executados 26 vezes. O piso e chamado em 6 casos e nao e chamado em 20.

| Caso | A: string vazia | B: copia igual a [] | C: igual a null | Usar piso |
|---|---|---|---|---|
| C01 | F | F | F | F |
| C02 | V | F logico | F logico | V |
| C03 | F | V | F logico | V |
| C04 | F | F | V | V |

Pares C01/C02, C01/C03 e C01/C04. Valores a direita de um termo verdadeiro podem nao ser avaliados. O trace mostra o predicado na auxiliar e seu efeito no if do chamador. TDD01 mostra [ ] transformado em [] somente na copia de verificacao, seguido da chamada ao piso.

| Decisao no jq | Base falsa | Alternativas verdadeiras |
|---|---|---|
| OR dos quatro aliases C++ | C09 | C10-C13, uma por vez |
| Alias h | token sem alias | C14 |
| OR dos aliases Python | C17 | C15-C16 |
| Presenca na lista | C05 nega | C01 permite |

A independencia no jq e inferida por casos de um elemento e saidas controladas, nao por rastreamento interno. Os pares C09/C10-C13 e C17/C15-C16 sustentam a demonstracao logica. Nao apresentar isso como medicao automatica de MC/DC.

Os arquivos brutos registram caminhos temporarios e linhas da revisao executada. As linhas da fase Green diferem das do Refactor; esta analise utiliza somente os traces posteriores ao Refactor.
