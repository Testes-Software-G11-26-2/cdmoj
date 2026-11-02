# Planejamento M20

Estado final: Red confirmado e Green/Refactor aprovados com 24 casos, conforme evidencias/tdd/README.md. As etapas planejadas abaixo foram executadas nesta sequencia.

## Objetivo e contrato

Unidade: effective_problem_langs em server/api/v1/lib/langs.sh. Base: 2c46d4b0.
Novo comportamento exigido pelo TDD: A falta do arquivo opcional problem-langs.json deve permitir o fallback e nao escrever diagnostico em stderr.

## Tecnicas e isolamento

Base: PTOSS-2, aulas de caixa-preta, caixa-branca, testes de unidade e TDD, e Aniche capitulo 8.
Particionamento por familias/formatos de entrada. Valores limite somente quando existem ordem ou comprimento: zero/um, primeira/ultima posicao. Nao supor maximo nao especificado.
Precedencia, existencia do pacote, cache e isolamento. MC/DC da whitelist do conf: C02/C03 para nao vazia e C02/C11 para diferente de []. plangs != null e defensiva e nao possui par falso viavel apos os filtros jq.
AAA: fixture de JSON, chamada da unidade com jq real, comparacao literal de JSON/status/stderr e efeitos. Somente load_contest_conf e duble. Nos casos de cache sao necessarias duas chamadas no mesmo processo.

Caixa-preta -> caixa-branca: iniciar por classes funcionais e complementar com ramos, cache e pares de independencia. Caixa-branca -> caixa-preta: selecionar caminhos estruturais e complementar com formatos invalidos, limites e valores esperados. A cobertura so sera relatada apos coletar evidencias.

## Red

Teste TDD01: A falta do arquivo opcional problem-langs.json deve permitir o fallback e nao escrever diagnostico em stderr.
Falha prevista por inspecao; ainda nao observada nesta pasta. A biblioteca nao foi quebrada nem recebeu uma implementacao propositalmente incorreta.

No PowerShell, dentro de C:\Users\negre\repos\moj\cdmoj-guilherme-m20:

```powershell
& "C:\Program Files\Git\bin\bash.exe" -n Test_Guilherme/effective-problem-langs.sh
& "C:\Program Files\Git\bin\bash.exe" Test_Guilherme/effective-problem-langs.sh --suite tdd --trace Test_Guilherme/evidencias/tdd/red/traces 2>&1 | Tee-Object Test_Guilherme/evidencias/tdd/red.txt
$mTddExit = $LASTEXITCODE
"EXIT DO TESTE: $mTddExit"
```

Tire a captura com Win + Shift + S e salve evidencias/img/m20-red.png. Erro de ambiente, caminho ou sintaxe nao e Red valido.

## Green e Refactor planejados

Green: implementar somente o necessario para TDD01 passar, preservando a regressao. Nenhum Green sera declarado antes da execucao.
Refactor: Extrair a leitura opcional e seu fallback em auxiliar, mantendo precedencia/cache no metodo. Executar novamente TDD01 e todos os casos sem alterar esperados para esconder falhas.

Commits por etapa real: planejamento; teste do requisito; registro Red; implementacao minima; registro Green; refatoracao; registro da regressao/cobertura.
