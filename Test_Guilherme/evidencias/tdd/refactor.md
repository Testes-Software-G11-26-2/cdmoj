# Refactor — M20

A leitura do arquivo opcional e o fallback {} foram extraidos para _problem_lang_overrides_json. effective_problem_langs permanece responsavel pelo cache e pela precedencia.

Esta etapa foi aplicada depois do Green confirmado pelo integrante. Nenhum
teste ou resultado esperado foi alterado para realizar a refatoracao.
O diff da mudanca estrutural esta em refactor.diff.

A regressao pos-Refactor ainda aguarda execucao. A aprovacao sera registrada
somente depois de conferir refactor.txt, os traces e a captura do integrante.
