# CRM de Vendas (`fab-crm-de-vendas`)

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem o app pelo CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou só o encanamento:
- As etapas do Studio viraram o fluxo do agente: primeiro movimento, a conversa (perguntas com opções), o plano mostrado ao dono antes de codar, a construção, conferir antes de dizer pronto e mudanças depois.
- Schema e automações são editados em `fab.schema.json` e `fab.automations.json` (`fabapp pull`, editar, `fabapp push`); o código sobe com `fabapp deploy`.
- A marca (cor, fonte, raio) é definida pelo agente em `apps/<slug>/fab.config.json → theme`, com aprovação do dono.
- Os critérios de aceite viraram a lista de conferência do plano, sem teto, conferida na pré-visualização e por busca no código.
- O CLI não grava registros: etapas padrão, origens e motivos de perda vêm do botão "Criar etapas padrão" no app, e os dados de exemplo de um botão "Carregar exemplos" no app ou do CMS do Studio.
- A memória do app vira `DECISOES.md` na raiz do projeto.
- O contrato da plataforma pelo terminal está em `references/fabapp-cli.md`.

A seção abaixo descreve a edição Studio (etapas e tamanhos são dela).

Faz a IA da Fabapp construir, para o dono de uma pequena empresa brasileira, um CRM de vendas que executa dentro do app o que as skills de origem faziam como agente no terminal: resumo do dia, lista de ligações, resposta rápida a lead, registro de conversas pela IA com aprovação, lacunas e plano de fechamento, roteamento, higiene, carteira, segmentos, importação por upsert e relatórios.

- **Categoria:** other
- **Etapas:** briefing, plan, build, edit
- **Tamanho (validador):** corpo ~4.000 tokens (por etapa: briefing ~1.690, plano ~2.040, construção ~1.800, edição ~1.390); referências ~18.600 tokens em 5 arquivos (`fab-modelo-de-dados.md`, `pipeline-e-etapas.md`, `telas-e-rotinas.md`, `relatorios.md`, `automacoes-e-ia.md`).
- **Não duplica:** `fab-agencia` (sites). Complementa outras skills da equipe que o dono pode ligar junto, sem depender delas: cobrança e nota ficam para uma skill de financeiro, chamados para uma de atendimento, retenção aprofundada para uma de retenção.

## Origem e licenças

| Fonte | Repositório | Licença | Aviso |
|---|---|---|---|
| HubSpot Agent CLI Skills (15 skills: bulk-operations, audience-targeting, communication-history, crm-data-quality, crm-lookup, custom-object-management, customer-retention, data-enrichment, deal-management, quote-to-cash, sales-execution, sales-reporting, team-ownership, ticket-resolution, workflow-automation, com `resources/`) | https://github.com/HubSpot/agent-cli-skills (commit 71f2bde) | Apache License 2.0 | Obra derivada; texto reescrito em português e adaptado à plataforma Fabapp. Sem arquivo NOTICE na origem. |
| Anthropic knowledge-work-plugins, plugin `sales` (daily-briefing, close-plan, deal-advance-gap, route-lead, crm-hygiene-check) | https://github.com/anthropics/knowledge-work-plugins (commit da38ec1) | Apache License 2.0 | Obra derivada; reescrita e adaptada. |
| Anthropic knowledge-work-plugins, plugin `small-business` (crm-autopilot com `reference/` inteira, speed-to-lead, call-list, lead-finder, com `reference/`) | https://github.com/anthropics/knowledge-work-plugins (commit da38ec1) | Apache License 2.0 | Obra derivada; reescrita e adaptada. |
| LeadMagic gtm-skills (pipeline-management, crm-toolkit, crm-integration, com `references/` e `templates/`) | https://github.com/LeadMagic/gtm-skills (commit 547f9b0) | MIT | Copyright (c) 2026 LeadMagic LLC. A permissão MIT exige manter este aviso em cópias ou partes substanciais. |
| Análise interna | `analise/03-crm-e-negocio.md` (inteira, com o exemplo "CRM de vendas para PME" da seção 4.4) | interna | Estrutura de domain skill: quando usar, entidades, campos, dois eixos de estado, telas, KPIs, automações, regras BR, papéis, seed, não fazer. |

