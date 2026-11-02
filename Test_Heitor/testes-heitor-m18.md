# Documentação de Testes - M18: `can_submit` (Grupo 11)

**Responsável:** Heitor  
**Branch:** `test/heitor-m18`  
**Repositório:** `cdmoj`  

---

## 1. Políticas de Contribuição do Repositório

### Política de Issues
* Toda alteração ou suíte de testes deve estar vinculada a uma Issue.
* A Issue deve especificar os critérios de bloqueio de submissão temporal e por perfil de usuário.

### Política de Branches
* Branches individuais no padrão `test/<nome>-<modulo>` (ex.: `test/heitor-m18`).
* Proibido commits diretos na `master`/`main`.

### Política de Pull Requests (PR)
* O PR deve referenciar a Issue (ex.: `Fixes #18`).
* Requer aprovação de ao menos um revisor e suite de testes com 100% de aprovação.

---

## 2. Descrição do Método M18 (`can_submit`)

O método `can_submit` valida se o usuário possui autorização para enviar código para julgamento:
- **Juízes** podem submeter mesmo após o término do contest (`phase="ended"`), permitindo recalibração ou testes de gabarito.
- **Equipes de Staff/Animeitor** não podem realizar submissões.
- **Competidores Comuns** têm a submissão aceita **apenas durante a fase ativa (`"running"`)**, sendo rejeitadas antes (`"before"`) e após (`"ended"`).

---

## 3. Metodologia de Desenvolvimento Orientado a Testes (TDD)

O método seguiu a prática de **TDD**:
- **Red:** Testes elaborados para validar bloqueio e permissão de submissão antes da escrita do código de controle;
- **Green:** Construção da lógica mínima de checagem de papel e janela de contest ativo (`running`);
- **Refactor:** Eliminação de redundâncias e garantia de tratamento de estados extemporâneos.
*(Para o detalhamento passo a passo dos 3 ciclos, consulte o arquivo `tdd-m18.md`).*

---

## 4. Matriz de Casos de Teste e Validação

| ID Caso de Teste | Papel do Usuário | Fase do Contest | Retorno Esperado (RC) | Retorno Obtido | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **CT01_M18** | Juiz (`is_judge=true`) | `ended` | 0 (Permitido) | 0 | ☑ PASSED |
| **CT02_M18** | Staff (`is_staff=true`) | `running` | 1 (Bloqueado) | 1 | ☑ PASSED |
| **CT03_M18** | Comum | `before` | 1 (Bloqueado) | 1 | ☑ PASSED |
| **CT04_M18** | Comum | `running` | 0 (Permitido) | 0 | ☑ PASSED |
| **CT05_M18** | Comum | `ended` | 1 (Bloqueado) | 1 | ☑ PASSED |

---

## 4. Como Executar os Testes

No terminal Bash:

```bash
cd Test_Heitor
chmod +x can_submit_test.sh
./can_submit_test.sh
```

---

## 5. Evidências de Execução

```text
=== Testando M18: can_submit ===
✅ PASSED: CT01_M18 (Juiz submete em ended)
✅ PASSED: CT02_M18 (Staff bloqueado de submeter)
✅ PASSED: CT03_M18 (Comum falha em before)
✅ PASSED: CT04_M18 (Comum submete em running)
✅ PASSED: CT05_M18 (Comum falha em ended)
=== Fim dos Testes M18 ===
```
