# Planejamento M19

Estado final: Red confirmado e Green/Refactor aprovados com 20 casos, conforme evidencias/tdd/README.md. As etapas planejadas abaixo foram executadas nesta sequencia.

## Objetivo e contrato

Unidade: _lang_canon em server/api/v1/lib/langs.sh. Base: 2c46d4b0.
Novo comportamento exigido pelo TDD: Rejeitar a ausencia de argumento com status 2, stdout e stderr vazios. Uma string vazia passada explicitamente continua valida.

## Tecnicas e isolamento

Base: PTOSS-2, aulas de caixa-preta, caixa-branca, testes de unidade e TDD, e Aniche capitulo 8.
Particionamento por familias/formatos de entrada. Valores limite somente quando existem ordem ou comprimento: zero/um, primeira/ultima posicao. Nao supor maximo nao especificado.
Quatro ramos do case; todos os sete aliases precisam de casos. MC/DC nao se aplica ao case.
AAA: argumento literal, chamada da unidade real em Bash novo, cmp dos bytes/status/stderr.

Caixa-preta -> caixa-branca: iniciar por classes funcionais e complementar com ramos, cache e pares de independencia. Caixa-branca -> caixa-preta: selecionar caminhos estruturais e complementar com formatos invalidos, limites e valores esperados. A cobertura so sera relatada apos coletar evidencias.

## Red

Teste TDD01: Rejeitar a ausencia de argumento com status 2, stdout e stderr vazios. Uma string vazia passada explicitamente continua valida.
Falha prevista por inspecao; ainda nao observada nesta pasta. A biblioteca nao foi quebrada nem recebeu uma implementacao propositalmente incorreta.

No PowerShell, dentro de C:\Users\negre\repos\moj\cdmoj-guilherme-m19:

```powershell
& "C:\Program Files\Git\bin\bash.exe" -n Test_Guilherme/lang-canon.sh
& "C:\Program Files\Git\bin\bash.exe" Test_Guilherme/lang-canon.sh --suite tdd --trace Test_Guilherme/evidencias/tdd/red/traces 2>&1 | Tee-Object Test_Guilherme/evidencias/tdd/red.txt
$mTddExit = $LASTEXITCODE
"EXIT DO TESTE: $mTddExit"
```

Tire a captura com Win + Shift + S e salve evidencias/img/m19-red.png. Erro de ambiente, caminho ou sintaxe nao e Red valido.

## Green e Refactor planejados

Green: implementar somente o necessario para TDD01 passar, preservando a regressao. Nenhum Green sera declarado antes da execucao.
Refactor: Separar a tabela de aliases da validacao/normalizacao, com auxiliar de responsabilidade unica. Executar novamente TDD01 e todos os casos sem alterar esperados para esconder falhas.

Commits por etapa real: planejamento; teste do requisito; registro Red; implementacao minima; registro Green; refatoracao; registro da regressao/cobertura.
