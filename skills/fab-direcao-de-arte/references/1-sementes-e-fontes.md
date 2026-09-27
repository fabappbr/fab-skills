# Sementes, fontes e contraste (consulta da conversa)

Este arquivo serve ao passo "fechar a marca" da conversa com o dono. As sementes são pontos de partida, não temas
prontos: a direção escolhida para o negócio manda, e a semente só empresta uma paleta já conferida e um par de fontes
que funciona. Todas as fontes abaixo existem no Google Fonts com o nome exato escrito aqui. Copie o nome letra por
letra para `titleFont` e `bodyFont`: nome inexistente não dá erro, o app sai na fonte do sistema.

## As 16 sementes conferidas

Todas passam nos pares: texto sobre fundo 7:1 ou mais, cor principal sobre fundo 3:1 ou mais, `primaryFg` sobre a
cor principal 4,5:1 ou mais, texto secundário sobre fundo e sobre o destaque 4,5:1 ou mais. Os números entre
parênteses são texto/fundo e principal/fundo. A coluna `primaryFg` foi conferida pela fórmula do fim deste arquivo
(é o quase branco ou o quase preto da própria semente; em Poste de Barbeiro, um quase preto mais fundo, 4,7:1).
Em todas, `card` pode receber o mesmo valor do `bg`.

| Semente | Mundo (de onde vem) | Estratégia e cena | primary | primaryFg | bg | text | accent | titleFont | bodyFont | radius |
|---|---|---|---|---|---|---|---|---|---|---|
| Azulejo e Louça | azulejo português, louça de padaria, balcão de mármore | Comprometida, clara (16,2 / 6,9) | #1d4fb8 | #f5f8fc | #f5f8fc | #0e1a36 | #dfe8fa | Young Serif | Hanken Grotesk | 6 |
| Placa de Feira | lona de barraca, caixote, preço pintado à mão | Paleta cheia, clara (14,9 / 5,0) | #c8321c | #f4f8ec | #f4f8ec | #1b2410 | #fde9b7 | Alfa Slab One | Chivo | 4 |
| Estrada e Oficina | placa verde de rodovia, faixa amarela, graxa | Encharcada, escura (10,7 / 7,3) | #f5c518 | #123f2f | #123f2f | #f1f5ef | #114533 | Barlow Condensed | Public Sans | 2 |
| Receituário | receita carimbada, azulejo branco de consultório, verde petróleo | Contida, clara (14,5 / 6,1) | #0b6b5c | #f7faf9 | #f7faf9 | #102a26 | #e0f6f0 | Schibsted Grotesk | Atkinson Hyperlegible Next | 10 |
| Quadra de Bairro | piso de quadra pintado, linha branca, placar amarelo | Encharcada, escura (10,1 / 7,3) | #ffd23f | #173f70 | #173f70 | #f7f9fc | #0d3a70 | Anton | Radio Canada | 4 |
| Cartela de Esmalte | cartela de cores de esmaltaria, frasco, laca | Comprometida, clara (17,1 / 6,5) | #b0124a | #fcf7fa | #fcf7fa | #22101a | #f5e0ea | Bodoni Moda | Albert Sans | 2 |
| Poste de Barbeiro | poste listrado, couro de cadeira, cromo, fim de tarde | Contida, escura (15,0 / 4,1) | #e0463b | #0b0f14 | #141d27 | #eef1f4 | #1f2b38 | Staatliches | Onest | 4 |
| Lousa e Giz | quadro verde de escola, giz amarelo, caderno de chamada | Encharcada, escura (11,0 / 7,4) | #f2c14e | #1e3a2c | #1e3a2c | #eef3ea | #214133 | Gabarito | Golos Text | 8 |
| Carimbo de Cartório | tinta de carimbo violeta, papel timbrado, fichário | Contida, clara (16,0 / 8,2) | #3b3f9c | #f6f7f9 | #f6f7f9 | #171b29 | #e3e4f5 | Libre Caslon Display | Libre Franklin | 2 |
| Planta Baixa | cópia heliográfica azul, cota, régua de escala | Encharcada, escura (12,1 / 13,8) | #ffffff | #0f2c59 | #0f2c59 | #eaf1fb | #15376c | Host Grotesk | Host Grotesk | 0 |
| Viveiro | estufa, muda em saquinho, etiqueta de planta | Comprometida, clara (14,8 / 6,0) | #2f6b2f | #f4f8f1 | #f4f8f1 | #14261a | #e1f0d8 | Petrona | Karla | 12 |
| Coleira e Petisco | coleira de náilon, pote de ração, brinquedo de borracha | Paleta cheia, clara (15,2 / 3,3) | #e2620e | #1c1f33 | #f4f7ff | #1c1f33 | #ffe6d1 | Tilt Warp | Rethink Sans | 16 |
| Vitral | vitral de capela, chumbo entre vidros, luz âmbar | Paleta cheia, clara (16,0 / 9,7) | #1e3a8a | #f5f7fb | #f5f7fb | #151a33 | #fde6bf | Brygada 1918 | Source Serif 4 | 6 |
| Bandeirinha | varal de festa junina, chita, papel de seda | Paleta cheia, clara (16,0 / 4,8) | #d42c28 | #f5faff | #f5faff | #1d1a33 | #fff0b3 | Shrikhand | Asap | 20 |
| Guarda-sol | guarda-sol listrado, água de piscina, coral de praia | Paleta cheia, clara (14,0 / 5,2) | #0e7482 | #f1fafa | #f1fafa | #0d2b33 | #fff1e6 | Unbounded | Commissioner | 24 |
| Livro-Caixa | livro contábil verde, caneta tinteiro, pauta dupla | Contida, clara (15,3 / 7,1) | #13603f | #f6f8f6 | #f6f8f6 | #0f2419 | #dceee2 | Chivo | Public Sans | 4 |

