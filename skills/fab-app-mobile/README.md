# App com Cara de App

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem e editam apps da Fabapp AI com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou o encanamento:

- As etapas do Studio viraram o fluxo do agente: Antes de começar, A conversa, O plano, A construção, Conferir antes de dizer pronto, Mudanças depois.
- O plano é um texto mostrado ao dono antes de codar; os critérios de aceite viraram a lista de conferência do plano, com todos os itens que se aplicam, sem teto.
- O modo claro, escuro ou do sistema e a marca (paleta, paleta `dark`, fontes, raio) são gravados pelo agente em `apps/<slug>/fab.config.json → theme` e enviados com `fabapp push`, depois de aprovados pelo dono; no Studio isso era patch de tema da plataforma.
- Nova pergunta de modo na conversa, porque no terminal não há o briefing da plataforma que escolhia a marca.
- A revisão automática do Studio virou conferência do agente em `fabapp dev` e por busca no código, com `fabapp deploy` tratando `build_failed` (422) e `account_builds_busy` (409).
- A memória do app virou `DECISOES.md`; o encerramento virou a mensagem final com a lista do que o dono faz no Studio (imagens e logo, app de loja, Entrar com Apple, integrações).
- Referências a outras skills da equipe viraram "se a skill estiver instalada", com a regra essencial escrita aqui.
- O contrato da plataforma pelo terminal vem em `references/fabapp-cli.md`.

Faz o app gerado se comportar como aplicativo de celular (no navegador, instalado como PWA e dentro da casca Expo), aplicando as regras do Apple HIG e do Material 3 traduzidas para a web, e desenha o fluxo de UX (casos de uso, mapa de telas, estados, rascunhos) antes do código.

- **Categoria:** other
- **Etapas:** plan, build, edit (sem briefing: a escolha entre jeito de app e jeito de site já é pergunta do briefing da plataforma, e o app nativo é configurado depois no Studio)
- **Tokens (validador, edição terminal):** corpo ~4.450; referências ~5.900 (mais `references/fabapp-cli.md`, copiado na montagem)
- **1.1.0 (14/10/2026):** barra de abas só nas raízes (`AppShell tabs="roots"`), navegação em camadas que entram e saem (`Screen`, `LayerLink`, `useLayerNav`) e cabeçalho de app com voltar e título em toda tela que não é raiz.
- **Arquivos:** `SKILL.md`, `references/regras-nativas.md`, `references/fluxo-de-ux.md`

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| ios-design-guidelines (SKILL.md, AGENTS.md, rules/_sections.md, metadata.json) | https://github.com/ehmo/platform-design-skills, `skills/ios`, commit dc2be82 | MIT, Copyright (c) 2026 (Platform Design Skills) |
| android-design-guidelines (SKILL.md, AGENTS.md, rules/_sections.md, metadata.json) | https://github.com/ehmo/platform-design-skills, `skills/android`, commit dc2be82 | MIT, Copyright (c) 2026 (Platform Design Skills) |
| ux-flow-designer (SKILL.md, README, references/mermaid-patterns, figma-integration, install-commands, assets/wireframe-template.html) | https://github.com/ThomasPraun/ux-flow-designer, commit 4d2052b | MIT, Copyright (c) 2026 Thomas Praun |

