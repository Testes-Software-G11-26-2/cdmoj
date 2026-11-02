# Registro do Ciclo TDD - Método M18 (`can_submit`)

**Disciplina:** Testes de Software  
**Grupo:** 11  
**Responsável:** Heitor  
**Método:** `can_submit`  

---

## 1. Visão Geral do Processo TDD
O método `can_submit` gerencia a submissão de respostas de competidores e juízes. O TDD foi aplicado para assegurar que submissões só sejam aceitas estritamente nos períodos e pelos papéis autorizados.

---

## 2. Ciclos de Desenvolvimento

### Ciclo 1: Submissão Administrativa (Juiz)
* **RED (Fase Vermelha):**
  * Teste do Juiz submetendo após encerramento oficial da prova:
    ```bash
    is_judge=true; phase="ended"
    assert_rc "Juiz submete em ended" 0 can_submit
    ```
  * **Resultado do Teste:** ❌ *FAILED* (Função não definida).
* **GREEN (Fase Verde):**
  * Implementação mínima para permitir o Juiz:
    ```bash
    can_submit() {
        if [ "$is_judge" = true ]; then return 0; fi
        return 1
    }
    ```
  * **Resultado do Teste:** ✅ *PASSED*.
* **REFACTOR:** Proteção inicial contra execução de papéis não autorizados.

---

### Ciclo 2: Bloqueio de Submissão por Equipe Técnica
* **RED (Fase Vermelha):**
  * Teste garantindo que equipe técnica não pode submeter:
    ```bash
    is_judge=false; phase="running"; is_staff=true
    assert_rc "Staff não submete" 1 can_submit
    ```
  * **Resultado do Teste:** ❌ *FAILED* (ou vulnerabilidade se `running` fosse liberado direto).
* **GREEN (Fase Verde):**
  * Bloqueio explícito dos papéis de apoio:
    ```bash
    can_submit() {
        if [ "$is_judge" = true ]; then return 0; fi
        if [ "$is_staff" = true ] || [ "$is_cstaff" = true ] || [ "$is_animeitor" = true ]; then return 1; fi
        return 1
    }
    ```
  * **Resultado do Teste:** ✅ *PASSED*.
* **REFACTOR:** Unificação da lista de cargos não-competidores.

---

### Ciclo 3: Janela Estrita de Submissão para Competidores
* **RED (Fase Vermelha):**
  * Teste permitindo submissão de competidor comum exclusivamente em `running`:
    ```bash
    phase="running"; assert_rc "Comum submete em running" 0 can_submit
    ```
  * **Resultado do Teste:** ❌ *FAILED* (Retornava 1 devido ao retorno padrão restritivo).
* **GREEN (Fase Verde):**
  * Liberação condicional exclusiva para a fase ativa:
    ```bash
    can_submit() {
        if [ "$is_judge" = true ]; then return 0; fi
        if [ "$is_staff" = true ] || [ "$is_cstaff" = true ] || [ "$is_animeitor" = true ]; then return 1; fi
        if [ "$phase" = "running" ]; then return 0; fi
        return 1
    }
    ```
  * **Resultado do Teste:** ✅ *PASSED* (Competidores submetem em `running`, e falham em `before` e `ended`).
* **REFACTOR:** Estrutura final blindada, sem brechas de submissão fora da janela oficial.
