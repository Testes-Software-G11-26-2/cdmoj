# M01 — `safe_src_filename` (CD-MOJ) · Testes de Software · Danielly

## 1. Identificação

| Item | Valor |
|---|---|
| Método | `safe_src_filename` (sanitização de nomes de arquivos enviados) |
| Arquivo | `server/api/v1/lib/common.sh` (linhas 259–271) |
| Branch | `test/DaniellyR-m12` |
| Ferramentas | GNU bash, Windows 11 (Git Bash/MINGW64), VS Code |
| Data | 2026-11-02 |
| Script | `test_Danielly/test-safe-src.sh`: testes automatizados e unitários |

Para reproduzir, rode na raiz do repositório `cdmoj`:

```bash
bash test_Danielly/test-safe-src.sh             # execução normal dos testes de caixa-preta
bash -x test_Danielly/test-safe-src.sh > test_Danielly/evidencias/traces/caixa-branca.trace 2>&1 # gera o trace estrutural
```

---

## 2. Contrato

O contrato da função `safe_src_filename` consiste em processar e higienizar nomes de arquivos enviados por utilizadores ou sistemas externos, garantindo que sejam seguros para manipulação no servidor:

- **Extração de Extensão:** Verifica a presença de pontos (`*.*`) para separar o nome base (`stem`) da extensão (`ext`). Se não houver ponto, trata o argumento inteiro como nome base.
- **Limpeza de Espaços e Caracteres de Controle:** Remove espaços em branco e carateres de controle logo no início (`${n//[[:space:]]/}`).
- **Tratamento de Sufixos de Download:** Remove padrões repetitivos de sufixo numérico de download, como `(1)`, utilizando casamento de expressões regulares (`while [[ "$stem" =~ ^(.+)\([0-9]+\)\s$ ]]`).
- **Remoção de Caracteres Inválidos (`bad`):** Filtra carateres especiais indesejados (como `!`, `?`, parênteses, etc.) através de um ciclo de varredura letra a letra.
- **Retorno:** Devolve o nome do arquivo limpo e seguro (com ponto e extensão, se houver, ou apenas o nome base).

---

## 3. Caixa-preta: partições e limites

| Partição / limite | Classe | Casos de Teste |
|---|---|---|
| P1 Nomes com espaços internos ou nas pontas (`teste .py`) | válida | Teste 1 |
| P2 Caracteres especiais (`!`, `?`) (`codigo!.c`, `java?.py`) | inválida/ajustada | Teste 2, Teste 3 |
| P3 Sufixos de download numéricos (`nome(1).java`) | válida/ajustada | Teste 4 |
| P4 Ausência de ponto separador de extensão (`qualquertexto!py`) | limite (caminho falso do `if`) | Teste 5 |

---

## 4. Caixa-branca

### Decisões e condições estruturais

A análise estrutural concentra-se na verificação da existência de extensão e na refatoração dos ciclos de limpeza:

- **Decisão D1 (`*.*`):** Verifica se o nome do ficheiro possui extensão.
  - *Caminho Verdadeiro:* Divide a string em `stem` e `ext`.
  - *Caminho Falso (`else`):* Atribui o nome inteiro a `stem` e deixa a extensão vazia.
- **Evidência de Traces:** O ficheiro `evidencias/traces/caixa-branca.trace` regista passo a passo a execução dos fluxos com e sem ponto, bem como o comportamento do laço de substituição de carateres proibidos.

---

## 5. Resultados

Execução validada com sucesso através do script de testes no Git Bash.

| ID | Entrada Testada | Saída Obtida | Status | Critério / Categoria |
|---|---|---|---|---|
| C01 | `teste .py` | `teste.py` | ok | P1: remoção de espaço |
| C02 | `codigo!.c` | `codigo.c` | ok | P2: remoção de caractere `!` |
| C03 | `java?.py` | `java.py` | ok | P2: remoção de caractere `?` |
| C04 | `nome(1).java` | `nome.java` | ok | P3: remoção de sufixo `(1)` |
| C05 | `qualquertexto!py` | `qualquertextopy` | ok | P4: caminho falso do `if` (sem ponto) |

*Nota: As capturas de tela com os resultados detalhados encontram-se guardadas na pasta `evidencias/img/`.*

---

## 6. Ciclos de TDD e Refatoração

Cumprindo os requisitos de desenvolvimento guiado por testes (TDD) e refatoração do código original do projeto:

1. **Ciclo 1 (Testes Funcionais):** Escrita dos testes de caixa-preta cobrindo classes de equivalência problemáticas (espaços, carateres especiais e sufixos).
2. **Ciclo 2 (Refatoração Estrutural):** Identificação de código duplicado no método original (dois blocos de laços `for` idênticos aplicados separadamente em `stem` e `ext`).
   - *Melhoria aplicada:* Extração da lógica repetitiva para uma função auxiliar autónoma chamada `limpar_texto`, que passou a ser invocada de forma limpa e reutilizável para ambas as variáveis, respeitando o princípio DRY (*Don't Repeat Yourself*).

## 7. Análise Crítica

A realização deste trabalho prático permitiu consolidar conceitos fundamentais de engenharia de software e testes automatizados aplicados a um projeto real de grande porte (CD-MOJ). A partir da análise do método `safe_src_filename`, destacam-se os seguintes pontos críticos:

- **Complementaridade entre Caixa-Preta e Caixa-Branca:** A abordagem de caixa-preta foi essencial para mapear as partições de equivalência e os limites funcionais (como tratamento de espaços, caracteres especiais `!` e `?`, e sufixos numéricos). Em contrapartida, a caixa-branca — com o auxílio do rastreamento de execução (`xtrace` / `-x`) — permitiu validar os caminhos lógicos reais do código, como a decisão estrutural de separação de extensão e o comportamento do laço para entradas sem ponto.
- **Qualidade da Testabilidade e Sistemas Reais:** Testar código legado em ambiente Bash apresenta desafios singulares devido à densidade sintática da linguagem e à ausência de estruturas nativas robustas de asserción encontradas em linguagens orientadas a objetos. No entanto, o uso de fixtures isoladas com diretórios temporários garantiu um ambiente controlado e determinístico.
- **Impacto do TDD e Refatoração:** A aplicação do ciclo de TDD e refatoração — especialmente a extração dos blocos de repetição `for` para uma função auxiliar isolada (`limpar_texto`) — demonstrou o impacto direto do princípio DRY (*Don't Repeat Yourself*). A mudança reduziu a duplicação de código e tornou a manutenção e a legibilidade do script significativamente superiores, sem alterar o comportamento funcional esperado.
- **Lições Aprendidas:** A equipe compreendeu que uma especificação clara de contrato aliada a testes rigorosos de unidade diminui drasticamente o índice de regressões, evidenciando que o planejamento de casos limpos e de limiar (limites) assegura maior resiliência ao software.

## 8. Declaração do Uso de IA

O suporte de inteligência artificial, GOOGLE GEMINI, foi utilizado de forma colaborativa durante o processo de desenvolvimento para:

1. Auxiliar na compreensão da sintaxe de scripts em Bash e na estruturação de funções auxiliares para a refatoração do código (`common.sh`).
2. Apoiar na formulação dos casos de teste baseados em partições de equivalência e análise de caminhos lógicos.
3. Auxiliar na organização e redação da documentação técnica e estruturação do relatório nos moldes exigidos pela disciplina.