As licenças Apache 2.0 e MIT permitem modificar e redistribuir. Nenhum parágrafo foi colado; frases curtas mantidas são regras com número.

## Mapa de cobertura

### HubSpot (hubspot/agent-cli-skills)

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| bulk-operations: dry-run antes de toda operação destrutiva | SKILL regra 5; telas "Padrão de operação em massa" | Prévia na tela com contagem e amostra antes/depois |
| Digest acima de 100 linhas, confirmação com a contagem, expira em 5 min | telas "Padrão de operação em massa" | Acima de 100, digitar o número; a expiração vira "a prévia vale para a tela aberta" (sem estado de servidor) |
| `hubspot history` como log de auditoria, não desfazer | modelo `audit_log`; tela Histórico | Mesmo princípio: histórico, sem desfazer |
| Paginar tudo antes de agir; nunca "contar" com uma página | relatorios "Como somar"; telas Duplicados e lote | Laço `limit`/`offset` do SDK |
| Leitura em lote, nunca um por um | telas (listas com filtro no servidor, `updateMany`, `bulkCreate` em blocos de 200) | SDK em vez de CLI |
| Upsert vence buscar e criar; chave natural em minúsculas | SKILL regra 6; modelo "Normalização"; telas Importar | Chave: e-mail, telefone +55, CPF/CNPJ; `count` antes de criar (não há unicidade no servidor) |
| Resultado por linha na ordem da entrada; refazer só as falhas | telas Importar | Relatório baixável e "Reprocessar só os erros" |
| Limite de taxa: testar com 50, dividir em pedaços | telas Importar (blocos de 200 com progresso) | Limites do SDK |
| Remodelagens (read → update, CSV → upsert, união e dedupe de buscas, tabela de frequência, exportar CSV) | telas Segmentos (união por id), Importar, Relatórios (agrupamento), Exportar | Feito no cliente |
| Filas sem "teams": agrupar por dono no cliente | relatorios Carteira; telas Carteiras | Agrupamento por `seller` |
| audience-targeting: filtros por ciclo de vida, status, dono, engajamento, cargo, geografia, negócios associados | telas Segmentos | Filtros do SDK + pós-filtro na tela |
| AND dentro do grupo, OR entre grupos | telas Segmentos | Um `list` por grupo, união por id |
| `~` é por palavra inteira; pós-filtrar | telas Segmentos (trecho de texto no cliente) | `contains` do SDK e filtro local |
| Cruzar empresa (firmografia) → contatos | telas Segmentos (segmento e porte da empresa) | Filtro `company in [ids]` |
| Salvar segmento e reusar para dono em lote e reconsulta | modelo `segment`; telas Segmentos | Registro salvo em vez de arquivo JSONL |
| Excluir opt-out da audiência | telas Segmentos; modelo LGPD | Exportação para campanha exclui e informa quantos saíram |
| Cookbook de segmentos (sem dono, nunca contatado, 2 ou mais negócios, reengajados) | telas Segmentos prontos | Quatro segmentos prontos |
| communication-history: histórico por registro, filtro por tipo, recorte de data, linha compacta | telas Ficha do negócio (Linha do tempo) e Ficha do contato | Atividades mais novas primeiro |
| Resumo pré-ligação (contato, empresa, negócios abertos, atividade recente) | telas "Preparar ligação" | Com 3 pontos da IA tirados só dos dados |
| Transcrições de chamadas | Fora | A plataforma não transcreve áudio; o dono cola o texto em Registrar com IA |
| crm-data-quality: achar incompletos (sem e-mail, sem telefone, sem dono) | telas Saúde dos dados (checagens por contato e empresa) | Consulta ao abrir |
| Normalizar valores em lote | telas Saúde dos dados (ações em lote) + padrão de lote | Com prévia |
| Dedupe com merge irreversível, paginação obrigatória | telas Duplicados e Mesclar | Mescla no app: move filhos com `updateWhere`, remove o secundário, avisa que não tem volta |
| "Não adivinhe nomes de propriedade; liste" | SKILL construção: modelos só de `fab-modelo-de-dados.md`; conferência final | O schema é da skill, não de um portal |
| Auditar propriedades | Configurações (campos extras listados) | Definições em `custom_field_def` |
| crm-lookup: buscar por id, e-mail, domínio, trecho de nome | telas (busca com debounce, chave normalizada) | Busca do SDK |
| Percorrer associações para o quadro completo | telas Ficha do contato/empresa/negócio | `ref` no filho consultado |
| custom-object-management: criar, inspecionar, atualizar rótulo, apagar esquema (destrutivo) | modelo "Campos e objetos personalizados"; SKILL edição | Campo extra = `custom_field_def` + json; objeto = modelo novo na edição; apagar objeto pede confirmação com contagem |
| customer-retention: clientes inativos 60 dias, nunca contatados | pipeline "Depois do ganho" (Clientes em risco); telas Segmentos | Tela e segmento pronto |
| Assinaturas em atraso | Fora (cobrança) | Sugere skill de financeiro |
| Tickets urgentes antigos, opt-out, empresa sem negócio aberto | pipeline risco (etiqueta "risco", opt-out); Saúde dos dados (empresa sem negócio) | Sem módulo de chamados; etiqueta do vendedor |
| Tarefa de retenção em lote para uma coorte | pipeline Rotina vermelho/amarelo; padrão de lote | "Criar tarefas" com prévia |
| Sem score de saúde nativo | pipeline "Risco de perder o cliente" | Cores por regra fixa |
| data-enrichment: upsert por e-mail/domínio, dry-run, conferir campos sobrescritos | telas Importar (passo 4, regra de sobrescrita) | Padrão só preenche vazios |
| Separar ok e falhas; 400 = campo ou enum inválido | telas Importar (motivo por linha) | 422 do servidor vira motivo legível |
| Busca OR em blocos de 5 | Fora | Não se aplica ao SDK |
| deal-management: descobrir funis e etapas em tempo de execução | pipeline (etapas são registros); SKILL construção 2 | `pipeline_stage` configurável, botão "Criar etapas padrão" |
| Qualificar lead em negócio, associar contato e empresa, promover ciclo de vida | modelo "Campos derivados" (eventos); telas Converter lead | Criar negócio é botão, nunca automático |
| Checklist de pré-qualificação (tem e-mail, empresa, sem negócio aberto, dono) | telas Converter lead; Saúde dos dados | Checagens na tela |
| Avançar ou reatribuir em lote | telas Carteiras; padrão de lote; diálogo de etapa | Mover etapa em lote passa pelo mesmo diálogo |
| Negócios parados (sem atividade 30d, fechamento vencido, sem valor, sem contato, probabilidade alta com fechamento distante) | pipeline "Tempo na etapa"; telas Saúde e Parados | Limites 14 dias (ajustável), 60 dias de fechamento |
| Estender datas vencidas em lote | telas Saúde (ação em lote) | Com prévia |
| Fechar = etapa + data; `hs_is_closed` derivado | SKILL regra 1; pipeline "Mudar de etapa" | `status` e `closed_at` gravados só pelo código |
| Ciclo de vida só para frente; status do lead independente | SKILL regra 1; modelo eventos; pipeline "Status do lead" | Dois enums |
| MQL/SQL | modelo `lifecycle` | Simplificado para PME: Lead, Oportunidade, Cliente, Promotor |
| quote-to-cash: catálogo, itens com preço que substitui o do produto, desconto %, total calculado só leitura | modelo `product`, `proposal`, `proposal_item`; telas Propostas | Total calculado na tela |
| Proposta sai de rascunho | telas Propostas (status) | Enviar registra atividade e `proposal_sent_at` |
| PDF e link de proposta só na interface da HubSpot | telas Propostas | Página de impressão (PDF pelo navegador) e texto para WhatsApp |
| Faturas e assinaturas (em aberto, vencidas, MRR) | Fora | Cobrança fora do escopo; nota fiscal não integrada |
| sales-execution: atividade invisível sem associação | SKILL regra 3; modelo `activity` | Validação: contato ou negócio obrigatório |
| Timestamp do fato, não do registro; tarefa: timestamp é o vencimento | SKILL regra 3; modelo `task.due_at` | `occurred_at` e `due_at` |
| Tipos e enums de ligação, nota, reunião, tarefa | modelo `activity`, `task` | Enums em português |
| Tarefa de follow-up por negócio em lote | telas Parados ("Criar tarefas") | Padrão de lote |
| sales-reporting: resumo diário (fecha em 7 dias, alterados em 24 h, funil aberto) | relatorios "Resumo diário"; telas Hoje | 7 e 14 dias |
| Funil por etapa e por dono | relatorios "Funil agora" | Soma no cliente |
| Ganhos e perdas, taxa por vendedor, receita por mês | relatorios "Ganhos e perdas" | `closed_at` |
| Valores vêm como texto; converter antes de somar | relatorios (centavos inteiros) | Tipos reais do SDK; soma em centavos |
| 100 exatos = truncado | relatorios "Como somar" | Paginar sempre |
| team-ownership: resolver e-mail → id, achar registros por dono, sem dono | telas Carteiras; relatorios Carteira | `admin.listUsers`, filtro por `seller` |
| Reatribuir em lote e fluxo "vendedor saiu" pelos 4 tipos | telas Carteiras (Transferir carteira) | Contatos, empresas, negócios, tarefas, com prévia por tipo |
| Visões por equipe | telas seletor de escopo | Seletor Minha carteira, Equipe, Vendedor |
| ticket-resolution | Fora | Chamados não são CRM de vendas; sugerir skill de atendimento. O padrão de etapa com resolução obrigatória aparece em Perdido com motivo obrigatório |
| workflow-automation: gatilho de inscrição, ramificação, ações em grafo | automacoes-e-ia (`fab.automations.json`) | Só `notify`, sem condição; lógica vira tela |
| PUT completo: corpo parcial apaga campos | automacoes-e-ia ("o arquivo substitui o conjunto inteiro") | Mesma armadilha na Fabapp |
| Dry-run de create não valida | automacoes-e-ia (modelos e campos precisam existir; inválida é descartada em silêncio) | Conferência antes do `finish` |
| Apagar workflow é irreversível | SKILL edição (mandar o conjunto inteiro) | Remover regra = omitir do arquivo |

