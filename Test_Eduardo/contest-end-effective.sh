#!/bin/bash
# contest-end-effective.sh — M15 `contest_end_effective` (server/api/v1/lib/contest-gate.sh): fim EFETIVO do
# contest p/ um login = CONTEST_END do conf, PRORROGADO pela regra de time-overrides.json que casar (só estende,
# e só quando há fim no conf). Testes de unidade derivados por caixa-preta (partições + limites) e caixa-branca
# (D1, D2 + MC/DC de D2 = R ∧ (A ∧ B)). Integrado com o M14 real (`time_override_end`), sem stub.
# Todos os casos (E01..E13, X1..X4, T1..T5) entram no exit code.
# TDD (ciclo 1): X3 e X4 eram XFAIL e foram promovidos a casos obrigatórios; T1 e T2 nasceram no Red do ciclo.
# TDD (ciclo 2): X1 e X2 eram XFAIL e foram promovidos a casos obrigatórios; T3, T4 e T5 nasceram no Red do ciclo.
# Sem rede, sem config real: MOJ_CONF inexistente e CONTESTSDIR na fixture.
# Uso: ./Test_Eduardo/contest-end-effective.sh [--trace]  (--trace grava evidencias/traces/<ID>.trace)
set -u
HERE="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"; LIB="$HERE/../server/api/v1/lib"
TRACE=0; [[ "${1:-}" == --trace ]] && TRACE=1
TRDIR="$HERE/evidencias/traces"; (( TRACE )) && mkdir -p "$TRDIR"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
export MOJ_CONF="$T/nao-existe.conf" CONTESTSDIR="$T/contests"; mkdir -p "$CONTESTSDIR"
source "$LIB/common.sh"; source "$LIB/contest-gate.sh"
set +o noglob    # common.sh liga o noglob; o script não depende de glob, mas volta ao normal
type contest_end_effective >/dev/null 2>&1 || { echo "FAIL: contest_end_effective não carregou"; exit 1; }
command -v jq >/dev/null || { echo "FAIL: time_override_end precisa do jq"; exit 1; }
pass=0; fail=0; xfail=0; xpass=0

# mk <contest> <linha CONTEST_END|-> <CONTEST_MODULES|-> <conteúdo do time-overrides.json|-> — '-' = ausente
mk(){ local d="$CONTESTSDIR/$1"; mkdir -p "$d"
  { printf 'CONTEST_ID=%s\nCONTEST_START=1690000000\n' "$1"
    [[ "$2" == - ]] || printf '%s\n' "$2"
    [[ "$3" == - ]] || printf 'CONTEST_MODULES=%s\n' "$3"; } > "$d/conf"
  [[ "$4" == - ]] || printf '%s' "$4" > "$d/time-overrides.json"; }
# rule <end> -> time-overrides.json com UMA regra que casa o login L
rule(){ printf '[{"regex":"^sede1-","end":%s}]' "$1"; }

# run <ID> args... -> OUT, ERR, RC (subshell: o source do conf não vaza entre casos)
run(){ local cid="$1"; shift
  ( if (( TRACE )); then
      exec 9>"$TRDIR/$cid.trace"; BASH_XTRACEFD=9; PS4='+ ${FUNCNAME[0]:-main}:${LINENO}: '; set -x
    fi
    contest_end_effective "$@"
  ) >"$T/out" 2>"$T/err"
  RC=$?; OUT="$(<"$T/out")"; ERR="$(<"$T/err")"; }

obtido(){ printf 'rc%s "%s"%s' "$RC" "$OUT" "${ERR:+ stderr=\"$ERR\"}"; }

# caso <C|X> <ID> <esperado stdout> args... — passa se rc 0, stdout == esperado e stderr vazio
caso(){ local k="$1" cid="$2" exp="$3"; shift 3
  run "$cid" "$@"
  local ok=1; [[ "$RC" == 0 && "$OUT" == "$exp" && -z "$ERR" ]] || ok=0
  local got; got="$(obtido)"
  if [[ "$k" == C ]]; then
    if (( ok )); then echo "  ok: $cid — obtido: $got"; ((pass++))
    else echo "  FAIL: $cid — esperado: \"$exp\" — obtido: $got"; ((fail++)); fi
  else
    if (( ok )); then echo "  XPASS: $cid — obtido: $got"; ((xpass++))
    else echo "  XFAIL: $cid — esperado: \"$exp\" — obtido: $got"; ((xfail++)); fi
  fi; }

