# Subsídios para o Relatório Final - M18: `can_submit`

**Autor:** Heitor  
**Grupo:** Grupo 11 - Testes de Software  

---

### Resumo Executivo
O método `can_submit` foi validado cobrindo cenários com privilégios administrativos (juiz), restrições funcionais (staff) e o ciclo de vida completo de submissão do competidor comum (`before`, `running`, `ended`).

### Aplicação do Ciclo TDD (Red -> Green -> Refactor)
O método seguiu a metodologia TDD em três ciclos:
1. **Ciclo 1 (Submissão Administrativa):** Teste permitindo submissão de juiz em contest encerrado falhou (RED); implementada liberação direta para juiz (GREEN);
2. **Ciclo 2 (Restrição de Operadores):** Teste garantindo bloqueio de staff/animeitor falhou (RED); implementado retorno de erro para equipe técnica (GREEN);
3. **Ciclo 3 (Janela Exclusiva de Submissão):** Teste restringindo competidor comum a submeter exclusivamente durante `phase="running"` falhou (RED); implementada verificação de fase (GREEN).
Código final limpo e verificado (REFACTOR).

### Resultados
Foram executados 5 casos de teste com 100% de aprovação (`PASSED`), assegurando que a barreira de submissão do juiz online bloqueia submissões prematuras ou intempestivas sem prejudicar a flexibilidade necessária para os administradores do sistema.
