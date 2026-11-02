# Registro do Ciclo TDD - Método M16 (`contest_phase`)

**Disciplina:** Testes de Software  
**Grupo:** 11  
**Responsável:** Heitor  
**Método:** `contest_phase`  

---

## 1. Visão Geral do Processo TDD
O desenvolvimento do método `contest_phase` seguiu estritamente o ciclo **Test-Driven Development (Red -> Green -> Refactor)**, onde cada funcionalidade e regra temporal foi introduzida a partir de um teste que inicialmente falhava.

---

## 2. Ciclos de Desenvolvimento

### Ciclo 1: Identificação de Prova Pré-Início (`before`)
* **RED (Fase Vermelha):**
  * Criação do teste para o cenário onde o tempo atual é menor que o início:
    ```bash
    now=99; start=100; end=200
    assert_equal "now < start" "before" "$(contest_phase)"
    ```
  * **Resultado do Teste:** ❌ *FAILED* (Função inexistente ou sem retorno).
* **GREEN (Fase Verde):**
  * Implementação mínima necessária:
    ```bash
    contest_phase() {
        if [ "$now" -lt "$start" ]; then
            echo "before"
        fi
    }
    ```
  * **Resultado do Teste:** ✅ *PASSED*.
* **REFACTOR (Refatoração):**
  * Garantia de tratamento seguro das variáveis de timestamp inteiro.

---

### Ciclo 2: Ativação da Prova (`running`)
* **RED (Fase Vermelha):**
  * Teste do limite exato de início e período intermediário:
    ```bash
    now=100; start=100; end=200
    assert_equal "now == start" "running" "$(contest_phase)"
    ```
  * **Resultado do Teste:** ❌ *FAILED* (Retornou vazio, esperado "running").
* **GREEN (Fase Verde):**
  * Extensão mínima da lógica condicional:
    ```bash
    contest_phase() {
        if [ "$now" -lt "$start" ]; then
            echo "before"
        else
            echo "running"
        fi
    }
    ```
  * **Resultado do Teste:** ✅ *PASSED* para `now=100` e `now=199`.
* **REFACTOR (Refatoração):**
  * Padronização da estrutura de blocos `if/elif/else`.

---

### Ciclo 3: Encerramento com e sem Prazo Definido (`ended`)
* **RED (Fase Vermelha):**
  * Teste para o instante exato de término e término passado:
    ```bash
    now=200; start=100; end=200
    assert_equal "now == end" "ended" "$(contest_phase)"
    ```
  * **Resultado do Teste:** ❌ *FAILED* (Retornou "running", esperado "ended").
* **GREEN (Fase Verde):**
  * Introdução da verificação de término (`$end > 0` e `$now >= $end`):
    ```bash
    contest_phase() {
        if [ "$now" -lt "$start" ]; then
            echo "before"
        elif [ "$end" -gt 0 ] && [ "$now" -ge "$end" ]; then
            echo "ended"
        else
            echo "running"
        fi
    }
    ```
  * **Resultado do Teste:** ✅ *PASSED* para todos os casos (inclusive CT05 com `end=0`).
* **REFACTOR (Refatoração):**
  * Validação final de clareza do código e conformidade com Bash padrão POSIX do repositório CD-MOJ.
