# Diretrizes de interface web (checklist de toda tela)

Itens marcados **[bloqueia]** são HIGH: entram na autorrevisão de "Conferir antes de dizer pronto" e têm de ser corrigidos. Os outros são melhoria aplicada ao escrever. Onde a plataforma já resolve (cabeçalho, fontes, tema, área segura da casca), está dito, e você não escreve nada por cima.

## Acessibilidade

- **[bloqueia]** Botão só com ícone tem `aria-label` com a ação e o objeto ("Excluir pedido PED-0042").
- **[bloqueia]** Todo controle de formulário tem `<label>` (via `<Field label htmlFor>`) ou `aria-label`.
- **[bloqueia]** Ação é `<button>`; navegação é `<Link>`/`<a>`. Nada de `div`/`span` com `onClick`. Elemento interativo próprio (card clicável, linha de tabela) é um `<Link>` ou `<button>` de verdade envolvendo o conteúdo, ou tem `role`, `tabIndex={0}` e `onKeyDown` para Enter e Espaço.
- **[bloqueia]** Imagem de dado com `alt` descritivo; imagem decorativa com `alt=""`. Ícone decorativo com `aria-hidden`.
- Aviso que chega depois (salvo, erro de validação, item adicionado) é anunciado: toast do `sonner` ou `aria-live="polite"`.
- HTML semântico antes de ARIA (`<button>`, `<a>`, `<label>`, `<table>`, `<nav>`, `<main>`).
- Títulos em ordem, um `h1` por tela. Âncora de título usada em link interno tem `scroll-mt-*` para não ficar sob o cabeçalho fixo.
- Vídeo com conteúdo tem legenda ou descrição; controles de mídia funcionam no teclado; mídia decorativa fica oculta para leitor de tela.

## Foco

- **[bloqueia]** Todo elemento interativo tem foco visível (`focus-visible:ring-2 focus-visible:ring-ring`; o kit já traz). `outline-none` só com esse substituto.
- Use `focus-visible` e não `focus` (o anel não aparece no clique do mouse).
- Controle composto (campo com botão dentro, grupo de chips) destaca o grupo com `focus-within:`.
- Cabeçalho fixo, barra de abas de baixo e toasts não cobrem o elemento focado (margem de rolagem `scroll-pb-24` no contêiner que rola, quando há barra inferior).

## Formulários

- **[bloqueia]** Erro aparece ao lado do campo (`<Field error>`), em texto que diz como corrigir ("Informe um e-mail como nome@empresa.com"), e o envio leva o foco ao primeiro campo com erro.
- **[bloqueia]** Botão de enviar fica habilitado até a chamada começar; durante a chamada, `LoadingButton` com spinner e desabilitado (evita pedido duplicado).
- **[bloqueia]** Nunca bloqueie colar (`onPaste` com `preventDefault`).
- Campos com `name` e `autoComplete` certos: `name`, `email`, `tel`, `street-address`, `postal-code`, `current-password`, `new-password`, `one-time-code`. Campo que não é de conta pode ter `autoComplete="off"` para o gerenciador de senhas não se meter.
- `type` e `inputMode` certos: `type="email"`, `type="tel"`, `inputMode="numeric"` para CPF, CEP e código; `inputMode="decimal"` para valor. Data sempre `<DatePicker>`, nunca `<input type="date">`.
- `spellCheck={false}` em e-mail, código, CPF, usuário.
- Caixa de seleção e rádio com o rótulo clicável junto (sem área morta entre os dois).
- Placeholder mostra um exemplo e termina com reticências (`…`): "Ex.: Maria da Silva…". Nunca substitui o rótulo.
- Alterações não salvas: ao sair por um botão do próprio app, peça confirmação com `ConfirmDialog`; ao fechar ou recarregar a aba, `beforeunload`. O `useBlocker` do react-router NÃO funciona neste app (exige roteador de dados); não use.
- `autoFocus` com parcimônia: só no campo principal de um diálogo ou de uma tela de busca no computador; no celular ele abre o teclado sem pedir.
- Campo controlado tem `onChange` (ou use `defaultValue`); o trabalho por tecla é barato. Formulário grande pode usar `react-hook-form` (campos não controlados).

