# Regras nativas (Apple HIG e Material 3) traduzidas para o app Fabapp

Cada regra traz a origem: **A** = Apple HIG para iPhone, **M** = Material 3 e Android. Onde a regra original é de API nativa sem equivalente na web, está escrito o que fazer no lugar.

Prioridade: CRÍTICA nunca se viola; ALTA segue-se salvo motivo registrado; MÉDIA é boa prática.

## 1. Layout e áreas seguras (CRÍTICA)

- **1.1 Toque mínimo** (A 1.1, M R6.5, M R6.6): 44 × 44 px em todo elemento clicável; 48 px em botão principal, item de lista e ícone de ação. Alvo pequeno cresce com padding, nunca se reduz para caber.
- **1.2 Área segura** (A 1.2, M R3.6 a R3.8): texto e controle nunca sob a barra de status, o recorte da câmera, a ilha dinâmica ou o indicador de início. Fundo e imagem decorativa podem ir até a borda; conteúdo não. Bordas fixas com `env(safe-area-inset-*)`. Lista rola por trás das barras com o respiro no começo e no fim.
- **1.3 Zona do polegar** (A 1.3): ação principal na metade de baixo; navegação secundária e ações raras no topo.
- **1.4 Todos os tamanhos de celular** (A 1.4): de 320 a 430 px de largura sem quebrar; nada de largura fixa em px; `min-w-0` em filhos de flex; no máximo 2 colunas na base.
- **1.5 Grade de 8** (A 1.5): espaçamentos em múltiplos de 8 (8, 16, 24, 32, 40, 48 px: `2, 4, 6, 8, 10, 12` no Tailwind), 4 para ajuste fino.
- **1.6 Deitado** (A 1.6): a tela funciona na horizontal, salvo tarefa específica.
- **1.7 Classes de largura e grade** (M R3.1 a R3.5, M 3.2):

| Classe | Largura | Colunas | Margem | Espaço entre colunas | No Tailwind |
|---|---|---|---|---|---|
| Compacta | < 600 | 4 | 16 | 8 | base: container `px-6` (padrão da plataforma), `gap-2` a `gap-3`, 1 ou 2 colunas de cartão |
| Média | 600 a 839 | 8 | 24 | 16 | `md:`: `gap-4`, 2 ou 3 colunas |
| Expandida | 840 + | 12 | 24 | 24 | `lg:`: `gap-6`, até 4 colunas |

  Em tela larga o conteúdo não ocupa a largura toda: texto e formulário em `max-w-3xl` (perto de 840 px), ou layout lista e detalhe lado a lado a partir de `lg`. As colunas da grade são para alinhar, não para encher de cartões. Decida por classe de largura (os breakpoints do Tailwind), nunca por aparelho.
- **1.8 Dobra** (M R3.9, R3.10): em dobrável, nada crítico atravessando a dobra; lista e detalhe em painéis separados a partir de `md`.

## 2. Navegação (CRÍTICA)

- **2.1 Abas embaixo para 3 a 5 seções de topo** (A 2.1, M R2.1): cada aba é uma categoria distinta e uma rota de topo; menos de 3 não é barra, mais de 5 vira "Mais".
- **2.2 Sem hambúrguer como navegação principal** (A 2.2): esconder a navegação derruba a descoberta de funções.
- **2.3 Rótulo sempre** (M R2.2): barra só de ícones não é permitida.
- **2.4 Estado ativo** (M R2.3, R2.4, A 7.5): ícone e rótulo na cor da marca como texto, rótulo mais forte e uma pílula de fundo suave atrás do ícone; inativo em cinza do tema. (O `lucide` não tem ícone cheio e vazado; o indicador faz esse papel.) Número pendente como `Badge` no ícone.
- **2.5 Qual navegação por largura** (M R2.5 a R2.9, M 2.5):

| Largura | 3 a 5 destinos | Mais de 5 |
|---|---|---|
| Celular | Abas embaixo | Abas + tela "Mais" |
| Média | Lateral estreita (rail) ou cabeçalho | Lateral com grupos |
| Larga | Lateral (rail ou fixa) | Lateral fixa com seções e divisórias |

  Na plataforma: abas `md:hidden`; a partir de `md`, a mesma `NAV` como lateral (app de ferramenta, painel) ou cabeçalho (app leve). A lateral pode ter no topo o botão da ação principal. Grupos da lateral com título e divisória.
