#!/usr/bin/env bash

# ==============================================================================
# Demonstração do Ciclo TDD - M18: can_submit
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

echo "=== CICLO TDD 1: Submissão de Juiz em Prova Encerrada ==="
echo "--- 1. Submissão de juiz sem implementação (Fase RED) ---"
stub() { return 1; }
is_judge=true; phase="ended"
assert_rc "Juiz em ended (função stub)" 0 stub

echo "--- 2. Implementação mínima de permissão do Juiz (Fase GREEN) ---"
can_submit_c1() {
    if [ "$is_judge" = true ]; then return 0; fi
    return 1
}
assert_rc "Juiz em ended (com C1)" 0 can_submit_c1

echo ""
echo "=== CICLO TDD 2: Bloqueio de Staff/Apoio ==="
echo "--- 1. Staff tentando submeter (Fase RED se padrão fosse 0) ---"
is_judge=false; phase="running"; is_staff=true
assert_rc "Staff bloqueado (verificação prévia)" 1 can_submit_c1

echo "--- 2. Bloqueio explícito dos papéis de apoio (Fase GREEN) ---"
can_submit_c2() {
    if [ "$is_judge" = true ]; then return 0; fi
    if [ "$is_staff" = true ] || [ "$is_cstaff" = true ] || [ "$is_animeitor" = true ]; then return 1; fi
    return 1
}
assert_rc "Staff bloqueado com C2" 1 can_submit_c2

echo ""
echo "=== CICLO TDD 3: Submissão Exclusiva em Running para Competidores ==="
echo "--- 1. Competidor comum tentando submeter em running (Fase RED) ---"
is_staff=false; phase="running"
assert_rc "Competidor em running (C2 bloqueava todos)" 0 can_submit_c2

echo "--- 2. Liberação exclusiva para 'running' (Fase GREEN / REFACTOR) ---"
can_submit_final() {
    if [ "$is_judge" = true ]; then return 0; fi
    if [ "$is_staff" = true ] || [ "$is_cstaff" = true ] || [ "$is_animeitor" = true ]; then return 1; fi
    if [ "$phase" = "running" ]; then return 0; fi
    return 1
}
assert_rc "Competidor liberado em running" 0 can_submit_final
phase="ended"
assert_rc "Competidor bloqueado em ended" 1 can_submit_final

echo ""
echo ">>> Ciclos TDD concluídos com sucesso para M18!"
