# M21 — lang_allowed

Guilherme Negreiros Pereira · Grupo 11.

## Estado

Red executado e confirmado: TDD01 falhou pelo motivo esperado, com exit 1 visivel na captura. Green confirmado com 26 aprovados e zero falhas; Refactor confirmado com 26 aprovados e zero falhas. O ciclo Red -> Green -> Refactor esta completo. As evidencias estao em evidencias/tdd/red.txt e evidencias/img/m21-red.png.

Suite planejada: 25 casos do contrato existente + TDD01 = 26 casos.

## Executar

Git Bash >= 4.3, jq, cmp e mktemp. Na raiz do projeto:

```bash
bash server/test/unit-lang-allowed.sh --suite regressao
bash server/test/unit-lang-allowed.sh --suite tdd
bash server/test/unit-lang-allowed.sh --suite todos
```

regressao verifica somente o contrato existente; tdd executa somente o novo requisito; todos executa ambos. Cada caso pode ter varias assertions, mas conta uma vez. --trace DIR guarda um arquivo por caso.

## Relatorio e evidencias

- [Relatorio do metodo e resultados](testes-guilherme-m21.md)
- [Cobertura de decisoes e pares de casos](evidencias/cobertura.md)
- [Etapas e evidencias do TDD](evidencias/tdd/README.md)
