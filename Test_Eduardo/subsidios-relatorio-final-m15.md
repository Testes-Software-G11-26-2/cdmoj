# Subsídios para o relatório final — M15 `contest_end_effective` (Eduardo)

Rascunho para ajudar a montar o **relatório técnico da equipe** (atividade 3). Segue a ordem de seções que o enunciado pede. Os números vêm das execuções reais registradas em `testes-eduardo-m15.md` (o relatório de testes deste método), e cada item aponta a seção onde está a evidência. O texto pode ser copiado e adaptado; as partes gerais (projeto, técnicas) são iguais às das branches do M10 e do M14 e só precisam entrar uma vez no relatório final.

## Introdução (contribuição)

Este método faz parte do bloco "Tempo e acesso do servidor" do roteiro de 21 métodos do Grupo 11. O Eduardo ficou com três métodos: M10 `id_arg` (moj-cli), M14 `time_override_end` e M15 `contest_end_effective` (cdmoj). O M15 decide **até quando cada time pode submeter**: é o fim efetivo da prova para um login, considerando a prorrogação por sede. Um erro aqui deixa um time submeter depois do fim ou o impede de submeter durante o tempo a que tem direito. Foi também o método escolhido para a atividade de TDD.

## Descrição do projeto (parte do cdmoj)

O MOJ é o juiz online da UnB. O `cdmoj` é a plataforma web:
- uma API em bash atrás do nginx + fcgiwrap (`server/api/v1/`, um handler por rota e bibliotecas em `lib/`);
- um frontend ESM sem build (`web/`);
- um "porteiro" em Python (`server/porteiro/moj-porteiro.py`) que serve as rotas quentes de leitura e **espelha** regras do bash.

O M15 fica em `server/api/v1/lib/contest-gate.sh` e é chamado pelo `contest_phase` (que decide o `/submit`), pelo countdown do `/contest/basic` e pelo envio offline. O espelho no porteiro é `end_effective`.

## Planejamento dos testes

- **Escopo:** teste de unidade, offline, da função integrada com o M14 real (sem stub). Nada de rede nem de dado real: `MOJ_CONF` aponta para um arquivo inexistente e `CONTESTSDIR` para uma fixture em `mktemp -d`.
- **Oráculo:** o contrato do comentário da função (*"o override só ESTENDE — nunca encurta — e só vale quando há um fim definido no conf"*), a função irmã `contest_end_all` e o espelho do porteiro, que foi **executado** como oráculo de paridade (`oraculo-porteiro.py`).
- **Planejamento escrito antes do código de teste:** `planejamento-m15.txt` (partições, casos E01–E13, pares MC/DC, hipóteses de defeito).
- **Critério de saída:** todo caso obrigatório passa; hipótese de defeito vira XFAIL (falha registrada que não quebra o exit code); nenhum esperado é alterado para fazer passar.

## Descrição das técnicas utilizadas

- **Caixa-preta:** partições de equivalência das três entradas (F1 `CONTEST_END` do conf, F2 o override vindo do M14, F3 o login), uma partição inválida por caso, e **valor limite** onde há ordem: `oend = END−1`, `END`, `END+1` e `END = 0` × `END = 1` (seção 3).
- **Caixa-branca:** decisões D1 e D2 com V e F; D2 tem três condições (`R ∧ (A ∧ B)`), cobertas por **MC/DC** com três pares (E02×E01, E02×E06, E02×E03). Curto-circuito e mascaramento documentados (seção 4).
- **Evidência de caminho:** xtrace por caso (`--trace`), que mostra a linha e o valor de cada condição.
- **Cobertura de linhas:** kcov (seção 5).
- **TDD:** ciclo Red → Green → Refactor sobre o defeito X3/X4 (seção 7).

## Testes desenvolvidos

- Script `contest-end-effective.sh`, no estilo dos testes do upstream (`set -u`, contadores, linha `RESULT`, exit 1 se algum caso obrigatório falhar).
- **Antes do TDD:** 17 casos — `13 passed, 0 failed, 4 xfail`.
- **Depois do TDD:** 19 casos — `17 passed, 0 failed, 2 xfail`.
- **Defeitos encontrados** (seção 6), todos divergências entre bash e porteiro:
  - X1/X2: override exponencial ou float é descartado e o time perde a prorrogação (só por arquivo editado fora da API);
  - X3/X4: `CONTEST_END` com zero à esquerda era lido em **octal**: `0100` virava 64 e a prova **encurtava** para 99; `09` dava erro de base. **Corrigido no TDD.**

## Métricas de cobertura

| Métrica | Valor medido | Como |
|---|---|---|
| Linhas do M15 (kcov, antes do TDD) | 6 de 6 linhas instrumentadas cobertas (36–41) | `cobertura.xml` do kcov |
| Decisões (V e F) | D1 e D2 com os dois lados exercitados | tabela da seção 4, conferida nos traces |
| MC/DC de D2 | 3 de 3 condições com par independente | pares da seção 4 + imagens `mcdc-*.png` |

