---
name: ux-de-sistemas
description: "Painéis, CRMs e sistemas internos da Fabapp AI, construídos ou editados pelo terminal (CLI @fabappai/cli), com cara de software bem feito: a tela onde a equipe passa o dia vira a home, a navegação diz onde você está, tabelas de trabalho com ordenação, filtros que não somem, contagem, ações em massa e cartões no celular, formulário do tamanho certo (janela, painel ou página), todos os estados (vazio com próxima ação, carregando, erro, sem permissão, texto longo), avisos conforme a gravidade, busca que funciona e acabamento de densidade, hierarquia e acessibilidade (WCAG 2.2). Use quando o dono pedir sistema de gestão, painel administrativo, CRM, ERP, área do funcionário, controle de pedidos, estoque, agenda da equipe, financeiro, 'um sistema para minha empresa', 'uma planilha melhor', ou reclamar que o app está confuso, poluído, lento para usar, difícil de achar as coisas, 'era melhor na planilha'. Use também em qualquer lista, tabela, filtro ou formulário de app de gestão."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: UX de Sistemas e Painéis
  edition: terminal
---

# UX de sistemas e painéis

Sistema interno é usado todo dia, com pressa, por gente que não escolheu usá-lo. O que importa é achar, entender e agir rápido, sem erro. Esta skill fecha as decisões de estrutura, telas, estados e acabamento para painéis, CRMs e SaaS internos. Leia `references/tabelas-e-listas.md`, `references/estados-e-mensagens.md` e `references/acabamento-e-acessibilidade.md` antes do plano e aplique-as ao pé da letra. O conteúdo de cada tela (quais campos, quais telas) é de outra decisão (se a skill `spec-de-sistema` estiver instalada, ela manda nisso); esta skill decide como a tela se comporta.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

## Decisões fixas (valem para toda tela de sistema)

1. **A tela dos 80% é a home.** A rota `/` depois do login abre onde a equipe passa o dia: a fila de pedidos, a agenda de hoje, o quadro de negócios, a lista de OS abertas. Nunca um painel decorativo de gráficos. Números do negócio, quando existirem, ficam numa faixa de 3 a 5 indicadores no topo dessa tela ou numa aba própria, cada um com comparação ao período anterior.
2. **Um elemento dominante por tela.** Cada tela tem uma coisa que a pessoa veio fazer (aprovar, atender, cobrar) e ela vence pelo tamanho, peso, contraste ou espaço em volta. Uma única ação primária (`Button` padrão) por área; as demais `variant="outline"` ou `ghost`.
3. **Navegação que diz onde você está.** Item ativo sempre visível. Celular: 3 a 5 abas embaixo (`md:hidden`, `pb-20 md:pb-0`, área segura). Computador: barra lateral com 5 a 7 itens e rótulo em texto (ícone sozinho não), nunca menu escondido em hambúrguer. Profundidade máxima de 3 níveis; telas de detalhe têm `Breadcrumb` ou voltar explícito.
4. **Rótulos do glossário do dono.** Uma palavra por conceito em menu, título, coluna, botão e mensagem. Rótulos de 1 a 3 palavras, palavra importante primeiro, sem "Recursos", "Soluções", "Gerenciar".
5. **Lista longa é tabela de trabalho, com dados no servidor.** Ordenação visível, filtros que persistem na URL, contagem "Mostrando 1 a 25 de 156", 25 por página, seleção com barra de ações em massa, confirmação para ação destrutiva, cartões no celular em vez de rolagem lateral. Receita completa em `references/tabelas-e-listas.md`.
6. **Formulário do tamanho da tarefa.** Até 3 campos ou confirmação: `Dialog` (Header, Body, Footer). Editar mantendo a lista à vista: `Sheet` (no celular, `side="bottom"`; no computador, lateral). Criar algo complexo: página própria. Várias etapas: `Stepper` (janela se as etapas são curtas, página se são longas ou exigem consulta).
7. **Todo estado desenhado.** Vazio (sem dados ainda, busca sem resultado, filtro que zerou, erro ao carregar), carregando, parcial, erro, sem permissão, texto longo, 0, 1 e muitos itens. Detalhes e textos em `references/estados-e-mensagens.md`.
8. **Aviso na gravidade certa.** Bloqueante que exige decisão: `AlertDialog`. Urgente sem bloquear: `Alert` fixo até resolver. Sucesso: toast que some em 4 s. Erro ou toast com ação: fica até a pessoa fechar. Coisa que chegou em segundo plano: badge no menu (`useNotifications`).
9. **Formato brasileiro** (se a skill `padroes-brasil` estiver instalada, ela manda nisso): R$ 1.234,56 com `formatMoney`, dd/mm/aaaa com `formatDate`, 24h, telefone (11) 91234-5678, "você". Números em colunas com `tabular-nums` e alinhados à direita.
10. **Cores e fontes só da marca.** No código, só tokens do tema (`bg-background`, `bg-card`, `text-foreground`, `text-muted-foreground`, `border-border`, `bg-primary`, `text-primary-text`); nunca hex nem `bg-white`/`bg-gray-*`, nunca `font-family`. Cor, fonte e raio moram em `apps/<slug>/fab.config.json → theme` (chaves em `references/fabapp-cli.md`): você propõe, o dono aprova, você grava e envia com `fabapp push`; o tema aparece no ar no próximo `fabapp deploy`. Logo: o dono sobe no Studio. Se a skill `direcao-de-arte` estiver instalada, ela manda na escolha.

