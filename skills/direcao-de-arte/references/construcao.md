# Receitas de construção (tipo, composição, movimento, assinatura, edição)

## Os três dials em classes

Os valores vêm do plano aprovado pelo dono e anotado no `DECISOES.md` (escala de 1 a 10). Cada faixa liga regras concretas.

**Variância (sóbrio a ousado)**
- 1 a 3: grade simétrica, colunas iguais, alinhamento central permitido, paddings iguais.
- 4 a 7: deslocamentos (uma imagem sobe sobre a seção seguinte com `-mt-8`), proporções de imagem misturadas (4:3 ao
  lado de 16:9 com `aspect-[4/3]` e `aspect-video`), títulos alinhados à esquerda sobre dados centrados. Herói
  centralizado evitado acima de 4 (exceção: manifesto ou anúncio em que a frase É o design).
- 8 a 10: assimetria forte (`md:grid-cols-[2fr_1fr]`, `md:grid-cols-[1fr_2fr_1fr]`), vazios grandes
  (`md:pl-[12vw]`), sobreposições, empilhamento com `Pin`.
- Sempre: abaixo de `md` tudo vira uma coluna (no máximo 2 colunas na base, com `min-w-0`), declarado no próprio
  componente, sem contar com o Tailwind "resolver".

**Movimento (parado a animado)**
- 1 a 3: nenhuma animação automática. Só `transition-colors` e `transition-transform` de 150 a 250ms em hover, foco e
  toque, e `active:scale-[0.98]` em botão e card clicável. Página inicial pública ainda ganha um sinal de vida: um único
  `Reveal` na primeira seção abaixo do herói basta.
- 4 a 7: `Reveal` só nos pontos da narrativa (não em toda seção), stagger de linha curta com
  `delay={Math.min(i,6)*60}`, um momento orquestrado na primeira dobra (`TextReveal` no título, ou `ScrollScale` na foto
  principal), transições de 300 a 500ms em abrir e fechar.
- 8 a 10: kit completo onde a narrativa pede: `Parallax` na imagem de fundo, `Pin` para um processo em capítulos,
  `ScrollScale`, `TextReveal`, `Counter` só com número real, `Marquee` no máximo um por página. Tudo do kit já
  respeita movimento reduzido; transição feita à mão leva `motion-reduce:transition-none`.
- Movimento declarado é movimento entregue: se não couber fazer direito, baixe o dial para 3 e entregue parado e limpo.
- Todo movimento se justifica numa frase: hierarquia (levar o olho ao que importa), narrativa (revelar na ordem da
  história), retorno de ação ou mudança de estado. "Ficou bonito" não é motivo.
- Material do movimento pelo significado: continuidade com transformação de posição e escala; foco com desfoque ou
  sombra limitados; revelação com máscara ou recorte (`clip-path` simples); estado com a menor mudança que deixa causa
  e efeito claros. Evite animar largura, altura, topo e margem. O conteúdo fica visível por padrão: animação que falha
  não pode esconder a página. Stagger só quando a lista aparece como lista, com atraso total limitado.
- Interação que responde a uma ação da pessoa (abrir, expandir, confirmar) é bem-vinda quando mostra o que mudou;
  animação que interrompe ou bloqueia o toque, nunca.

**Densidade (arejado a completo)**
- 1 a 3: entre seções `py-24` a `py-32`, poucas coisas por tela, imagens grandes.
- 4 a 7: entre seções `py-16` a `py-20`, espaçamento de app comum.
- 8 a 10: `py-8` a `py-12`, sem caixas de card: dados respiram em layout simples separados por linha de 1px
  (`divide-y divide-border`), números em `tabular-nums`, rótulos em `text-sm`.

Presets de partida (variância / movimento / densidade), ajustados pela leitura do negócio:

