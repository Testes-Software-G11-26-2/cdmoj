# Subsídios para o Relatório Final - M16: `contest_phase`

**Autor:** Heitor  
**Grupo:** Grupo 11 - Testes de Software  

---

### Resumo Executivo
O método `contest_phase` do módulo de controle temporal do servidor CD-MOJ foi validado contra requisitos de fronteira e equivalência temporal. Foram projetados 5 casos de teste cobrindo todas as partições válidas de estados (`before`, `running`, `ended`) e situações especiais (provas sem limite de tempo, `end=0`).

### Tabela de Cobertura e Resultados

```
+------------+-------------------------------+-------------------+-----------------+----------+
| Caso Teste | Condição Analisada            | Parâmetros (n/s/e)| Saída Esperada  | Situação |
+------------+-------------------------------+-------------------+-----------------+----------+
| CT01_M16   | Limite inferior (pré-início)  | now=99, s=100, e=200 | before          | SUCESSO  |
| CT02_M16   | Limite exato de ativação      | now=100, s=100, e=200| running         | SUCESSO  |
| CT03_M16   | Limite superior em prova      | now=199, s=100, e=200| running         | SUCESSO  |
| CT04_M16   | Limite exato de término       | now=200, s=100, e=200| ended           | SUCESSO  |
| CT05_M16   | Prova sem prazo (end=0)       | now=250, s=100, e=0  | running         | SUCESSO  |
+------------+-------------------------------+-------------------+-----------------+----------+
```

### Análise de Conformidade
Todos os 5 casos de teste executaram com 100% de sucesso, demonstrando que o algoritmo de julgamento temporal atende aos requisitos sem ocorrência de bugs nas transições de estados de contagem de tempo.