Ressalvas: o kcov mede só **linha** — a linha da D2 conta como coberta com qualquer caso, então decisão e MC/DC vêm dos traces e dos pares, não da ferramenta. O kcov não foi regerado depois do TDD (lacuna registrada).

## Descrição do processo de TDD

Resumo da seção 7 do relatório de testes. Cada fase tem um commit próprio na branch `test/eduardo-m15`, então é possível fazer checkout no Red e ver o teste falhar.

| Fase | Commit | O que mudou | Resultado |
|---|---|---|---|
| Red | `863e72e0` | X3/X4 promovidos de XFAIL a obrigatórios; casos novos T1 (`0001700000000`) e T2 (`00`) | `13 passed, 4 failed`, exit 1 |
| Green | `e2812ad9` | 1 linha: `$((10#$CONTEST_END))` força base decimal | `17 passed, 0 failed` |
| Refactor | `b8cf5b96` | regra extraída para o helper `epoch_dec_to` (nameref, sem fork); sai o `a && b \|\| c` | `17 passed, 0 failed` + 4 smokes do upstream sem falha |

## Análise crítica (contribuição do M15)

**Complementaridade entre caixa-preta e caixa-branca.**
- A caixa-preta achou o defeito mais grave: X3 nasceu da partição "zero à esquerda" de F1, pensada a partir da entrada, não do código.
- A caixa-branca explicou **por que** ele acontece: a D1 aceita `0100` (a regex casa), mas a D2 compara em outra base. Sem olhar as duas decisões juntas, o defeito pareceria aleatório.
- O MC/DC mostrou que cada condição da D2 (R, A, B) muda o resultado sozinha. Os limites `END−1/END/END+1` da caixa-preta são os mesmos dados que separam B, então as técnicas se reforçam.

**Qualidade da testabilidade.**
- *Ajuda:* as libs podem ser carregadas com `source` sem subir servidor, e o diretório de dados vem de variável de ambiente (`CONTESTSDIR`, `MOJ_CONF`) — isso permitiu fixture isolada sem mock.
- *Ajuda:* o espelho em Python dá um **oráculo independente** de graça.
- *Atrapalha:* a função faz `source` do conf, que pode sobrescrever variáveis do chamador; cada caso precisou rodar em subshell.
- *Atrapalha:* a saída é texto (`printf`), não número, então `"00"` e `"0"` são saídas diferentes e o contrato não diz qual é a certa (o T2 fixou `0`, pela paridade com o porteiro).

**Dificuldades de testar um sistema real.**
- As linhas citadas no roteiro já estavam desatualizadas; foi preciso localizar as funções pelo nome.
- Separar "defeito" de "entrada impossível": o writer da API faz `floor` no `end`, então float e exponencial só chegam por arquivo editado à mão. Cada XFAIL ganhou um rótulo de alcançabilidade.
- O comportamento real contradisse o planejamento: a previsão era "`09` passa sem erro"; a execução deu erro de base. Só rodando de verdade o oráculo ficou certo.
- O upstream tem 216 scripts de teste; rodar tudo a cada mudança não é viável, então a regressão foi uma amostra (os 4 que exercitam esta lib).

**Limitações das técnicas aplicadas.**
- O xtrace mostra o `(( A && B ))` numa linha só; a independência entre A e B veio dos dados, não do trace.
- kcov mede linha, não decisão; o "100% das linhas" do M15 não diz nada sobre MC/DC.
- Teste de unidade não prova o caminho pela rota: a alcançabilidade do X3/X4 pelo `POST /contest/admin/settings` foi deduzida lendo o código, não executada.

**Impacto do TDD no design e na manutenção.**
- O teste escrito antes obrigou a decidir o contrato que faltava (T2: `"00"` deve sair `0`).
- O Refactor deu nome à regra (`epoch_dec_to`) e a tornou reutilizável sem custo de processo — e foi procurando onde reutilizá-la que apareceu o **mesmo defeito na `contest_end_all`** (confirmado por execução: `0100` → `99`). O TDD virou uma ferramenta de descoberta, não só de correção.
- Fases pequenas (1 linha no Green) deixam o diff revisável e o histórico explica o porquê de cada mudança.

**Lições aprendidas.**
- O oráculo vem do contrato, nunca do que o código faz hoje.
- Hipótese só vale depois de executada (o caso do octal).
- Registrar defeito como XFAIL antes de corrigir preserva a evidência do vermelho e facilita o TDD depois.
- Conhecer as armadilhas das ferramentas economiza horas: kcov tem de rodar o script executável, não `bash <script>`.

## Conclusão (contribuição)

O M15 foi testado com 19 casos (17 obrigatórios e 2 hipóteses de defeito), com cobertura de decisões e MC/DC documentada e oráculo de paridade executado. Foram encontrados quatro defeitos, todos divergências entre o bash e o porteiro. Dois deles (X3/X4, leitura em octal que podia encurtar a prova) foram corrigidos com TDD, em três commits que mostram o Red, o Green e o Refactor. Ficam como trabalho futuro: o mesmo defeito na `contest_end_all` e a correção do X1/X2 no M14.
