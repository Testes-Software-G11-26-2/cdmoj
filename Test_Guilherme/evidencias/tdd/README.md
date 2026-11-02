# Evidencias TDD — M21

## Red confirmado

Execucao realizada pelo integrante em 02/11/2026. Log real: red.txt; trace: red/traces/TDD01.trace; captura: ../img/m21-red.png.
Resultado: 0 aprovados, 1 falha. A captura do PowerShell mostra exit 1.
Motivo observado: A lista [ ] nao aciona o piso; a permissao e negada, apesar de py estar no piso controlado.

Este resultado foi registrado antes de qualquer correcao de producao nesta branch. Os arquivos de log foram apenas transcodificados para UTF-8/LF, preservando o conteudo.

## Green confirmado

Execucao realizada pelo integrante em 02/11/2026: 26 aprovados, 0 falhas, incluindo TDD01. Log: green.txt; traces: green/traces/; captura: ../img/m21-green.png. A captura mostra exit 0. Os testes nao foram alterados entre Red e Green. O diff da implementacao minima esta em green.diff.

## Refactor

Proxima etapa: refatoracao estrutural e reexecucao da mesma suite. Ainda nao executada.
