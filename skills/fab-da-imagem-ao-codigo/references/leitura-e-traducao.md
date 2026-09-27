# Leitura e tradução: fichas, tabelas e checagens

No terminal você vê a imagem de referência: leia cada campo abaixo olhando os pixels da seção, reabrindo o arquivo quantas vezes precisar.

## 1. Ficha de leitura (uma por seção, no plano)

Não é leitura de "clima". Trate a referência como especificação e extraia, de cada seção:

**Identidade da seção**
- o que a seção é (herói, recursos, prova social, preços, FAQ, contato, rodapé, lista, formulário)
- a prioridade visual (o que o olho vê primeiro, segundo, terceiro)
- a ordem dela na página

**Texto** (transcreva o que for legível, literal)
- título do herói, apoio do herói, rótulos dos botões
- títulos de seção, nomes de recursos, rótulos de preço
- nomes e cargos em depoimentos (só se forem do dono)
- itens do menu e do rodapé
- se o texto não estiver legível: peça print maior ao dono na conversa; na construção, registre como incerto

**Tipografia**
- relações de tamanho (o título é quantas vezes o texto?) e de peso
- número de linhas e onde quebram
- sensação de entrelinha (apertada, normal, aberta) e de espaçamento entre letras
- serifa ou sem serifa; contraste entre título e texto
- ritmo dos títulos de seção; tamanho do texto do botão
- tipo calmo ou agressivo
- não achate a tipografia numa hierarquia genérica

**Espaço** (lógica fiel, não medida exata de pixel)
- entre título e apoio; entre texto e botões
- entre cartões; topo e base da seção
- margens laterais; padding interno dos cartões
- entre imagem e texto; espaço do menu; espaço do bloco de chamada final
- cadência entre seções
- se a referência é generosa, o código é generoso

**Botões e componentes**
- tamanho, forma, canto, preenchido ou contorno
- uso de ícone; humor sugerido de hover
- hierarquia principal e secundário
- estrutura de cartão; uso de etiquetas; divisórias; sombras; bordas; lógica de pílula
- estilo de campo, se houver formulário

**Cor**
- fundo, cor dos painéis, destaques, preenchimento de botão
- hierarquia de cor de texto; lógica de cor da borda
- humor da sombra; tom e grade de cor das imagens
- contenção ou intensidade de gradiente
- não troque uma paleta pensada por cores genéricas

**Estrutura**
- lógica de grade (quantas colunas, proporções como 7/5 ou 8/4)
- alinhamento (esquerda, centro, deslocado)
- densidade da seção; ritmo visual; motivos que se repetem e definem a linguagem
- tratamento de imagem e de ícone; lógica de profundidade

**Incertezas**
- o que ainda está pouco claro e como foi resolvido (ordem de resolução do SKILL.md)

O objetivo é entender exatamente POR QUE a referência parece forte.

## 2. Tradução para o código da plataforma

### Espaço (px da referência para a escala Tailwind)
| px | classe | px | classe |
|---|---|---|---|
| 4 | `1` | 40 | `10` |
| 8 | `2` | 48 | `12` |
| 12 | `3` | 64 | `16` |
| 16 | `4` | 80 | `20` |
| 20 | `5` | 96 | `24` |
| 24 | `6` | 128 | `32` |
| 32 | `8` | 160 | `40` |

Seção de 120px ou mais em cima e embaixo na referência: `py-16 sm:py-24 lg:py-32` (a base menor é para o celular). Margem lateral: o contêiner obrigatório `mx-auto max-w-* px-6`; a largura máxima vem da referência (`max-w-5xl` para 1024px, `max-w-6xl` para 1152px, `max-w-7xl` para 1280px).

### Tamanho de texto
| px na referência | classe |
|---|---|
| 12 | `text-xs` |
| 14 | `text-sm` |
| 16 | `text-base` |
| 18 | `text-lg` |
| 20 a 24 | `text-xl` / `text-2xl` |
| 30 a 36 | `text-3xl` / `text-4xl` |
| 48 | `text-5xl` |
| 60 | `text-6xl` |
| 72 ou mais | `text-7xl` / `text-8xl` |

