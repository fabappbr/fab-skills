# Corrigir Bug (`corrigir-bug`)

## Edição terminal

Esta é a edição para agentes que editam apps da Fabapp AI pelo terminal (Claude Code, Codex, OpenCode, Cursor, Gemini
CLI) com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; o que mudou:

- Reproduzir: no Studio a IA só seguia o caminho do código; pelo terminal o agente reproduz de verdade na
  pré-visualização do `fabapp dev` (com a ferramenta de navegador que tiver) e lê o console e a aba de rede. Sem
  navegador, continua valendo o caminho do código.
- Seção nova "Antes de começar: o código que você lê é o que está no ar?": último deploy, edições feitas no Studio
  (`fabapp dev --reset`), `fabapp pull`.
- Fronteira "Dados": o CLI não lê registros (sem `read_records`); a evidência vem da pré-visualização como owner ou admin
  ou do dono olhando o CMS do Studio.
- `[Preview errors]` virou o console do navegador; `check_build` virou `npx tsc -b` e `npx vite build` locais, `fabapp
  push` e `fabapp deploy` com `✓ Live:`; o sintoma original é conferido no app no ar.
- Correção de dados (`propose_data_fill`) virou orientação ao dono para corrigir no CMS do Studio.
- "Publicar de novo no Studio" virou `fabapp deploy`; a referência de armadilhas ganhou a seção "Funciona na
  pré-visualização e não no ar" (build falho, tema sem deploy, dependência, arquivos ignorados, binário, imagens do
  Studio sobrescritas, template, manifesto de funções).
- A memória do app (`update_knowledge`) virou `DECISOES.md`; a regra dos três pergunta ao dono com a ferramenta de
  perguntas de opção.
- Acrescentados: primeiro movimento, contrato ao vivo e a regra das duas mãos. `references/fabapp-cli.md` é copiado
  pelo script de montagem.

Faz a IA da Fabapp consertar defeito relatado pelo dono achando a causa antes de mexer no código: quatro fases, uma hipótese por vez, evidência em cada fronteira do app (tela, chamada ao SDK, regra de acesso, dados), armadilhas da plataforma, regra dos três e explicação ao dono em português simples.

- **Categoria:** other
- **Etapas:** edit
- **Tamanho:** corpo ~2.964 tokens (edit), referências ~3.421 tokens (validador em 26/09/2026).

**Por que só `edit`:** conserto de defeito acontece num app que já existe. A etapa `plan` da skill é a do planejador de app NOVO, que nunca conserta nada. O planejador da edição (o chat que aprova a mudança) não recebe o corpo das skills: ele lê só a `description` para escolher a skill; por isso a descrição traz as frases de defeito que o dono usa. O corpo inteiro chega à construção da edição, que tem as ferramentas de investigação (`read_file`, `read_records`, `check_build`, `lookup_docs`, `update_knowledge`) e o bloco `[Preview errors]`.

## Origem

| Skill de referência | Repositório | Licença |
|---|---|---|
| `systematic-debugging` (SKILL.md, root-cause-tracing.md, defense-in-depth.md, condition-based-waiting.md e o exemplo .ts, find-polluter.sh, test-pressure-1/2/3.md, test-academic.md, CREATION-LOG.md) | https://github.com/obra/superpowers (commit 5bf4e78) | MIT, Copyright (c) 2025 Jesse Vincent |
| `test-driven-development` (SKILL.md, writing-good-tests.md) | https://github.com/obra/superpowers (commit 5bf4e78) | MIT, Copyright (c) 2025 Jesse Vincent |

Análise usada: `fabapp-skills-referencia/analise/02-codigo-e-processo.md` §3 (systematic-debugging e test-driven-development) e §2 (regra das 2-3 tentativas da Supabase, "lista vazia sem erro"), §5 (combinar a forma com a falha).

A licença MIT exige manter o aviso de copyright e a permissão em cópias substanciais: esta é uma obra derivada reescrita em português, e o aviso fica neste README.

## Mapa de cobertura

