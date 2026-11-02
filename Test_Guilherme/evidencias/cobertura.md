# Cobertura observada — M20

Fonte: 24 traces reais em tdd/refactor/traces/ e log tdd/refactor.txt. Execucao do integrante em 02/11/2026; 24 PASS, 0 FAIL, exit 0 visivel na captura.

A analise abaixo e de comandos/decisoes observados por xtrace e resultados dos testes. Nao foi executado kcov e nao se declara cobertura automatica de linhas. Uma linha Bash pode conter varios comandos. Os filtros internos do jq nao sao instrumentados por xtrace.

| Decisao | Caminho de um resultado | Caminho oposto |
|---|---|---|
| Leitura do override | C01: arquivo lido | TDD01: leitura ausente usa {} |
| Conteudo da leitura | C01: nao vazio | C10: vazio usa {} |
| Cache | C21: primeira chamada carrega | C21: segunda chamada reutiliza |
| LANGUAGES nao vazia | C02: pipeline de tokens | C03: sem tokens |
| Override utilizavel | C01: retorna override | C02: procura conf |
| Conf utilizavel | C02: retorna conf | C03/C11: procura pacote |
| Arquivo publico existe | C03: publico | C04: privado |
| Saida de pacote utilizavel | C03: mantem lista | C05: fallback [] |

Oito decisoes Bash delimitadas, com ambos os resultados observados. A auxiliar de leitura e chamada 25 vezes e o metodo principal 27 vezes: tres casos usam duas chamadas, e outro contest exige carga propria. Esses numeros nao sao uma medida de desempenho.

| Caso MC/DC do conf | A: clangs nao vazia | B: clangs != [] | Decisao |
|---|---|---|---|
| C02 | V | V | V |
| C03 | F | V logico, nao avaliado | F |
| C11 | V | F | F |

Pares C02/C03 para A e C02/C11 para B. O curto-circuito impede avaliar B quando A e falsa. Os termos plangs != null, apos // empty e // [], nao possuem falso viavel no dominio documentado; nao se alega MC/DC integral nessas decisoes.

Os arquivos brutos registram caminhos temporarios e linhas da revisao executada. As linhas da fase Green diferem das do Refactor; esta analise utiliza somente os traces posteriores ao Refactor.