| Caso | V | M | D |
|---|---|---|---|
| Página pública de serviço local (salão, oficina, clínica) | 5 | 4 | 4 |
| Vitrine ou loja | 6 | 5 | 5 |
| Cardápio e pedido | 5 | 4 | 6 |
| Portfólio, estúdio, fotografia, evento | 8 | 7 | 3 |
| App de cliente com login (treino, pedidos, curso) | 4 | 3 | 5 |
| Agenda, painel, cadastro, área administrativa | 3 | 2 | 7 |
| Confiança acima de tudo (escola, igreja, órgão, saúde, jurídico) | 3 | 2 | 5 |
| Site premium de agência com muita animação | 8 | 8 | 3 (sugira ao dono a skill fab-agencia, se ela estiver instalada) |

Tradução dos pedidos do dono: "mais sério, mais limpo, mais sóbrio" V -2 e M -2; "mais moderno, mais diferente,
mais ousado, mais chamativo" V +2; "mais vivo, mais animado" M +2; "menos animação, mais parado" M -3; "mais
arejado, menos apertado, respirando" D -2; "mais completo, mais informação, mais compacto" D +2.

## Tipografia em classes (a fonte vem do `theme`; o tamanho, o peso e o ritmo são da construção)

- `src/app-typography.css` é do app: é ali que a identidade tipográfica se fixa uma vez para todas as telas, dentro de
  `@layer base`, com famílias sempre pelos tokens (`var(--font-display)`, `var(--font-sans)`), nunca pelo nome. Se o
  app não tiver o arquivo, escreva-o inteiro a partir do conteúdo padrão `@layer base { h1, h2, h3, h4, h5, h6 {
  font-family: var(--font-display); letter-spacing: var(--fab-title-tracking, normal); } }`. Se o `fabapp deploy`
  avisar que ignorou o arquivo, aplique as mesmas regras por classe nas páginas. Nunca ponha nome de fonte nem
  `@import` do Google Fonts ali: a família é a do `theme`.
- Fonte de título de exibição (condensada, de letreiro, de peso único, slab pesada ou serifada de alto contraste):
  aplique `var(--font-display)` só em `h1` e `h2` e ponha `h3` a `h6` em `var(--font-sans)` no mesmo arquivo. Fonte de
  título neutra pode ficar em todos os títulos.
- Espaçamento de letras do título, pela forma da fonte: grotesca grande de `-0.02em` a `-0.03em`; serifada de exibição
  `-0.01em`; condensada ou de caixa alta `0` a `0.01em`; nunca abaixo de `-0.04em`. Texto claro sobre fundo escuro
  ganha `leading` um pouco maior, `0.01em` de espaçamento e um degrau de peso a mais. O valor base vai no
  `titleTracking` do `theme` (o arquivo padrão lê `var(--fab-title-tracking)`); ajustes por nível ficam em
  `src/app-typography.css`.
- Fonte de peso único: títulos em `font-normal` (negrito falso borra).
- Persuadir: `h1` mantém a base `text-3xl sm:text-4xl` e cresce a partir de `md`: até 6 palavras `md:text-5xl
  lg:text-6xl`; 3 a 5 palavras podem ir a `lg:text-7xl`; 1 a 3 palavras a `lg:text-8xl` (teto). Título em até 2
  linhas no computador; 4 linhas é erro de tamanho, não de texto. Planeje o tamanho do título junto com o da imagem.
- Operar: escala apertada, razão 1,125 a 1,2 (`text-sm` dado, `text-base` corpo, `text-lg` subtítulo, `text-xl`
  título de bloco, `h1` pela regra da plataforma). Tamanho fixo, nunca fluido. Uma família costuma bastar.
- Ler: corpo `text-base` ou `text-lg`, `leading-relaxed`, `max-w-prose`; serifada de leitura com um pouco mais de
  entrelinha que uma sans.
- Hierarquia vem de peso e tamanho, não de cor: `font-bold` ou `font-extrabold` no que importa, `font-normal` no resto.
  Ênfase dentro de um título: itálico ou negrito da MESMA família, nunca uma palavra em outra fonte nem em outra cor.
