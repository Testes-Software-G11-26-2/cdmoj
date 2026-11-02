# Test_Eduardo — M15 `contest_end_effective` (cdmoj)

Testes de unidade do método M15 `contest_end_effective` (`server/api/v1/lib/contest-gate.sh`), feitos pelo Eduardo para a disciplina Testes de Software (FGA0314), Grupo 11. Os quatro defeitos encontrados foram corrigidos em **2 ciclos de TDD** (Red → Green → Refactor).

O relatório completo está em **[testes-eduardo-m15.md](testes-eduardo-m15.md)**: contrato, caixa-preta, caixa-branca (MC/DC), resultados, defeitos, os 2 ciclos de TDD (seção 7) e lacunas. O planejamento escrito antes dos testes está em [planejamento-m15.txt](planejamento-m15.txt), e o texto de apoio para o relatório final da equipe em [subsidios-relatorio-final-m15.md](subsidios-relatorio-final-m15.md).

## Pré-requisitos

- bash 5 e jq (testado com bash 5.3.20 e jq 1.8.2);
- Python 3, só para o oráculo do porteiro (testado com 3.14.8);
- kcov, só para medir a cobertura (testado com kcov 43).

O teste é **offline**: não usa rede nem o MOJ real. `MOJ_CONF` aponta para um arquivo que não existe e `CONTESTSDIR` para uma fixture em `mktemp -d`, apagada no fim; nenhuma configuração nem dado da máquina é lido.

## Como executar

Na raiz do `cdmoj`:

```bash
./Test_Eduardo/contest-end-effective.sh             # execução normal
./Test_Eduardo/contest-end-effective.sh --trace     # também grava evidencias/traces/<ID>.trace (xtrace)
python3 -I Test_Eduardo/oraculo-porteiro.py         # oráculo: o espelho em Python (porteiro) nas mesmas entradas
bash server/test/smoke-time-overrides.sh            # regressão do TDD (teste do upstream, não alterado)
kcov --include-path="$PWD/server/api/v1/lib/contest-gate.sh" Test_Eduardo/evidencias/cobertura ./Test_Eduardo/contest-end-effective.sh
```

Resultado esperado: `RESULT: 22 passed, 0 failed, 0 xfail` e exit 0. Antes do TDD eram `13 passed, 0 failed, 4 xfail`, e depois do ciclo 1, `17 passed, 0 failed, 2 xfail`. Os XFAIL eram os defeitos da seção 6 do relatório, que viraram casos obrigatórios nos Reds e foram corrigidos nos Greens. O exit é 1 só se um caso obrigatório falhar.

Para o kcov, rode o **script executável**, não `bash <script>`: no segundo caso o kcov mede o próprio bash e o relatório sai vazio.

## Ver os ciclos de TDD

Cada fase tem um commit próprio nesta branch:

| Ciclo | Fase | Commit | Resultado |
|---|---|---|---|
| 1 (X3/X4, octal) | Red | `863e72e0` | `13 passed, 4 failed, 2 xfail` (exit 1) |
| 1 | Green | `e2812ad9` | `17 passed, 0 failed, 2 xfail` |
| 1 | Refactor | `b8cf5b96` | `17 passed, 0 failed, 2 xfail` |
| 2 (X1/X2, float e exponencial) | Red | `994477e5` | `18 passed, 4 failed, 0 xfail` (exit 1) |
| 2 | Green | `65468927` | `22 passed, 0 failed, 0 xfail` |
| 2 | Refactor | `32b6362c` | `22 passed, 0 failed, 0 xfail` |

Para ver um teste falhar no Red: `git checkout 863e72e0 && ./Test_Eduardo/contest-end-effective.sh` (ou `994477e5` para o ciclo 2; volte com `git checkout test/eduardo-m15`). As saídas e os diffs de cada fase estão em `evidencias/tdd/`.

## Onde estão as evidências

| Caminho | Conteúdo |
|---|---|
| `contest-end-effective.sh` | o script de teste |
| `oraculo-porteiro.py` | oráculo de paridade com o porteiro em Python |
| `evidencias/saida-2026-11-02.txt` | saída completa da execução atual (depois dos 2 ciclos de TDD) |
| `evidencias/saida-2026-11-01.txt` | saída de antes do TDD (histórico) |
| `evidencias/oraculo-porteiro-2026-11-02.txt` | saída do oráculo (com T1–T5); a de 2026-11-01 é a anterior |
| `evidencias/traces/` | xtrace de cada caso (código depois dos 2 ciclos) |
| `evidencias/cobertura/index.html` | relatório de cobertura do kcov, depois dos 2 ciclos (abrir no navegador); dados em `contest-end-effective.sh.b4f6d613e03ef3f5/cobertura.xml` |
| `evidencias/tdd/` | saída e diff de cada fase dos 2 ciclos de TDD (`ciclo1-*`, `ciclo2-*`), e a regressão com os testes do upstream |
| `evidencias/img/` | imagens usadas no relatório |

O M14 `time_override_end`, do mesmo arquivo, está na branch `test/eduardo-m14`.