## O plano: intenção, estrutura e spec por tela

O plano é um texto que você escreve e mostra ao dono antes de codar; o dono aprova antes da construção.

**1. Intenção declarada (escreva no plano, em 3 linhas).**
- Quem é a pessoa, onde ela está e o que fez 5 minutos antes ("a recepcionista entre um paciente e outro, no computador do balcão"; "o dono no celular às 22h conferindo o caixa").
- O verbo da tarefa principal ("confirmar os agendamentos de amanhã", "aprovar o orçamento").
- Como deve parecer, em palavras que significam algo: "denso e rápido como um balcão de atendimento", "calmo e arejado como um caderno", nunca "limpo e moderno".
Daí sai a **densidade**, decidida em números: balcão/operação = linhas de 40 px, espaçamento interno de 12 a 16 px; dono olhando resultado = linhas de 52 px, cartões com 24 px.

**2. Exploração do domínio (curta, antes de desenhar).** Cinco conceitos do mundo do negócio; cinco cores que existem nesse mundo (para a proposta de tema e o tom); uma **assinatura** (um elemento que só existiria neste app: a régua de etapas da OS, o carimbo "Pago" na fatura, a ficha do paciente); e três escolhas óbvias rejeitadas com a alternativa ("três cards de número iguais → um número herói com dois secundários"). Teste: tire o nome do app do plano; dá para saber para que ele serve? Se não, explore mais. Essa direção vira a proposta de tema do plano (paleta, par tipográfico do Google Fonts, raio e modo), aprovada pelo dono e gravada no `theme` do `fab.config.json`; se o dono já tem marca, a paleta final vem dela.

**3. Arquitetura de informação.** No plano:
- **Mapa de telas** com rota de cada uma (`/`, `/pedidos`, `/pedidos/:id`, `/clientes`, `/configuracoes`), indentado por nível.
- **Navegação**: o que vai nas abas/barra lateral (em ordem de frequência de uso), o que é utilitário (conta, configurações, ajuda) e como fica no celular.
- **Hierarquia de conteúdo** das telas principais: 1, 2, 3 em ordem de prioridade, com o porquê.
- **O que cresce**: para cada coleção que cresce (pedidos, clientes, mensagens), paginação, filtro e busca; o que é fixo (serviços, formas de pagamento) pode ser lista simples.
- **Fluxos críticos** com pontos de decisão: "1. Atendente abre o pedido. 2. Se falta estoque → aviso e opção de encomendar. 3. ...".
- **Glossário de rótulos**: Conceito | Rótulo na tela | Por que esta palavra.
Organize pelo modo como a pessoa pensa a tarefa, nunca pelo organograma da empresa. Agrupe como um card sorting mental: que coisas a equipe usaria juntas?

