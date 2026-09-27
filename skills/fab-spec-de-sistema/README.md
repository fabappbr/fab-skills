# Spec de Sistema

## Edição terminal

Esta é a edição para agentes que constroem e editam apps da Fabapp AI pelo terminal (Claude Code, Codex, OpenCode,
Cursor, Gemini CLI) com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio (PRD, spec por tela,
convenção de nomes, arquivo de domínio, foco de revisão, modelos); o que mudou:

- As etapas viraram "O plano" (texto que o dono aprova antes de codar), "A construção" e "Mudanças depois".
- Os critérios de aceite (até 8, a skill escolhia 2 ou 3) viraram a lista de conferência do plano, sem teto: entram
  todos os que valem, marcados "no código" ou "na tela".
- `assumptions` do plano viraram suposições escritas no plano; as que bloqueiam viram pergunta ao dono com a ferramenta
  de perguntas de opção.
- O schema vai no `fab.schema.json` com `fabapp push` antes do código; a construção em paralelo pode usar subagentes.
- Paradas: apagar dados é do dono no CMS do Studio (o CLI não grava registros); publicar sem o dono pedir vira
  `fabapp deploy --no-publish`.
- A memória do app (`update_knowledge`) virou `DECISOES.md`; `check_build` virou `npx tsc -b`, `npx vite build`,
  pré-visualização e deploy; o resumo final virou a mensagem final ao dono.
- As skills `fab-ux-de-sistemas`, `fab-verificar-antes-de-entregar` e `fab-redesign-e-polimento` são citadas como recomendação, com a
  regra essencial escrita aqui.
- Acrescentados: primeiro movimento, contrato ao vivo e a regra das duas mãos. `references/fabapp-cli.md` é copiado
  pelo script de montagem.

Faz apps de várias telas (CRM, gestão, OS, estoque, financeiro, área logada) saírem completos e coerentes: PRD enxuto
e spec por tela no plano, nomes definidos uma vez no esqueleto da construção, nenhum marcador vazio, foco de revisão
em cinco situações e registro de decisões ("decidi X; se estiver errado custa Y") que vai para `update_knowledge`.

- **Categoria:** other
- **Etapas:** plan, build, edit
- **Tokens (validador):** corpo ~5.420 (plano ~2.900, construção ~2.540, edição ~1.090 nas partes marcadas; cada
  etapa recebe o corpo inteiro); referências ~5.160
- **Arquivos:** `SKILL.md`, `references/modelos.md`

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| code-to-prd (SKILL.md, references, assets, expected_outputs, scripts lidos para entender a função) | https://github.com/alirezarezvani/claude-skills, `product-team/code-to-prd/skills/code-to-prd`, commit 19392f7 | MIT, Copyright (c) 2025 Alireza Rezvani. A própria skill credita o conceito original a @lihanglogan (https://github.com/lihanglogan/code-to-prd) |
| write-spec | https://github.com/anthropics/knowledge-work-plugins, `product-management/skills/write-spec`, commit da38ec1 | Apache 2.0 |
| writing-plans (superpowers) | https://github.com/obra/superpowers, commit 5bf4e78 | MIT, Copyright (c) 2025 Jesse Vincent |
| executing-plans (superpowers) | idem | MIT, Copyright (c) 2025 Jesse Vincent |

A parte derivada de write-spec é obra derivada sob Apache 2.0: reescrita em português e alterada para a plataforma
Fabapp (as mudanças estão no mapa abaixo). As partes MIT mantêm os avisos de copyright acima. Texto próprio, sem
parágrafos copiados. Análises usadas: `analise/02-codigo-e-processo.md` §3 e `02-crm-sistemas/ANALISE.md`.

## Mapa de cobertura