L=sede1-alfa                    # login que casa ^sede1-
END='CONTEST_END=1700000000'

# ---- fixture: um contest por caso ---------------------------------------------------------------------
mk e01 "$END" sedes -
mk e02 "$END" sedes "$(rule 1700000100)"
mk e03 "$END" sedes "$(rule 1700000000)"
mk e04 "$END" sedes "$(rule 1700000001)"
mk e05 "$END" sedes "$(rule 1699999999)"
mk e06 'CONTEST_END=0' sedes "$(rule 1700000100)"
mk e07 'CONTEST_END=1' sedes "$(rule 1700000100)"
mk e08 - sedes "$(rule 1700000100)"
mk e09 'CONTEST_END=abc' sedes "$(rule 1700000100)"
mk e12 "$END" coortes "$(rule 1700000100)"
mk e13 "$END" sedes '[{"regex":"^sede1-","end":-1},{"regex":"^sede1-","end":1700000100}]'
mk x01 "$END" sedes "$(rule 1.7000001e9)"
mk x02 "$END" sedes '[{"regex":"^sede1-","end":1700000100.5},{"regex":"^sede1-","end":1700000200}]'
mk x03 'CONTEST_END=0100' sedes "$(rule 99)"
mk x04 'CONTEST_END=09' sedes "$(rule 1700000100)"
mk t01 'CONTEST_END=0001700000000' sedes "$(rule 1699999999)"
mk t02 'CONTEST_END=00' sedes -
mk t03 "$END" sedes "$(rule 1e10)"
mk t04 "$END" sedes "$(rule 1.70000015e9)"
mk t05 "$END" sedes "$(rule 1700000000.9)"

echo "== caixa-preta: CONTEST_END do conf (F1) =="
caso C E01 1700000000 e01 "$L"
caso C E06 0          e06 "$L"
caso C E08 0          e08 "$L"
caso C E09 0          e09 "$L"
caso C E10 0          e10 "$L"      # contest sem diretório: conf ausente

echo "== caixa-preta: override (F2) e limites oend × END =="
caso C E02 1700000100 e02 "$L"
caso C E03 1700000000 e03 "$L"
caso C E04 1700000001 e04 "$L"
caso C E05 1700000000 e05 "$L"
caso C E07 1700000100 e07 "$L"

echo "== caixa-preta: login (F3) e módulo sedes =="
caso C E11 1700000000 e02
caso C E12 1700000000 e12 "$L"

echo "== 1ª regra que casa vence, mesmo com end negativo (bash = porteiro) =="
caso C E13 1700000000 e13 "$L"

echo "== TDD ciclo 1: CONTEST_END com zero à esquerda é DECIMAL (ex-XFAIL X3/X4 + T1/T2) =="
caso C X3 100        x03 "$L"     # nunca encurta: 0100 = 100, override 99 não vale
caso C X4 1700000100 x04 "$L"     # 09 = 9: sem erro de base, o override estende
caso C T1 1700000000 t01 "$L"     # epoch real com zeros à esquerda: override menor não encurta
caso C T2 0          t02 "$L"     # 00 = sem limite, devolvido como 0 (o porteiro devolve int 0)

echo "== TDD ciclo 2: override numérico não inteiro vale TRUNCADO, como o int() do porteiro (ex-XFAIL X1/X2 + T3..T5) =="
caso C X1 1700000100 x01 "$L"     # 1.7000001e9: o jq ecoa 1.7000001E+9
caso C X2 1700000100 x02 "$L"     # 1700000100.5 (1ª regra vence) → 1700000100
caso C T3 10000000000 t03 "$L"    # 1e10: expoente sem parte fracionária (o jq ecoa 1E+10)
caso C T4 1700000150 t04 "$L"     # 1.70000015e9: sobra fração depois do expoente → trunca
caso C T5 1700000000 t05 "$L"     # 1700000000.9: trunca (não arredonda) → não passa do fim, não estende

(( xpass )) && echo "  ($xpass hipótese(s) XPASS: o defeito não se manifestou)"
echo; echo "RESULT: $pass passed, $fail failed, $xfail xfail"
(( fail == 0 ))