Como usar uma semente:
- Escolha pela afinidade de MUNDO com a direção escolhida, nunca pelo setor escrito na tabela. Uma padaria pode
  nascer de "Placa de Feira"; um escritório de contabilidade pode nascer de "Planta Baixa".
- Variação controlada: gire o matiz da `primary` e do `accent` em até 20 graus e troque UMA das fontes por outra da
  mesma voz (lista abaixo). Mantenha a claridade de cada cor igual à da semente: é a claridade que garante o
  contraste, e girar só o matiz preserva as razões acima. Depois de girar, confira de novo `primaryFg` sobre a
  `primary`.
- Títulos em fonte de peso único (Young Serif, Alfa Slab One, Anton, Staatliches, Libre Caslon Display, Tilt Warp,
  Shrikhand, Gloock, Dela Gothic One, Bungee): registre na direção "títulos em `font-normal`", porque não existe
  negrito dessas famílias e o navegador desenha um negrito falso, borrado.
- `Planta Baixa` tem botão branco com texto escuro; é a exceção que prova a regra de testar os pares, não um erro.
- Semente escura (Estrada e Oficina, Quadra de Bairro, Poste de Barbeiro, Lousa e Giz, Planta Baixa): `mode:
  "dark"`, com `bg`, `card`, `text` e `primary` repetidos no bloco `dark`.

Exemplo de `theme` a partir de uma semente (Lousa e Giz, sem giro), em `apps/<slug>/fab.config.json`:

```json
{
  "theme": {
    "mode": "dark",
    "primary": "#f2c14e", "primaryFg": "#1e3a2c",
    "bg": "#1e3a2c", "card": "#1e3a2c", "text": "#eef3ea",
    "accent": "#214133",
    "radius": 8,
    "titleFont": "Gabarito", "bodyFont": "Golos Text", "titleTracking": "-0.02em",
    "dark": { "bg": "#1e3a2c", "card": "#1e3a2c", "text": "#eef3ea", "primary": "#f2c14e" }
  }
}
```

`destructive` entra quando a direção precisa de um vermelho próprio, conferido contra o `bg` pela mesma fórmula.
Nunca escreva `primaryText`: a cor da marca como texto é derivada pela plataforma com contraste AA.

## Fontes que denunciam modelo de IA (evite por padrão)

Nas superfícies de persuadir (página pública, vitrine, landing, cardápio), estas famílias são o que o modelo usa
quando parou de procurar. Escolher uma delas exige um motivo que nenhuma outra resolva, e "o setor combina" nunca é
motivo (livraria pedindo serifa e tecnologia pedindo mono são justamente as associações a quebrar):