| Função/técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| Iron Law "no fixes without root cause investigation first" | "A lei de ferro" | |
| "Symptom fixes are failure"; letra x espírito | Lei de ferro | "Reescrever a tela" é o conserto de sintoma típico do gerador |
| When to use / ESPECIALLY when / Don't skip when | Lei de ferro (último parágrafo) e descrição | |
| Fase 1.1 ler erros inteiros | Fase 1 item 1 | Toast, `[Preview errors]`, `ApiError` e códigos |
| Fase 1.2 reproduzir | Fase 1 item 2 | Reproduzir pelo caminho do código (rota → página → handler → SDK → schema → access) |
| Fase 1.3 mudanças recentes | Fase 1 item 3 | A última edição do dono é a primeira suspeita |
| Fase 1.4 instrumentação por fronteira de componente | Fase 1 item 4 (tabela de 4 fronteiras) + "faça o erro aparecer" | Fronteiras tela, SDK, regra de acesso, dados; o registro na fronteira é o erro visível |
| Fase 1.5 rastrear o fluxo de dados | Fase 1 item 5 + `references/rastrear-e-blindar.md` §1 | |
| Fase 2 (exemplo que funciona, ler referência inteira, listar diferenças, dependências) | "Fase 2" | Outra tela do app; `lookup_docs`; plano do dono e integrações |
| Fase 3 (hipótese única escrita, mudança mínima, conferir, "quando não sabe") | "Fase 3" | "Não sei" vira mensagem honesta ao dono |
| Fase 4.1 criar caso de teste que falha | Fase 4 item 1 | Sem suíte de testes: checagem concreta que falha hoje e passa depois (teste de regressão adaptado) |
| Fase 4.2 um conserto, sem "while I'm here" | Fase 4 item 2 | |
| Fase 4.3 verificar | Fase 4 item 4 | `check_build` depois da última alteração + sintoma original pelo caminho do código |
| Fase 4.4 e 4.5: menos de 3 volta; 3 ou mais questiona a arquitetura | "A regra dos três" | Explicar ao dono com 2 ou 3 saídas; registrar tentativas com `update_knowledge` |
| Red Flags | "Sinais de que você está chutando" (seus pensamentos) | |
| "Your human partner's signals" | "Sinais..." (frases do dono) | Frases reais de dono leigo |
| Tabela de racionalizações | "Racionalizações e a realidade" | Mais linhas da plataforma: abrir permissão, atraso fixo, conserto sugerido pelo dono |
| Quick Reference das fases | Estrutura das 4 fases | |
| "When process reveals no root cause" (e os 95%) | "Quando a causa está fora do app" + última linha das racionalizações | Causas externas reais: gateway, integração, plano, limite de e-mail, CORS |
| root-cause-tracing: rastreio de 5 passos, instrumentação com stack antes da operação, contexto | `rastrear-e-blindar.md` §1 | Exemplo de pedido sem cliente no lugar do `git init` |
| root-cause-tracing: find-polluter.sh (bissecção) | `rastrear-e-blindar.md` §1, "divida ao meio" | Bissecção pelas mudanças da última edição |
| root-cause-tracing: "never fix just the symptom" + defesa depois | §1 regra final | |
| defense-in-depth: 4 camadas (entrada, negócio, ambiente, registro) | `rastrear-e-blindar.md` §2 + Fase 4 item 3 | Camada "ambiente" vira "servidor" (schema, access, função de backend) |
| defense-in-depth: aplicar (fluxo, pontos, validar, testar contorno) | §2 "Aplicando" | Exemplo: importação pula o formulário |
| condition-based-waiting: padrão, tabela, erros comuns, quando o tempo é certo | `rastrear-e-blindar.md` §3 | `await`, `useLive`, `isLoading`; debounce de 300 ms documentado |
| condition-based-waiting-example.ts (`waitForEvent` etc.) | §3 tabela | O app não tem testes; a espera por condição é a do SDK |
| test-pressure-1/2/3 (urgência, custo afundado e cansaço, autoridade) | Racionalizações: "o dono tem pressa", "mais uma tentativa", "o dono sugeriu o conserto" | Pressões reais do dono |
| test-academic, CREATION-LOG | Não entram no corpo | São material de teste e histórico da própria skill, não instrução |
| TDD Iron Law e Red-Green-Refactor | Fase 4 itens 1 e 4 | "Falha antes, passa depois" vira critério concreto; não há ciclo de testes no app |
| TDD "Verify RED/GREEN" obrigatório | Fase 4 itens 1 e 4 | |
| TDD "Debugging integration: bug found, write failing test" | Fase 4 item 1 | |
| writing-good-tests: "name the break" (que mudança faz o teste falhar) | Fase 4 item 1, última frase | |
| writing-good-tests: expectativa derivada à mão, sem mock, mutation check | Fase 4 item 1 (checagem concreta, reverter o conserto a faria falhar) | Sem suíte, o resto (mocks, utilitários de teste) não se aplica |
| TDD "Delete means delete" | Não entra | Código gerado é exceção listada pela própria TDD; aqui vale "desfaça a mudança da hipótese que falhou" (Fase 3 item 3) |
| (Fabapp) armadilhas da plataforma | `references/armadilhas-da-plataforma.md` | Lista vazia (acesso/filtro), 401/402/403/404/409/422/429, 403 depois de signup com verificação, tela, automação, pagamento, publicação |
| (Fabapp) explicar ao dono | "No resumo ao dono (`finish`)" | O que acontecia, por quê, o que mudei, como conferir, o que depende de você |

Ficou de fora: comandos de terminal (`npm test`, `git diff`, `security find-identity`), exemplos de CI e assinatura de código (não existem no app), e a exigência de rodar suíte de testes (o app gerado não tem suíte; a plataforma confere critérios e build depois).
