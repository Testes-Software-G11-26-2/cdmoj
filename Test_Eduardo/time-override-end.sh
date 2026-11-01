#!/bin/bash
# time-override-end.sh — M14 `time_override_end` (server/api/v1/lib/contest-gate.sh): o `end` da 1ª regra de
# contests/<c>/time-overrides.json cujo regex casa com o login (só com o módulo `sedes` ligado). Testes de unidade
# derivados por caixa-preta (partições + limites) e caixa-branca (D1–D7 + MC/DC).
# C01..C29 entram no exit code; X1, X2 são hipóteses de defeito (XFAIL: o esperado é falharem hoje).
# Sem rede, sem config real: MOJ_CONF inexistente e CONTESTSDIR na fixture.
# Uso: ./Test_Eduardo/time-override-end.sh [--trace]  (--trace grava evidencias/traces/<ID>.trace)
set -u
HERE="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"; LIB="$HERE/../server/api/v1/lib"
TRACE=0; [[ "${1:-}" == --trace ]] && TRACE=1
TRDIR="$HERE/evidencias/traces"; (( TRACE )) && mkdir -p "$TRDIR"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
export MOJ_CONF="$T/nao-existe.conf" CONTESTSDIR="$T/contests"; mkdir -p "$CONTESTSDIR"
source "$LIB/common.sh"; source "$LIB/contest-gate.sh"
set +o noglob    # common.sh liga o noglob; o script não depende de glob, mas volta ao normal
type time_override_end >/dev/null 2>&1 || { echo "FAIL: time_override_end não carregou"; exit 1; }
declare -F mod_on >/dev/null && { echo "ABORT: mod_on já carregado — D2 (source do modules.sh) não seria exercitada"; exit 1; }
command -v jq >/dev/null || { echo "FAIL: time_override_end precisa do jq"; exit 1; }
pass=0; fail=0; xfail=0; xpass=0

# mk <contest> <CONTEST_MODULES|-> <conteúdo do time-overrides.json|-> — '-' = linha/arquivo ausente
mk(){ local d="$CONTESTSDIR/$1"; mkdir -p "$d"
  { printf 'CONTEST_ID=%s\nCONTEST_END=1700000000\n' "$1"; [[ "$2" == - ]] || printf 'CONTEST_MODULES=%s\n' "$2"; } > "$d/conf"
  [[ "$3" == - ]] || printf '%s' "$3" > "$d/time-overrides.json"; }

# run <ID> <preload 0|1> args... -> OUT, ERR, RC. Subshell: cada caso começa sem mod_on (D2 = F),
# a menos que preload=1 (modules.sh já carregado, D2 = V).
run(){ local cid="$1" pre="$2"; shift 2
  ( (( pre )) && source "$LIB/modules.sh"
    if (( TRACE )); then
      exec 9>"$TRDIR/$cid.trace"; BASH_XTRACEFD=9; PS4='+ ${FUNCNAME[0]:-main}:${LINENO}: '; set -x
    fi
    time_override_end "$@"
  ) >"$T/out" 2>"$T/err"
  RC=$?; OUT="$(<"$T/out")"; ERR="$(<"$T/err")"; }

obtido(){ printf 'rc%s "%s"%s' "$RC" "$OUT" "${ERR:+ stderr=\"$ERR\"}"; }

# caso <C|X> <ID> <esperado stdout> <preload> args... — passa se stdout == esperado e stderr vazio
caso(){ local k="$1" cid="$2" exp="$3" pre="$4"; shift 4
  run "$cid" "$pre" "$@"
  local ok=1; [[ "$OUT" == "$exp" && -z "$ERR" ]] || ok=0
  local got; got="$(obtido)"
  if [[ "$k" == C ]]; then
    if (( ok )); then echo "  ok: $cid — obtido: $got"; ((pass++))
    else echo "  FAIL: $cid — esperado: \"$exp\" — obtido: $got"; ((fail++)); fi
  else
    if (( ok )); then echo "  XPASS: $cid — obtido: $got"; ((xpass++))
    else echo "  XFAIL: $cid — esperado: \"$exp\" — obtido: $got"; ((xfail++)); fi
  fi; }

L=sede1-alfa                                     # login que casa ^sede1-
OK='{"regex":"^sede1-","end":1700000100}'       # regra válida que casa L