- De treino, por reflexo: Fraunces, Playfair Display, Cormorant, Cormorant Garamond, Lora, Crimson Pro, Crimson
  Text, Newsreader, Instrument Serif, DM Serif Display, Syne, Space Grotesk, Space Mono, IBM Plex (como display),
  Inter como fonte de título, DM Sans, Outfit, Plus Jakarta Sans, Instrument Sans.
- Os padrões desta plataforma (saem sozinhos quando ninguém decide a marca): Space Grotesk, Plus Jakarta Sans,
  Manrope, Inter, Epilogue, Poppins, Nunito Sans, Sora, IBM Plex Sans, Bricolage Grotesque, Figtree.
- Os clichês por nicho no Brasil: Montserrat e Poppins em tudo; Playfair com Inter para salão e spa; Great Vibes ou
  Pacifico para "feminino"; Bebas Neue para academia; Cinzel para "luxo"; Orbitron para tecnologia; Roboto, Open
  Sans e Lato como "neutro".

Rota de exceção: se o dono nomeou a fonte, ou a marca já existe com ela, use sem discutir. Em telas de operar
(painel, agenda, cadastro), uma fonte de trabalho neutra (Inter, Public Sans, IBM Plex Sans, Atkinson Hyperlegible
Next) é a escolha certa para o CORPO; a personalidade fica no título.

## Fontes por voz (todas conferidas no catálogo)

Títulos:
- Grotesca com caráter: Schibsted Grotesk, Familjen Grotesk, Hanken Grotesk, Host Grotesk, Rethink Sans,
  Geologica, Golos Text, Onest, Albert Sans, Red Hat Display, Funnel Display, Mona Sans, Chivo, Wix Madefor Display.
- Condensada, de placa ou de esporte: Barlow Condensed, Saira Condensed, Sofia Sans Extra Condensed, Asap
  Condensed, Archivo Narrow, Big Shoulders; de peso único: Anton, League Gothic, Staatliches, Fjalla One.
- Larga ou geométrica: Unbounded, Encode Sans Expanded, Parkinsans, Gabarito; de peso único: Dela Gothic One.
- Serifada de exibição (só quando o mundo pede, com o motivo escrito): Bodoni Moda, Brygada 1918, Besley, Petrona,
  Alegreya, Vollkorn, Zilla Slab; de peso único: Young Serif, Gloock, Libre Caslon Display, Hedvig Letters Serif,
  Alfa Slab One.
- Arredondada ou de letreiro: Tilt Warp, Baloo 2, Grandstander, Shrikhand, Bagel Fat One, Chonburi, Bungee.
- Mono (só para dado, código ou medida, nunca como fantasia de "técnico"): Martian Mono, Azeret Mono, Spline Sans Mono.

Corpo (sans ou serif com regular e negrito): Hanken Grotesk, Schibsted Grotesk, Onest, Golos Text, Albert Sans, Red
Hat Text, Public Sans, Atkinson Hyperlegible Next, Commissioner, Alegreya Sans, Libre Franklin, Radio Canada,
Rethink Sans, Reddit Sans, Host Grotesk, Funnel Sans, Chivo, Asap, Karla, Sofia Sans, Geologica, Mona Sans, Wix
Madefor Text; serifadas de leitura: Literata, Source Serif 4, Alegreya, Spectral, Gelasio, Petrona.

Regras de par:
- Uma família ou duas. Com duas, que sejam claramente diferentes (condensada com humanista, serifada com grotesca).
  Duas grotescas parecidas lado a lado leem como erro.
- Fonte de título condensada, de letreiro, de peso único ou serifada de alto contraste (Bodoni Moda, Libre Caslon
  Display) só a partir de 28px. Abaixo disso o título vai na fonte do corpo (a construção cuida disso em
  `src/app-typography.css`).
- Público mais velho ou leitura longa (clínica, igreja, escola, órgão): corpo de legibilidade alta (Atkinson
  Hyperlegible Next, Public Sans, Literata).
- Emoção na serifa itálica, creme e luz de abajur em tema acolhedor, familiar ou infantil é o viés medido do modelo,
  não uma escolha. Trate a primeira paleta assim como já gasta e refaça a partir dos materiais saturados do mundo.

## Estratégia de cor com as cores do `theme`

