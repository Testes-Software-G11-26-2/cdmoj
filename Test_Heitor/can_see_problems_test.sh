#!/usr/bin/env bash

# ==============================================================================
# Testes de Unidade - M17: can_see_problems
# Repositório: cdmoj (Grupo 11 - Testes de Software)
# Responsável: Heitor
# ==============================================================================

# Função sob teste (Simulação/Mock de permissão de visualização)
can_see_problems() {
    if [ "$is_judge" = true ]; then return 0; fi
    if [ "$is_staff" = true ] || [ "$is_cstaff" = true ] || [ "$is_animeitor" = true ]; then return 1; fi
    if [ "$phase" = "before" ]; then return 1; fi
    return 0
}

# Utilitário de Assert para Return Code ($?)
assert_rc() {
    local case_name="$1"
    local expected_rc="$2"
    "$3" # Executa a função
    local actual_rc=$?
    if [ "$expected_rc" -eq "$actual_rc" ]; then
        echo "✅ PASSED: $case_name"
    else
        echo "❌ FAILED: $case_name | Retorno Esperado: $expected_rc, Obtido: $actual_rc"
        exit_code=1
    fi
}

exit_code=0

echo "=== Testando M17: can_see_problems ==="

# Reset aos cargos
is_judge=false; is_staff=false; is_cstaff=false; is_animeitor=false

# 1. Juiz pode ver mesmo antes do início (phase="before")
is_judge=true; phase="before"; assert_rc "CT01_M17 (Juiz vê em before)" 0 can_see_problems

# 2. Cargos de apoio bloqueados durante a prova (phase="running")
is_judge=false; phase="running"
is_staff=true; assert_rc "CT02_M17 (Staff bloqueado em running)" 1 can_see_problems
is_staff=false; is_cstaff=true; assert_rc "CT03_M17 (Cstaff bloqueado em running)" 1 can_see_problems
is_cstaff=false; is_animeitor=true; assert_rc "CT04_M17 (Animeitor bloqueado em running)" 1 can_see_problems

# 3. Usuário Comum em cada uma das fases
is_animeitor=false # Usuário comum
phase="before"; assert_rc "CT05_M17 (Comum bloqueado em before)" 1 can_see_problems
phase="running"; assert_rc "CT06_M17 (Comum permitido em running)" 0 can_see_problems
phase="ended"; assert_rc "CT07_M17 (Comum permitido em ended)" 0 can_see_problems

echo "=== Fim dos Testes M17 ==="
exit $exit_code
