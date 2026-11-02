# Estilo: gráfico ousado e produto herói

Formas da marca, cores chapadas, letreiros que correm, o produto que cai, quica e vira preço. Serve para varejo, comida, promoção, evento e oferta.

Referência: `references/examples/padaria.md` (a padaria: pão de queijo de sábado, sem foto de produto).

## Regras contáveis

- Fundos chapados nas cores da marca, trocando **a cada cena** (nunca 2 seguidas iguais), sem sair do esquema claro ou escuro da peça.
- O produto: com foto, `<Product cutout>` grande (**pelo menos 40% da altura do quadro** no herói); sem foto, peça uma imagem gerada dele (`ai-image`, num `<Picture>` ou no fundo). Nunca uma forma genérica no lugar do produto.
- O preço entra **junto do produto ou logo depois dele**, com `<PriceTag entrance="punch">` de **230 a 430 px** e, em peça sem trilha, `hits` de `cha-ching` no quadro em que assenta.
- Pelo menos **um `<Marquee>`** (decoração, com `outline` ou `alpha` baixo) e **um `<Morph>`** na peça.
- Movimento físico: queda, achatamento e quique (`interpolate` com `inQuad` na queda, mola `bouncy` no assento) em pelo menos **uma cena**.
- `<Burst>` no pico (o preço ou o fecho), no máximo **2 na peça**.
- Transições de energia: `shape-burst`, `shape-circle`, `whip-*`, `push-*` e um `match` sobre o produto.
- Texto curto em caixa alta ou peso 800: o herói de **150 a 340 px** (`<Kinetic fit>` sem faixa), o apoio de 60 a 80 px.
