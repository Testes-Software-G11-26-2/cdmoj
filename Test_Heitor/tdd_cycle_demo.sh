#!/usr/bin/env bash

# ==============================================================================
# Demonstração do Ciclo TDD - M17: can_see_problems
# Mostra a fase RED (falha esperada) e a fase GREEN (aprovação)
# ==============================================================================

assert_rc() {
    local case_name="$1"
    local expected_rc="$2"
    "$3"
    local actual_rc=$?
    if [ "$expected_rc" -eq "$actual_rc" ]; then
        echo "  [GREEN] ✅ PASSED: $case_name"
    else
        echo "  [RED]   ❌ FAILED: $case_name | Esperado RC: $expected_rc, Obtido RC: $actual_rc"
    fi
}

echo "=== CICLO TDD 1: Acesso de Juiz ==="
echo "--- 1. Testando Juiz sem implementação (Fase RED) ---"
stub() { return 1; }
is_judge=true; phase="before"
assert_rc "Juiz em before (função vazia/stub)" 0 stub

echo "--- 2. Implementação mínima para Juiz (Fase GREEN) ---"
can_see_c1() {
    if [ "$is_judge" = true ]; then return 0; fi
    return 1
}
assert_rc "Juiz em before (com permissão de juiz)" 0 can_see_c1

echo ""
echo "=== CICLO TDD 2: Bloqueio de Staff/Apoio ==="
echo "--- 1. Testando Staff com implementação C1 (Fase RED) ---"
is_judge=false; phase="running"; is_staff=true
assert_rc "Staff bloqueado em running (C1 não trata staff)" 1 can_see_c1

echo "--- 2. Implementação de filtro de staff (Fase GREEN) ---"
can_see_c2() {
    if [ "$is_judge" = true ]; then return 0; fi
    if [ "$is_staff" = true ] || [ "$is_cstaff" = true ] || [ "$is_animeitor" = true ]; then return 1; fi
    return 0
}
assert_rc "Staff bloqueado em running (após C2)" 1 can_see_c2

echo ""
echo "=== CICLO TDD 3: Restrição de Fase para Competidores Comuns ==="
echo "--- 1. Competidor em fase 'before' com C2 (Fase RED) ---"
is_staff=false; phase="before"
assert_rc "Comum em before (C2 libera indevidamente)" 1 can_see_c2

echo "--- 2. Implementação final com checagem de fase (Fase GREEN / REFACTOR) ---"
can_see_final() {
    if [ "$is_judge" = true ]; then return 0; fi
    if [ "$is_staff" = true ] || [ "$is_cstaff" = true ] || [ "$is_animeitor" = true ]; then return 1; fi
    if [ "$phase" = "before" ]; then return 1; fi
    return 0
}
assert_rc "Comum bloqueado em before (após C3)" 1 can_see_final
phase="running"
assert_rc "Comum liberado em running" 0 can_see_final

echo ""
echo ">>> Ciclos TDD concluídos com sucesso para M17!"