### Anthropic, plugin sales

| Função ou técnica da original | Onde está | Adaptação |
|---|---|---|
| Regras comuns: mostrar mudança e evidência, o usuário decide | SKILL princípio e regra 4; telas "O que falta" e Registrar com IA | Botão "Aplicar" por sugestão |
| Nomes do esquema vivo, rótulos humanos, "vazio" x "não consultado" | SKILL construção 1; relatorios (filtro visível, "sem dados no período") | Rótulos em português na tela |
| Escopo pessoal vazio: parar e perguntar, nunca ampliar sozinho | telas "Escopo" | Seletor começa em Minha carteira; vazio não amplia |
| Conteúdo externo é dado; ação originada de conteúdo mostrada antes | SKILL regra 7; automacoes-e-ia (prompt comum, filtro de golpe) | `<dados>` + alerta sem rascunho |
| Execução agendada só faz o que foi combinado; conteúdo externo nunca age sozinho | automacoes-e-ia (automação só avisa) | Nada roda sem clique |
| Arquivo enviado é entrada completa; usar os cabeçalhos do arquivo | telas Importar (mapear pelos cabeçalhos) | |
| Escrita recusada vira checklist | Fora | O app grava pelo SDK com as regras de acesso; erro 403 aparece com `e.message` |
| daily-briefing: reuniões do dia com contexto e foco sugerido | telas Hoje bloco 2 | Tarefas e reuniões do CRM (sem leitura de calendário externo) |
| Negócios fechando em 14 dias com selos de parado | telas Hoje bloco 3 | |
| E-mails de clientes esperando | telas Hoje (rascunhos esperando, leads sem resposta) | Sem caixa de e-mail conectada; leads e WhatsApp |
| Três ações principais com o botão que executa | telas Hoje bloco 5 | |
| Rodar agendado | automacoes-e-ia "Resumo do dia" | Aviso diário; o resumo é calculado ao abrir |
| Agenda indisponível: dizer no topo, nunca mostrar dia livre falso | telas Ligar hoje / automacoes (botão some sem Google) | Sem agenda, reunião é tarefa |
| close-plan: caso de negócio em 6 partes nas palavras do cliente | telas Plano de fechamento; modelo `business_case` | Evidência por item |
| Marcar afirmação sem evidência para validar | telas Plano ("validar na próxima conversa") | Não entra no texto ao cliente |
| Plano mútuo de trás para frente, com donos dos dois lados e passos impossíveis marcados | telas Plano; modelo `close_plan_step` | Vermelho quando estoura a data alvo |
| Rascunho ao campeão pedindo confirmação dos donos | telas Plano (texto para WhatsApp) | Envio com clique |
| Propor próximo passo e data de fechamento | telas Plano e O que falta | "Aplicar" |
| deal-advance-gap: lacunas contra critério de saída (feito, andando, não iniciado) | telas "O que falta" passos 1 e 2 | Calculado sem IA |
| Qualificação só marca o que bloqueia | pipeline "Qualificação leve" (regras); telas O que falta passo 3 | |
| Critérios vagos geram lacunas vagas; usar padrão rotulado | pipeline (critérios padrão por etapa, editáveis) | |
| Sequenciar: nós, cliente, interno; paralelo x sequencial; ação que destrava mais | telas O que falta passo 4 | |
| Data mais cedo crível e aviso se passa da data atual | telas O que falta passo 5 | Soma das medianas |
| Itens já em andamento não são pedidos de novo | telas O que falta passo 6 | |
| route-lead: regras do dono, deterministas, regra citada | telas Roteamento | `routing_rule` + rodízio por menor carga |
| Precedência: conta existente → dono da conta; negócio aberto → dono do negócio vence | telas Roteamento 1 e 2 | |
| Cartão: dono recomendado, veredito, recado de passagem, pedido de informação | telas Roteamento (cartão) | Rascunhos com clique |
| Aceitar ou trocar com motivo; sem motivo grava "sem motivo informado"; motivos repetidos viram proposta de regra | telas Roteamento; Configurações | `audit_log` |
| Antes/depois do dono e dono vindo só de conteúdo colado mostrado antes | telas Roteamento | |
| Varredura agendada da fila com contagem de novos | automacoes-e-ia (lead novo para gestores) | Aviso na chegada; quadro calculado ao abrir |
| crm-hygiene-check: tabela de checagens (valor, fechamento, próximo passo, idade na etapa 2x mediana, atividade 14 d, contatos, critério da etapa) | telas Saúde dos dados | Mais: dono e contato/empresa |
| Sugerir valores (próximo passo "dd/mm, verbo, o quê, com quem", data realista pela mediana, etapa se a evidência contradiz) | telas Saúde (sugestões) | Formato brasileiro de data |
| Saída: crítico, atenção, limpos; ações em lote agregadas | telas Saúde (resumo e lote) | |
| Tudo é recomendação até o usuário escolher | telas Saúde ("Aplicar") | |

