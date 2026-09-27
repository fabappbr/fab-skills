# Sites por Segmento

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem o app pelo CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou só o encanamento:
- As etapas do Studio viraram o fluxo do agente: primeiro movimento, a conversa (perguntas com opções), o plano mostrado ao dono antes de codar, a construção, conferir antes de dizer pronto e mudanças depois.
- Schema e automações são editados em `fab.schema.json` e `fab.automations.json` (`fabapp pull`, editar, `fabapp push`); o código sobe com `fabapp deploy`.
- A marca (cor, fonte, raio) é definida pelo agente em `apps/<slug>/fab.config.json → theme`, com aprovação do dono.
- Os critérios de aceite viraram a lista de conferência do plano, sem teto, conferida na pré-visualização e por busca no código.
- SEO por rota: no Studio o build não escrevia a configuração de SEO e o dono conferia na tela do Studio; aqui o agente escreve `apps/<slug>/fab.config.json → seo` (título e descrição da home, `pages` por rota estática, `structured`, `breadcrumbs`, `ogImage`) e envia com `fabapp push`, além de `<FabHead>` nas rotas dinâmicas.
- `business_profile` e os modelos do setor vão no `fab.schema.json` (`fabapp pull`/`push`); a automação de aviso vai no `fab.automations.json`.
- Registros: o CLI não grava registros, então os fatos que o dono conta na conversa voltam para ele como lista pronta para cadastrar no CMS do Studio ou no painel de admin do app.
- A leitura dos sites de concorrentes usa a ferramenta de leitura de páginas do próprio agente (ou `curl`).
- A memória do app (decisões de conselho, convenções removidas a pedido) é o `DECISOES.md` na raiz do projeto.
- A memória do app vira `DECISOES.md` na raiz do projeto.
- O contrato da plataforma pelo terminal está em `references/fabapp-cli.md`.

A seção abaixo descreve a edição Studio (etapas e tamanhos são dela).

Faz o site gerado pela Fabapp parecer do ramo do negócio: decide blocos obrigatórios, ação de conversão, sinais de confiança, regras de conselho e a arquitetura das páginas por setor brasileiro. O setor decide o que o site precisa ter, nunca a cara (cor e fonte vêm da marca).

- **Categoria:** sites
- **Etapas:** briefing, plan, build, edit
- **Tokens (validador):** corpo ~5.810 (cada etapa recebe de ~2.500 a ~3.350); referências ~8.050 (cabem inteiras no briefing, limite 8.000)
- **Arquivos:** `SKILL.md`, `references/convencoes-por-setor.md`, `references/mapa-do-site.md`

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| vertical-site-conventions (SKILL.md e as 11 referências) | https://github.com/rampstackco/claude-skills, `skills/vertical-site-conventions`, commit 3d4510a | MIT, Copyright (c) 2026 RampStack Co. |
| site-architecture (SKILL.md e as 3 referências) | https://github.com/coreyhaines31/marketingskills, `skills/site-architecture`, commit 5b2c000 | MIT, Copyright (c) 2025 Corey Haines |
| ui-ux-pro-max (amostra de `data/products.csv` e `data/ui-reasoning.csv`: colunas de "must have", considerações e anti-padrões por setor; paletas ignoradas) | https://github.com/nextlevelbuilder/ui-ux-pro-max-skill, commit dcc40ff | MIT, Copyright (c) 2024 Next Level Builder |