A marca do app tem quatro cores que decidem a estratégia: `primary` (ação e marca), `bg` (fundo da página), `text`
(texto) e `accent` (tinta suave de destaque, usada em fundos de seção, seleção e hover). As outras chaves do `theme`
acompanham: `card` (a superfície dos cartões; o mesmo valor do `bg` é o ponto de partida), `primaryFg` (o texto
sobre o preenchimento da marca, quase branco ou quase preto conferido contra a `primary`) e `destructive` (erro e
ação destrutiva). O texto secundário e a cor da marca como texto (`primaryText`) são derivados pela plataforma com
contraste garantido.

| Estratégia | Como fica nas 4 cores | Onde a construção gasta |
|---|---|---|
| Contida | `bg` quase neutro, `primary` sóbria, `accent` quase invisível | cor só em ação, seleção e estado |
| Comprometida | `primary` saturada; `accent` visível | faixas inteiras em `bg-primary` ou `bg-accent` cobrindo 30 a 60% da primeira tela |
| Paleta cheia | `bg`, `primary` e `accent` em três matizes diferentes | três papéis nomeados; fotos do `AppImage` trazem o resto |
| Encharcada | `bg` É a cor da marca (escura ou saturada), `text` claro, `primary` em contraste | a superfície inteira é a cor; a ação vem na cor de contraste |

Ponto de partida por modo: operar começa em Contida; persuadir e experimentar têm permissão para as outras três.
A cor se compromete na escala da página (regiões inteiras), não em pingos de destaque sobre um fundo neutro.

Claro ou escuro nunca é padrão nem vem do setor. Escreva uma frase de cena física (quem usa, onde, sob que luz) e
deixe a frase decidir. "A cliente marca horário no ônibus, de manhã, no celular" pede claro. "O cliente da barbearia
olha o celular no fim da tarde, na calçada" permite escuro. Um app escuro se faz com `bg` escuro e `text` claro,
`mode: "dark"` e os mesmos valores no bloco `dark` do `theme`.

## Conferir contraste de uma paleta própria

Quando não partir de uma semente, calcule. Luminância relativa de um hex: para cada canal, v = canal/255;
se v ≤ 0,04045 use v/12,92, senão ((v+0,055)/1,055)^2,4. L = 0,2126 R + 0,7152 G + 0,0722 B.
Razão = (L_clara + 0,05) / (L_escura + 0,05).

Pares obrigatórios (os pares "on-"):
- `text` sobre `bg` (e sobre `card`): 4,5:1 no mínimo; mire 7:1 (corpo de leitura).
- `primary` sobre `bg`: 3:1 no mínimo (borda e forma do botão precisam aparecer).
- `primaryFg` sobre `primary`: 4,5:1. No terminal você escreve o `primaryFg`: escolha o quase branco ou o quase
  preto que passa, e confira.
- `text` sobre `accent`: 4,5:1 (o destaque vira fundo de seção e de item selecionado).
- Em fundo escuro, `accent` também escuro (uma tinta da `primary` misturada ao `bg`); em fundo claro, `accent` claro.
- Com bloco `dark`, os mesmos pares valem para os valores dele.

Atalhos seguros: um hex com os três canais em E6 ou mais tem L acima de 0,78; um hex com os três canais em 33 ou
menos tem L abaixo de 0,035; esse par passa de 9:1. Nunca use preto puro #000000 nem branco puro #ffffff como `bg`
ou `text` de marca (tiram profundidade); use quase preto e quase branco com um leve matiz da marca.

Se a ferramenta do agente roda comandos, faça a conta num script curto (Python ou Node) com a fórmula acima e
mostre as razões ao dono junto com a proposta.

## Clichês de paleta por setor (o banco de dados americano erra aqui)

Setor decide o que o app precisa ter, nunca a cara. Estas combinações saem sozinhas e deixam mil apps iguais:
salão e spa em rosa #EC4899 com lavanda #8B5CF6; clínica em azul #0077B6 com branco; academia em laranja #FF6B35 no
escuro; imobiliária e "luxo" em azul-marinho com dourado #D4AF37; restaurante em laranja, vermelho e marrom;
jurídico em marinho #1E3A5F com dourado; tecnologia em roxo e índigo com brilho. Se a direção cair numa delas sem o
dono ter pedido, o teste do prompt vizinho falhou.