- **2.6 Título grande nas telas de topo** (A 2.3): h1 grande; cabeçalho compacto ao entrar num detalhe (M R5.5, R5.6: barra de topo pequena na maioria das telas; se ela encolher ao rolar, que acompanhe a rolagem).
- **2.7 Voltar** (A 2.4, M R2.10 a R2.13): nunca capture o voltar do navegador, do Android ou o gesto de borda do iPhone; o botão "voltar" da tela leva ao nível acima (`navigate(-1)` quando veio de dentro do app, senão para a lista da aba). Nunca "tem certeza?" ao voltar, salvo com dado digitado não salvo (aí `AlertDialog` "Descartar alterações?").
- **2.8 Pilha dentro da aba** (A 2.5): lista → detalhe → edição com rotas aninhadas (`/pedidos`, `/pedidos/:id`, `/pedidos/:id/editar`); cada registro tem endereço próprio, para o push, o compartilhar e o voltar funcionarem.
- **2.9 Guardar estado** (A 2.6, A 2.7, M R2.14): ao voltar ou trocar de aba, a pessoa reencontra rolagem, filtro, busca e seleção. Filtros na URL; reconhecer é melhor que lembrar: onde estou, o que escolhi e para onde posso ir ficam visíveis.
- **2.10 Barra de abas nunca some** ao descer na pilha de uma aba (A 7.5, anti-padrão 9). Somem só nas telas fora da casca (login, checkout, onboarding).

## 3. Tipografia e texto que cresce (ALTA)

- **3.1 Estilos, não tamanhos soltos** (A 3.1, M R4.3): use a escala do tema (`text-sm`, `text-base`, `text-lg`, `text-2xl`, `text-3xl`); a fonte vem da marca, nunca `font-family` no código (A 3.4 vira "fonte da marca").
- **3.2 Cresce com o aparelho** (A 3.2, A 3.3, M R4.1, R4.4): tamanhos em `rem` acompanham a configuração de texto do navegador e da casca; teste mental a 200%: o layout quebra linha, troca linha por coluna, e nunca corta texto essencial (`line-clamp` só em texto secundário, com o completo no detalhe).
- **3.3 Mínimos** (A 3.5, M R4.2): corpo 16 px; nada abaixo de 11 px (rótulo da aba); texto de corpo nunca abaixo de 12 px.
- **3.4 Entrelinha** (M R4.5): 1,2 a 1,5 vez o tamanho.
- **3.5 Hierarquia por peso e tamanho** (A 3.6), nunca só por cor.
- Escala Material de referência (para decidir níveis): título de tela 28 a 32, seção 22 a 24, corpo 16, secundário 14, legenda 12, rótulo 11 a 14.

## 4. Cor e modo escuro (ALTA)

- **4.1 Cores semânticas** (A 4.1, M R1.2, R1.4, R1.5): só tokens (`bg-background`, `bg-card`, `text-foreground`, `text-muted-foreground`, `bg-primary` com `text-primary-foreground`). Texto sempre no par "sobre" do fundo. Cor da marca não vira fundo de área grande; fundo é `background`/`card`.
- **4.2 Claro e escuro** (A 4.2, M R1.7, R1.8, R1.9): os tokens já trocam no modo escuro, que não é preto puro. O dono escolhe claro, escuro ou seguir o sistema, e você grava a escolha em `apps/<slug>/fab.config.json → theme.mode` (`light`, `dark` ou `system`), com a paleta `dark` (`dark: { bg, card, text, primary }`) preenchida, e envia com `fabapp push` (aparece no ar no próximo `fabapp deploy`), sem mexer em CSS. Modo escuro com cor fixa no código quebra: é por isso que cor fixa é proibida.
- **4.3 Nunca só cor** (A 4.3, A 5.6, M R6.8): erro com ícone e texto; status com rótulo (`Badge` "Pago", não só um ponto verde).
- **4.4 Contraste** (A 4.4, M R6.7): 4,5:1 para texto normal, 3:1 para texto grande (24 px, ou 18,5 px em negrito). Texto na cor da marca usa `text-primary-text`.
- **4.5 Hierarquia de fundo** (A 4.6): `background` (superfície), `card` (agrupado), `muted` (dentro do agrupado).
- **4.6 Uma cor de destaque para o que é clicável** (A 4.7, M R1.6): a cor da marca marca botão e link; o acento é raro.
- Paleta dinâmica pelo papel de parede, P3, geração de tons por semente (A 4.5, M R1.1, R1.3, R1.10, R1.11): não se aplica; a paleta vem da marca, gravada por você no `theme` do `fab.config.json` depois da aprovação do dono. A cor de texto AA da marca (`primaryText`) é derivada pela plataforma (não a escreva); o contraste dos pares que você escolhe (`primary` com `primaryFg`, `text` sobre `bg` e `card`, e os mesmos na paleta `dark`) você confere ao escolher, pela regra 4.4.

