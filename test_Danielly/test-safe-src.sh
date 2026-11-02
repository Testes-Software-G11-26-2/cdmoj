#!/bin/bash

source server/api/v1/lib/common.sh

#teste caixa preta
resultado=$(safe_src_filename "teste .py") #erro com espaço
res=$(safe_src_filename "codigo!.c") 
res3=$(safe_src_filename "java?.py")
res4=$(safe_src_filename "nome(1).java")
res5=$(safe_src_filename "qualquertexto!py")

echo "Teste 1 (Com espaço): $resultado"
echo "Teste 2 (Carater especial !): $res"
echo "Teste 3 (Carater especial ?): $res3"
echo "Teste 4 (repetição de download): $res4"
echo "teste 5 (entrar no else): $res5"

resultado=$(safe_src_filename "teste .py")
if [ "$resultado" == "teste.py" ]; then
  echo "ok: C01 (espaço) -> obtido: $resultado"
else
  echo "falha: C01 -> obtido: $resultado"
fi