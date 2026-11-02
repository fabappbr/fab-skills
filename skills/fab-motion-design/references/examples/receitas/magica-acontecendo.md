# Receita de cena: a mágica acontecendo (o processo)

```tsx
/* A mágica acontecendo. 2,5 s = 5 batidas; uma peça assenta a cada batida (15 quadros), o quadro se enche sozinho.
 * Plano: três cartões de imagem montam um mosaico que vaza pela borda direita; o título curto em cima, à esquerda.
 * Tamanhos: título em <Kinetic fit> (2 palavras); cartões de 620 px, o último cortado pela borda (vazamento de propósito).
 * Movimento: cada cartão entra em 12 quadros (spring snappy, sobra leve) nas batidas 1, 2 e 3; o título entra na 0.
 * Só o cartão novo se mexe; os que assentaram ficam parados.
 * Leva: a câmera mergulha no último cartão, que vira a cena seguinte: a PRÓXIMA cena entra com transition="zoom-through"
 * e carry "dive into the last card" (a transição vai na cena que entra). Esta entra com push-left.
 */
<Scene canvas duration={sec(2.5)} bg="primary" transition="push-left">
  <Safe align="flex-start" justify="flex-start">
    <Kinetic mode="scale-punch" fit dur={12} color="ink">Vira vídeo.</Kinetic>
  </Safe>
  <At x={0.3} y={0.62}><Move keys={[{ at: 15, scale: 0.6, opacity: 0 }, { at: 27, scale: 1, opacity: 1, ease: "outBack" }]}>
    <Picture slot="tile-a" prompt="fresh croissants on a wooden tray, top view, soft light, no text" width={620} aspect="4/5" /></Move></At>
  <At x={0.72} y={0.74}><Move keys={[{ at: 30, scale: 0.6, opacity: 0 }, { at: 42, scale: 1, opacity: 1, ease: "outBack" }]}>
    <Picture slot="tile-b" prompt="barista pouring latte art, warm cafe light, close-up, no text" width={620} aspect="4/5" /></Move></At>
  <At x={1.0} y={0.9}><Move keys={[{ at: 45, scale: 0.6, opacity: 0 }, { at: 57, scale: 1, opacity: 1, ease: "outBack" },
                                    { at: 63, scale: 1 }, { at: 75, scale: 3, ease: "inExpo" }]}>
    <Picture slot="tile-c" prompt="bakery counter seen from the street at dawn, no text" width={620} aspect="4/5" /></Move></At>
</Scene>
```
