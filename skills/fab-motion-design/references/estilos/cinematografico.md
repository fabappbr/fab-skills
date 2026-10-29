# Estilo: cinematográfico

Imagem em movimento atrás e letreiro por cima: fundo em vídeo gerado (ou a foto real do item), grão, luz que vaza, cortes no ritmo da trilha. Serve para turismo, gastronomia, imóvel, evento, marca com clima.

Referência: ainda não há peça de referência deste estilo. Use a textura da cena 1 e da cena 7 de `references/examples/launch.md` e o letreiro da cena 3 de `references/examples/aurea.md`.

## Regras contáveis

- Fundo de imagem ou vídeo em **pelo menos metade das cenas** (`ai-video`, `ai-image`, `photo` do item); no máximo **2 vagas `ai-video`** na peça.
- Letreiro: **uma linha** de até 4 palavras por cena, de **110 a 170 px**, com `blur-in` ou `mask-up` por linha; sempre dentro de `<Safe>`.
- `<Grain amount>` de 0,06 a 0,1 em **toda cena**, `<Vignette>` em toda cena com imagem; `<LightLeak>` em no máximo **2 cenas**.
- Câmera lenta e contínua (zoom de 1 a 1,08 na cena inteira, direção alternada entre cenas).
- Transições: `fade`, `match`, `zoom-through`, `whip-*` no pico; nenhuma `shape-*` além de uma.
- Cenas de **2 a 3 s**, com uma cena curta (1,2 a 1,5 s) logo antes do momento mais forte.
- Nada de padrão gráfico (`<Grid>`, `<Dots>`) por cima de imagem.
