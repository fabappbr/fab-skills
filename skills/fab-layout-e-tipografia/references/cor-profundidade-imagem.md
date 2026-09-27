# Cor, profundidade, imagem e movimento fino

## Cinza primeiro, cor por último
Construa a tela só com os neutros do tema e resolva a hierarquia com tamanho, peso e espaço. A cor entra por último e com trabalho definido. Se a tela só se entende com cor, ela está usando a cor como muleta.

## Os papéis de cor (todos por token)
- Texto em três níveis: principal `text-foreground`, apoio `text-muted-foreground`, terciário (legenda, desabilitado) `text-muted-foreground` em tamanho menor. Não use opacidade baixa em texto que precisa ser lido.
- Superfícies: `bg-background` (página), `bg-card` (elevado), `bg-muted` (zona recuada, hover, trilho); tom da marca `bg-primary/5` a `bg-primary/10`.
- Ação, seleção e foco: `bg-primary` + `text-primary-foreground`; texto na cor da marca `text-primary-text`; anel `ring-ring`.
- Bordas: `border-border` (sutil); campo de formulário já vem do kit.
- Erro: `text-destructive`, `bg-destructive/10`. Sucesso, aviso e informação têm token próprio no tema: `text-success`, `text-warning`, `text-info` (e `bg-success/10` etc.), só em status e sempre com ícone ou texto junto. Nada de `text-emerald-*`, `text-amber-*` nem `dark:` com cor fixa.
- Os neutros do tema já saem levemente tingidos pela marca (frio ou quente); é isso que tira o ar "sem vida" do cinza puro. Nunca misture cinza frio e quente fixos no código.

Significados que não se contrariam: vermelho só para erro e ação destrutiva (nunca num botão principal que não destrói nada); verde não serve para erro (daltonismo); cor pouco saturada não serve para ação importante; no máximo 3 cores de destaque na interface. A cor da marca em si é decisão do dono: você propõe a paleta no `theme` de `apps/<slug>/fab.config.json`, ele aprova e você grava (SKILL.md, "A marca no tema"). No código, esta skill só decide onde ela aparece.

## Contraste
Texto de corpo 4,5:1; texto grande (18px ou mais, ou 14px negrito) 3:1; componentes de interface (borda de campo, ícone que informa, foco) 3:1. Nunca cinza sobre fundo colorido: sobre `bg-primary` use `text-primary-foreground` (ou `/80` para apoio). Informação nunca só pela cor: junte ícone, texto ou forma. Ao propor a paleta do `theme`, confira estes números nos pares que você grava: `text` sobre `bg` e sobre `card`, `primaryFg` sobre `primary`, também na paleta `dark`.

## Modo escuro
O `theme` compõe claro e escuro: `mode` (`light`, `dark` ou `system`) e a paleta `dark: { bg, card, text, primary }`, que você grava junto com a clara. O código só usa tokens e os dois funcionam. Não inverta à mão, não fixe preto puro nem branco puro, não use `dark:` com cor fixa para "consertar" um token. O que o código ainda decide no escuro: elevação por superfície mais clara (o `bg-card` já faz), sombra quase invisível (não conte com ela para separar), foto decorativa pode ganhar `dark:brightness-90`. Confira no escuro: texto legível, hierarquia clara, foco visível, campos visíveis, erro e sucesso distintos, carregando visível, ícones visíveis, cor da marca reconhecível.

## Profundidade e sombra
- A sombra diz altura: pequena = pouco acima (botão, card que se destaca), grande = flutuando (menu, diálogo, popover).
- Escala: `shadow-sm` em card (teto para cards; produtos de referência são quase planos); `shadow-md` em card ao passar o mouse, se houver; `shadow-lg` em menu e popover; `shadow-xl` em diálogo (o kit já aplica nos flutuantes).
- Boa sombra tem duas partes (uma curta e nítida, outra larga e suave); as do Tailwind já são assim. Cor da sombra é escuro transparente, nunca cinza opaco. Uma direção de luz só (de cima).
- Se tudo flutua, nada tem profundidade: use pouco.
- Profundidade sem sombra: superfície mais clara sobre fundo recuado (`bg-card` em `bg-muted`), borda fina, gradiente sutil do tom da marca (`bg-gradient-to-b from-primary/10 to-transparent`), sobreposição de elementos.