- Nada de CAIXA ALTA em rótulo por padrão; rótulos em caixa de frase.

## Composição por modo

**Persuadir (página pública, vitrine, landing, preços, cardápio)**
- A primeira dobra é uma tese, não um cabeçalho: abre com a coisa mais característica do mundo do negócio, na forma
  que ela tem na vida (a vitrine de pães, a cadeira vazia às 18h, a grade de horários de hoje, o prato do dia).
  Teste da memória: quem sair depois de uma tela, o que descreve uma hora depois? Se a resposta é um clima, a
  direção não se comprometeu.
- Prove, não afirme: mostre o app funcionando (horários livres de hoje vindos dos dados, o cardápio de verdade, o
  "aberto agora" calculado pelo horário), não um parágrafo dizendo que é fácil.
- Famílias de layout para variar seções: faixa de largura total com imagem, pilha vertical centrada, grade assimétrica,
  bento com N células para N itens, lista em grupos com título, faixa rolando (`ScrollRow`), capítulos fixados (`Pin`),
  citação grande sozinha, tabela de preço simples, mapa por link. Uma família por seção, no máximo uma vez por página.
- Seção padrão: título curto (até 8 palavras), parágrafo curto (até 25 palavras), um visual OU uma ação.
- Ritmo de estúdio: uma passagem densa ganha uma calma depois; varie escala, imagem, densidade e silêncio dentro da
  mesma gramática; um só ritmo de espaçamento; a página termina com um fechamento de verdade (a ação principal outra
  vez, com o mesmo texto).
- Imagem: foto grande e decisiva vale mais que cinco medianas. Descreva no `prompt` do `AppImage` o objeto físico do
  negócio, não a categoria ("pão de fermentação natural cortado sobre tábua, luz lateral da manhã", não "padaria").
  Texto sobre foto sempre com véu (`bg-gradient-to-t from-black/60 via-black/20 to-transparent` e texto claro).

- Formas de herói para escolher pelo mundo (não pelo hábito): dividido assimétrico (texto de um lado, imagem do
  outro, respiro generoso); manifesto tipográfico (frase grande, sem imagem, quase cartaz, só quando a frase É o
  design); faixa de mídia inteira com véu e texto por cima; título que se revela (`TextReveal`); herói fixado enquanto
  o conteúdo passa (`Pin`); em app de produto, nada de herói: o estado da pessoa e as ações dela no topo.
- Ficha técnica ou lista longa de especificações (cardápio de vinhos, planos, características do imóvel): nunca 10
  linhas com filete em cada uma. Agrupe em 2 ou 3 blocos com título, ou destaque 3 ou 4 itens em blocos grandes e
  guarde o resto em "Ver ficha completa" (acordeão).
- Uma só voz de texto por página: não misture o registro técnico ("47 tarefas, 0,6 trocas por dia"), a prosa de
  revista e o grito de marketing na mesma composição.
- Profundidade: card só quando a elevação diz hierarquia de verdade; senão agrupe com espaço, `border-t` ou
  `divide-y`. Sombra, quando houver, tingida da cor do conteúdo (`shadow-foreground/10`), nunca preta pura sobre fundo
  claro.
- Espaço: escala de 4 em 4 (`gap-2`, `gap-4`, `gap-6`, `gap-8`, `gap-12`, `gap-16`); `gap` para irmãos em vez de margem
  em cada filho; agrupe por proximidade antes de pôr caixa. Teste do olhar apertado: com os detalhes borrados, ainda
  se vê o principal, o secundário e os grupos, nessa ordem.
- Imagens com proporção declarada (`aspect-[4/3]`, `aspect-video`, `aspect-square`) para a página não pular ao
  carregar; textura de grão, se a direção pedir, só numa camada fixa com `pointer-events-none`, nunca no que rola.