| Função/técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| code-to-prd: público duplo (negócio e quem reconstrói) | Abertura e regra 1 | O plano é lido pelo dono e pela construção |
| code-to-prd: fase 1, varredura global (estrutura, inventário de rotas, contexto global, enums, modelos, middleware) | "Na edição", passo 1; inventário de telas no plano | Rotas, domínio, schema, papéis, automações |
| code-to-prd: inventário de páginas (rota, título, menu, arquivo) | "No plano: spec por tela", inventário; modelos §2 | Coluna "quem acessa" |
| code-to-prd: A visão geral da página, B layout e regiões | Frase de abertura e regiões de cada tela | Igual |
| code-to-prd: C inventário de campos (forma, lista: filtros, colunas, ações) | Lista e Formulário; modelos §3 e §4 | Tipos de campo da plataforma |
| code-to-prd: prioridade de extração do nome do campo | "Na edição", documentar: nome visível vem do texto da tela | Igual |
| code-to-prd: D interação "ação → resposta" e os 10 tipos de interação | "Interações" | Igual, com SDK |
| code-to-prd: transições de status | Máquina de status; modelos §8 | Automação sem condição: histórico `<modelo>_event` ou função |
| code-to-prd: E dependências de API, integrada versus mock, deduzir a API necessária do mock | "Lado servidor"; "Na edição", passo 4 (dado fixo é dívida) | Sem API própria: modelos, funções e automações; mock vira consulta ao modelo |
| code-to-prd: F relações entre páginas | "Relações entre telas"; modelos §9 | Igual |
| code-to-prd: fase 3, estrutura de saída (README, páginas, apêndices de enum, relações, APIs) | Seções do plano; dicionário; glossário; modelos §1 a §11 | No markdown do plano, não em pastas |
| code-to-prd: README do PRD (visão geral, módulos, inventário, modelo de permissão, padrões comuns) | PRD enxuto: Módulos, Regras gerais do app, Papéis | Igual |
| code-to-prd: princípios (linguagem de negócio, lógica escondida, enums exaustivos, marcar incerteza, página autocontida) | "Em todas as etapas: regras da spec" 1 a 6 | `[TBC]` vira suposição no plano, decisão na construção ou "a confirmar com você" na documentação |
| code-to-prd: estratégias por tipo de página (lista, forma, detalhe, modal, painel) | Lista, Formulário, Detalhe, Painel, Dialog e Sheet | Mais a regra modal/painel lateral/página |
| code-to-prd: estratégias de backend (CRUD, auth, upload, webhook, job) | "Lado servidor"; upload no Formulário | Funções e automações da plataforma |
| code-to-prd: ritmo (mais de 15 páginas em lotes por módulo) | PRD enxuto, "Mais de 15 telas" | Primeira versão com o módulo central |
| code-to-prd: armadilhas comuns | modelos §13, tabela de armadilhas | Adaptadas (Dialog, dependência, permissão, parâmetro, erro, dado fixo) |
| code-to-prd: checklist de qualidade (completude, precisão, leitura, estrutura, backend) | modelos §13 e conferência antes de emitir o plano | Estrutura de pastas trocada pelas seções do plano |
| code-to-prd: expected_outputs (lista de usuários, dicionário de enum, README) | modelos §3, §7, §1 | Exemplo único: OS de oficina |
| code-to-prd: scripts `codebase_analyzer.py` e `prd_scaffolder.py` | Leitura de arquivos na edição; modelos como esqueleto | O gerador não executa script; a função (varrer e montar esqueleto) virou instrução e modelo |
| code-to-prd: engenharia reversa de um sistema em PRD | "Quando o dono pede para entender ou documentar o app" | Resposta no `summary`, sem mudar código |
| write-spec: entender o pedido e reunir contexto (problema, usuários, métricas, restrições, o que já existe) | PRD enxuto: Problema com "como é feito hoje" | A leitura detalhada do pedido é da skill `fab-leitura-do-pedido` (sugestão) |
| write-spec: puxar contexto de ferramentas conectadas | Fora | Não há rastreador nem base de conhecimento externos; a memória do app chega sozinha |
| write-spec: seções do PRD (problema, objetivos, não objetivos, histórias, requisitos, métricas, perguntas, prazo) | "No plano: PRD enxuto" | Encaixadas nas seções do `emit_plan` |
| write-spec: objetivos como resultado, não entrega | Objetivos | Igual |
| write-spec: não objetivos com motivo | "O que NÃO vamos construir" | Igual |
| write-spec: histórias, INVEST e erros comuns | Histórias por papel | Igual |
| write-spec: P0/P1/P2, MoSCoW, "se tudo é P0", P2 como seguro de arquitetura | Prioridade | P2 = o modelo de dados não pode impedir |
| write-spec: métricas líderes e atrasadas, metas específicas, limite e meta esticada, momento de medir | Métricas | Só o que o app conta (`count`, soma na tela) |
| write-spec: perguntas em aberto, bloqueantes ou não | `assumptions` com `impact` | Igual |
| write-spec: prazos e fases | "Prazo e fases" | Igual |
| write-spec: critérios Given/When/Then ou checklist, feliz, erro, borda, negativos, sem palavras vagas | "No plano: critérios de aceite" | `acceptance_criteria` com `kind` |
| write-spec: gestão de escopo (reconhecer e prevenir), estacionamento de ideias | "Escopo durante o refinamento" | Próximos passos = estacionamento |
| write-spec: limitar investigação no tempo | Fora | Não há investigação longa no fluxo; o plano decide |
| write-spec: formato escaneável; revisar e iterar; ofertas de continuação | Seções do plano; `next_steps` | Igual em função |
| writing-plans: engenheiro sem contexto; cabeçalho Goal/Architecture/Stack/Spec | Plano como autoridade; construção em paralelo | Pilha fixa, sem cabeçalho técnico |
| writing-plans: Global Constraints | "Regras gerais do app" | Igual |
| writing-plans: Review Focus (cinco entradas que os testes não cobrem) | "Na construção: foco de revisão" e critérios 1 a 5 | Os cinco da análise: lista vazia, sem login, campo nulo, texto longo, celular |
| writing-plans: checagem de escopo | "Mais de 15 telas" | Igual |
| writing-plans: estrutura de arquivos antes das tarefas | "Mapa de arquivos antes de escrever" | Igual |
| writing-plans: Interfaces Consumes/Produces com assinaturas exatas | Tabela de convenção de nomes e arquivo de domínio no esqueleto | Convenção determinística, porque as páginas são geradas em paralelo sem ver umas às outras |
| writing-plans: No Placeholders | "Sem marcador vazio" | Lista traduzida para React e para a plataforma |
| writing-plans: autorrevisão (cobertura, placeholder, consistência de tipos, foco) | Conferência antes do `finish` | Mais `check_build` |
| writing-plans: tamanho de tarefa, passos de 2 a 5 minutos, TDD, commits | Fora | Sem testes nem git no gerador; a conferência é feita pelos critérios e pelo QA da plataforma |
| writing-plans: handoff de execução (subagentes ou nativo) e revisor do plano | Fora / conferência do plano | A plataforma decide como executa; o revisor virou a conferência calibrada |
| executing-plans: execução contínua, sem pedir para continuar | "Seguir sem parar" | Igual |
| executing-plans: rulings "decidi, por quê, custo se errado" | Registro de decisões | Duráveis em `update_knowledge` (`decisions`); miúdas no `summary` |
| executing-plans: as quatro paradas | "Só quatro coisas param" | Traduzidas: apagar dados, segurança, efeito fora do app, plano quebrado |
| executing-plans: ledger que sobrevive à compactação | `update_knowledge` e `summary` | Igual em função |
| executing-plans: ler o brief de cada tarefa | Tabela de desculpas, "Lembro o que a spec diz" | Igual |
| executing-plans: varredura prévia de conflitos entre interfaces | "Percorra a spec de cada tela e garanta que toda função está exportada" | No esqueleto |
| executing-plans: contrato de conclusão com evidência | Conferência e `finish` | `check_build` e rastreio dos critérios |
| executing-plans: revisão final, regradação pelo efeito, minors adiados | Foco de revisão ("a gravidade é o que a pessoa sofre"); `next_steps` | A revisão final é do QA da plataforma |
| executing-plans: tabela de racionalizações | Tabela "Desculpa / Realidade" | 6 linhas adaptadas |
| executing-plans: TDD, worktree, scripts `task-start`/`task-done`, pacote de revisão | Fora | Sem git nem execução de comando; o QA da plataforma cumpre o papel |
| ANALISE camada 1 a 4: regras de dados, exclusão com filhos, tela dos 80%, filtros que persistem, colunas, formulário em etapas, estados vazios | Exclusão com filhos; Tela inicial de quem opera; Lista; Formulário; foco de revisão | Dinheiro em `money`; exclusão já é lógica na plataforma; índice não existe (filtro sempre no servidor) |

## O que ficou de fora e por quê

- Scripts, pastas `prd/`, git, TDD e subagentes: o gerador não executa nada e escreve só o app; a função foi levada
  para o plano, o esqueleto da construção e o QA automático.
- Índices de banco e `tenant_id`: a plataforma não tem índice nem restrição; multiempresa usa `organization` e
  `membership` canônicos, fora do escopo desta skill.
