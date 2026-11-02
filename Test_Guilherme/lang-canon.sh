#!/usr/bin/env bash
# M19: unidade real, sem handlers HTTP, banco, servidor ou copia da funcao.
# Requer Bash >= 4.3 (declare -gA na biblioteca), tr, mktemp e cmp.
set -uo pipefail
export LC_ALL=C
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LIB="$ROOT/server/api/v1/lib/langs.sh"
suite=todos
trace_dir=''
while (( $# )); do
  case "$1" in
    --suite) [[ $# -ge 2 ]] || exit 2; suite="$2"; shift 2 ;;
    --trace) if [[ $# -ge 2 && "$2" != --* ]]; then trace_dir="$2"; shift 2; else trace_dir="$ROOT/Test_Guilherme/evidencias/traces"; shift; fi ;;
    *) printf 'Uso: bash %s [--suite todos|regressao|tdd] [--trace DIR]\n' "$0" >&2; exit 2 ;;
  esac
done
case "$suite" in todos|regressao|tdd) ;; *) printf 'Suite invalida: %s\n' "$suite" >&2; exit 2 ;; esac
if [[ -n "$trace_dir" ]]; then
  mkdir -p -- "$trace_dir" || exit 2
  trace_dir="$(cd -- "$trace_dir" && pwd)"
fi
T="$(mktemp -d)" || exit 2
trap 'rm -rf -- "$T"' EXIT
passed=0 failed=0 selected=0

check_case() {
  local id="$1" technique="$2" expected="$3" expected_rc="$4" rc
  shift 4
  # Arrange: valores esperados explicitos; cada caso recebe um processo novo.
  printf '%s' "$expected" > "$T/expected"
  # Act: carrega a biblioteca de producao e chama SOMENTE _lang_canon.
  # --noprofile/--norc evita configuracoes pessoais; -u detecta argumentos ausentes.
  # xtrace usa outro descritor: nao contamina stdout/stderr observados.
  "$BASH" --noprofile --norc -u -c '
    source "$1"
    trace_file="$2"
    shift 2
    if [[ -n "$trace_file" ]]; then
      exec 3>"$trace_file"
      BASH_XTRACEFD=3
      PS4="+\${BASH_SOURCE[0]:-bash-c}:\${LINENO}:\${FUNCNAME[0]:-main}: "
      set -x
    fi
    _lang_canon "$@"
  ' m19 "$LIB" "${trace_dir:+$trace_dir/$id.trace}" "$@" > "$T/out" 2> "$T/err"
  rc=$?
  # Assert: bytes EXATOS (inclusive ausencia de newline), status e stderr.
  # Nao usa $(funcao), pois isso esconderia newlines finais indevidos.
  if [[ "$rc" -eq "$expected_rc" ]] && cmp -s "$T/expected" "$T/out" && [[ ! -s "$T/err" ]]; then
    printf 'PASS %s [%s]\n' "$id" "$technique"
    passed=$((passed + 1))
  else
    printf 'FAIL %s [%s] expected_rc=%s actual_rc=%s\n' "$id" "$technique" "$expected_rc" "$rc"
    printf '  expected=%q actual=%q\n' "$expected" "$(<"$T/out")"
    [[ ! -s "$T/err" ]] || { printf '  stderr: '; cat "$T/err"; }
    failed=$((failed + 1))
  fi
  selected=$((selected + 1))
}

regression_case() {
  [[ "$suite" == tdd ]] || check_case "$@"
}

# Caixa-preta: classes do contrato; esperados nao calculados pela implementacao.

printf "M19 | _lang_canon | suite=%s\n" "$suite"
regression_case C01 'PE:alias-cc' cpp 0 cc
regression_case C02 'PE:alias-h' c 0 H
regression_case C03 'PE:alias-py3' py 0 PY3
regression_case C04 'PE:outro-token' java 0 JAVA
regression_case C05 'PE:token-desconhecido' rust1 0 RUST1
regression_case C06 'AVL:zero-caracteres' '' 0 ''
regression_case C07 'PE:canonico-cpp' cpp 0 CPP
regression_case C08 'PE:espacos-preservados' ' c++ ' 0 ' C++ '
regression_case C09 'PE:ponto-preservado' .py 0 .PY
regression_case C10 'fronteira-lexical:alias-incompleto' c+ 0 C+
regression_case C11 'PE:nao-casar-substring' xcc 0 XCC
regression_case C12 'AVL:um-caractere' a 0 A
regression_case C13 'PE:formato-literal' '%s\n' 0 '%s\n'
regression_case C14 'CB:alternativa-c++' cpp 0 c++
regression_case C15 'CB:alternativa-cxx' cpp 0 cxx
regression_case C16 'CB:alternativa-hpp' cpp 0 hpp
regression_case C17 'CB:alternativa-py2' py 0 py2
regression_case C18 'PE:caixa-mista' cpp 0 cXx
regression_case C19 'PE:canonico-python' py 0 PY
if [[ "$suite" != regressao ]]; then
  check_case TDD01 'TDD:argumento-ausente-retorna-2' '' 2
fi
printf 'RESULT: %s passed, %s failed, %s selected (suite=%s)\n' "$passed" "$failed" "$selected" "$suite"
(( selected > 0 && failed == 0 ))
