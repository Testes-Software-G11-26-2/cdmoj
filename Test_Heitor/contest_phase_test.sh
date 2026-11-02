#!/usr/bin/env bash

# ==============================================================================
# Testes de Unidade - M16: contest_phase
# Repositório: cdmoj (Grupo 11 - Testes de Software)
# Responsável: Heitor
# ==============================================================================

# Função sob teste (Simulação/Mock do contest-gate)
contest_phase() {
    if [ "$now" -lt "$start" ]; then
        echo "before"
    elif [ "$end" -gt 0 ] && [ "$now" -ge "$end" ]; then
        echo "ended"
    else
        echo "running"
    fi
}

# Utilitário de Assert
assert_equal() {
    local case_name="$1"
    local expected="$2"
    local actual="$3"
    if [ "$expected" == "$actual" ]; then
        echo "✅ PASSED: $case_name"
    else
        echo "❌ FAILED: $case_name | Esperado: $expected, Obtido: $actual"
        exit_code=1
    fi
}

exit_code=0

echo "=== Testando M16: contest_phase ==="
start=100; end=200

# Limite inferior: antes do início
now=99;  assert_equal "CT01_M16 (now < start)" "before" "$(contest_phase)"

# Limite exato de início: início da prova
now=100; assert_equal "CT02_M16 (now == start)" "running" "$(contest_phase)"

# Limite inferior de encerramento: instante antes do fim
now=199; assert_equal "CT03_M16 (now < end)" "running" "$(contest_phase)"

# Limite exato de término: prova finalizada
now=200; assert_equal "CT04_M16 (now == end)" "ended" "$(contest_phase)"

# Contest sem prazo de encerramento (end == 0)
end=0
now=250; assert_equal "CT05_M16 (Sem prazo de fim)" "running" "$(contest_phase)"

echo "=== Fim dos Testes M16 ==="
exit $exit_code
