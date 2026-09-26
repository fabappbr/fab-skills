# Dashboards e Relatórios

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem o app pelo CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou só o encanamento:
- As etapas do Studio viraram o fluxo do agente: primeiro movimento, a conversa (perguntas com opções), o plano mostrado ao dono antes de codar, a construção, conferir antes de dizer pronto e mudanças depois.
- Schema e automações são editados em `fab.schema.json` e `fab.automations.json` (`fabapp pull`, editar, `fabapp push`); o código sobe com `fabapp deploy`.
- A marca (cor, fonte, raio) é definida pelo agente em `apps/<slug>/fab.config.json → theme`, com aprovação do dono.
- Os critérios de aceite viraram a lista de conferência do plano, sem teto, conferida na pré-visualização e por busca no código.
- O teto de 8 critérios do Studio saiu: todos os candidatos da skill entram na lista de conferência.
- A memória do app vira `DECISOES.md` na raiz do projeto.
- O contrato da plataforma pelo terminal está em `references/fabapp-cli.md`.

A seção abaixo descreve a edição Studio (etapas e tamanhos são dela).

Faz a IA da Fabapp construir painéis e relatórios que servem para decidir: entrevista antes de desenhar, 3 a 5 KPIs
com comparação, gráfico escolhido pela pergunta, cálculo feito no código do app com proteção contra número enganoso,
resumo em português simples e relatório recorrente que chega com link.

- **Categoria:** dashboards
- **Etapas:** briefing, plan, build, edit
- **Tamanho (validador):** corpo ~5,3 mil tokens (briefing ~1,1 mil, plano ~1,9 mil, construção ~2,7 mil, edição
  ~0,8 mil); referências ~12,3 mil tokens em 5 arquivos. No briefing só cabem 8 mil de referência: as perguntas moram no
  corpo.

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| design-dashboards | https://github.com/dastoyan/skills (pasta design-dashboards, nota 0ba207d) | MIT, Copyright (c) 2026 Stoyan Stoitsev |
| dashboard-designer | https://github.com/NickCrew/claude-cortex (skills/dashboard-designer, bb47af7) | MIT |
| kpi-dashboard-design | https://github.com/wshobson/agents (plugins/business-analytics/skills/kpi-dashboard-design, 4236bb9) | MIT, Copyright (c) 2024 Seth Hobson |
| data-storytelling | https://github.com/wshobson/agents (plugins/business-analytics/skills/data-storytelling, 4236bb9) | MIT, Copyright (c) 2024 Seth Hobson |
| tufte-data-viz | https://github.com/caylent/tufte-data-viz (raiz, ae7ca0d) | MIT, Copyright (c) 2026 Caylent |
| tufte | https://github.com/aref-vc/tufte-claude-skill (raiz, a145acf) | MIT, Copyright (c) 2026 tufte-claude-skill contributors |
| strategy-consulting-visualization | https://github.com/kgraph57/mckinsey-style-visualization-skill | MIT |
| ecom | https://github.com/takechanman1228/claude-ecom (skills/ecom, 7ddf7ff) | MIT |
| validate-data | https://github.com/anthropics/knowledge-work-plugins (data/skills/validate-data, da38ec1) | Apache-2.0 |
| modeling-dimension-tables | https://github.com/PostHog/skills (skills/omnibus/modeling-dimension-tables, f89d437) | MIT, Copyright (c) 2025 |
| report-pack | https://github.com/anthropics/knowledge-work-plugins (pequenas empresas, da38ec1) | Apache-2.0 |
| sales-reporting | https://github.com/HubSpot/agent-cli-skills (71f2bde) | Apache-2.0 |

Todas as licenças MIT exigem manter o aviso de copyright e a permissão em cópias substanciais; este pacote é obra
derivada reescrita (nenhum parágrafo colado) e registra aqui os avisos. As Apache-2.0 pedem aviso de modificação:
o texto foi reescrito e adaptado à plataforma Fabapp em 26/09/2026. dastoyan cita inspiração em Stephen Few
(Information Dashboard Design); as duas skills de Tufte se baseiam nos livros de Edward Tufte. Nenhuma afiliação.

