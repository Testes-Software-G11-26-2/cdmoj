# Subsídios para o relatório final — M14 `time_override_end` (Eduardo)

Rascunho para ajudar a montar o **relatório técnico da equipe** (atividade 3). Segue a ordem de seções que o enunciado pede. Os números vêm das execuções reais registradas em `testes-eduardo-m14.md` (o relatório de testes deste método), e cada item aponta a seção onde está a evidência. As partes gerais (projeto, técnicas) são iguais às das branches do M10 e do M15 e só precisam entrar uma vez no relatório final.

## Introdução (contribuição)

O M14 faz parte do bloco "Tempo e acesso do servidor" do roteiro de 21 métodos do Grupo 11 (métodos do Eduardo: M10, M14 e M15). Ele lê a **prorrogação por sede**: quando uma sede tem um problema (queda de energia, por exemplo), a organização dá mais tempo só aos times dela, numa regra do arquivo `time-overrides.json`. O M14 devolve o novo fim para um login. Um erro aqui tira os minutos extras de uma sede inteira ou os dá a quem não deveria ter.

## Descrição do projeto (parte do cdmoj)

O MOJ é o juiz online da UnB. O `cdmoj` é a plataforma web:
- uma API em bash atrás do nginx + fcgiwrap (`server/api/v1/`, um handler por rota e bibliotecas em `lib/`);
- um frontend ESM sem build (`web/`);
- um "porteiro" em Python (`server/porteiro/moj-porteiro.py`) que serve as rotas quentes de leitura e **espelha** regras do bash.

O M14 fica em `server/api/v1/lib/contest-gate.sh`; o único chamador é o M15 (`contest_end_effective`), que alimenta o `/submit` e o countdown. O espelho no porteiro é `override_end`. A lógica principal mora num **programa jq** dentro da função bash.

## Planejamento dos testes

- **Escopo:** teste de unidade, offline. Sem stub do `mod_on`: cada contest da fixture tem `CONTEST_MODULES` no conf, e a lib de módulos real é carregada. `MOJ_CONF` aponta para um arquivo inexistente e `CONTESTSDIR` para uma fixture em `mktemp -d`.
- **Oráculo:** o comentário da função (formato `[{regex, end, reason?}, …]`, "1ª que casa vence", "try/catch protege de regex inválido", módulo `sedes` desligado = arquivo não vale), o **writer** da API (o que ele aceita gravar) e o espelho do porteiro, **executado** como oráculo de paridade (`oraculo-porteiro.py`).
- **Planejamento escrito antes do código de teste:** `planejamento-m14.txt` (partições, casos C01–C28, pares MC/DC, hipóteses).
- **Critério de saída:** todo caso obrigatório passa; hipótese de defeito vira XFAIL; nenhum esperado é alterado para fazer passar.

## Descrição das técnicas utilizadas

- **Caixa-preta:** partições do arquivo (ausente, vazio, JSON inválido, objeto no lugar de lista, lista com elemento que não é objeto…), do login (vazio, ausente), do módulo `sedes` e dos campos de cada regra (regex vazia, ausente, inválida, não string; `end` não numérico…). Uma partição inválida por caso (seção 3).
- **Caixa-branca:** sete decisões (D1–D7), quatro delas **dentro do jq**. **MC/DC** com pares para A, B, D2, D3, c1, c2 e c3 (seção 4). Curto-circuito do `&&` do bash e do `and` do jq documentados.
- **Evidência de caminho:** xtrace por caso (`--trace`) para as decisões em bash; para as do jq, o par se apoia em entrada e saída (a 1ª regra é pulada e a 2ª vence).
- **Cobertura de linhas:** kcov (seção 5).
- **TDD:** os defeitos ficaram registrados como XFAIL (o "vermelho"); o ciclo completo Red/Green/Refactor foi feito no M15 (branch `test/eduardo-m15`).

## Testes desenvolvidos

- Script `time-override-end.sh`, no estilo dos testes do upstream: 30 casos — `28 passed, 0 failed, 2 xfail`.
- **Defeitos encontrados** (seção 6), os dois só alcançáveis com o arquivo editado fora da API e os dois divergências com o porteiro:
  - X1: um **objeto** no lugar da lista é aceito (o `.[]?` do jq itera os valores do objeto); o porteiro ignora;
  - X2: **um único elemento que não é objeto** (`"x"`) derruba o jq e **silencia todas as regras**, inclusive as válidas. Uma sede inteira perderia a prorrogação; o porteiro pula o elemento.
- Correção sugerida em diff (`if type=="array" … | objects`), validada numa cópia descartável: X1 e X2 passam e nenhum caso quebra. **Não aplicada.**

## Métricas de cobertura

