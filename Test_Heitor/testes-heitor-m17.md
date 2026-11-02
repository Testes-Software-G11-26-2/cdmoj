# Documentação de Testes - M17: `can_see_problems` (Grupo 11)

**Responsável:** Heitor  
**Branch:** `test/heitor-m17`  
**Repositório:** `cdmoj`  

---

## 1. Políticas de Contribuição do Repositório

### Política de Issues
* Toda modificação e adição de testes deve ser referenciada por uma Issue.
* A Issue descreve o comportamento esperado da autorização de visualização e regras de bloqueio.

### Política de Branches
* Branches individuais no padrão `test/<nome>-<modulo>` (ex.: `test/heitor-m17`).
* Proibido commits diretos na `master`/`main`.

### Política de Pull Requests (PR)
* O PR deve referenciar a Issue (ex.: `Fixes #17`).
* Requer aprovação de ao menos um revisor e suite de testes 100% verde.

---

## 2. Descrição do Método M17 (`can_see_problems`)

O método `can_see_problems` aplica as regras de controle de acesso aos enunciados de problemas de uma prova no CD-MOJ:
- **Juízes** possuem acesso irrestrito, inclusive antes do início da prova (`phase="before"`).
- **Membros de Staff, Cstaff e Animeitor** não competem e têm visualização bloqueada durante o andamento.
- **Usuários Comuns (competidores)** só podem visualizar problemas quando a prova estiver em andamento (`"running"`) ou após seu encerramento (`"ended"`), permanecendo estritamente bloqueados na fase preliminar (`"before"`).

---

## 3. Matriz de Casos de Teste e Cobertura Lógica

| ID Caso de Teste | Papel do Usuário | Fase do Contest | Retorno Esperado (RC) | Retorno Obtido | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **CT01_M17** | Juiz (`is_judge=true`) | `before` | 0 (Permitido) | 0 | ☑ PASSED |
| **CT02_M17** | Staff (`is_staff=true`) | `running` | 1 (Bloqueado) | 1 | ☑ PASSED |
| **CT03_M17** | Cstaff (`is_cstaff=true`) | `running` | 1 (Bloqueado) | 1 | ☑ PASSED |
| **CT04_M17** | Animeitor (`is_animeitor=true`) | `running` | 1 (Bloqueado) | 1 | ☑ PASSED |
| **CT05_M17** | Comum | `before` | 1 (Bloqueado) | 1 | ☑ PASSED |
| **CT06_M17** | Comum | `running` | 0 (Permitido) | 0 | ☑ PASSED |
| **CT07_M17** | Comum | `ended` | 0 (Permitido) | 0 | ☑ PASSED |

---

## 4. Como Executar os Testes

No terminal Bash:

```bash
cd Test_Heitor
chmod +x can_see_problems_test.sh
./can_see_problems_test.sh
```

---

## 5. Evidências de Execução

```text
=== Testando M17: can_see_problems ===
✅ PASSED: CT01_M17 (Juiz vê em before)
✅ PASSED: CT02_M17 (Staff bloqueado em running)
✅ PASSED: CT03_M17 (Cstaff bloqueado em running)
✅ PASSED: CT04_M17 (Animeitor bloqueado em running)
✅ PASSED: CT05_M17 (Comum bloqueado em before)
✅ PASSED: CT06_M17 (Comum permitido em running)
✅ PASSED: CT07_M17 (Comum permitido em ended)
=== Fim dos Testes M17 ===
```
