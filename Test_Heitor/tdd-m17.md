# Registro do Ciclo TDD - Método M17 (`can_see_problems`)

**Disciplina:** Testes de Software  
**Grupo:** 11  
**Responsável:** Heitor  
**Método:** `can_see_problems`  

---

## 1. Visão Geral do Processo TDD
O método `can_see_problems` regula a permissão de visualização dos problemas da prova com base no papel do usuário (`is_judge`, `is_staff`, `is_cstaff`, `is_animeitor`) e na fase (`phase`). O ciclo Red -> Green -> Refactor foi utilizado para desacoplar e garantir cada regra de permissão.

---

## 2. Ciclos de Desenvolvimento

### Ciclo 1: Privilégio Irrestrito do Juiz
* **RED (Fase Vermelha):**
  * Teste do Juiz tentando visualizar a prova antes do início:
    ```bash
    is_judge=true; phase="before"
    assert_rc "Juiz em before" 0 can_see_problems
    ```
  * **Resultado do Teste:** ❌ *FAILED* (Função inexistente ou retorno 127).
* **GREEN (Fase Verde):**
  * Implementação mínima para atender à autorização do juiz:
    ```bash
    can_see_problems() {
        if [ "$is_judge" = true ]; then return 0; fi
        return 1
    }
    ```
  * **Resultado do Teste:** ✅ *PASSED*.
* **REFACTOR:** Retorno booleano direto via exit codes no Bash (`0 = true/sucesso`, `1 = false/bloqueio`).

---

### Ciclo 2: Bloqueio de Funções Técnicas e de Apoio
* **RED (Fase Vermelha):**
  * Teste para Staff, Cstaff e Animeitor em prova em andamento:
    ```bash
    is_judge=false; phase="running"
    is_staff=true; assert_rc "Staff bloqueado em running" 1 can_see_problems
    ```
  * **Resultado do Teste:** ❌ *FAILED* (Esperado bloqueio com RC=1, função não previa os papéis).
* **GREEN (Fase Verde):**
  * Inclusão do filtro para os cargos operacionais:
    ```bash
    can_see_problems() {
        if [ "$is_judge" = true ]; then return 0; fi
        if [ "$is_staff" = true ] || [ "$is_cstaff" = true ] || [ "$is_animeitor" = true ]; then return 1; fi
        return 0
    }
    ```
  * **Resultado do Teste:** ✅ *PASSED* para todos os cargos de apoio.
* **REFACTOR:** Agrupamento conciso das flags de apoio em expressão única `||`.

---

### Ciclo 3: Restrição Temporal para Competidor Comum
* **RED (Fase Vermelha):**
  * Teste de competidor comum tentando acessar em fase preliminar (`before`):
    ```bash
    is_judge=false; is_staff=false; phase="before"
    assert_rc "Comum em before" 1 can_see_problems
    ```
  * **Resultado do Teste:** ❌ *FAILED* (Retornava 0 liberando acesso prematuro).
* **GREEN (Fase Verde):**
  * Adição da barreira de fase antes do retorno padrão:
    ```bash
    can_see_problems() {
        if [ "$is_judge" = true ]; then return 0; fi
        if [ "$is_staff" = true ] || [ "$is_cstaff" = true ] || [ "$is_animeitor" = true ]; then return 1; fi
        if [ "$phase" = "before" ]; then return 1; fi
        return 0
    }
    ```
  * **Resultado do Teste:** ✅ *PASSED* (Passa em `before`, `running` e `ended`).
* **REFACTOR:** Revisão final de legibilidade e garantia de ausência de efeitos colaterais.