O h1 sempre sobe por tela a partir da base obrigatória da plataforma: título de 72px na referência vira `text-3xl sm:text-4xl lg:text-7xl`; nunca o tamanho de desktop na base. Entrelinha e espaçamento entre letras: `leading-[1.05]`, `tracking-[-0.03em]` etc.; ajuste global dos títulos em `src/app-typography.css` (é arquivo seu e viaja no `fabapp deploy`; dentro de `@layer base`, famílias só por `var(--font-display)` e `var(--font-sans)`, nunca nome de fonte). O espaçamento de letras global dos títulos também pode ir no tema, em `titleTracking`.

### Cantos
O tema define um raio base (`radius` em px, NÚMERO, em `apps/<slug>/fab.config.json → theme`). Controles saem com `rounded-md` (raio menos 2px), cartões com `rounded-xl` (raio mais 4px). Canto que foge disso na referência: classe explícita (`rounded-[2rem]`, `rounded-none`, `rounded-full` para pílula).

### Sombra
Referência plana: sem sombra. Sombra leve: `shadow-sm`. Sombra difusa de estúdio: `shadow-[0_20px_40px_-24px_rgba(0,0,0,0.12)]` (rgba é permitido; hex não). Sombra dura só se a referência for claramente assim.

### Cor pelo papel (nunca hex no código)
| Papel na referência | No tema (`fab.config.json → theme`) | No código |
|---|---|---|
| fundo da página | `bg` | `bg-background` |
| cartão ou painel | `card` (sem ele, segue o `bg`) | `bg-card` |
| painel levemente tingido | derivado | `bg-muted` ou `bg-secondary` |
| texto principal | `text` | `text-foreground` |
| texto secundário | derivado | `text-muted-foreground` |
| botão principal | `primary` (texto sobre ele: `primaryFg`) | `bg-primary text-primary-foreground` |
| texto na cor da marca | derivado (não escreva `primaryText`) | `text-primary-text` |
| destaque suave | `accent` | `bg-accent` |
| bordas | derivado | `border-border` |
| sucesso, aviso, erro, informação | tema (`destructive` para erro) | `text-success`, `text-warning`, `text-destructive`, `text-info` |
| véu sobre foto | nenhum | `bg-black/40`, `from-black/60` |

### Fonte pela aparência (Google Fonts; "só título" = não serve como fonte de texto)

O nome da coluna Título vai em `titleFont` e o da coluna Texto em `bodyFont`, exatamente como no catálogo do Google Fonts.
| Aparência na referência | Título | Texto |
|---|---|---|
| grotesca limpa (estilo interface) | Geist | Geist |
| grotesca refinada | Instrument Sans | Instrument Sans |
| grotesca com personalidade | Bricolage Grotesque | Geist |
| geométrica larga | Unbounded | Geist |
| display condensada de impacto | Anton (só título) | Archivo |
| sans preta monolítica | Archivo Black (só título) | Archivo |
| serifa editorial | Newsreader ou Fraunces | Geist ou Plus Jakarta Sans |
| serifa de luxo alto contraste | Playfair Display ou Bodoni Moda | Plus Jakarta Sans |
| serifa de revista, peso único | Instrument Serif ou DM Serif Display (só título) | Geist |
| suíça racional | Inter Tight | Inter Tight |
| amigável arredondada | Outfit ou Figtree | Figtree |
| mono técnica | a plataforma usa JetBrains Mono na classe `font-mono` | (mono não é fonte de texto) |

### Ícones
O lucide mais próximo, com o mesmo peso de traço em todo o app (`strokeWidth` único). Ícone que não existe no lucide: o mais parecido; nunca invente nome.

