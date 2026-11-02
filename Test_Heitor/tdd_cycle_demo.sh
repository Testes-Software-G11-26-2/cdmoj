#!/usr/bin/env bash

# ==============================================================================
# Demonstração do Ciclo TDD - M16: contest_phase
# Mostra a fase RED (falha esperada) e a fase GREEN (aprovação)
# ==============================================================================

assert_equal() {
    local case_name="$1"
    local expected="$2"
    local actual="$3"
    if [ "$expected" == "$actual" ]; then
        echo "  [GREEN] ✅ PASSED: $case_name"
    else
        echo "  [RED]   ❌ FAILED: $case_name | Esperado: '$expected', Obtido: '$actual'"
    fi
}

echo "=== CICLO TDD 1: Fase Preliminar ('before') ==="
echo "--- 1. Executando teste antes da implementação (Fase RED) ---"
contest_phase_stub() { :; }
now=99; start=100; end=200
assert_equal "now < start (antes da implementação)" "before" "$(contest_phase_stub)"

echo "--- 2. Implementação mínima da regra (Fase GREEN) ---"
contest_phase_c1() {
    if [ "$now" -lt "$start" ]; then echo "before"; fi
}
assert_equal "now < start (após implementação mínima)" "before" "$(contest_phase_c1)"

echo ""
echo "=== CICLO TDD 2: Prova em Andamento ('running') ==="
echo "--- 1. Executando teste para now == start (Fase RED) ---"
now=100; start=100; end=200
assert_equal "now == start (esperava running, c1 falha)" "running" "$(contest_phase_c1)"

echo "--- 2. Extensão da regra para running (Fase GREEN) ---"
contest_phase_c2() {
    if [ "$now" -lt "$start" ]; then echo "before"; else echo "running"; fi
}
assert_equal "now == start (após implementar running)" "running" "$(contest_phase_c2)"

echo ""
echo "=== CICLO TDD 3: Encerramento com e sem Prazo ('ended') ==="
echo "--- 1. Executando teste para now == end (Fase RED) ---"
now=200; start=100; end=200
assert_equal "now == end (esperava ended, c2 retorna running)" "ended" "$(contest_phase_c2)"

echo "--- 2. Implementação completa e refatoração (Fase GREEN / REFACTOR) ---"
contest_phase_final() {
    if [ "$now" -lt "$start" ]; then
        echo "before"
    elif [ "$end" -gt 0 ] && [ "$now" -ge "$end" ]; then
        echo "ended"
    else
        echo "running"
    fi
}
assert_equal "now == end (implementação final)" "ended" "$(contest_phase_final)"
now=250; end=0
assert_equal "Sem prazo de fim (end == 0)" "running" "$(contest_phase_final)"

echo ""
echo ">>> Ciclos TDD concluídos com sucesso para M16!"
