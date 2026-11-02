# M20 — effective_problem_langs

Guilherme Negreiros Pereira · Grupo 11.

## Estado

Red executado e confirmado: TDD01 falhou pelo motivo esperado, com exit 1 visivel na captura. Green confirmado com 24 aprovados e zero falhas; Refactor confirmado com 24 aprovados e zero falhas. O ciclo Red -> Green -> Refactor esta completo. As evidencias estao em evidencias/tdd/red.txt e evidencias/img/m20-red.png.

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

## Resultados e cobertura

- [Relatorio do metodo](testes-guilherme-m20.md)
- [Cobertura observada e MC/DC](evidencias/cobertura.md)
- [Etapas TDD e evidencias](evidencias/tdd/README.md)

Os 24 casos passaram apos o Refactor. Nao ha kcov ou imagens geradas automaticamente.