## Imagens
- Decorativa: `<AppImage slot="..." prompt="..." alt="...">`, uma por linha, nunca dentro de `.map()`. O CLI não gera imagem: o dono troca ou gera cada slot no Studio (a troca grava o `src` na tag pela linha); depois das trocas, publique o que é seu e rode `fabapp dev --reset` antes de editar de novo. Nunca `<img>` com URL de banco de imagens ou de outro site. Imagem de dado vem do campo `image`/`list` do registro.
- Nunca esticar: proporção fixa (`aspect-[4/3]`, `aspect-video`, `aspect-square`) com `object-cover` e recorte pensado. A proporção reservada também impede a página de pular ao carregar. Imagem de dado abaixo da primeira dobra com `loading="lazy"`.
- Texto sobre foto precisa de véu: gradiente `bg-gradient-to-t from-black/60 to-transparent` com `text-white`, ou véu inteiro `bg-black/40`, ou caixa sólida atrás do texto, ou foto com área calma onde o texto fica.
- Avatar: sempre com alternativa de iniciais (`AvatarFallback`); tamanho fixo por contexto: 32px em lista (`size-8`), 48px em card (`size-12`), 96px em perfil (`size-24`); redondo para pessoa, quadrado arredondado para empresa ou produto; avatares sobrepostos com `ring-2 ring-background`.
- Ícones (`lucide-react`): tamanho pelo texto ao lado: texto de 12 a 14px → 16px (`size-4`); 16px → 20px (`size-5`); 18 a 20px → 24px (`size-6`); ícone de destaque 32px (`size-8`). Ícone e texto alinhados ao centro com `gap-2`. Um conjunto só, mesmo traço. Use ícone em navegação, ação comum (editar, excluir, compartilhar) e status; não use para encher espaço, em botão cujo texto já é claro, ou como enfeite sem sentido.
- Estado vazio é oportunidade: ilustração ou ícone próprio mais a ação que tira do vazio.

## Movimento fino (microinterações)
Animação serve para dar retorno, orientar (de onde veio, para onde foi), chamar atenção para uma mudança, ensinar ou manter o contexto numa troca de estado; encantar só de vez em quando. Não serve para "ficar legal", copiar o concorrente, animar toda mudança ou disfarçar lentidão.

| Tipo | Duração |
|---|---|
| retorno imediato (hover, toque) | 100 a 150ms |
| transição simples (aparecer, deslizar) | 150 a 250ms |
| transição complexa (diálogo, navegação) | 250 a 350ms |
| entrada de conteúdo | 200 a 400ms |
| ênfase | 300 a 500ms |

A maioria fica perto de 200ms: abaixo de 100ms não se percebe, acima de 400ms parece lento (carregamento e progresso podem ser mais longos, porque são espera real). Distância maior pede um pouco mais de tempo: 8 a 16px em 100 a 150ms, 50 a 100px em 150 a 250ms, tela inteira em 250 a 350ms.

Curvas: `ease-out` para o que entra, `ease-in` para o que sai (e sai mais rápido), `ease-in-out` para o que se move dentro da tela, `linear` só em progresso e opacidade contínua. Nada de quique.

Padrões: botão `transition-colors duration-150` e `active:scale-[0.97]`; diálogo, menu e aviso (`sonner`) já animam pelo kit; entrada de lista com `<Reveal delay={Math.min(i,6)*60}>` de `@/components/ui/reveal` (o atraso é você quem passa, 60ms por item até o sexto; escalonamento de 0 a 50ms parece um bloco só, acima de 100ms parece lento); carregando: `Spinner` só depois de 300 a 500ms de espera (espera menor que 1s nem precisa), barra de progresso quando se sabe o avanço (nunca volta, termina em 100% antes de sumir), `Skeleton` com o formato do conteúdo, brilho discreto, trocado pelo conteúdo assim que chega.

Sempre: `useReducedMotion` de `@/components/ui/motion` (reduzir deslocamento, manter a mudança de opacidade e cor que dá sentido); nada que pisque; nada de rolagem com parallax forte, vídeo automático ou laço infinito decorativo; animar só `transform` e `opacity`; sem `animation-timeline` (o Safari ignora e o efeito some; confira por `grep` antes do deploy). A interface precisa funcionar sem a animação.

## Acessibilidade de estrutura
- Títulos em ordem, marcos (`header`, `nav`, `main`, `footer`), listas e tabelas de verdade (`th` no cabeçalho).
- Foco: ao abrir diálogo, foco no primeiro campo; ao fechar, volta ao botão que abriu (o kit faz); ao dar erro no envio, foco no primeiro campo com erro; ao carregar conteúdo novo, no título dele; ao excluir um item, no vizinho.
- Grupo de abas ou opções navegável por setas (o kit Radix já faz).
- Mudança de estado anunciada: região `aria-live="polite"` para "Salvo", "3 resultados".
- Ícone decorativo com `aria-hidden`; botão só com ícone com `aria-label` que diz o objeto ("Excluir comentário de Ana").
- Zoom de 200% sem perder conteúdo; nada rola de lado a 320px.