### Anthropic, plugin small-business

| Função ou técnica da original | Onde está | Adaptação |
|---|---|---|
| crm-autopilot: quatro modos (registrar, varredura, retomada, higiene) | telas Registrar com IA, Parados, Saúde | Varredura agendada fora (ver abaixo) |
| Varredura agendada de e-mail, agenda e transcrições (standing mode) | Fora | O app não lê caixa de e-mail nem Zoom; substituído por colar texto, aviso de WhatsApp recebido e cálculo ao abrir |
| Extração de transcrição: próximo passo e de quem, orçamento, prazo, objeção literal, outras pessoas, concorrente | automacoes-e-ia prompt 2; telas Registrar | Schema do `invokeLLM` |
| Resumo de 3 a 5 linhas, nunca o texto inteiro | telas Registrar passo 4; exemplo em automacoes | |
| Data do fato, não de agora | telas Registrar (pede a data); SKILL regra 3 | |
| Resolver contato por e-mail em minúsculas; anunciar criação de contato | telas Registrar passo 2 | |
| Ordem de resolução do negócio; nunca criar negócio | telas Registrar passo 3; SKILL regra 4 | |
| Propor campos; etapa e valor são do dono | telas Registrar passo 5 | Sinal com botão para o diálogo normal |
| Base vazia: contar primeiro, oferecer estrutura, não resolver | telas Registrar (base vazia) | Criar etapas e importar |
| Não registrar duas vezes o mesmo evento | modelo `source_hash`; telas Registrar passo 4 | |
| Retomada: 14 dias ou fechamento vencido, por valor e depois silêncio, 3 em destaque, rascunho ancorado no último fato | telas Parados; automacoes prompt 3 | |
| Voz do dono: 3 mensagens aprovadas; sem amostra, neutro e avisado | modelo `voice_samples`; telas Parados | |
| Fila de próximo passo (dono, ação, data) | SKILL regra 2; telas Hoje | Formulário não salva sem |
| Checklist de limpeza (última atividade, próximo passo, etapa só sinal, data, valor, contatos, nota que contradiz vira nova nota) | telas Saúde e Registrar; SKILL regra 3 | |
| Diffs lado a lado aprovados item a item | telas Registrar passo 5 | |
| Portões: nunca apagar, nunca mudar etapa, nunca criar negócio, nunca enviar sem aprovação | SKILL regras 3, 4, 8 | Excluir existe só para o dono, com prévia |
| Relato que começa pelo que precisa do dono | telas Hoje bloco 1; Registrar passo 6 | |
| lightweight_crm: 4 abas (contatos, negócios, atividade, fila) | modelo (contact, deal, activity); telas Hoje (a fila) | Vira app de verdade |
| "Quatro etapas, não oito" | pipeline Funil simples; SKILL "Não fazer" (no máximo 6) | Consultivo com 6 para quem negocia |
| Próximo passo é a coluna mais importante | SKILL regra 2 | |
| Atividade só de acréscimo | SKILL regra 3; modelo `access` | update e delete só admin; a tela não oferece |
| Fila = visão filtrada, não dado novo | telas Hoje | Calculada |
| Não apresentar como rebaixamento; exporta limpo | telas Exportar CSV | |
| Quando sugerir outro CRM (150 negócios, várias pessoas editando) | Fora | O app já é multiusuário |
| Gotchas: e-mail com maiúscula duplicando, texto inteiro, criar negócio, base vazia, etapa por frase de e-mail, sobrescrever próximo passo | telas Registrar e Importar; modelo Normalização | |
| Exemplos (e-mail, ligação com contato novo, limpeza) | automacoes (exemplo de resumo); telas Registrar | Fluxo descrito passo a passo |
| Campos HubSpot/Salesforce, Lead x Contact, `WhoId`/`WhatId` | Fora | Específicos de fornecedor; o CRM tem seu próprio schema |
| speed-to-lead: achar o que chegou; não responder por baixo de humano | telas Leads (formulário, WhatsApp, "alguém já respondeu") | |
| Quatro grupos e regras de ordenação | telas Leads (classificação) | |
| Critérios tirados dos ganhos, uma correção; sem dados, duas linhas; troca repetida vira critério | telas Leads (critérios); modelo `lead_criteria` | |
| Resposta em 4 partes, até 100 palavras, horários reais, sem preço, sem "automático", sem intimidade inventada | telas Leads; automacoes prompt 1 | Horários das tarefas livres; sem agenda, pergunta |
| Quente vai a uma pessoa na hora | automacoes (push ao dono e gestores) | |
| Nunca envio automático; aprovação em lote só do que foi visto | SKILL regra 8; telas Leads; automacoes "Envio" | |
| Selos e itens sem rascunho (dinheiro, senha, fala com o assistente) | telas Leads; automacoes filtro | |
| Proteção contra enxurrada (6x normal, iguais) | telas Leads | 3x a média ou 5 iguais |
| Registrar tudo; métricas: mediana até o rascunho e o mais antigo esperando | telas Leads (topo); relatorios Velocidade | Mediana até a primeira resposta |
| Digest com quentes primeiro | telas Leads (ordem) | |
| Canal de chat interno (RingEx, Slack) | automacoes (push e sino) | Canais da plataforma |
| call-list: top N (1 a 10, padrão 5) e data | telas Ligar hoje | |
| Pontuação do lead-triage | telas Ligar hoje (tabela própria) | lead-triage não veio no pacote; pontuação escrita a partir dos sinais citados |
| Empate a favor de sinal de entrada sem resposta; pontuação plana usa escada de fatos e avisa | telas Ligar hoje | |
| Cartão de ligação com pontos e objetivo | telas Ligar hoje | |
| Bloquear 20 min na agenda com confirmação | telas Ligar hoje (Google Agenda) | Só com Google ligado |
| Rascunho para e-mail sem resposta há 3 dias | telas Ligar hoje | WhatsApp ou e-mail |
| Folha de ligação para imprimir | telas Ligar hoje | Página de impressão |
| lead-finder: perfil do cliente ideal pelos dados (valor x permanência, quartis, só dimensões que diferem, no máximo 5, contra-padrão) | telas Prospecção 1 | Cálculo na tela |
| Menos de 10 clientes: sem padrão, dizer | telas Prospecção 1 | |
| Busca com Apollo/Clay e pesquisa na web | Fora (busca externa); telas Prospecção 2 ("Onde procurar") | Plataforma sem fonte de dados de empresas: lista entra por planilha e cadastro; fontes adaptadas ao Brasil |
| Pessoa certa por empresa; empresa sem contato fica | telas Prospecção 4 | |
| Nota encaixe/sinal/alcance 0,4/0,4/0,2 com tabelas; sinal com data e fonte; abaixo de 4 fora; empate por recência; 40 a 60 linhas | telas Prospecção 3 | |
| Confiança do contato (verificado, deduzido, desconhecido); nunca inventar contato | modelo `prospect`; telas Prospecção 4 | |
| Top 10 com motivo; XLSX completo | telas Prospecção 4 | CSV |
| Escrever no CRM só com sim, dizendo o que será criado e a etiqueta | telas Prospecção 4 | |
| Conferir se a empresa ainda existe | telas Prospecção 2 (orientação) | Checagem manual do dono |

