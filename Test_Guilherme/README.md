# M19 — _lang_canon

Guilherme Negreiros Pereira · Grupo 11.

## Estado

Red executado e confirmado: TDD01 falhou pelo motivo esperado, com exit 1 visivel na captura. Green e Refactor ainda nao confirmados. As evidencias estao em evidencias/tdd/red.txt e evidencias/img/m19-red.png.

Suite planejada: 19 casos do contrato existente + TDD01 = 20 casos.

## Executar

Git Bash >= 4.3, tr, cmp e mktemp. Na raiz do projeto:

```bash
bash Test_Guilherme/lang-canon.sh --suite regressao
bash Test_Guilherme/lang-canon.sh --suite tdd
bash Test_Guilherme/lang-canon.sh --suite todos
```

regressao verifica somente o contrato existente; tdd executa somente o novo requisito; todos executa ambos. Cada caso pode ter varias assertions, mas conta uma vez. --trace DIR guarda um arquivo por caso.

## Capturar Red no PowerShell

Execute os comandos de captura em planejamento-m19.md. Salve a imagem em evidencias/img/m19-red.png. Mantenha comando, resultado final e exit code visiveis. Nenhuma imagem sera criada automaticamente.

Somente apos confirmar a falha pelo motivo esperado sera implementado Green minimo. Depois, Refactor real e nova regressao com os mesmos testes. O relatorio final sera escrito apos as execucoes.
