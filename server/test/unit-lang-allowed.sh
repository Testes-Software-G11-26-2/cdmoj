#!/usr/bin/env bash
# M21: lang_allowed real e jq real; colaboradores de canonizacao/plataforma stubados.
set -uo pipefail
export LC_ALL=C
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
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

scenario() (
  # Arrange: cada caso tem processo e arquivos de observacao proprios.
  local id="$1" verdict="$2" langs="$3" ext="$4" canonical="$5"
  local floor_json="$6" expected_floor_calls="$7" D="$T/$1" rc
  mkdir -p "$D"
  source "$LIB"
  # Espioes registram chamadas em arquivo porque $(...) executa em subshell.
  # Retornos explicitos por caso: nao se reimplementa a tabela de _lang_canon.
  _lang_canon() { printf '%s' "$1" > "$D/canon-arg"; printf '.\n' >> "$D/canon-calls"; printf '%s' "$canonical"; }
  platform_langs_json() { printf '.\n' >> "$D/floor-calls"; printf '%s' "$floor_json"; }
  if [[ -n "$trace_dir" ]]; then
    exec 3>"$trace_dir/$id.trace"
    BASH_XTRACEFD=3
    PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:-main}: '
    set -x
  fi
  # Act: uma chamada para a funcao-alvo, sem HTTP ou fixture de contest.
  lang_allowed "$langs" "$ext" > "$D/out" 2> "$D/err"
  rc=$?
  printf '%s' "$rc" > "$D/actual-rc"
  # Assert: permissao e negacao pelo status; stdout e stderr devem ser vazios.
  case "$verdict" in allow) [[ "$rc" -eq 0 ]] || return 1 ;; deny) [[ "$rc" -ne 0 ]] || return 1 ;; *) return 2 ;; esac
  [[ ! -s "$D/out" && ! -s "$D/err" ]] || return 1
  printf '%s' "$ext" > "$D/expected-arg"
  cmp -s "$D/expected-arg" "$D/canon-arg" || return 1
  local calls=0 line
  while IFS= read -r line; do calls=$((calls + 1)); done < "$D/canon-calls"
  [[ "$calls" -eq 1 ]] || return 1
  calls=0
  if [[ -f "$D/floor-calls" ]]; then
    while IFS= read -r line; do calls=$((calls + 1)); done < "$D/floor-calls"
  fi
  [[ "$calls" -eq "$expected_floor_calls" ]]
)
check_case() {
  local id="$1" technique="$2" rc
  shift 2
  if scenario "$id" "$@"; then
    printf 'PASS %s [%s]\n' "$id" "$technique"; passed=$((passed + 1))
  else
    rc=$?
    if [[ -f "$T/$id/actual-rc" ]]; then printf '  expected=%s actual_rc=%s\n' "$1" "$(<"$T/$id/actual-rc")"; fi
    printf 'FAIL %s [%s] scenario_rc=%s\n' "$id" "$technique" "$rc"
    [[ ! -s "$T/$id/err" ]] || cat "$T/$id/err"
    failed=$((failed + 1))
  fi
  selected=$((selected + 1))
}
regression_case() {
  [[ "$suite" == tdd ]] || check_case "$@"
}
# ID, tecnica, allow/deny, whitelist, extensao, retorno do canonizador, piso, n.chamadas-piso.

printf "M21 | lang_allowed | suite=%s\n" "$suite"
regression_case C01 'MCDC:piso-base' allow '["py"]' py py '["cpp"]' 0
regression_case C02 'MCDC:piso-vazio' deny '' py py '["cpp"]' 1
regression_case C03 'MCDC:piso-array-vazio' deny '[]' py py '["cpp"]' 1
regression_case C04 'MCDC:piso-null' deny null py py '["cpp"]' 1
regression_case C05 'PE:lista-explicita-nega' deny '["cpp"]' py py '["cpp"]' 0
regression_case C06 'PE:piso-autoriza' allow '[]' cpp cpp '["cpp","py"]' 1
regression_case C07 'PE:piso-nega-binario' deny '[]' exe exe '["cpp","py"]' 1
regression_case C08 'PE:exotica-explicita' allow '["brainfuck"]' brainfuck brainfuck '["cpp"]' 0
regression_case C09 'MCDC:cpp-base' deny '["zzz"]' cpp cpp '["cpp"]' 0
regression_case C10 'MCDC:cpp-c++' allow '["c++"]' cpp cpp '["cpp"]' 0
regression_case C11 'MCDC:cpp-cc' allow '["cc"]' cpp cpp '["cpp"]' 0
regression_case C12 'MCDC:cpp-cxx' allow '["cxx"]' cpp cpp '["cpp"]' 0
regression_case C13 'MCDC:cpp-hpp' allow '["hpp"]' cpp cpp '["cpp"]' 0
regression_case C14 'CB:alias-h' allow '["h"]' c c '["cpp"]' 0
regression_case C15 'MCDC:python-py3' allow '["py3"]' py py '["cpp"]' 0
regression_case C16 'MCDC:python-py2' allow '["py2"]' py py '["cpp"]' 0
regression_case C17 'MCDC:python-base' deny '["zzz"]' py py '["cpp"]' 0
regression_case C18 'PE:caixa-na-whitelist' allow '["JAVA"]' java java '["cpp"]' 0
regression_case C19 'contrato:extensao-canonizada' allow '["cpp"]' CC cpp '["cpp"]' 0
regression_case C20 'AVL:primeiro-elemento' allow '["py","cpp","java"]' py py '["cpp"]' 0
regression_case C21 'AVL:ultimo-elemento' allow '["java","cpp","py"]' py py '["cpp"]' 0
regression_case C22 'PE:nao-casar-substring' deny '["python"]' py py '["cpp"]' 0
regression_case C23 'PE:json-malformado' deny '[' py py '["cpp"]' 0
regression_case C24 'PE:tipo-invalido' deny '[null,"py"]' py py '["cpp"]' 0
regression_case C25 'PE:espaco-literal-preservado' allow '[" "]' ' ' ' ' '["cpp"]' 0
if [[ "$suite" != regressao ]]; then
  check_case TDD01 'TDD:array-vazio-semantico-usa-piso' allow '[ ]' py py '["py"]' 1
fi
printf 'RESULT: %s passed, %s failed, %s selected (suite=%s)\n' "$passed" "$failed" "$selected" "$suite"
(( selected > 0 && failed == 0 ))
