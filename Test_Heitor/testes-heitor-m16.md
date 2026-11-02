# Documentação de Testes - M16: `contest_phase` (Grupo 11)

**Responsável:** Heitor  
**Branch:** `test/heitor-m16`  
**Repositório:** `cdmoj`  

---

## 1. Políticas de Contribuição do Repositório

### Política de Issues
* Toda nova funcionalidade, alteração ou criação de bateria de testes deve estar associada a uma Issue aberta no repositório.
* A Issue deve conter descrição clara do método sob teste, critérios de aceitação e passos para reprodução/validação.

### Política de Branches
* Não é permitido realizar commits diretos nas branches `master` ou `main`.
* As branches de teste seguem o padrão definido pelo grupo: `test/<nome>-<modulo>` (ex.: `test/heitor-m16`).

### Política de Pull Requests (PR)
* O PR deve referenciar a Issue correspondente (ex.: `Fixes #16` ou `Closes #16`).
* O PR deve incluir o relatório em Markdown com evidências de execução e código dos testes passando sem falhas.
* O merge requer aprovação por Code Review de ao menos um membro do grupo.

---

## 2. Descrição do Método M16 (`contest_phase`)

O método `contest_phase` avalia o estado temporal de uma maratona de programação (contest), retornando um dos seguintes estados:
- `"before"`: quando o instante corrente é anterior ao horário de início;
- `"running"`: quando o contest já iniciou e ainda não alcançou o horário limite de encerramento (ou quando não possui limite estabelecido);
- `"ended"`: quando o instante corrente é igual ou posterior ao horário final.

---

## 3. Metodologia de Desenvolvimento Orientado a Testes (TDD)

O desenvolvimento deste método seguiu o ciclo **Red-Green-Refactor**:
- **Red:** Elaboração antecipada dos testes unitários para cada requisito de fase (`before`, `running`, `ended`), observando as falhas iniciais;
- **Green:** Implementação do código estritamente necessário para aprovação dos testes de transição temporal;
- **Refactor:** Limpeza do fluxo de condicionais e padronização POSIX.
*(Para o detalhamento passo a passo dos 3 ciclos, consulte o arquivo `tdd-m16.md`).*

---

## 4. Estratégia de Teste (PCE e AVL)

Foram aplicadas as técnicas de **Particionamento em Classes de Equivalência (PCE)** e **Análise de Valor Limite (AVL)**:

| ID Caso de Teste | Descrição da Condição | Entradas (`now`, `start`, `end`) | Saída Esperada | Saída Obtida | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **CT01_M16** | Instante antes do início (`now < start`) | `now=99, start=100, end=200` | `before` | `before` | ☑ PASSED |
| **CT02_M16** | Instante exato de início (`now == start`) | `now=100, start=100, end=200` | `running` | `running` | ☑ PASSED |
| **CT03_M16** | Imediatamente antes do fim (`now < end`) | `now=199, start=100, end=200` | `running` | `running` | ☑ PASSED |
| **CT04_M16** | Instante exato de fim (`now == end`) | `now=200, start=100, end=200` | `ended` | `ended` | ☑ PASSED |
| **CT05_M16** | Contest sem prazo definido (`end == 0`) | `now=250, start=100, end=0` | `running` | `running` | ☑ PASSED |

---

## 4. Como Executar os Testes

No terminal Bash (Linux, WSL ou Git Bash):

```bash
cd Test_Heitor
chmod +x contest_phase_test.sh
./contest_phase_test.sh
```

---

## 5. Evidências de Execução

Saída obtida diretamente da execução do script no ambiente de testes:

```text
=== Testando M16: contest_phase ===
✅ PASSED: CT01_M16 (now < start)
✅ PASSED: CT02_M16 (now == start)
✅ PASSED: CT03_M16 (now < end)
✅ PASSED: CT04_M16 (now == end)
✅ PASSED: CT05_M16 (Sem prazo de fim)
=== Fim dos Testes M16 ===
```
