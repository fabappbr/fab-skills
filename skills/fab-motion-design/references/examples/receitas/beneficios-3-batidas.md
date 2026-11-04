# Receita de cena: benefícios em 3 batidas

```tsx
/* Benefícios em 3 batidas. 3 s = 6 batidas; um benefício a cada 2 batidas (30 quadros), nunca três cenas iguais seguidas.
 * Plano: alinhado à esquerda (varia o desenho das cenas centradas em volta); no máximo 4 palavras heroicas por vez.
 * Tamanhos: "Sem" em <Kinetic fit={[150, 200]}> (teto de propósito: "Sem" não passa da palavra que troca), a palavra que troca em <WordSwap size={210}>; 3 ícones de 220 px na faixa de baixo.
 * Movimento: a troca cai na batida (every={30}); cada ícone assenta junto com a sua palavra (pop). Sem Grid, Dots nem Glow:
 * a cena é das palavras e dos ícones.
 * Leva: a câmera continua andando para a esquerda na cena seguinte (carry "camera keeps moving left", transição push-left).
 */
<Scene canvas duration={sec(3)} bg="background" transition="whip-left">
  <Camera keys={[{ at: 0, x: 0 }, { at: 90, x: 60, ease: "smooth" }]}>
    <Safe align="flex-start" justify="flex-start">
      <Kinetic mode="mask-up" fit={[150, 200]} color="ink" align="left">Sem</Kinetic>
      <WordSwap words={["editor.", "programa.", "espera."]} at={4} every={30} mode="mask" size={210} color="accent" align="left" />
    </Safe>
    <Icon name="check" size={220} at={4} entrance="pop" color="accent" x={0.2} y={0.84} />
    <Icon name="check" size={220} at={34} entrance="pop" color="accent" x={0.5} y={0.84} />
    <Icon name="check" size={220} at={64} entrance="pop" color="accent" x={0.8} y={0.84} />
  </Camera>
</Scene>
```