### LeadMagic (gtm-skills)

| Função ou técnica da original | Onde está | Adaptação |
|---|---|---|
| pipeline-management: Objetivo + Ações + Critério de saída por etapa | pipeline tabela consultiva; modelo `pipeline_stage` | Campos da etapa |
| Etapa nomeada pelo avanço do cliente, não pela ação | pipeline (abertura) | |
| Escolha do movimento por valor (transacional, consultivo, estratégico) | SKILL briefing pergunta 1; pipeline (simples x consultivo, etapa extra) | Pergunta em linguagem do dono |
| SPICED por etapa, progressivo, com regra de desqualificação sem evento crítico | pipeline "Qualificação leve" | Cinco perguntas em português, nível 0/1/2 |
| MEDDICC 0/1/2, teste do campeão, portões 6/10/12/13 de 14 | pipeline "Placar de negócio grande" | Só para negócio grande |
| SPICED e MEDDICC nos mesmos campos | pipeline (último parágrafo do placar) | |
| Gap Selling: estado atual, futuro, lacuna; sem "happy ears" | pipeline Qualificação (situação, dor, impacto com evidência); Plano de fechamento | |
| Metas de conversão entre etapas; alerta com queda de 10 pontos | pipeline "Conversão"; relatorios Velocidade | Base é o próprio app; faixas de mercado só como referência |
| Limites de tempo (Discovery 21 d sem evento; Proposta 30 d sem decisor) | pipeline "Tempo na etapa" | |
| Bowtie e pacotes de passagem com SLA | pipeline "Depois do ganho" | Pacote no ganho; SLA de 1 h para lead |
| Categorias de previsão ligadas a critério | pipeline "Previsão"; relatorios | |
| Revisão semanal e perguntas de inspeção | pipeline "Revisão semanal"; relatorios Revisão | |
| Armadilhas (etapas por ação, SPICED velho, sem conversão, passagem por e-mail, etapas demais, processo sem material) | pipeline (etapa pelo cliente, reconfirmar prazo, conversão, pacote, máximo 9) | Material de vendas fora |
| Gilkey: 6 resultados por conversa, mínimo 50, uma variável por vez, diagnóstico por grupo | pipeline "Resultado da ligação"; relatorios | |
| Gilkey: intenção de telefone, regra dos 20%, discagem de precisão | Fora | Sem discador nem dados de intenção |
| Reisert: 4 baldes, rotina de trás para frente, cadência de 14 dias, 93%/98%, parar em 5 e voltar em 90 dias, roteiro de abertura | pipeline "Status do lead e rotina"; telas Ligar hoje (ordem) | LinkedIn trocado por WhatsApp |
| Coaching ao vivo (CallBlitz), especialistas, links | Fora | Não é funcionalidade de app |
| crm-toolkit: 5 a 7 etapas com critério; chave de dedupe e-mail e domínio | pipeline; modelo Normalização | CNPJ no lugar de domínio |
| Contatos x leads (quarentena) | modelo (um contato com `lifecycle` e `lead_status`; `inquiry` como quarentena do formulário) | Sem objeto Lead duplicado |
| Enriquecimento só num sentido, sem sobrescrever o que humano corrigiu | telas Importar (só preenche vazios por padrão) | |
| Higiene: pessoa sem contato, negócio sem valor e data, parado 60 d | telas Saúde; pipeline Tempo na etapa | |
| Cadência de higiene (diária, semanal, mensal) | telas Hoje (diária), Revisão semanal, Duplicados (quando quiser) | |
| Seleção de CRM, parceiros de implantação, custos, blueprints Salesforce/HubSpot/Attio, Benioff V2MOM | Fora | O app é o CRM; não se aplica |
| Listas como filas (Attio) | telas Segmentos e Hoje | |
| Land and expand, renovação 90 a 120 dias antes, expansão separada do cliente novo | pipeline "Depois do ganho"; relatorios (receita sem misturar) | `parent_deal`, `deal_type`, automação -90 |
| crm-integration: dono de cada campo, quem escreve | modelo "Campos derivados" | Código grava derivados; pessoa grava o resto |
| Etapas de ciclo de vida com entrada e saída | modelo eventos de `lifecycle` | |
| Campos obrigatórios mínimos | SKILL regra 2; modelo | Só o que a próxima etapa precisa |
| Painéis: conversão, funil, idade na etapa, origem, completude | relatorios | |
| Taxonomia de motivo de perda | modelo `crm_option` motivo_perda | |
| Scripts `check-output.py` e templates de entrega | SKILL critérios de aceite e conferência antes do `finish` | A plataforma confere os critérios depois do build |
| churn-prediction e onboarding-sequences (gancho pedido) | pipeline "Depois do ganho" | Sinais adaptados sem dados de uso; rotina vermelho/amarelo |

