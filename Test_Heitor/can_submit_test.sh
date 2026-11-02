#!/usr/bin/env bash

# ==============================================================================
# Testes de Unidade - M18: can_submit
# Repositório: cdmoj (Grupo 11 - Testes de Software)
# Responsável: Heitor
# ==============================================================================

# Função sob teste (Simulação/Mock de permissão de submissão)
can_submit() {
    if [ "$is_judge" = true ]; then return 0; fi
    if [ "$is_staff" = true ] || [ "$is_cstaff" = true ] || [ "$is_animeitor" = true ]; then return 1; fi
    if [ "$phase" = "running" ]; then return 0; fi
    return 1
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

echo "=== Testando M18: can_submit ==="

# Reset aos cargos
is_judge=false; is_staff=false; is_cstaff=false; is_animeitor=false

# 1. Juiz tem permissão de submissão mesmo após o fim da prova
is_judge=true; phase="ended"; assert_rc "CT01_M18 (Juiz submete em ended)" 0 can_submit

# 2. Staff impedido de submeter durante prova
is_judge=false; phase="running"
is_staff=true; assert_rc "CT02_M18 (Staff bloqueado de submeter)" 1 can_submit

# 3. Usuário Comum: permitido apenas em running, bloqueado em before e ended
is_staff=false # Utilizador comum
phase="before"; assert_rc "CT03_M18 (Comum falha em before)" 1 can_submit
phase="running"; assert_rc "CT04_M18 (Comum submete em running)" 0 can_submit
phase="ended"; assert_rc "CT05_M18 (Comum falha em ended)" 1 can_submit

echo "=== Fim dos Testes M18 ==="
exit $exit_code