## 5. Acessibilidade (CRÍTICA)

- **5.1 Nome em todo controle** (A 5.1, M R6.1, R6.2): `aria-label` descrevendo a ação ou o sentido. Decorativo com `aria-hidden`.
- **5.2 Agrupar o que é um item só** (M R6.3): a linha da lista inteira é um link, com o texto dela lido de uma vez.
- **5.3 Ordem lógica** (A 5.2, M R6.10): ordem do código igual à visual; sem `tabIndex` positivo.
- **5.4 Foco depois de navegar** (M R6.11): ao fechar folha ou diálogo, o foco volta a quem abriu (o kit já faz); ao trocar de tela, título no topo.
- **5.5 Negrito e alto contraste** (A 5.3, A 5.5, M R6.9): tokens e pesos da escala respeitam as preferências; nada de texto em imagem.
- **5.6 Menos movimento** (A 5.4): `useReducedMotion` desliga parallax, contadores e entradas decorativas.
- **5.7 Alternativa para todo gesto** (A 5.7, M R6.4, R7.4): o que se faz arrastando ou segurando também se faz por botão ou menu.
- **5.8 Teclado e acionadores** (A 5.8, M R6.12): tudo operável por Tab e Enter; foco visível.
- **5.9 Gráfico acessível** (M R6.13): gráfico sempre acompanhado dos números em texto ou tabela.

## 6. Gestos (ALTA)

- **6.1 Vocabulário padrão** (A 6.1): tocar = ação e seleção; pressionar e segurar = menu de contexto; deslizar na horizontal = apagar, arquivar, voltar; deslizar na vertical = rolar, fechar folha; pinçar = zoom.
- **6.2 Gestos do sistema são do sistema** (A 6.2, M R7.1, R7.2): borda esquerda (voltar), topo (notificações), base (início). Nada interativo nos 20 px de baixo além da barra com área segura; o container `px-6` já afasta das bordas laterais.
- **6.3 Gesto próprio precisa ser descoberto** (A 6.3): alça visual e o mesmo comando num botão ou menu.
- **6.4 Deslizar para apagar** (M R7.3): desfazível (toast com "Desfazer") ou confirmado.
- **6.5 Resposta ao toque** (M R7.5, A 8.7): todo elemento clicável muda de estado no toque (`active:` e o estado de pressionado do kit). Vibração do aparelho não existe no SDK: o retorno é visual.
- **6.6 Segurar nunca é o único caminho** (A 7.7, M R7.6).
- **6.7 Entradas** (A 6.4): toque primeiro, mas teclado físico e acionadores funcionam.

## 7. Componentes (ALTA)