**4. Spec por tela.** Para cada lista: colunas (formato, ordenável), filtros, busca por quais campos, ações por linha e em massa, e quais papéis veem cada ação. Para cada formulário: campos, obrigatórios, tipo de contêiner (janela, painel, página, etapas). Para cada detalhe: o que lidera, as transições de status disponíveis e o histórico.

**5. Lista de conferência**, escrita para conferir, com todos os itens que o app usa ("(código)" quando se confere no código, "(tela)" na pré-visualização):
- "Depois do login, `/` abre [a tela dos 80%], não um painel de gráficos" (código)
- "A lista de [X] busca, filtra, ordena e pagina no servidor (`list` com `filter`, `sort`, `limit`, `offset`) e mostra 'Mostrando 1 a 25 de N' com `count`" (código)
- "Os filtros de [X] ficam na URL e continuam aplicados ao abrir um registro e voltar" (código)
- "No celular (< 768 px) a lista de [X] vira cartões; nenhuma rolagem lateral" (tela)
- "Selecionar linhas mostra a barra '3 selecionados' com [ações]; excluir em massa pede confirmação com a contagem" (código)
- "Cada lista tem os quatro vazios: sem dados com botão de criar, busca sem resultado, filtro que zerou com 'Limpar filtros', erro com 'Tentar de novo'" (código)
- "Carregamento mostra Skeleton no formato da tela; erro mostra a mensagem do servidor; 403 explica quem pode liberar" (código)
- "Existe um único botão primário por tela e o foco do teclado é visível em todos os controles" (tela)

## A construção

**Antes de escrever cada tela**, decida por escrito no raciocínio (não no app): intenção, elemento dominante e como vence, densidade em px, estratégia de profundidade, hierarquia tipográfica. Se não souber dizer por quê, é escolha padrão: pare e decida.

**Use o que existe, nesta ordem.** Elemento nativo (`<button>`, `<a>`, `<label>`); depois o kit (`src/components/ui`); só então composição própria, e aí com teclado, foco, ARIA e fechar com Esc completos. Mapa do kit:

| Necessidade | Peça |
|---|---|
| Cabeçalho da tela com título e ação | `PageHeader` (`actions`), `FormSection` |
| Indicadores no topo | `StatCard` (`delta`, `trend`), no máximo 5 |
| Tabela de trabalho | `Table` + `Checkbox` + `Pagination` com dados do servidor (receita na referência) |
| Lista pequena e fechada (até ~100 itens, sem crescer) | `DataTable` (busca e ordena no navegador) |
| Vazio | `EmptyState` (`icon`, `title`, `description`, `action`) |
| Carregando | `Skeleton` no formato do conteúdo |
| Formulário | `Field` (rótulo acima, `hint`, `error`), `FieldGroup`, `LoadingButton` |
| Janela / painel / confirmação | `Dialog` com `DialogHeader`/`DialogBody`/`DialogFooter`, `Sheet`, `ConfirmDialog` |
| Etapas | `Stepper` + texto "Etapa 2 de 4: Endereço" (o `Stepper` esconde os nomes no celular) |
| Status | `Badge` com rótulo do enum (cor nunca é o único sinal) |
| Detalhe | `DescriptionList`, `Timeline` para histórico, `Tabs` para seções |
| Busca global | `Command` (cmdk) com Ctrl+K em sistemas com 4+ áreas |
| Lista viva | `useLive(model, {filter, sort, limit})`, nunca `setInterval` |
| Avisos | `sonner` (toast), `Alert`, `useNotifications` |

