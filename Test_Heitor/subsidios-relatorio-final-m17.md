# Subsídios para o Relatório Final - M17: `can_see_problems`

**Autor:** Heitor  
**Grupo:** Grupo 11 - Testes de Software  

---

### Resumo Executivo
O método `can_see_problems` foi submetido a testes baseados em Tabela de Decisão e Cobertura Lógica. O objetivo foi certificar que as regras de confidencialidade dos problemas são estritamente respeitadas antes do início da maratona e que os papéis com privilégios administrativos (juízes) mantêm visão irrestrita, enquanto contas operacionais (staff/animeitor) e competidores comuns obedecem às permissões estabelecidas.

### Aplicação do Ciclo TDD (Red -> Green -> Refactor)
O método foi construído em ciclos incrementais de TDD:
1. **Ciclo 1 (Privilégio do Juiz):** Teste para acesso do juiz em "before" falhou (RED); implementado retorno 0 para `is_judge=true` (GREEN);
2. **Ciclo 2 (Bloqueio de Staff/Apoio):** Teste para staff em "running" falhou (RED); implementado bloqueio condicional para staff, cstaff e animeitor (GREEN);
3. **Ciclo 3 (Restrição a Competidores):** Teste bloqueando usuário comum em "before" e liberando em "running"/"ended" falhou (RED); implementada validação de fase (GREEN).
Lógica refatorada em expressões booleanas limpas (REFACTOR).

### Resultados Obtidos
Foram 7 cenários avaliados com 100% de taxa de sucesso (`PASSED`). O método bloqueia adequadamente o acesso indevido em fase preliminar e garante a liberação transparente no momento de início do contest.
