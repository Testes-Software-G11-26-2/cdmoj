# M20 — effective_problem_langs

Guilherme Negreiros Pereira · Grupo 11.

## Estado

Red executado e confirmado: TDD01 falhou pelo motivo esperado, com exit 1 visivel na captura. Green confirmado com 24 aprovados e zero falhas; Refactor confirmado com 24 aprovados e zero falhas. O ciclo Red -> Green -> Refactor esta completo. As evidencias estao em evidencias/tdd/red.txt e evidencias/img/m20-red.png.

Suite planejada: 23 casos do contrato existente + TDD01 = 24 casos.

## Executar

Git Bash >= 4.3, jq, cmp e mktemp. Na raiz do projeto:

```bash
bash server/test/unit-effective-problem-langs.sh --suite regressao
bash server/test/unit-effective-problem-langs.sh --suite tdd
bash server/test/unit-effective-problem-langs.sh --suite todos
```

regressao verifica somente o contrato existente; tdd executa somente o novo requisito; todos executa ambos. Cada caso pode ter varias assertions, mas conta uma vez. --trace DIR guarda um arquivo por caso.

## Relatorio e evidencias

- [Relatorio do metodo e resultados](testes-guilherme-m20.md)
- [Cobertura de decisoes e pares de casos](evidencias/cobertura.md)
- [Etapas e evidencias do TDD](evidencias/tdd/README.md)
