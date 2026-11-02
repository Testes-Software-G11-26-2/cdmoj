#!/usr/bin/env bash
# M20: funcao real, jq real, filesystem temporario e dublê do carregador de conf.
set -uo pipefail
export LC_ALL=C
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LIB="$ROOT/server/api/v1/lib/langs.sh"
suite=todos trace_dir=''
while (( $# )); do
  case "$1" in
    --suite) [[ $# -ge 2 ]] || exit 2; suite="$2"; shift 2 ;;
    --trace) if [[ $# -ge 2 && "$2" != --* ]]; then trace_dir="$2"; shift 2; else trace_dir="$ROOT/Test_Guilherme/evidencias/traces"; shift; fi ;;
    *) printf 'Uso: bash %s [--suite todos|regressao|tdd] [--trace DIR]\n' "$0" >&2; exit 2 ;;
  esac
done
case "$suite" in todos|regressao|tdd) ;; *) exit 2 ;; esac
command -v jq >/dev/null || { printf 'ERRO de ambiente: jq necessario; nenhum teste executado.\n' >&2; exit 2; }
if [[ -n "$trace_dir" ]]; then
  mkdir -p -- "$trace_dir" || exit 2
  trace_dir="$(cd -- "$trace_dir" && pwd)"
fi
T="$(mktemp -d)" || exit 2
trap 'rm -rf -- "$T"' EXIT
passed=0 failed=0 selected=0

put_fixture() { [[ "$2" == @missing ]] || printf '%s' "$2" > "$1"; }
assert_output() {
  local expected="$1" rc="$2"
  printf '%s' "$expected" > "$D/expected"
  [[ "$rc" -eq 0 ]] && cmp -s "$D/expected" "$D/out" && [[ ! -s "$D/err" ]]
}

scenario() (
  # Arrange: processo isolado por caso; sem configuracao real da maquina.
  local id="$1" expected="$2" override="$3" conf="$4" public="$5" private="$6" mode="$7" rc
  local D="$T/$id"
  mkdir -p "$D/contests/c" "$D/contests/c2" "$D/contests/treino/var/jsons" "$D/contests/treino/var/jsons-private"
  local CONTESTSDIR="$D/contests"
  put_fixture "$CONTESTSDIR/c/problem-langs.json" "$override"
  put_fixture "$CONTESTSDIR/treino/var/jsons/org#p.json" "$public"
  put_fixture "$CONTESTSDIR/treino/var/jsons-private/org#p.json" "$private"
  source "$LIB"
  # Dublê somente da fronteira de configuracao. O jq e a funcao-alvo sao reais.
  load_contest_conf() {
    printf '%s\n' "$1" >> "$D/loads"
    M20_MARKER=changed
    if [[ "$conf" == @fail ]]; then return 1; fi
    LANGUAGES="$conf"
  }
  LANGUAGES=outer-value
  M20_MARKER=outer-marker
  if [[ -n "$trace_dir" ]]; then
    exec 3>"$trace_dir/$id.trace"
    BASH_XTRACEFD=3
    PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:-main}: '
    set -x
  fi
  # Act: redirecionamento, nao $(funcao), para preservar o cache no processo.
  effective_problem_langs c 'org#p' > "$D/out" 2> "$D/err"
  rc=$?
  # Assert: bytes JSON compactos, status e ausencia de vazamento do conf.
  assert_output "$expected" "$rc" || return 1
  [[ "$LANGUAGES" == outer-value && "$M20_MARKER" == outer-marker ]] || return 1
  case "$mode" in
    once) ;;
    cache-same)
      printf '%s' '{"org#p":["rs"]}' > "$CONTESTSDIR/c/problem-langs.json"
      conf=java
      effective_problem_langs c 'org#p' > "$D/out" 2> "$D/err"; rc=$?
      assert_output "$expected" "$rc" || return 1 ;;
    cache-pid)
      effective_problem_langs c 'org#q' > "$D/out" 2> "$D/err"; rc=$?
      assert_output '["c"]' "$rc" || return 1 ;;
    cache-contest)
      printf '%s' '{"org#p":["py"]}' > "$CONTESTSDIR/c2/problem-langs.json"
      effective_problem_langs c2 'org#p' > "$D/out" 2> "$D/err"; rc=$?
      assert_output '["py"]' "$rc" || return 1 ;;
    *) return 2 ;;
  esac
  local loads=0 line
  while IFS= read -r line; do loads=$((loads + 1)); done < "$D/loads"
  if [[ "$mode" == cache-contest ]]; then [[ "$loads" -eq 2 ]]; else [[ "$loads" -eq 1 ]]; fi
)