| Precisa de | No app | Regra |
|---|---|---|
| Ação principal da tela | `Button` cheio, largo, embaixo; ou botão flutuante com rótulo | Um por tela (M R5.1 a R5.4); flutuante acima das abas, canto inferior direito |
| Ação secundária | `Button variant="outline"` | (A 7.1) |
| Ação terciária | `Button variant="ghost"` ou link | |
| Excluir | `Button variant="destructive"` + `AlertDialog` | (A 7.1) |
| Decisão crítica | `AlertDialog`, 2 botões, no máximo 3 | Título em pergunta curta, texto explica, cancelar à esquerda (A 7.2, M R5.11 a R5.13) |
| Tarefa curta | `Sheet side="bottom"` | Fechar por botão e por arrastar, alça visível, conteúdo rolável (A 7.3, M R5.8 a R5.10) |
| Aviso breve | `toast` (sonner) | Não crítico, some sozinho, uma ação ("Desfazer"), acima das abas (M R5.14 a R5.16) |
| Lista | linhas de 48 px, `ScrollArea` só se necessário | Ações de linha num menu; deslizar opcional (A 7.4) |
| Busca | `Input` com ícone no topo da lista | Sugestões e buscas recentes quando útil (A 7.6) |
| Menu de contexto | `DropdownMenu` no botão "…" da linha | Nunca o único caminho (A 7.7) |
| Progresso conhecido | `Progress` com % | (A 7.8) |
| Progresso desconhecido | `Spinner` pequeno dentro do botão ou da seção | Nunca tela inteira |
| Escolha entre 2 a 5 | `Tabs` ou `RadioCard` | (A Referência rápida, M SegmentedButton) |
| Liga e desliga | `Switch` alinhado à direita na linha | |
| Filtro | chips em `ScrollRow` | Chip de filtro alterna; nunca empilhados (M R5.17, R5.18) |
| Etiquetas digitadas | `TagsInput` | |
| Cartão | `Card` | |
| Ícones | `lucide-react`, mesmo peso do texto ao lado | Ícone nunca mais pesado que o texto (A 7.9 a 7.11: SF Symbols não existem na web) |

- **7.1 Waiting states** (A 8.8, M R5.19): o toque é reconhecido na hora; depois vem progresso, esqueleto ou resultado parcial. Nunca interface parada enquanto trabalha.

## 8. Padrões (MÉDIA)

- **8.1 Onboarding** (A 8.1): 3 a 5 passos até o primeiro resultado real (a original dizia 3 telas; a Fabapp segue a regra de onboarding da equipe: se a skill `fab-formularios-e-onboarding` estiver instalada, ela manda nisso), "Pular" sempre, login adiado até ser preciso.
- **8.2 Carregando** (A 8.2): `Skeleton` com o formato do conteúdo final.
- **8.3 Abertura** (A 8.3): sem tela de logo; a primeira tela é o próprio app (a casca e o PWA cuidam da abertura).
- **8.4 Modal com parcimônia** (A 8.4): só para concluir ou abandonar uma tarefa focada; saída clara; nunca modal sobre modal (navegue dentro do mesmo).
- **8.5 Notificação só de valor** (A 8.5, M R8.1 a R8.9): avise o que a pessoa quer saber (pedido saiu, horário amanhã, mensagem nova); todo aviso tem `link` para a tela certa; tipos separados que a pessoa pode ligar e desligar numa tela de preferências (guarde em `appUser.fields`); nada de avisar tudo como urgente. Na plataforma: `sendPush` do admin, automação com canal `push`, lembrete com automação `relative` (as automações vão em `fab.automations.json`, com `fabapp pull` antes e `fabapp push` depois). Canais do Android, resposta direta, "marcar como lida" e notificação expandida são da casca, não do app.
- **8.6 Configurações** (A 8.6): as frequentes numa tela dentro de "Perfil"; permissões do sistema ficam nos ajustes do aparelho (explique como chegar lá quando a pessoa negou).
- **8.7 Retorno** (A 8.7): toda ação muda algo na tela (botão, toast, item novo).

## 9. Privacidade e permissões (ALTA)

