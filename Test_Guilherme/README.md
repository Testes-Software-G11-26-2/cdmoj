# M20 — effective_problem_langs

Guilherme Negreiros Pereira · Grupo 11.

## Estado

Etapa atual: preparar e executar Red. Producao igual a base 2c46d4b0. Nenhum Red, Green ou Refactor confirmado nesta pasta.

Suite planejada: 23 casos do contrato existente + TDD01 = 24 casos.

## Executar

Git Bash >= 4.3, jq, cmp e mktemp. Na raiz do projeto:

```bash
bash Test_Guilherme/effective-problem-langs.sh --suite regressao
bash Test_Guilherme/effective-problem-langs.sh --suite tdd
bash Test_Guilherme/effective-problem-langs.sh --suite todos
```

regressao verifica somente o contrato existente; tdd executa somente o novo requisito; todos executa ambos. Cada caso pode ter varias assertions, mas conta uma vez. --trace DIR guarda um arquivo por caso.

## Capturar Red no PowerShell

Execute os comandos de captura em planejamento-m20.md. Salve a imagem em evidencias/img/m20-red.png. Mantenha comando, resultado final e exit code visiveis. Nenhuma imagem sera criada automaticamente.

Somente apos confirmar a falha pelo motivo esperado sera implementado Green minimo. Depois, Refactor real e nova regressao com os mesmos testes. O relatorio final sera escrito apos as execucoes.
