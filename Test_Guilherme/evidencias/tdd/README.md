# Evidencias TDD — M19

## Red confirmado

Execucao realizada pelo integrante em 02/11/2026. Log real: red.txt; trace: red/traces/TDD01.trace; captura: ../img/m19-red.png.
Resultado: 0 aprovados, 1 falha. A captura do PowerShell mostra exit 1.
Motivo observado: Sem argumento, o acesso a $1 gera diagnostico; a funcao retorna 0 em vez de 2.

Este resultado foi registrado antes de qualquer correcao de producao nesta branch. Os arquivos de log foram apenas transcodificados para UTF-8/LF, preservando o conteudo.

## Green confirmado

Execucao realizada pelo integrante em 02/11/2026: 20 aprovados, 0 falhas, incluindo TDD01. Log: green.txt; traces: green/traces/; captura: ../img/m19-green.png. A captura mostra exit 0. Os testes nao foram alterados entre Red e Green. O diff da implementacao minima esta em green.diff.

## Refactor

Refatoracao estrutural implementada, descrita em refactor.md e refactor.diff.
A reexecucao da mesma suite ainda esta pendente; Green nao comprova por si
so a preservacao do comportamento depois desta mudanca.