- Parágrafo marcado por espaço entre parágrafos OU recuo da primeira linha, nunca os dois.
- Ícones: só `lucide-react`, uma espessura de traço, um tamanho por nível (16, 20 ou 24px), contorno e preenchido
  não se misturam no mesmo nível, ícone decorativo ao lado de texto com `aria-hidden`, botão só de ícone com nome
  acessível.
- Camadas: `z-index` só para camadas do sistema (cabeçalho fixo, modal, sobreposição), sem `z-50` espalhado.

**Operar (painel, agenda, cadastro, área logada)**
- O teste é a confiança imediata de quem conhece o tipo de ferramenta: estranheza sem propósito é o defeito
  (botão enfeitado, controle diferente do resto, animação gratuita, fonte de exibição em rótulo).
- Cor só em ação principal, seleção e estado; estado sempre com cor e texto (nunca só cor). Uma segunda camada
  neutra para barras e painéis (`bg-muted`).
- Todo componente interativo com padrão, hover, foco, ativo, desabilitado, carregando e erro.
- Estado vazio ensina a tela e traz a ação; skeleton no lugar de spinner no meio do conteúdo.
- Nada de sequência de carregamento; transições de 150 a 250ms; modal só quando precisa.
- A marca vive nos detalhes: o título da tela na fonte da marca, a cor de seleção, o anel de foco, o estado vazio
  com uma frase na voz do negócio.

## O momento assinatura (escolha UM, derivado do mundo, e nomeie no plano)

Precisa passar no teste do vizinho: outro negócio do mesmo ramo não poderia usar sem mudar. Exemplos de forma (a
matéria vem do negócio):
- A grade de horários livres de hoje na primeira dobra, lida dos dados, com o próximo horário em destaque.
- O "aberto agora" ou "fecha às 22h" calculado do horário do dia, no topo, na voz da casa.
- O título entrando palavra por palavra (`TextReveal`) numa frase que é do negócio, não de marketing.
- A foto principal crescendo ao entrar (`ScrollScale`) ou deslizando devagar (`Parallax`).
- Um processo em capítulos fixados na tela (`Pin height={3}`): do corte ao acabamento, da massa ao forno.
- Uma faixa rolando (`Marquee`) com itens reais: os sabores do dia, as marcas atendidas de verdade.
- Uma tabela de preço que é o próprio objeto do mundo (a lousa do boteco, a etiqueta de feira), em código, não imagem.
- No app de operar: o estado vazio da primeira vez, a confirmação de agendamento com o resumo e o botão de lembrete,
  a conclusão de uma meta com resposta proporcional ao esforço.

Contenção: gaste a ousadia num lugar só. Um elemento memorável; o resto quieto e disciplinado. Antes de entregar,
tire um acessório (o conselho da Chanel): a decoração que não serve ao pedido sai.

## Pedidos de ajuste de intensidade (edição)

**"Mais ousado", "mais chamativo", "está sem graça"** (escopo é soberano: só o alvo nomeado muda)
- Descubra por que o alvo está chato olhando o que os vizinhos dele já fazem: o título no tamanho cheio, o motivo do
  mundo, a densidade e o ritmo. O alvo quase sempre está fugindo dos melhores recursos do próprio sistema.
- Amplifique o que o sistema já tem (a escala tipográfica no máximo, o motivo do mundo, a cor da marca em região
  inteira), sem cor, fonte, raio ou sombra nova. Um movimento decisivo feito por inteiro, e o resto em volta mais
  quieto para ele aparecer. Se tudo ficou mais alto, ficou mais chato.
- Teste do esqueleto: tire o texto e olhe a estrutura. Se ela ainda diz o que a seção é, a ousadia está no design;
  se só funciona com as palavras, a ousadia está no tamanho da letra.
- A reação por reflexo (mais efeitos) é o contrário de ousado: recuse primeiro.

**"Mais discreto", "mais sóbrio", "está poluído"**
- Persuadir: mais respiro, paleta mais contida na composição (faixas `bg-accent` voltam a `bg-background`), menos
  drama, o ponto de vista fica. Operar: menos ruído (menos fundo colorido, cards mais planos, menos movimento).