## Animação

- **[bloqueia]** Respeite `prefers-reduced-motion`: use `useReducedMotion()` do kit de motion ou a variante `motion-reduce:`; laço decorativo para quando a pessoa pediu menos movimento.
- **[bloqueia]** Nunca `transition-all` (classe) nem `transition: all`: liste o que anima (`transition-colors`, `transition-opacity`, `transition-transform`).
- Anime só `transform` e `opacity` (o compositor faz sem refazer o layout).
- `transform-origin` certo (menu que abre do botão cresce a partir dele: `origin-top-right`).
- SVG: transforme o `<g>` ou o `div` em volta, com `transform-box: fill-box` e origem no centro.
- Animação interrompível: responde a um novo clique no meio.
- Movimento automático com mais de 5 segundos ao lado de outro conteúdo (carrossel, `Marquee`) tem pausar ou esconder.
- Nunca `animation-timeline` (o Safari ignora e a plataforma proíbe; o `fabapp deploy` não confere, então busque no código); entrada por rolagem usa `<Reveal>`.

## Tipografia e números

- **[bloqueia]** Coluna de número, total, preço, placar e contador usa `tabular-nums` (os dígitos não dançam quando o valor muda).
- Reticências tipográficas `…`, não `...`. Estados de espera terminam em `…`: "Carregando…", "Salvando…".
- Aspas curvas “ ” no texto visível.
- Espaço inseparável onde a quebra separaria número e unidade: `10&nbsp;kg`, `5&nbsp;min`. `formatMoney` já cuida do "R$".
- Títulos com `text-balance` e parágrafos com `text-pretty` (sem palavra sozinha na última linha).

## Conteúdo variável

- **[bloqueia]** Toda lista, tabela e busca tem estado vazio com uma ação (`<EmptyState title action>`), nunca uma área em branco.
- **[bloqueia]** Texto do usuário cabe no pior caso: `truncate`, `line-clamp-2` ou `break-words`; filho de flex com texto tem `min-w-0`.
- Pense no nome curto, no médio e no enorme ("Maria", "Restaurante e Pizzaria Sabor da Vila Madalena Ltda").
- Campo opcional vazio não mostra "undefined", "null" nem rótulo sem valor.

## Imagens

- **[bloqueia]** Imagem de dado (`<img src={registro.photo}>`) tem `width` e `height` ou fica num contêiner com proporção fixa (`aspect-square`, `aspect-video`) e `object-cover`, para a página não pular quando carrega.
- Abaixo da primeira dobra: `loading="lazy"`. A imagem principal da primeira dobra: `fetchPriority="high"`.
- Imagem decorativa é `<AppImage slot prompt>`; nunca `<img>` apontando para banco de imagens.

## Desempenho

- **[bloqueia]** Lista com mais de 50 itens: paginação no servidor, ou virtualização, ou `content-visibility:auto` por item.
- Nada de medir layout (`getBoundingClientRect`, `offsetHeight`, `scrollTop`) durante o render; leitura e escrita de DOM em lote.
- Vídeo curto em loop em vez de GIF animado (`<video autoPlay muted loop playsInline>` com imagem parada de reserva e sem autoplay quando a pessoa pediu menos movimento).
- Fontes, pré-conexão de fontes e cabeçalho são da plataforma: não adicione `<link>` de fonte.

## Navegação e estado na URL

- **[bloqueia]** Ação destrutiva pede confirmação com `ConfirmDialog` (`destructive`) ou oferece "Desfazer" num toast adiando a execução por alguns segundos; nunca apaga direto. Nunca `window.confirm`.
- Filtro, aba, página da lista, ordenação e busca ficam na URL (`useSearchParams` do react-router): recarregar a página e compartilhar o link mostram o mesmo recorte.

