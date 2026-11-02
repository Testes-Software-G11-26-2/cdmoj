# M19 — _lang_canon

Guilherme Negreiros Pereira · Grupo 11.

## Estado

Red executado e confirmado: TDD01 falhou pelo motivo esperado, com exit 1 visivel na captura. Green confirmado com 20 aprovados e zero falhas; Refactor confirmado com 20 aprovados e zero falhas. O ciclo Red -> Green -> Refactor esta completo. As evidencias estao em evidencias/tdd/red.txt e evidencias/img/m19-red.png.

Suite planejada: 19 casos do contrato existente + TDD01 = 20 casos.

## Executar

Git Bash >= 4.3, tr, cmp e mktemp. Na raiz do projeto:

```bash
bash server/test/unit-lang-canon.sh --suite regressao
bash server/test/unit-lang-canon.sh --suite tdd
bash server/test/unit-lang-canon.sh --suite todos
```

regressao verifica somente o contrato existente; tdd executa somente o novo requisito; todos executa ambos. Cada caso pode ter varias assertions, mas conta uma vez. --trace DIR guarda um arquivo por caso.

## Relatorio e evidencias

- [Relatorio do metodo e resultados](testes-guilherme-m19.md)
- [Cobertura de decisoes e pares de casos](evidencias/cobertura.md)
- [Etapas e evidencias do TDD](evidencias/tdd/README.md)