As três licenças MIT permitem obra derivada desde que o aviso de copyright e a permissão acompanhem cópias substanciais. O texto aqui é reescrito em português para a plataforma Fabapp; os avisos acima ficam registrados neste README. Análises consultadas: `03-sites-apps-layout/ANALISE.md` (fichas 7 e 9) e `analise/01-design.md` §4.

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| Lista controlada de 10 formatos de site | `convencoes-por-setor.md`, cabeçalho "Formatos" | 11 formatos (entrou "serviço profissional"), cada setor brasileiro ligado a um |
| Dimensão 1: tarefa principal maior e mais cedo, um CTA no herói, alcançável sem rolar, versão compacta fixa, compromisso documentado | SKILL, eixo 1 | Versão fixa vira cabeçalho no computador e barra no rodapé no celular; compromisso vai em `assumptions` |
| Dimensão 2: registro e densidade, contagem de módulos acima da dobra, evitar SaaS arejado | SKILL, eixo 2; plano item 1 | Registros traduzidos; contagem de módulos declarada no plano |
| Dimensão 3: vitrine, uma forma de sinalizar profundidade, plana ou hierárquica, ícone/imagem/texto | SKILL, eixo 3 | Sem mudança de conteúdo |
| Dimensão 4: caminhos primário/secundário/ausente, busca por setor, não inventar caminhos | SKILL, eixo 4 | Filtros no parâmetro da URL para compartilhar |
| Dimensão 5: postura constante até rodapé, estados vazios, imagens | SKILL, eixo 5; construção "Estados vazios" | Voz e cor pela marca da plataforma |
| Dimensão 6: sinais de confiança do setor, onde o setor os põe, bloco agregado | SKILL, eixo 6; tabela por setor | Registro de conselho brasileiro no lugar de "license" |
| Linha funcional versus demonstração | SKILL, "Nada inventado" (parágrafo final) | Na Fabapp tudo é real; dado semeado marcado como exemplo, sem confirmação falsa |
| Dimensão 7 e checklist: presente/ausente/roteado, 3 ou mais ausências = fora do setor, 1 ou 2 com motivo | SKILL, eixo 7; plano item 6; critérios de aceite | Cada convenção vira `acceptance_criteria` |
| Itens que carregam densidade e limiar 8 de 10 | SKILL, eixo 7; marcações (D) na tabela | Mantido; qualquer (D) ausente reprova |
| A cunha (uma por site, duas diluem) | SKILL, eixo 7; plano item 7; "Cunhas" por setor | Mantido |
| Barra de experiência do `competitor-experience-audit` sobrepõe os padrões | Briefing, "A barra do mercado" | Troca da auditoria por `fetch_url` em 2 ou 3 concorrentes que o dono citar |
| "Se o formato não está claro, pergunte" | Briefing, mesmo parágrafo | Mantido |
| Notas de composição com mão de obra para outras skills (hand-off) | Plano, itens 1 a 9 | O plano da Fabapp é a especificação que o build lê; sem roteamento para outras skills (cada skill é autossuficiente) |
| Roteamento para design-standards, creative-direction, information-architecture | SKILL, introdução | Cor e fonte ficam com a marca (briefing; na edição, patch de tema e aba Marca do Studio); arquitetura foi absorvida; direção de arte sugerida como `fab-agencia` ao dono |
| Padrões de falha (moderno vago, SaaS arejado, tarefa enterrada, redefinir estética, ignorar a barra, template, pular a síntese, confundir implementação com composição) | SKILL, "Armadilhas" | Mais uma: iframe de terceiro para a ação (vem das referências de serviço e comida) |
| shape-local-service-booking (10 convenções, D 2/4/9, equipe, fluxo de agendamento, política, telefone, JSON-LD, acessibilidade, cunhas) | Tabela: salão/barbearia, clínica, academia, pet, domicílio; SKILL construção (agendamento, equipe) | Agendamento com `service`/`availability`/`booking` e `<SlotPicker/>` (conferido no código: exige usuário logado, então "sem conta" virou "acesso mínimo criado ao confirmar"); JSON-LD pela configuração `seo.structured` da plataforma, que o dono confere no Studio |
| shape-hospitality-food (10 convenções, D 1/5/9, cardápio sem PDF, voz da cozinha, reserva no site, prova única, horário linha a linha, cunhas) | Tabela: restaurante, padaria | Delivery e WhatsApp como ação brasileira; nota digitada pelo dono |
| shape-ecommerce-catalog (11 convenções, D 2/9/10/11, filtros, carrinho, ofertas, profundidade, volume) | Tabela: loja com catálogo | Profundidade com `count()` real; volume limitado ao catálogo do dono; CNPJ, troca de 7 dias, Pix e parcelamento; nota de captura de tela descartada (infraestrutura de auditoria, sem equivalente) |
| shape-b2b-manufacturer (11 convenções, D 2/5/8/11, specs em HTML, aplicações com métricas, formulário de 6 campos, preço sob cotação, imagens) | Tabela: fornecedor B2B | JSON-LD de produto pela plataforma; métricas só informadas pelo dono |
| Stubs: inventory-listing, directory, subscription-app, institution, ecommerce-standout, hospitality-experience | Tabela: imobiliária, veículos, diretório, produto digital, igreja/ONG/escola, loja de marca, hotel, passeios | Preenchidos com o provisório da original mais convenções brasileiras |
| ui-ux-pro-max: must have por setor (agendamento e convênio em clínica, mapa em imobiliária, contato de emergência e certificação em serviço de casa, horários em igreja, segurança em creche, cardápio e pedido em padaria, portfólio em fotógrafo) e anti-padrões (gradiente roxo em clínica, horário escondido, fotos ruins) | Tabela, convenções e anti-padrões de cada setor | Paletas e estilos por setor descartados de propósito (estereótipo visual); antes e depois opcional por causa de CFM e CFO |
| site-architecture: contexto do negócio, site novo ou reestruturação, URLs a preservar | Briefing, "Site anterior"; edição, redirecionamento | Redirecionamento por rota `<Navigate>` (a plataforma não tem 301 configurável) |
| Tipos de site, profundidade típica, templates por tipo | `mapa-do-site.md`, tabela e modelos | Slugs em português sem acento |
| Regra dos 3 cliques, plano versus profundo, níveis N0 a N3, 20+ itens pedem nível | `mapa-do-site.md` | Mantido |
| Árvore em ASCII | Plano item 2; `mapa-do-site.md` | Mantido |
| Diagrama Mermaid | Não incluído | O plano é lido pelo dono em markdown simples; a árvore em texto cumpre a função sem custo extra de tokens |
| Tipos de navegação, regras do cabeçalho (4 a 7, CTA à direita, logo, ordem), menu grande, menu dividido | `mapa-do-site.md` "Menu"; plano item 3 | Menu com palavras do cliente final (análise, ficha 3) |
| Rodapé em colunas, mínimo, expandido | `mapa-do-site.md` "Rodapé"; plano item 4 | Colunas brasileiras (endereço, horário, CNPJ, registro) |
| Trilha espelhando URL, regras, schema | `mapa-do-site.md` "Trilha"; construção | Schema gerado pela plataforma (`seo.breadcrumbs`) |
| Princípios de URL (6), padrões por tipo, erros comuns | `mapa-do-site.md` "Endereços"; plano item 2 | Mais o campo `slug` e a checagem de duplicidade com `count()` |
| Links internos: tipos, regras, 5 a 10 por 1.000 palavras, hub e raios, auditoria | `mapa-do-site.md` "Links internos" | Links como `<Link>` para o buscador |
| Navegação móvel (hambúrguer, CTA visível, busca no menu, sanfona) e barra inferior | `mapa-do-site.md`; construção | Casca de site da plataforma (`Sheet`); barra de abas fica para apps, não para sites |
| Anti-padrões de navegação e tabela de correções; navegação para SEO | `mapa-do-site.md` | Mantido |
| Formato de saída (árvore, sitemap visual, tabela de URLs, especificação de navegação, plano de links) | Plano itens 2 a 5; `mapa-do-site.md` "Como mostrar no plano" | Sem Mermaid |
| Perguntas específicas da tarefa (tipo, quantas páginas, 5 mais importantes, URLs, público) | Briefing, perguntas 1 a 6 e "Site anterior" | Só o que muda o site; o resto vira suposição |

## Regras brasileiras acrescentadas

Setores com conselho (CFM, CFO, CRP, CREFITO, CRN, CRMV, OAB, CRECI, CRC, CREF, credenciamento no Detran): a skill não afirma o teor de nenhuma regra. O site sai conservador por padrão (registro digitado pelo dono; sem preço, promessa, depoimento, casos ou antes e depois) e cada bloco só entra quando o dono confirma que o conselho dele permite; a confirmação vai para `update_knowledge`. Loja: identificação da empresa e política de troca escritas pelo dono, preço total antes de pagar, Pix e parcelamento só se forem verdade. LGPD com `/privacidade`. SEO: `<FabHead>` por página; a configuração `fab.config.json → seo` não é escrita pelo build (o dono confere no Studio), e não há 301 configurável (rota antiga vira `<Navigate>` no mesmo domínio).
