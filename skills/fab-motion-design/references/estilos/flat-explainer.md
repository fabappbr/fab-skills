# Estilo: explicativo chapado

Formas e ícones chapados da marca, movimento com mola, uma ideia por cena; simpático e claro. Serve para serviço explicado, passo a passo, app, varejo, promoção e comida.

Referência: `references/examples/padaria.md` (a padaria: pão de queijo de sábado).

## Regras contáveis

- Paleta: só cores chapadas; `primary` nas formas, `accent` no destaque, o fundo troca a cada cena dentro do esquema. Sem marca: fundo `#fff6e9`, `primary` `#2456e8`, `accent` `#ffc23d`, texto `#1f2a44`.
- Tipo: sem serifa arredondada ou geométrica, peso **700 a 800**, caixa de frase, herói de **150 a 260 px** (`<Headline>` ou `<Kinetic fit>`), apoio de 60 a 80 px. Marca com título em serifa: o kit a põe no peso dela, nunca preta.
- Tempo (30 qps): mola `bouncy` em formas e ícones (assenta em até 24 quadros), `snappy` no texto; `stagger` de 3 a 4 quadros; algo entra a cada **15 a 20 quadros**.
- Composição: `<Layout place="upper">` com as palavras sobre o objeto herói (`<Icon>`, `<Shape>`, `<Product>`) de **40 a 60% da largura** embaixo, nunca por cima dele; as formas da marca ao lado das palavras são `<Ornament>` dentro do `<Layout>` (opacidade de 0,1 a 0,25, na zona livre), nunca bolhas estacionadas nas bordas; margens de 10%.
- Transições: `shape-circle`, `shape-blob`, `push-*`, `match` sobre o herói; pelo menos **um `<Morph>`** na peça.
- Textura: sem `<Grain>` e sem desfoque; `<Burst count>` até 40, no máximo **2** na peça; `<Dots>` ou `<Rings>` com `alpha` até 0,12 em menos da metade das cenas.
- Evite: gradiente, foto atrás de texto, contorno mais fino que 6 px, frase longa.