```tsx
const [params, setParams] = useSearchParams();
const status = params.get("status") ?? "all";
const pagina = Number(params.get("p") ?? "1");
function trocarStatus(s: string) { setParams(p => { p.set("status", s); p.delete("p"); return p; }, { replace: true }); }
```

- Link é `<Link>`/`<a>` (Ctrl+clique e clique do meio abrem em nova aba); nunca `onClick={() => navigate(...)}` num elemento que parece link.
- Estado que a pessoa gostaria de compartilhar ou reabrir (painel expandido, registro aberto num `Sheet`) também pode ir para a URL (`?pedido=ID`).

## Toque e interação

- `touch-manipulation` em botões e controles que recebem toque rápido (tira o atraso de duplo toque).
- Destaque de toque do navegador definido de propósito (`[-webkit-tap-highlight-color:transparent]` quando o componente já tem estado de pressionado).
- `overscroll-contain` em `Dialog`, `Sheet` e listas roláveis dentro de painel (a página de trás não rola junto).
- Arrastar (lista ordenável com `@dnd-kit`): sem seleção de texto durante o arraste (`select-none`) e com alternativa por botão ou teclado ("Mover para cima").
- Gesto de deslizar, pinçar ou traçar sempre tem alternativa por toque simples e teclado.

## Layout

- Área segura nas bordas fixas (a casca da plataforma já trata a barra inferior; componente fixo seu soma a área segura como a casca faz, por exemplo `pb-[calc(1rem+env(safe-area-inset-bottom))]`).
- Sem rolagem lateral acidental: conserte o conteúdo que estoura; linha que rola de lado é `ScrollRow`.
- Layout com flex e grid, não com medição em JavaScript.

## Tema

- Cor, modo escuro, `color-scheme` e `theme-color` vêm do tema: a paleta e o `mode` ficam em `apps/<slug>/fab.config.json → theme` (chaves em `references/fabapp-cli.md`), enviados com `fabapp push`. No código, use só tokens (`bg-background`, `text-foreground`, `border-border`).
- Seleção usa o `Select` do kit, nunca `<select>` nativo (que fica ilegível no modo escuro do Windows).

## Idioma e formato

- **[bloqueia]** Data, hora e dinheiro sempre por `formatDate`, `formatDateTime` e `formatMoney` (locale do app). Nunca formato montado à mão nem `toISOString().slice(0, 10)`.
- Número grande com `Intl.NumberFormat` no locale do app (`1.234`).
- Nome de marca, código de pedido e identificador técnico com `translate="no"` (o tradutor do navegador não estraga).
- O idioma vem do app (`schema.locale`), não do IP.

## Estados de interação

- Botões e links com estado `hover:` visível.
- Estados de interação aumentam o contraste: hover, pressionado e foco mais marcados que o repouso.

## Texto da interface (em português)

- Voz ativa: "Salve o cliente", não "O cliente será salvo".
- Títulos e botões com só a primeira letra maiúscula (padrão brasileiro), não Title Case.
- Numerais para contagem: "8 pedidos", não "oito pedidos".
- Rótulo de botão específico: "Salvar cliente", "Enviar orçamento", não "Continuar" ou "OK".
- Mensagem de erro diz o que fazer: "Sem conexão. Confira a internet e toque em Tentar de novo."
- Trate a pessoa por "você"; o app não fala de si na primeira pessoa.

## Antipadrões (sempre procurar)

`maximum-scale=1` ou `user-scalable=no` (a plataforma controla o `index.html`; nunca tente mudar), `onPaste` com `preventDefault`, `transition-all`, `outline-none` sem anel de foco, navegação por `onClick` sem `<a>`, `div` ou `span` clicável, imagem de dado sem dimensão, `.map()` de lista enorme sem paginação, campo sem rótulo, botão de ícone sem `aria-label`, data ou dinheiro formatado à mão, `autoFocus` sem motivo, GIF onde cabe vídeo, gesto sem alternativa.
