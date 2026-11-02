# Refactor — M21

A normalizacao usada apenas na verificacao de array vazio e o predicado foram extraidos para _lang_uses_platform_floor. lang_allowed usa um if explicito para selecionar o piso e depois decide a permissao.

Esta etapa foi aplicada depois do Green confirmado pelo integrante. Nenhum
teste ou resultado esperado foi alterado para realizar a refatoracao.
O diff da mudanca estrutural esta em refactor.diff.

A regressao pos-Refactor foi executada pelo integrante e conferida: 26 aprovados e 0 falhas. O log refactor.txt, os 26 traces e a captura m21-refactor.png comprovam esta etapa; o PowerShell mostra exit 0.