### Análise interna (seção 4.4 e princípios)

| Item | Onde está |
|---|---|
| Quando usar / não usar | description; SKILL "Não é loja virtual" |
| Entidades e relações | modelo "Relações" |
| Campos obrigatórios e validações, derivados bloqueados | modelo campos, derivados |
| Pipeline padrão com probabilidade; perdido exige motivo; ganho exige valor | pipeline; SKILL critérios |
| Telas mínimas (Hoje, kanban, contatos, fichas, proposta, importar, relatórios, configurações) | telas |
| Relatórios e KPIs | relatorios |
| Automações (lead novo, parado, proposta 3 dias, vendedor desligado, lote) | automacoes; telas Carteiras |
| Regras BR (CPF, CNPJ alfanumérico, telefone E.164, WhatsApp, LGPD, nota fiscal) | modelo "Normalização" e "Regras brasileiras" |
| Papéis (dono, gestor, vendedor, financeiro) | modelo "Acesso" (financeiro fora, porque cobrança não entra) |
| Seed | modelo "Dados de exemplo" |
| Não fazer | SKILL "Não fazer" |
| Dinheiro em centavos | Plataforma usa `money`; soma em centavos no código (relatorios) |
| Pix, boleto, cobrança por webhook | Fora: cobrança não faz parte deste CRM (sugerir skill de financeiro) |
