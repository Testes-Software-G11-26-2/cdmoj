# Planejamento M21

## Objetivo e contrato

Unidade: lang_allowed em server/api/v1/lib/langs.sh. Base: 2c46d4b0.
Novo comportamento exigido pelo TDD: [ ] deve ser tratado como array vazio, usando o mesmo piso da plataforma que [].

## Tecnicas e isolamento

Base: PTOSS-2, aulas de caixa-preta, caixa-branca, testes de unidade e TDD, e Aniche capitulo 8.
Particionamento por familias/formatos de entrada. Valores limite somente quando existem ordem ou comprimento: zero/um, primeira/ultima posicao. Nao supor maximo nao especificado.
MC/DC do piso: C01/C02, C01/C03, C01/C04. OR C++: C09 contra C10-C13. OR Python: C17 contra C15/C16. xtrace nao instrumenta o interior do jq; os pares internos sao demonstrados por entradas/saidas.
AAA: whitelist e retornos literais, chamada de lang_allowed real com jq real e assertions de status/saidas/interacoes. _lang_canon e platform_langs_json sao dubles; a canonizacao da whitelist no jq e real.

Caixa-preta -> caixa-branca: iniciar por classes funcionais e complementar com ramos, cache e pares de independencia. Caixa-branca -> caixa-preta: selecionar caminhos estruturais e complementar com formatos invalidos, limites e valores esperados. A cobertura so sera relatada apos coletar evidencias.

## Red

Teste TDD01: [ ] deve ser tratado como array vazio, usando o mesmo piso da plataforma que [].
Falha prevista por inspecao; ainda nao observada nesta pasta. A biblioteca nao foi quebrada nem recebeu uma implementacao propositalmente incorreta.

No PowerShell, dentro de C:\Users\negre\repos\moj\cdmoj-guilherme-m21:

```powershell
& "C:\Program Files\Git\bin\bash.exe" -n Test_Guilherme/lang-allowed.sh
& "C:\Program Files\Git\bin\bash.exe" Test_Guilherme/lang-allowed.sh --suite tdd --trace Test_Guilherme/evidencias/tdd/red/traces 2>&1 | Tee-Object Test_Guilherme/evidencias/tdd/red.txt
$mTddExit = $LASTEXITCODE
"EXIT DO TESTE: $mTddExit"
```

Tire a captura com Win + Shift + S e salve evidencias/img/m21-red.png. Erro de ambiente, caminho ou sintaxe nao e Red valido.

## Green e Refactor planejados

Green: implementar somente o necessario para TDD01 passar, preservando a regressao. Nenhum Green sera declarado antes da execucao.
Refactor: Extrair o predicado de selecao do piso e manter a autorizacao na funcao principal. Executar novamente TDD01 e todos os casos sem alterar esperados para esconder falhas.

Commits por etapa real: planejamento; teste do requisito; registro Red; implementacao minima; registro Green; refatoracao; registro da regressao/cobertura.