- Peso: 900 vira 600, 700 vira 500; menos saltos de escala; bordas mais finas ou nenhuma; remova gradiente, sombra,
  padrão e textura que não servem; movimento com distância de 10 a 20px, curva suave, sem quique; tire animação que
  não tem motivo.
- Saturação menor (70 a 85%) é mudança de cor: vai pelo `theme` do `apps/<slug>/fab.config.json` (valores
  conferidos e aprovados pelo dono, `fabapp push` e `fabapp deploy`), não por código.
- Nunca: deixar tudo do mesmo tamanho e peso, tirar toda a cor, apagar a personalidade, sacrificar a clareza das
  ações, deixar tudo pequeno e leve.

**"Mais simples", "tem coisa demais"**
- Um objetivo por tela; o que é secundário vai para abas, acordeão ou "ver mais"; junte ações parecidas; uma ação
  principal clara; corte o texto pela metade e de novo; nada de cards onde espaço e alinhamento resolvem.
- Nunca tirar função necessária nem informação de decisão; simplicidade é tirar obstáculo, não recurso.

**"Mais personalidade", "mais encanto"**
- Uma tese de encanto em uma frase (o que a pessoa deve sentir e por que isso é deste negócio), entregue no menor
  sistema possível: resposta a uma ação importante, texto na voz da casa, estado vazio, recuperação de erro.
- Sucesso proporcional ao esforço; espera com progresso verdadeiro, nunca trabalho fingido; erro primeiro diz o
  problema e a saída, piada nunca em dinheiro, privacidade, perda ou bloqueio; o encanto aguenta a centésima vez.

**"Algo nunca visto", "efeito uau"**
- O uau depende do contexto: numa página de venda é sensorial (revelação por rolagem, capítulos fixados); numa tela
  de trabalho é sensação (salvar na hora com retorno claro, lista que filtra sem piscar, busca com 300ms de
  espera). Proponha 2 ou 3 caminhos com o custo de cada um e deixe o dono escolher antes de construir.
- Sempre com degradação boa: sem o efeito a tela continua boa. Um momento extraordinário, nunca vários competindo.

## Protocolo de repaginação (edição)

- Detecte o modo antes de tudo: ajuste pontual (preserva tudo fora do alvo), repaginação que preserva a marca
  (evolui aos poucos) ou repaginação completa (visual novo sobre o mesmo conteúdo). Na dúvida, pergunte uma vez:
  "Quer manter a cara atual e só melhorar, ou começar o visual do zero?"
- Antes de mexer, registre o estado atual (leia o `theme` do `fab.config.json` e o `DECISOES.md`): cores e fontes da marca, raio, rotas e navegação, blocos que funcionam,
  vícios a aposentar (da calibração), dials atuais lidos da tela. Esse é o ponto de partida, não o padrão da skill.
- Alavancas em ordem de risco, pare quando o pedido estiver atendido: 1) tipografia (tamanhos, pesos, ritmo, em
  `app-typography.css`); 2) espaçamento e ritmo; 3) cor (pelo `theme` do `fab.config.json`); 4) movimento no nível do dial;
  5) recompor herói e seções-chave; 6) trocar um bloco inteiro só quando ele não tem conserto.
- Base sólida (conteúdo e navegação bons) pede evolução com as alavancas 1 a 4: cerca de 70% do valor com 40% do
  risco. Problema estrutural pede repaginação com o conteúdo preservado. Marca mudando é começo do zero.
- Nunca mude em silêncio endereço das páginas, rótulos da navegação, campos de formulário, logo, textos legais e textos
  que o dono escreveu (se a skill `redesign-e-polimento` estiver instalada, a lista completa está nela).
- Repaginar substitui, ajustar preserva: nunca dividir a diferença polindo o visual que se decidiu descartar.