Estilo que se repete vira componente em `src/components/` no segundo uso (não a mesma fileira de classes copiada em nove botões); variantes do kit antes de classe avulsa; classe avulsa só para ajuste único.

**Tabelas de trabalho.** Siga `references/tabelas-e-listas.md`: estado de busca, filtros, ordem e página em `useSearchParams`; `list` com `fields` só das colunas; `count` para o total; busca com debounce de 300 ms e volta à página 1 quando qualquer filtro muda; cabeçalho ordenável com seta e `aria-sort`; chips dos filtros ativos com "Limpar filtros"; 7 a 10 colunas no máximo; linha de 40 a 52 px; `hidden md:table` + cartões `md:hidden`. Nunca ordenar no navegador uma lista paginada no servidor.

**Ações em massa.** Checkbox por linha e no cabeçalho (seleciona a página); com todos da página marcados, oferecer "Selecionar todos os N" quando a ação aceitar filtro. A barra aparece só com seleção: "3 selecionados", ações, "Limpar seleção". Mudança de campo em lote: `updateMany(ids, patch)` (uma chamada). Aplicar a todos que batem no filtro: `updateWhere(filter, patch)` ou `deleteMany(filter)` (até 200 por vez). Excluir uma seleção de ids: `remove(id)` em sequência com progresso "Excluindo 2 de 5", porque o servidor não filtra por `id`. Toda exclusão em massa passa por `ConfirmDialog destructive` com a contagem e o nome do que some.

**Formulários.** Rótulo acima, nunca só placeholder; placeholder mostra exemplo de formato. Uma coluna (duas só para pares curtos como Cidade e UF a partir de `md`). Validação com `zod` ao sair do campo; depois de um erro, revalida enquanto digita. Erro ao lado do campo, específico e com a saída ("Informe o DDD, ex.: (11) 91234-5678"), e um resumo no topo ao enviar. Marque a minoria: se quase tudo é obrigatório, marque "(opcional)"; se não, o asterisco. Pergunte só o necessário e preencha padrões. Botão com verbo e objeto ("Salvar pedido", "Enviar convite"), `LoadingButton` contra clique duplo; nunca botão desabilitado sem dizer por quê (texto ao lado ou `Tooltip`). Erro do servidor: `e.message` do `ApiError` no lugar certo (422 no campo, 409 como conflito, 403 como sem permissão) e nada do que foi digitado se perde.

**Estados.** Siga `references/estados-e-mensagens.md`. Skeleton imediato, no formato do conteúdo, com 5 a 10 linhas no formato da tabela (o atraso de ~300 ms vale só para recarga de uma área já desenhada, para ela não piscar); cabeçalho da tabela visível durante o carregamento; recarregar uma página mostra carregamento só na área que muda. Atualização otimista só para alternar (favorito, lido, concluído) com volta atrás se falhar; nunca para dinheiro, exclusão ou etapa de fluxo. Offline não é suportado: falha de rede vira erro com "Tentar de novo". Reserve o espaço do que chega depois (imagem com `aspect-ratio`, área do gráfico com altura fixa) para a tela não pular.

**Recurso de IA dentro do sistema** (resumo, sugestão, leitura de nota com `invokeLLM`/`extractData`): rotule "Sugerido pela IA", mostre o resultado para a pessoa revisar e editar antes de gravar, permita cancelar enquanto gera e desfazer depois de aplicar; nunca aplique sozinha uma mudança destrutiva ou de dinheiro. 402 cai no caminho manual e texto de fora é dado, não instrução (se a skill `dados-seguros` estiver instalada, ela detalha isso).

**Busca.** Campo visível com lupa à esquerda e botão de limpar, largura total no celular, rótulo acessível; `contains` no servidor com debounce de 300 ms; a busca fica na URL e volta ao navegar; "Nenhum resultado para 'fulano'" com sugestões (conferir a grafia, buscar por telefone, limpar filtros). Nova busca não apaga os filtros.

