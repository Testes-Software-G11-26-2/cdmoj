#!/usr/bin/env python3
"""oraculo-porteiro.py — executa o ESPELHO em Python do M14 (server/porteiro/moj-porteiro.py) sobre as mesmas
entradas dos casos XFAIL do script bash. É o oráculo de paridade bash × porteiro citado no README. Offline: importa o
módulo (não sobe o servidor FastCGI) e usa um CONTESTSDIR temporário, apagado no fim.
Uso: python3 -I Test_Eduardo/oraculo-porteiro.py"""
import importlib.util, os, sys, tempfile

HERE = os.path.dirname(os.path.realpath(__file__))
L = "sede1-alfa"
CASOS = [  # (nome, CONTEST_END, time-overrides.json, função)
    ("M14 X1 objeto", "1700000000", '{"a":{"regex":"^sede1-","end":1700000100}}', "override_end"),
    ("M14 X2 elem. string", "1700000000", '["x",{"regex":"^sede1-","end":1700000100}]', "override_end"),
    ("M14 C17 regex 5", "1700000000", '[{"regex":5,"end":1700000900},{"regex":"^sede1-","end":1700000200}]', "override_end"),
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