| Métrica | Valor medido | Como |
|---|---|---|
| Linhas com comando bash (23–26) | 4 de 4 cobertas | `cobertura.xml` do kcov |
| Linhas que o kcov instrumentou | 7, das quais 4 cobertas | as 3 restantes (27–29) são o **texto do programa jq**, não código bash — artefato da ferramenta |
| Decisões (V e F) | D1–D7 com os dois lados exercitados | tabela da seção 4 |
| MC/DC | 7 condições com par independente (A, B, D2, D3, c1, c2, c3) | pares da seção 4 + imagens `mcdc-*.png` |

Ressalva: o número cru do kcov (4 de 7) **subestima** a cobertura real e não enxerga nenhuma condição do jq. Decisão e MC/DC vêm dos pares, não da ferramenta.

## Descrição do processo de TDD

No M14 o TDD ficou na primeira etapa: cada hipótese de defeito foi escrita como teste **antes** de qualquer correção e registrada falhando (XFAIL X1 e X2). A correção não foi aplicada no código de produção desta branch. O ciclo completo (Red → Green → Refactor, um commit por fase) está documentado na branch do M15.

## Análise crítica (contribuição do M14)

**Complementaridade entre caixa-preta e caixa-branca.**
- A caixa-preta, guiada pelo contrato ("é uma lista"), propôs a entrada "objeto no lugar de lista" (X1) e "elemento que não é objeto" (X2).
- A caixa-branca explicou o resultado: o `try/catch` protege só o `test()` da regex, não o acesso `.regex` num elemento string — por isso um elemento ruim derruba as regras boas. Sem ler o jq, o X2 pareceria "a prorrogação às vezes não funciona".
- O MC/DC por elemento (c1, c2: a 1ª regra é pulada e a 2ª vence) só faz sentido porque a caixa-preta definiu a ordem ("1ª que casa vence").

**Qualidade da testabilidade.**
- *Ajuda:* dados vêm de diretório configurável por variável de ambiente; a lib carrega com `source`; o espelho do porteiro serve de oráculo.
- *Atrapalha:* quatro das sete decisões estão dentro de uma **string jq** — invisíveis ao xtrace e ao kcov. É a maior barreira de testabilidade deste método.
- *Atrapalha:* o `2>/dev/null` engole o erro do jq (o X2 sai como "sem prorrogação", sem nenhum log).

**Dificuldades de testar um sistema real.**
- Distinguir defeito de entrada impossível: o writer da API só grava listas de objetos válidas, então X1/X2 dependem de arquivo editado à mão, restaurado ou migrado. Isso teve de ser verificado no writer e registrado como rótulo de alcançabilidade.
- Duas implementações da mesma regra (bash e Python) com dialetos de regex diferentes (Oniguruma × `re`), que não dá para cobrir por inteiro.
- Decisões do Eduardo no meio do caminho (ex.: o arquivo-objeto era só uma nota e virou XFAIL) mostram que o oráculo às vezes exige julgamento, não só leitura.

**Limitações das técnicas aplicadas.**
- xtrace e kcov não enxergam o jq; a cobertura das condições internas é argumentada por entrada/saída.
- O oráculo do porteiro importa as funções mas não sobe o servidor FastCGI: o caminho "exceção → porteiro declina → bash responde" foi lido no código, não executado.
- Formatos exóticos do conf (`CONTEST_MODULES` com espaço) e o código de saída (rc 5 do jq) ficaram fora do critério.

**Impacto do TDD no design e na manutenção.**
- Escrever o X2 como teste antes da correção deixou claro que o problema era de **projeto** (onde fica o `try`), não de um valor: a correção sugerida mexe na forma de iterar (`objects`), não num caso particular.
- Os XFAIL documentam o defeito de forma executável: quem aplicar a correção vê o XPASS e sabe que pode promover o caso.

**Lições aprendidas.**
- Lógica embutida em outra linguagem (jq dentro de bash) precisa de estratégia de teste própria; as ferramentas de bash não a enxergam.
- O writer da API é parte do oráculo: o comentário dele (*"regra quebrada silenciaria as demais no gate"*) descreve exatamente o X2.
- `kcov` com número baixo nem sempre é teste fraco: é preciso ler quais linhas ele conta.

## Conclusão (contribuição)

O M14 foi testado com 30 casos (28 obrigatórios e 2 hipóteses de defeito), com sete decisões e sete pares de MC/DC documentados e paridade com o porteiro executada. Os dois defeitos encontrados fazem o bash divergir do porteiro com um arquivo malformado; o mais grave (X2) silencia a prorrogação de uma sede inteira por causa de uma única entrada ruim. A correção está proposta e validada fora do repositório, sem ter sido aplicada.