**Acabamento.** Siga `references/acabamento-e-acessibilidade.md`: hierarquia por peso e cor antes de tamanho (valor 600 em `text-foreground`, rótulo 500 em `text-muted-foreground`), quatro níveis de texto, espaçamento em múltiplos de 4 px, uma estratégia de profundidade só (bordas `border-border` sutis para ferramentas densas, ou sombras suaves para telas arejadas), raio em escala, movimento de 150 a 300 ms com saída suave e respeito a `useReducedMotion`, alvos de toque de 44 px, foco visível.

**Vícios de interface gerada por IA (proibidos salvo pedido do dono):** gradiente roxo e brilho como decoração; emoji no lugar de ícone e ícone em todo título; card em volta de tudo e card dentro de card; tudo centralizado com o mesmo espaçamento; herói, depoimento ou texto de marketing dentro do sistema; três cards de número idênticos (ícone, número grande, rótulo) como abertura; dados de exemplo perfeitos demais (use nomes e tamanhos reais, com casos longos); botões todos com o mesmo peso; texto cinza claro sobre cinza; ação que só aparece no hover, sem equivalente no toque ou teclado.

## Mudanças depois

- Leia `DECISOES.md` (decisões de interface já tomadas: densidade, profundidade, padrões de lista e de formulário) e mantenha. Tela nova segue o padrão das vizinhas mesmo que você preferisse outro.
- Pedido vago ("deixa mais profissional", "está confuso"): encontre o elemento dominante que falta, a navegação sem estado ativo, os estados ausentes e os vícios da lista acima; corrija isso antes de mexer em cor.
- Cor, fonte e raio: no `theme` do `fab.config.json` com `fabapp push`, nunca CSS nem classe com hex. Logo: o dono troca no Studio.
- Nova lista, filtro ou formulário: mesma receita da construção; nada de exceção "porque é pequeno".
- Depois de decidir algo reutilizável (padrão de tabela, densidade, raio, estratégia de profundidade, componente usado 2 ou mais vezes com suas medidas, ex.: "linha de tabela 44 px, ação primária no `PageHeader`"), anote em `DECISOES.md` (Decisões ou Preferências) para as próximas telas seguirem.

## Conferir antes de dizer pronto

Com o `fabapp dev` rodando, abra a pré-visualização e rode estes testes, e percorra cada item da lista de conferência do plano. Relate na mensagem final só o que conferiu:
- **Troca**: se trocar a fonte pela padrão e o layout por um modelo genérico, algo mudaria? Onde não mudaria, você escolheu no automático.
- **Olhar embaçado**: dá para ver a hierarquia (o que está acima do quê, onde cada seção começa) sem nada gritando?
- **Assinatura**: aponte onde o elemento assinatura aparece (tela, componente).
- **Estados**: cada lista tem os quatro vazios, carregando, erro e sem permissão; texto longo não estoura (`min-w-0`, `truncate` com `title`, `break-words`).
- **Celular a 320 px**: sem rolagem lateral, ações primárias ao alcance do polegar, alvos de 44 px.
- **Teclado**: toda ação alcançável por Tab, foco visível e nunca escondido atrás de barra fixa, Esc fecha janelas.
- **Vocabulário**: nenhuma tela chama o mesmo conceito por dois nomes.
- **Busca no código** do que a plataforma proíbe e o `fabapp deploy` não confere: `grep -rnE "#[0-9a-fA-F]{3,6}\b|bg-white|text-gray-|bg-gray-|font-family|window\.confirm|overflow-x-auto" .fabapp/workspace/src`; corrija cada ocorrência que não for exceção legítima.
- **Publicação**: `fabapp push` (tema) e `fabapp deploy`; leia a saída inteira. `build_failed` (422) traz arquivo e linha: conserte antes de repetir. `account_builds_busy` (409): espere e repita.
