# Subsídios para o Relatório Final - M17: `can_see_problems`

**Autor:** Heitor  
**Grupo:** Grupo 11 - Testes de Software  

---

### Resumo Executivo
O método `can_see_problems` foi submetido a testes baseados em Tabela de Decisão e Cobertura Lógica. O objetivo foi certificar que as regras de confidencialidade dos problemas são estritamente respeitadas antes do início da maratona e que os papéis com privilégios administrativos (juízes) mantêm visão irrestrita, enquanto contas operacionais (staff/animeitor) e competidores comuns obedecem às permissões estabelecidas.

### Resultados Obtidos
Foram 7 cenários avaliados com 100% de taxa de sucesso (`PASSED`). O método bloqueia adequadamente o acesso indevido em fase preliminar e garante a liberação transparente no momento de início do contest.
