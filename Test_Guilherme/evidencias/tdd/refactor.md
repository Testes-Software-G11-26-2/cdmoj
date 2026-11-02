# Refactor — M20

A leitura do arquivo opcional e o fallback {} foram extraidos para _problem_lang_overrides_json. effective_problem_langs permanece responsavel pelo cache e pela precedencia.

Esta etapa foi aplicada depois do Green confirmado pelo integrante. Nenhum
teste ou resultado esperado foi alterado para realizar a refatoracao.
O diff da mudanca estrutural esta em refactor.diff.

A regressao pos-Refactor foi executada pelo integrante e conferida: 24 aprovados e 0 falhas. O log refactor.txt, os 24 traces e a captura m20-refactor.png comprovam esta etapa; o PowerShell mostra exit 0.