### Movimento sugerido pela referência
| Sugestão | No kit |
|---|---|
| texto revelando por rolagem | `TextReveal` |
| seção presa contando uma história | `Pin` |
| blocos subindo em cascata | `Reveal` com `delay={Math.min(i,6)*60}` |
| imagem derivando com a rolagem | `Parallax` |
| acordeão abrindo suave | `Accordion` do kit |
| passagem com fade de cinema | `ScrollScale` com `fade` |
| faixa infinita de logos ou frases | `Marquee` |
| número contando | `Counter` (só número real) |

Nunca `animation-timeline`.

## 3. Motor de combinação (só sem anexo)

Escolha uma combinação coerente e cumpra do começo ao fim. Nada de misturar tudo.

- **Paradigma de tema** (1): claro impecável; escuro profundo; cor sólida de estúdio; neutro premium silencioso.
- **Fundo** (1): grade técnica sutil ou pontilhado; cor sólida com profundidade de luz suave; imagem de cinema em largura total; superfície com textura tátil.
- **Caráter tipográfico** (1): grotesca limpa; grotesca refinada; display expressiva; condensada de impacto; serifa editorial com sans; hierarquia racional suíça.
- **Arquitetura do herói** (1): minimalista centrado de cinema; dividido assimétrico; polaroides espalhadas; tipografia gigante em linha; composição editorial deslocada; imagem enorme com texto contido.
- **Sistema de seções** (1): ritmo de bento modular; blocos editoriais alternados; narrativa empilhada de pôster; cadência de galeria; disciplina de grade suíça; fluxo de marketing assimétrico.
- **Componentes de assinatura** (exatamente 4):

| Componente | Como construir |
|---|---|
| alvenaria quadrada escalonada na diagonal | grade de quadrados `aspect-square` com `sm:translate-y-8` alternado |
| baralho de cartões em cascata 3D | cartões empilhados com `rotate-2`/`-rotate-3` e sobreposição (sem rotação no celular) |
| fatias em acordeão por hover | `flex` de painéis com `hover:flex-[3] transition-all` (no celular, empilhados) |
| bento sem vão impecável | `grid gap-px bg-border` com filhos `bg-background` |
| faixa infinita de marcas | `Marquee` (só logos ou frases reais) |
| arco de polaroides girando | `AppImage` em molduras brancas giradas, `ScrollRow` no celular |
| linhas verticais de ritmo | `border-l border-border` decorativas no contêiner |
| layout editorial fora da grade | blocos com `lg:col-start-*` deslocados |
| pilha de painéis de produto | telas do próprio app em molduras sobrepostas |
| mural de depoimentos dividido | só depoimentos reais do dono; sem eles, marcador para preencher |
| molduras de recorte em camadas | `AppImage` sobrepostas com proporções diferentes |

- **Sugestões de movimento** (exatamente 2), da tabela de movimento acima.

Toda composição escrita comunica: layout, hierarquia, espaço, escala de tipo, prioridade do botão, estilo dos componentes, tratamento de imagem e o sistema de design. Uma pessoa deve conseguir construir lendo só o bloco.

## 4. Pacotes de seções (sem anexo), adaptados a negócio brasileiro

- **4 seções**: herói; serviços ou recursos; prova social; chamada final (WhatsApp, agendar, orçamento).
- **8 seções**: herói; faixa de confiança (formas de pagamento, bairros atendidos, anos de atuação informados pelo dono); recursos; vitrine do produto ou do espaço; benefícios ou casos de uso; depoimentos; preços (só se o dono informou); chamada final.
- **12 seções**: herói; faixa de confiança; grade de recursos; prévia do produto; problema e solução; benefícios; como funciona; números ou integrações (só reais); depoimentos; preços; perguntas frequentes; chamada final e rodapé com endereço, horário, WhatsApp e Instagram.

Faixa de "logos de clientes" só com logos reais que o dono mandar.

## 5. Consistência entre várias referências

Com mais de uma imagem: mesmo mundo de marca, mesma lógica de escala de tipo, mesma disciplina de espaço, mesmo estilo de botão, mesmo humor de ícone, mesmo tratamento de imagem, mesma linguagem de tom, mesma família de componentes. A seção 2, 3 ou 8 não pode virar outro site. Se duas imagens discordarem, vale a mais recente, e isso vira suposição.

