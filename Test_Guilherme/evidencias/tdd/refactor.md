# Refactor — M19

A tabela de aliases foi extraida para _lang_alias_canon. _lang_canon permanece responsavel pela guarda de argumento e normalizacao. As alternativas e os valores impressos foram mantidos.

Esta etapa foi aplicada depois do Green confirmado pelo integrante. Nenhum
teste ou resultado esperado foi alterado para realizar a refatoracao.
O diff da mudanca estrutural esta em refactor.diff.

A regressao pos-Refactor foi executada pelo integrante e conferida: 20 aprovados e 0 falhas. O log refactor.txt, os 20 traces e a captura m19-refactor.png comprovam esta etapa; o PowerShell mostra exit 0.