check_case() {
  local id="$1" technique="$2" rc
  shift 2
  if scenario "$id" "$@"; then
    printf 'PASS %s [%s]\n' "$id" "$technique"; passed=$((passed + 1))
  else
    rc=$?
    printf 'FAIL %s [%s] scenario_rc=%s\n' "$id" "$technique" "$rc"
    [[ ! -f "$T/$id/out" ]] || { printf '  actual='; cat "$T/$id/out"; printf '\n'; }
    [[ ! -s "$T/$id/err" ]] || cat "$T/$id/err"
    failed=$((failed + 1))
  fi
  selected=$((selected + 1))
}
regression_case() {
  [[ "$suite" == tdd ]] || check_case "$@"
}
# ID, tecnica, esperado, override, LANGUAGES, pacote publico, privado, modo.

printf "M20 | effective_problem_langs | suite=%s\n" "$suite"
regression_case C01 'PE:problema-vence' '["cpp"]' '{"org#p":["cpp"]}' py '{"languages":["java"]}' '{"languages":["c"]}' once
regression_case C02 'PE:contest-vence' '["py"]' '{}' py '{"languages":["java"]}' @missing once
regression_case C03 'PE:pacote-publico' '["java"]' '{}' '' '{"languages":["java"]}' @missing once
regression_case C04 'PE:pacote-privado' '["c"]' '{}' '' @missing '{"languages":["c"]}' once
regression_case C05 'PE:fallback' '[]' '{}' '' @missing @missing once
regression_case C06 'PE:override-vazio-soberano' '[]' '{"org#p":[]}' py '{"languages":["java"]}' @missing once
regression_case C07 'PE:override-null' '["py"]' '{"org#p":null}' py @missing @missing once
regression_case C08 'PE:pid-ausente' '["py"]' '{"outro":["cpp"]}' py @missing @missing once
regression_case C09 'PE:override-malformado' '["py"]' '{' py @missing @missing once
regression_case C10 'AVL:arquivo-zero-bytes' '["py"]' '' py @missing @missing once
regression_case C11 'CB:conf-so-espacos' '["java"]' '{}' '   ' '{"languages":["java"]}' @missing once
regression_case C12 'PE:conf-multiplas' '["py","cpp"]' '{}' 'py cpp' @missing @missing once
regression_case C13 'PE:publico-vazio-vence-privado' '[]' '{}' '' '{"languages":[]}' '{"languages":["cpp"]}' once
regression_case C14 'PE:pacote-null' '[]' '{}' '' '{"languages":null}' @missing once
regression_case C15 'caracterizacao:publico-invalido-nao-tenta-privado' '[]' '{}' '' '{' '{"languages":["cpp"]}' once
regression_case C16 'PE:privado-malformado' '[]' '{}' '' @missing '{' once
regression_case C17 'PE:aliases-preservados' '["C++","PY3"]' '{"org#p":["C++","PY3"]}' '' @missing @missing once
regression_case C18 'PE:seleciona-chave-exata' '["py"]' '{"org#px":["c"],"org#p":["py"]}' '' @missing @missing once
regression_case C19 'PE:falha-do-carregador' '["java"]' '{}' @fail '{"languages":["java"]}' @missing once
regression_case C20 'PE:ordem-e-duplicatas' '["py","cpp","py"]' '{}' '' '{"languages":["py","cpp","py"]}' @missing once
regression_case C21 'CB:cache-mesmo-contest' '["cpp"]' '{"org#p":["cpp"]}' '' @missing @missing cache-same
regression_case C22 'CB:cache-outro-pid' '["cpp"]' '{"org#p":["cpp"],"org#q":["c"]}' '' @missing @missing cache-pid
regression_case C23 'CB:cache-outro-contest' '["cpp"]' '{"org#p":["cpp"]}' '' @missing @missing cache-contest
if [[ "$suite" != regressao ]]; then
  check_case TDD01 'TDD:override-ausente-silencioso' '["py"]' @missing py @missing @missing once
fi
printf 'RESULT: %s passed, %s failed, %s selected (suite=%s)\n' "$passed" "$failed" "$selected" "$suite"
(( selected > 0 && failed == 0 ))