## 6. Lista anti-desleixo de IA (proibida salvo pedido explícito)

- **Layout**: colagem ilegível; seções centradas sem fim; fileiras idênticas de cartões seção após seção; blocos texto-esquerda e imagem-direita clonados; complexidade falsa sem hierarquia; espaço vazio decorativo sem propósito; cartão dentro de cartão dentro de cartão; seções inteiras em contêiner arredondado gigante; compartimentos de painel sem motivo.
- **Visual**: gradiente roxo e azul padrão de IA; bordas brilhando demais; manchas flutuando por toda parte; vidro empilhado sem motivo; detalhe futurista sem estrutura; ruído que esconde o layout.
- **Tipografia**: título gigante com apoio minúsculo e fraco; humores de fonte demais; quebras de linha estranhas; caixa alta preguiçosa em tudo; truque de título em gradiente.
- **Texto**: "Eleve", "Transforme", "Revolucione", "Descubra o poder", "próximo nível", "sem complicação", "de forma simples e rápida", "soluções inovadoras", "plataforma transformadora", "sua jornada começa aqui".
- **Marca falsa**: "Empresa X", "Acme", "Nexus", "TechNova" e parecidos; use o nome do dono.
- **Complexidade falsa**: rótulos de controle pseudoempresariais, marcadores de sistema decorativos, microtexto de status de enchimento, jargão de "orquestração" ou "runtime" que não é do negócio.
- **Densidade**: seções entupidas; excesso de cartões; pouco espaço entre seções grandes; paredes de conteúdo cansativas.

Tipografia é material de design: contraste de tamanho claro, ordem de leitura óbvia, momentos de display fortes, texto legível, texto conciso, títulos de seção que reforçam a estrutura. Em direção editorial, a tipografia molda a composição; em produto e tecnologia, comunica confiança e precisão.

## 7. Checagem de clareza (antes de dizer pronto)

1. A referência (imagem, export ou composição escrita) veio antes do código?
2. Todas as referências foram lidas a fundo, seção a seção?
3. Os textos foram transcritos? Onde não deu, pedi print maior ou registrei?
4. Pedi prints suficientes, ou aceitei uma imagem comprimida demais?
5. Pedi print novo da seção em vez de trabalhar com recorte pequeno?
6. A hierarquia é óbvia?
7. O herói está limpo o bastante?
8. A tipografia foi analisada de verdade?
9. As relações de espaço foram entendidas?
10. Botões e componentes foram extraídos?
11. As cores foram extraídas por papel?
12. O resultado é visualmente marcante?
13. Está livre dos sinais óbvios de IA da lista 6?
14. Dá para reconhecer a referência no app pronto?
15. Várias referências parecem do mesmo site?
16. A análise foi limpa, estruturada e específica?
17. As caixas aninhadas desnecessárias saíram?
18. A primeira tela está limpa e legível num notebook pequeno?
19. Pílulas, rótulos e microelementos técnicos falsos foram reduzidos?
20. Os fatos da imagem (depoimentos, números, logos) são do dono ou viraram marcador?
21. O que difere da referência está explicado na mensagem final ao dono, com o motivo?

## 8. Exemplos de interpretação

**"Faz o herói igual a este print" (1 imagem de herói)**: ler título, apoio, botão, espaço, cores e a imagem principal; se o título não estiver legível, pedir print na tela cheia; herói calmo e legível, sem rótulos de sistema nem cartões aninhados; construir só o herói e conferir contra a ficha.

**"Quero o site com estas 8 partes" (8 prints)**: uma ficha por print; se uma seção ficou ilegível, pedir de novo só aquela; sistema de design extraído uma vez; seções abertas, sem caixa em volta de tudo; construir as 8 na ordem e conferir uma a uma.

**"Site premium de estúdio criativo, 4 seções, sem imagem"**: composição escrita com uma combinação do motor, 4 blocos de seção com detalhe no herói; herói muito limpo; sem pílulas de enfeite; construir a partir dos 4 blocos e conferir cada um.