As regras de plataforma derivam das diretrizes públicas da Apple e do Google; o texto aqui é reescrito, sem exemplos de SwiftUI, UIKit, Compose ou XML. Análise consultada: `03-sites-apps-layout/ANALISE.md` (fichas 5, 6 e 11).

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| iOS 1.1 a 1.6 (toque 44 pt, área segura, polegar, tamanhos, grade de 8, horizontal) | SKILL regras 1, 2, 4; `regras-nativas.md` §1 | Área segura com `env(safe-area-inset-*)`; 48 px nos alvos principais (Material) |
| Android R3.1 a R3.10 (classes de largura, grade 4/8/12 com margens e espaços, largura máxima ~840, borda a borda, dobráveis) | `regras-nativas.md` §1.7, §1.8 | Tabela convertida para breakpoints do Tailwind; margem da plataforma `px-6` prevalece sobre 16 dp |
| iOS 2.1 a 2.7 (abas, sem hambúrguer, título grande, voltar por gesto, pilha, estado, reconhecer) | SKILL regra 3 e construção; `regras-nativas.md` §2 | Pilha por rotas aninhadas; estado em parâmetros da URL |
| Android R2.1 a R2.14 (barra 3 a 5, rótulos, ícone cheio/vazado, indicador, rail, drawer, voltar preditivo, Up versus Back, sem "tem certeza", reconhecer) | `regras-nativas.md` §2 | Ícone cheio/vazado vira indicador em pílula (o `lucide` não tem variantes cheias); voltar preditivo é do sistema, o app só não o bloqueia |
| Tabela de navegação por largura e quantidade de destinos | `regras-nativas.md` §2.5 | Casca de app da plataforma (`AppShell tabs="roots"`): abas só nas raízes no celular, topo ou lateral a partir de `md`; detalhes em camadas (`Screen`) |
| iOS 3.1 a 3.6 e Android R4.1 a R4.5 (estilos, Dynamic Type até 200%, fonte customizada que escala, mínimos 11/12, entrelinha, hierarquia) | SKILL regra 5; `regras-nativas.md` §3 | `rem` do Tailwind acompanha a configuração de texto; fonte vem da marca; campo com 16 px contra zoom do iPhone (acréscimo web) |
| iOS 4.1 a 4.7 e Android R1.1 a R1.11 (cores semânticas, claro e escuro, nunca só cor, 4,5:1, P3, fundos, uma cor de destaque, papéis "on", tema dinâmico, sementes) | SKILL regra 6; `regras-nativas.md` §4 | Tokens da marca; modo pelo patch de tema (`light`/`dark`/`system`); cor dinâmica do papel de parede, P3 e geração por semente não se aplicam (a plataforma gera e confere a paleta) |
| iOS 5.1 a 5.8 e Android R6.1 a R6.13 (leitor de tela, ordem, negrito, menos movimento, contraste alto, alternativa a gesto, teclado, agrupar, ações customizadas, foco, canvas) | SKILL construção "Acessibilidade" e "Movimento"; `regras-nativas.md` §5 | `aria-label`, `useReducedMotion`; canvas vira "gráfico acompanhado dos números" |
| iOS 6.1 a 6.4 e Android R7.1 a R7.7 (gestos padrão, gestos do sistema, gesto descobrível, entradas, zonas de gesto, puxar para atualizar, deslizar para apagar desfazível, ripple, segurar, vibração) | SKILL construção; `regras-nativas.md` §6 | Puxar para atualizar dispensado (`useLive` atualiza); vibração sem API no SDK, retorno visual obrigatório |
| iOS 7.1 a 7.11 e Android R5.1 a R5.19 (botões, alertas, folhas, listas, abas, busca, menus, progresso, símbolos; FAB, barra de topo, folhas, diálogos, snackbar, chips, esperas) | SKILL construção; `regras-nativas.md` §7 (tabela de componentes do kit) | Mapeados para `Button`, `AlertDialog`, `Sheet`, `toast`, `ScrollRow`, `Skeleton`, `LoadingButton`, `DropdownMenu`; SF Symbols viram `lucide` com peso do texto |
| iOS 8.1 a 8.8 (onboarding 3 telas, esqueleto, abertura, modal, notificações, configurações, retorno, espera imediata) | SKILL regras 7, 9 e "Entrada do app"; `regras-nativas.md` §8 | Mantido |
| Android R8.1 a R8.9 (canais, importância, toque abre conteúdo, estilos de mensagem) | `regras-nativas.md` §8.5 | Tipos de aviso com preferências em `appUser.fields`; `link` em todo push; canais e resposta direta são da casca |
| iOS 9.1 a 9.6 e Android R9.1 a R9.8 (permissão no contexto, explicação antes, negar sem bloquear, só o necessário, seletor de fotos, localização aproximada, conta só quando precisa, Entrar com Apple, ATT) | SKILL regra 8 e construção "Aparelho"; `regras-nativas.md` §9 | `fab-native` (`takePhoto`, `pickImage`, `getLocation`, `registerPush`, `authBiometric`); Apple login pelo `SocialAuthButtons`; rastreamento é da plataforma |
| iOS 10.1 a 10.6 e Android R10.1 a R10.10 (widgets, atalhos, Spotlight, compartilhar, Live Activities, interrupções, links profundos) | `regras-nativas.md` §10 | Compartilhar com `share()`, links profundos por rota, rascunho contra interrupção; widgets, atalhos, Spotlight e Live Activities declarados como indisponíveis |
| Referência rápida (necessidade → componente) | `regras-nativas.md` §7 | Componentes do kit da plataforma |
| Listas de conferência iOS e Android | `regras-nativas.md` "Lista de conferência"; mensagem final ao dono | Unificadas |
| 15 antipadrões iOS e tabela de antipadrões Android, "Never Do" dos AGENTS.md | `regras-nativas.md` "Antipadrões" | Unificados em 20 itens |
| Prioridades CRÍTICA, ALTA, MÉDIA | `regras-nativas.md` topo | Mantidas |
| ux-flow: fase 1, casos de uso com os 7 campos e aprovação antes de seguir | SKILL plano item 1; `fluxo-de-ux.md` §1 | A aprovação é a do plano pelo dono |
| Fase 2: mapa mestre de telas, fluxograma, diagrama de estados e de sequência por caso, até 15 a 20 nós, subfluxos, estilos | SKILL plano itens 2 a 5; `fluxo-de-ux.md` §2 a §5 | Em texto (o plano não renderiza Mermaid); sequência vira lista de chamadas do SDK com os erros de cada uma |
| Padrões de estado (formulário aninhado, estados paralelos, sessão) | `fluxo-de-ux.md` §4 | Mantidos, com os códigos de erro da plataforma |
| Fase 3: wireframes HTML clicáveis em 375 px, tons de cinza, navegação entre telas, sem beco sem saída, inventário | SKILL plano item 6; `fluxo-de-ux.md` §6; regra 9 | O protótipo clicável é o próprio app no preview; o rascunho vira texto de cima para baixo; "nenhum beco sem saída" virou critério de aceite |
| Oferecer pré-visualização no navegador | Não incluído | A plataforma abre o app no navegador sozinha depois do build |
| Fase 4: documento de entrega (mapa, inventário, diagramas, ligações, padrões, perguntas em aberto) | `fluxo-de-ux.md` §7 | Perguntas em aberto viram `assumptions` |
| Convenções de nome (telas, ações, estados) e de arquivo | `fluxo-de-ux.md` §3 | Nomes de tela consistentes entre fluxos; arquivos não se aplicam |
| Exportação para Figma, comandos de instalação, verificação de skills irmãs | Não incluído | Sem Figma nem MCP no gerador; a skill é autossuficiente |
| Formas de nó do fluxograma | `fluxo-de-ux.md` §3 | Notação em texto `[Tela]`, `{Decisão?}`, `(Ação)`, `>Resultado` |

## Fora de propósito

Nada de React Native nem código nativo: a casca Expo usa o mesmo app web. A publicação na loja não é pergunta nem promessa; o dono configura depois, na aba "App para celular" do Studio.