- **9.1 Na hora certa** (A 9.1, M R9.1): peça câmera, localização e notificação no toque do botão que precisa, nunca na abertura.
- **9.2 Explique antes** (A 9.2, M R9.2): uma tela ou folha curta ("Usamos sua localização só para mostrar as lojas perto de você") com "Permitir" e "Agora não". O pedido do sistema aparece uma vez só; se negar, mostre como liberar nos ajustes.
- **9.3 Negou, segue funcionando** (M R9.3): alternativa real (digitar o endereço, escolher foto da galeria).
- **9.4 Só o necessário** (M R9.4, R9.6, R9.7, A 9.6): não peça o que não usa; localização só no momento; `pickImage()` para escolher foto (não precisa de acesso à galeria inteira).
- **9.5 Conta só quando precisa** (A 9.4): explorar sem conta; exigir login só para comprar, salvar, conversar.
- **9.6 Entrar com Apple** (A 9.3): se o app oferece entrar com Google e vai para a App Store, ponha na lista do que o dono faz no Studio ligar também "Entrar com Apple" no painel e use `SocialAuthButtons providers={['apple','google']}` (Apple primeiro).
- **9.7 Rastreamento** (A 9.5): quem injeta analytics é a plataforma, com o consentimento que o dono configura; o app não escreve rastreamento.
- **9.8 Indicador de câmera ou microfone em uso** (M R9.8): do sistema; o app mostra o estado "gravando" quando grava.

## 10. Integração com o sistema (MÉDIA)

- **10.1 Compartilhar** (A 10.4, M R10.9, R10.10): `share({ title, text, url })` com o link da rota do registro (a plataforma gera o cartão de compartilhamento das rotas).
- **10.2 Links profundos** (M R10.8): cada conteúdo público tem rota própria; push e compartilhamento abrem direto nela.
- **10.3 Interrupções** (A 10.6): ligação ou troca de app não perdem o que foi digitado (rascunho guardado).
- **10.4 Instalar**: `<InstallPrompt/>` (de `@/lib/fab-client`) oferece instalar o PWA e se esconde sozinho quando o app já está instalado. Dentro da casca nativa não faz sentido: renderize-o só quando `!isNativeApp()` (de `@/lib/fab-native`).
- **Não disponíveis** (A 10.1, 10.2, 10.3, 10.5, M R10.1 a R10.7): widgets, atalhos do ícone, Siri e Spotlight, Live Activities. Não prometa; o equivalente possível é notificação com link e o app instalado na tela inicial.

## Lista de conferência

- Layout: alvos ≥ 44 px (48 nos principais); nada sob as áreas do sistema; ação principal na metade de baixo; de 320 a 430 px sem quebrar; espaçamento na grade de 8; conteúdo com largura máxima em tela grande.
- Navegação: 3 a 5 abas com rótulo; sem hambúrguer no celular; título grande no topo; voltar funciona em tudo; estado guardado ao trocar de aba; abas visíveis dentro da pilha.
- Texto: escala do tema em `rem`; aguenta 200%; nada abaixo de 11 px; corpo 16 px.
- Cor: só tokens; modo escuro intencional; nada só por cor; contraste 4,5:1; uma cor para o clicável.
- Acessibilidade: nome em todo controle; ordem lógica; menos movimento respeitado; todo gesto com alternativa; teclado.
- Componentes: diálogo só para decisão crítica; folha fecha por botão e arrasto; linhas de 48 px; exclusão destrutiva confirmada ou desfazível; um botão principal por tela.
- Permissões: pedidas no contexto; explicação antes; alternativa se negar; app útil sem conta.
- Sistema: compartilhar nos conteúdos compartilháveis; toda notificação abre a tela certa; rascunho sobrevive a interrupção.

## Antipadrões (nunca)

1. Menu hambúrguer como navegação principal no celular.
2. Botão voltar próprio que bloqueia o voltar do sistema.
3. Spinner de tela inteira.
4. Tela de abertura com logo.
5. Pedir todas as permissões na primeira abertura.
6. Tamanho de fonte fixo em px que não cresce.
7. Só cor para indicar estado.
8. Diálogo para informação não crítica (use toast ou texto na tela).
9. Esconder as abas ao entrar num detalhe.
10. Conteúdo sob o recorte da câmera ou o indicador de início.
11. Modal sem saída.
12. Gesto sem alternativa.
13. Alvo de toque menor que 44 px.
14. Modal sobre modal.
15. Modo escuro como remendo (cor fixa no código).
16. Barra de abas só com ícones.
17. Dois botões flutuantes, ou flutuante para ação secundária.
18. Conteúdo esticado de ponta a ponta no computador.
19. Bloquear o app porque a pessoa negou uma permissão.
20. Barra de navegação desenhada do zero em vez da casca da plataforma.