Análise usada: `fabapp-skills-referencia-2/01-dashboards-bi/ANALISE.md`.

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| dastoyan: painel como instrumento de decisão; começar pela decisão, público e cadência | SKILL.md intro e "No briefing" | vira entrevista com opções clicáveis |
| dastoyan: Dashboard Spec Grill em rodadas (público, decisão, cadência, limites, drill-down, o que não responder) | SKILL.md "No briefing" (2 rodadas, 6 perguntas) e "No plano" item 7 | limites e drill-down decididos pela IA e registrados; "o que NÃO vamos construir" no plano |
| dastoyan: modos crítica, conceito, redesenho, especificação | Crítica e redesenho em "Na edição" (manter, corrigir, trocar, tirar); conceito e especificação em "No plano" | uma direção só, sem dois conceitos concorrentes |
| dastoyan: severidade alta, média, baixa | "Na edição" (engana a decisão, atrasa a leitura, acabamento) | mesmas três classes em palavras |
| dastoyan: três papéis (estratégico, analítico, operacional), não misturar | SKILL.md "No plano" item 1 e briefing | "analítico" vira tático (dono de PME não explora dados) |
| dastoyan: KPI sem contexto é inacabado; exemplos fraco e forte | Regra 2 do SKILL.md, cartão de KPI | `delta` com referencial escrito |
| dastoyan: precisão só a necessária; unidade e período junto do número | "Formatos BR" e cabeçalho | |
| dastoyan: falhas comuns (gauges, pizzas, escalas truncadas, cor demais, destaque em tudo) | `tufte-na-tela.md` lista do que tirar | |
| dastoyan: heurísticas de gráfico (texto, tabela, barras, horizontais, zero, linha, sparkline, small multiples, bullet, dispersão, evitar empilhado não-base, radial, 3D) | `escolha-de-grafico.md` | com o componente real de cada caso |
| dastoyan: percepção (atributos pré-atentivos, posição e comprimento primeiro) | `tufte-na-tela.md` princípios 5, 9; `escolha-de-grafico.md` | |
| dastoyan: layout e hierarquia; Gestalt (proximidade, semelhança, cercamento, fechamento, continuidade, conexão, figura e fundo) | SKILL.md hierarquia fixa; `tufte-na-tela.md` camadas | Gestalt condensado em regras de agrupamento e bordas |
| dastoyan: cor por escassez, painel quieto quando tudo está bem, não só vermelho e verde | SKILL.md cartão de KPI (`tone`), `tufte-na-tela.md` cor | cor da marca por tokens; o `tone` do StatCard substitui a paleta própria |
| dastoyan: interação (drill-down, filtros discretos, sem instrução fixa) | SKILL.md cartão clicável, seletor de período | |
| dastoyan: painel operacional (estado, frescor, severidade, dono, próxima ação; estados normal, alerta, crítico, desatualizado, sem dados, resolvido; linha estável durante atualização) | SKILL.md "Painel operacional" | `useLive`; silenciar e escalar alertas ficam fora (sem ação além de `notify`) |
| NickCrew: tabela de regras (herói no canto, 15 a 20% de espaço, 4 a 5 cores, 6 a 8 gráficos, títulos como achado, carimbo de atualização, celular com 3 KPIs, contraste 4,5:1) | SKILL.md "No plano" e "Na construção" | limite de 6 gráficos no resumo; celular em 2 colunas (regra da plataforma) |
| NickCrew: arquétipos e quantidade de KPIs | SKILL.md "No plano" tabela de níveis | analista ilimitado fica fora (público é o dono) |
| NickCrew: KPI acionável, no tempo, comparável, inequívoco; processo 20 métricas para 3 a 5 temas | SKILL.md "No plano" item 2 | |
| NickCrew: níveis 1, 2, 3 (manchete, contexto, detalhe) | SKILL.md hierarquia | |
| NickCrew: layout F, Z e grade | SKILL.md hierarquia fixa | fechado num layout só (F) |
| NickCrew: código de cores com hex próprios | fora | a plataforma proíbe hex; tokens do tema |
| NickCrew: escolha de ferramenta de BI (Tableau, Power BI, Looker...) | fora | o painel é construído dentro do app |
| NickCrew: checklist final; teste dos 5 segundos; carimbo "atualizado" | SKILL.md "Antes do finish" | |
| NickCrew: erros comuns (vaidade, filtros de data inconsistentes, auto-atualizar tela de estudo) | `kpis-por-negocio.md` vaidade; SKILL.md seletor único; operacional estável | |
| wshobson kpi: estratégico, tático, operacional | SKILL.md "No plano" item 1 | |
| wshobson kpi: SMART, hierarquia resumo, departamentos, drill-down | SKILL.md item 1 e 2 | |
| wshobson kpi: KPIs por departamento (vendas, marketing, produto, finanças) | `kpis-por-negocio.md` | reescritos por nicho de PME brasileira |
| wshobson kpi: governança de fórmula (MRR não bate) | `kpis-por-negocio.md` MRR; `armadilhas-de-metrica.md` definição | tooltip "Como calculamos" |
| wshobson kpi: verde no painel e cliente reclamando | `kpis-por-negocio.md` | |
| wshobson kpi: coorte por mês e não por dia | `kpis-por-negocio.md` assinatura | |
| wshobson kpi: tabela de snapshot pré-agregada | `armadilhas-de-metrica.md` modelo de resumo diário | sem cron: o próprio painel grava os dias fechados, ou função sob demanda |
| wshobson kpi: limiar dinâmico (2 desvios da média móvel) | `kpis-por-negocio.md` alertas | |
| wshobson kpi: SQL e Streamlit | fora | a plataforma não tem SQL; cálculo em TypeScript no app |
| wshobson storytelling: setup, conflito, resolução; arco; três pilares; "e daí" primeiro; não despejar | `relatorio-recorrente.md` estrutura da história | |
| wshobson storytelling: frameworks problema-solução, tendência, comparação | `relatorio-recorrente.md` | |
| wshobson storytelling: revelação progressiva, contraste, anotação | `relatorio-recorrente.md` recursos visuais | revelação vira drill-down no app |
| wshobson storytelling: resumo mensal de uma página | `relatorio-recorrente.md` estrutura da página | |
| wshobson storytelling: manchetes com fórmula, frases de transição, incerteza em faixa | `tufte-na-tela.md` voz; `relatorio-recorrente.md` | frases de transição de slide ficam fora (não é apresentação) |
| wshobson storytelling: templates de slide | fora | o produto é tela e página de relatório, não deck |
| caylent: 22 regras universais | `tufte-na-tela.md` e `escolha-de-grafico.md` | fonte serifada e fundo off-white ficam fora (fonte e cor vêm da marca) |
| caylent: cinza primeiro, destaque seletivo; paletas categórica, sequencial, divergente | `tufte-na-tela.md` cor | por tokens |
| caylent: títulos afirmam; formatar número para humanos; não desenhar o que uma frase diz | SKILL.md regra 3 e gráficos; formatos BR | "R$ 12,4 mil" |
| caylent: acessível (contraste, dupla codificação, texto alternativo, teclado) | `tufte-na-tela.md` acessibilidade | |
| caylent: responsivo não é encolher; toque 44 px; 320 px | `escolha-de-grafico.md` celular | 360 px |
| caylent: animação só para explicar; modo escuro; tooltips mínimos | `tufte-na-tela.md` | modo escuro pelos tokens |
| caylent: small multiples, sparklines, slopegraph, marcas de tapete | `escolha-de-grafico.md` receitas | marcas de tapete (dispersão) ficam fora: dispersão quase não se usa em PME |
| caylent: configurações por biblioteca (ECharts, Chart.js, matplotlib, Plotly, D3) | fora; Recharts adaptado em `escolha-de-grafico.md` | a plataforma usa Chart do fab-client e recharts |
| aref-vc: 10 princípios; seleção em 2 passos; checagens; ordenação | `tufte-na-tela.md`, `escolha-de-grafico.md` | |
| aref-vc: kill list e keep list | `tufte-na-tela.md` | |
| aref-vc: voz do relatório (sem travessão, sem hype) | `tufte-na-tela.md` voz | |
| aref-vc: checklist de 20 itens | `tufte-na-tela.md` checklist | |
| aref-vc: pedido explícito de pizza atendido com nota | SKILL.md "Na edição" | |
| aref-vc: presets HTML/SVG e React (dot plot, slopegraph D3) | `escolha-de-grafico.md` RankBars e tabela | dot plot vira barra fina; D3 fora (sem necessidade) |
| kgraph57: passo 0 de Zelazny (cinco comparações) | `escolha-de-grafico.md` | |
| kgraph57: manchete com uma proposição só; orçamento de palavras | `tufte-na-tela.md` voz | |
| kgraph57: catálogo padrão para pergunta (cascata, gap, antes e depois, funil, scorecard, small multiples, distribuição) | `escolha-de-grafico.md` catálogo | |
| kgraph57: cascata com positivos e negativos distintos e rótulo com sinal | `escolha-de-grafico.md` Waterfall | |
| kgraph57: rubrica de qualidade, portões de bloqueio, revisão por lentes, quebradores de viés | `armadilhas-de-metrica.md` conferência e classificação final | notas de 0 a 24 ficam fora (a ecom e a dastoyan proíbem nota); os portões viram a conferência |
| kgraph57: perfis de documento, sistema de estilo de slide, scripts de render, estudo de consultorias, reprodução de referência | fora | slide e documento impresso de consultoria não são o produto; cor e fonte vêm da marca |
| takechanman ecom: Python calcula, o modelo interpreta | Regra 1 do SKILL.md; resumo automático | código do app calcula; `invokeLLM` só redige, com conferência dos números |
| ecom: árvore de KPI, decomposição volume, ticket e mistura | `kpis-por-negocio.md` árvore | |
| ecom: ~30 checagens com passa, atenção, falha e limites | `kpis-por-negocio.md` faixas de saúde | 13 checagens que o app calcula com os próprios dados; margem por categoria, ciclo de vida de SKU, pares de venda cruzada e frete grátis ficam fora (exigem custo e catálogo que o app típico não tem) |
| ecom: sem nota numérica | `kpis-por-negocio.md` | |
| ecom: janelas 30, 90, 365; mês de calendário; parcial | `kpis-por-negocio.md`, `relatorio-recorrente.md`, `armadilhas-de-metrica.md` | |
| ecom: formato do achado e verbos proibidos; 80/20; limite de achados | `kpis-por-negocio.md` achado | |
| ecom: plano de ação de até 5 por horizonte, guardrails | `relatorio-recorrente.md`, `kpis-por-negocio.md` | |
| ecom: modelos de narrativa por trajetória; anti-padrões do resumo | `relatorio-recorrente.md` resumo por modelo | |
| ecom: clusters de achados | `kpis-por-negocio.md` temas que aparecem juntos | |
| ecom: benchmarks por setor | `kpis-por-negocio.md` referências por setor | só recompra; AOV e margem em dólar ficam fora (não se aplicam ao Brasil) |
| ecom: fórmulas de impacto | `relatorio-recorrente.md` impacto estimado | |
| ecom: segmentos RFM | `kpis-por-negocio.md` | |
| ecom: pergunta pontual | `relatorio-recorrente.md` | |
| ecom: dados incompletos (omitir, sem N/A) | `relatorio-recorrente.md` | |
| ecom: ações recomendadas por checagem (fidelidade, e-mail pós-compra...) | fora | são conselhos de marketing, não construção do painel; o relatório diz a direção com os dados do app |
| validate-data: metodologia, checklist de QA, armadilhas (join, sobrevivência, período incompleto, denominador, média de médias, fuso, seleção, Simpson, amostra, outlier) | `armadilhas-de-metrica.md` | cada uma vira proteção no código |
| validate-data: checagens de magnitude, validação cruzada, sinais vermelhos | `armadilhas-de-metrica.md` conferência | `read_records` para conferir registros |
| validate-data: avaliação de confiança em 3 níveis | `armadilhas-de-metrica.md` (pronto, com ressalvas, revisar) | no `finish` |
| validate-data: documentação da análise | `armadilhas-de-metrica.md` definição documentada | tooltip + `metrics.ts` |
| validate-data: versionamento de análise em git | fora | o app é versionado pela plataforma |
| PostHog: fatos e dimensões; uma linha por entidade; chave única | SKILL.md "No plano" item 5 | `ref` no fato, `enum` para dimensão fixa, `count` antes de criar |
| PostHog: dimensão de data como calendário | `armadilhas-de-metrica.md` calendário | código com feriados nacionais do Brasil |
| PostHog: registrar a definição para não surgir cópia rival | `armadilhas-de-metrica.md` definição | |
| PostHog: HogQL, dbt, convertCurrency, materialização | fora | não existem na plataforma; moeda única do app |
| report-pack: definido uma vez, entregue na cadência, sem reentrevista | `relatorio-recorrente.md` | `report_setting` + automação `schedule` (diário) ou `relative` sobre `report_delivery` (semanal, mensal) |
| report-pack: pacote + pulso numa leitura só | `relatorio-recorrente.md` | |
| report-pack: oferecer cadência uma vez, depois de um relatório útil | `relatorio-recorrente.md` | cartão único na página |
| report-pack: nunca pular entrega por dado faltando; nomear a lacuna | `relatorio-recorrente.md` | |
| report-pack: planilha XLSX, CSV sem conector, conectores e Zapier | fora | os dados já moram no app; importação de planilha é outra peça; Zapier não existe; impressão em PDF no lugar do XLSX |
| sales-reporting: briefing diário, funil por etapa e por dono, ganhos e perdidos, taxa de ganho, receita por mês | `kpis-por-negocio.md` CRM; `relatorio-recorrente.md` briefing do vendedor | paginação e agregação no código em vez de jq |
| sales-reporting: 100 por chamada e paginar antes de somar | SKILL.md cálculo | 200 por página na Fabapp |

## O que foi trocado e por quê

- **Agregação no servidor e SQL**: a plataforma só faz `count`; somas vêm de `list` paginado com `fields`, de função de
  backend (Pro+) ou do modelo de resumo diário.
- **Tarefa agendada que calcula**: não existe; a automação só avisa. O relatório calcula ao abrir e o aviso leva o
  link. Semanal e mensal usam `relative` sobre registros de entrega pré-criados, porque `schedule` só tem diário e
  por hora.
- **Cores e fontes das originais** (hex, serifas de Tufte, fundo off-white): proibidas pela plataforma; tudo por tokens
  da marca e `tone` do StatCard.
- **Gráficos**: barras horizontais, bullet e cascata não existem prontos; a skill traz receitas com o kit e o recharts.