# ---- fixture: um contest por caso ---------------------------------------------------------------------
mk c01 sedes "[$OK]"
mk c02 sedes -
mk c03 sedes ''
mk c04 sedes '[{"regex":"^sede1-","end":1700000100'
mk c05 sedes '[]'
mk c09 coortes "[$OK]"
mk c10 - "[$OK]"
mk c11 sedesX "[$OK]"
mk c12 coortes,sedes "[$OK]"
mk c13 sedes '[{"regex":"^sede2-","end":1700000100}]'
mk c14 sedes '[{"regex":"","end":1700000900},{"regex":"^sede1-","end":1700000200}]'
mk c15 sedes '[{"end":1700000900},{"regex":"^sede1-","end":1700000200}]'
mk c16 sedes '[{"regex":"(","end":1700000900},{"regex":"^sede1-","end":1700000200}]'
mk c17 sedes '[{"regex":5,"end":1700000900},{"regex":"^sede1-","end":1700000200}]'
mk c18 sedes '[{"regex":"^sede1-","end":"1700000900"},{"regex":"^sede1-","end":1700000200}]'
mk c19 sedes '[{"regex":"^sede1-","end":true},{"regex":"^sede1-","end":1700000200}]'
mk c20 sedes '[{"regex":"^sede1-","end":null},{"regex":"^sede1-","end":1700000200}]'
mk c21 sedes '[{"regex":"^sede1-","end":0}]'
mk c22 sedes '[{"regex":"^sede1-","end":1}]'
mk c23 sedes '[{"regex":"^sede1-","end":100},{"regex":"alfa","end":200}]'
mk c24 sedes '[{"regex":"^sede2-","end":100},{"regex":"^sede3-","end":200},{"regex":"^sede1-","end":300}]'
mk c25 sedes '[{"regex":"^t1\\.","end":1700000100}]'
mk c28 sedes '[{"regex":"sede1","end":1700000100}]'
mk x01 sedes "{\"a\":$OK}"
mk x02 sedes "[\"x\",$OK]"

echo "== caixa-preta: arquivo (E1) =="
caso C C01 1700000100 0 c01 "$L"
caso C C02 ''         0 c02 "$L"
caso C C03 ''         0 c03 "$L"
caso C C04 ''         0 c04 "$L"
caso C C05 ''         0 c05 "$L"

echo "== caixa-preta: login (E2) =="
caso C C07 ''         0 c01 ''
caso C C08 ''         0 c01

echo "== caixa-preta: módulo sedes (E3) =="
caso C C09 ''         0 c09 "$L"
caso C C10 ''         0 c10 "$L"
caso C C11 ''         0 c11 "$L"
caso C C12 1700000100 0 c12 "$L"

echo "== caixa-preta: regex e end da 1ª regra inválidos, uma por vez (E4, E5) =="
caso C C13 ''         0 c13 "$L"
caso C C14 1700000200 0 c14 "$L"
caso C C15 1700000200 0 c15 "$L"
caso C C16 1700000200 0 c16 "$L"
caso C C17 1700000200 0 c17 "$L"
caso C C18 1700000200 0 c18 "$L"
caso C C19 1700000200 0 c19 "$L"
caso C C20 1700000200 0 c20 "$L"

echo "== limites: end 0 x 1, posição da regra (E5, E6) =="
caso C C21 0          0 c21 "$L"
caso C C22 1          0 c22 "$L"
caso C C23 100        0 c23 "$L"
caso C C24 300        0 c24 "$L"

echo "== limites do casamento: ^t1\\. e busca não ancorada =="
caso C C25 1700000100 0 c25 t1.a
caso C C26 ''         0 c25 t1a
caso C C27 ''         0 c25 xt1.a
caso C C28 1700000100 0 c28 xsede1y

echo "== caixa-branca: D2 com mod_on já carregado (preload) =="
caso C C29 1700000100 1 c01 "$L"

echo "== hipótese de defeito (XFAIL): formato [{regex,end}] — arquivo objeto não é lista =="
caso X X1 ''          0 x01 "$L"

echo "== hipótese de defeito (XFAIL): elemento que não é objeto não pode silenciar as outras regras =="
caso X X2 1700000100  0 x02 "$L"

(( xpass )) && echo "  ($xpass hipótese(s) XPASS: o defeito não se manifestou)"
echo; echo "RESULT: $pass passed, $fail failed, $xfail xfail"
(( fail == 0 ))
