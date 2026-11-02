#!/usr/bin/env python3
"""oraculo-porteiro.py — executa o ESPELHO em Python do M15 (server/porteiro/moj-porteiro.py) sobre as mesmas
entradas dos casos XFAIL (e dos casos do ciclo TDD) do script bash. É o oráculo de paridade bash × porteiro citado no relatório (testes-eduardo-m15.md). Offline: importa o
módulo (não sobe o servidor FastCGI) e usa um CONTESTSDIR temporário, apagado no fim.
Uso: python3 -I Test_Eduardo/oraculo-porteiro.py"""
import importlib.util, os, sys, tempfile

HERE = os.path.dirname(os.path.realpath(__file__))
L = "sede1-alfa"
CASOS = [  # (nome, CONTEST_END, time-overrides.json, função)
    ("M15 E13 end -1", "1700000000", '[{"regex":"^sede1-","end":-1},{"regex":"^sede1-","end":1700000100}]', "end_effective"),
    ("M15 X1 1.7000001e9", "1700000000", '[{"regex":"^sede1-","end":1.7000001e9}]', "end_effective"),
    ("M15 X2 float", "1700000000", '[{"regex":"^sede1-","end":1700000100.5},{"regex":"^sede1-","end":1700000200}]', "end_effective"),
    ("M15 X3 END=0100", "0100", '[{"regex":"^sede1-","end":99}]', "end_effective"),
    ("M15 X4 END=09", "09", '[{"regex":"^sede1-","end":1700000100}]', "end_effective"),
    ("M15 T1 END=000170…", "0001700000000", '[{"regex":"^sede1-","end":1699999999}]', "end_effective"),
    ("M15 T2 END=00", "00", '[]', "end_effective"),
]

with tempfile.TemporaryDirectory() as tmp:
    os.environ["CONTESTSDIR"] = tmp          # lido pelo porteiro na importação
    spec = importlib.util.spec_from_file_location("porteiro", os.path.join(HERE, "..", "server", "porteiro", "moj-porteiro.py"))
    p = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(p)
    print(f"# porteiro = espelho; Python {sys.version.split()[0]}")
    for i, (nome, end, tov, fn) in enumerate(CASOS):
        c = f"k{i}"
        os.makedirs(os.path.join(tmp, c))
        with open(os.path.join(tmp, c, "conf"), "w") as f:
            f.write(f"CONTEST_END={end}\nCONTEST_MODULES=sedes\n")
        with open(os.path.join(tmp, c, "time-overrides.json"), "w") as f:
            f.write(tov)
        try:
            print(f"{nome:22s} porteiro.{fn} = {getattr(p, fn)(c, L)!r}")
        except Exception as e:  # o porteiro faz o mesmo: except Exception -> declina -> o bash responde
            print(f"{nome:22s} porteiro levanta {type(e).__name__}: {e}  -> except Exception -> fallback p/ o bash")
