# Test_Eduardo — M14 `time_override_end` (cdmoj)

Testes de unidade do método M14 `time_override_end` (`server/api/v1/lib/contest-gate.sh`), feitos pelo Eduardo para a disciplina Testes de Software (FGA0314), Grupo 11. Os dois defeitos encontrados (X1 e X2) foram corrigidos num ciclo de **TDD** (Red → Green → Refactor).

O relatório completo está em **[testes-eduardo-m14.md](testes-eduardo-m14.md)**: contrato, caixa-preta, caixa-branca (MC/DC), resultados, defeitos, o ciclo de TDD (seção 7) e lacunas. O planejamento escrito antes dos testes está em [planejamento-m14.txt](planejamento-m14.txt), e o texto de apoio para o relatório final da equipe em [subsidios-relatorio-final-m14.md](subsidios-relatorio-final-m14.md).

## Pré-requisitos

- bash 5 e jq (testado com bash 5.3.20 e jq 1.8.2);
- Python 3, só para o oráculo do porteiro (testado com 3.14.8);
- kcov, só para medir a cobertura (testado com kcov 43).

O teste é **offline**: não usa rede nem o MOJ real. `MOJ_CONF` aponta para um arquivo que não existe e `CONTESTSDIR` para uma fixture em `mktemp -d`, apagada no fim; nenhuma configuração nem dado da máquina é lido.

## Como executar

Na raiz do `cdmoj`:

```bash
./Test_Eduardo/time-override-end.sh             # execução normal
./Test_Eduardo/time-override-end.sh --trace     # também grava evidencias/traces/<ID>.trace (xtrace)
python3 -I Test_Eduardo/oraculo-porteiro.py     # oráculo: o espelho em Python (porteiro) nas mesmas entradas
bash server/test/smoke-time-overrides.sh        # regressão do TDD (teste do upstream, não alterado)
kcov --include-path="$PWD/server/api/v1/lib/contest-gate.sh" Test_Eduardo/evidencias/cobertura ./Test_Eduardo/time-override-end.sh
```

Resultado esperado: `RESULT: 33 passed, 0 failed, 0 xfail` e exit 0. Antes do TDD eram `28 passed, 0 failed, 2 xfail`: os 2 XFAIL eram os defeitos X1 e X2 (seção 6 do relatório), que viraram casos obrigatórios no Red e foram corrigidos no Green. O exit é 1 só se um caso obrigatório falhar.

Para o kcov, rode o **script executável**, não `bash <script>`: no segundo caso o kcov mede o próprio bash e o relatório sai vazio.

## Ver o ciclo de TDD

| Fase | Resultado |
|---|---|
| Red | `29 passed, 4 failed, 0 xfail` (exit 1) |
| Green | `33 passed, 0 failed, 0 xfail` |
| Refactor | `33 passed, 0 failed, 0 xfail` |

As saídas e os diffs de cada fase, e a regressão com os testes do upstream, estão em `evidencias/tdd/`. O relato completo está na seção 7 do relatório.

## Onde estão as evidências

| Caminho | Conteúdo |
|---|---|
| `time-override-end.sh` | o script de teste |
| `oraculo-porteiro.py` | oráculo de paridade com o porteiro em Python |
| `evidencias/saida-2026-11-02.txt` | saída completa da execução atual (depois do TDD) |
| `evidencias/saida-2026-11-01.txt` | saída de antes do TDD (histórico) |
| `evidencias/oraculo-porteiro-2026-11-02.txt` | saída do oráculo (com T1–T3); a de 2026-11-01 é a anterior |
| `evidencias/traces/` | xtrace de cada caso (código depois do TDD) |
| `evidencias/cobertura/index.html` | relatório de cobertura do kcov, depois do TDD (abrir no navegador); dados em `time-override-end.sh.e59b551128ea4781/cobertura.xml` |
| `evidencias/tdd/` | saída e diff de cada fase do TDD, e a regressão com os testes do upstream |
| `evidencias/img/` | imagens usadas no relatório |

O M15 `contest_end_effective`, do mesmo arquivo, está na branch `test/eduardo-m15`.
