# Receita de cena: benefícios em 3 batidas

```tsx
/* Benefícios em 3 batidas. 3 s = 6 batidas; um benefício a cada 2 batidas (30 quadros), nunca três cenas iguais seguidas.
 * Plano: um bloco <Layout> alinhado à esquerda na margem da grade (varia o desenho das cenas centradas em volta): a frase em cima,
 * a fila de 3 ícones embaixo, no mesmo bloco; no máximo 4 palavras heroicas por vez.
 * Tamanhos: "Sem" e a palavra que troca a 184 px (o passo "xl" da escala); 3 ícones de 180 px.
 * Movimento: a troca cai na batida (every={30}); cada ícone assenta junto com a sua palavra (pop). Sem Grid, Dots nem Glow:
 * a cena é das palavras e dos ícones.
 * Leva: a câmera continua andando para a esquerda na cena seguinte (carry "camera keeps moving left", transição push-left).
 */
<Scene canvas duration={sec(3)} bg="background" transition="whip-left">
  <Camera keys={[{ at: 0, x: 0 }, { at: 90, x: 30, ease: "smooth" }]}>
    <Layout gap={56}>
      <div>
        <Kinetic mode="mask-up" size={184} color="ink" align="left">Sem</Kinetic>
        <WordSwap words={["editor.", "programa.", "espera."]} at={4} every={30} mode="mask" size={184} color="accent" align="left" />
      </div>
      <div style={{ display: "flex", gap: 72 }}>
        <Icon name="check" size={180} at={4} entrance="pop" color="accent" />
        <Icon name="check" size={180} at={34} entrance="pop" color="accent" />
        <Icon name="check" size={180} at={64} entrance="pop" color="accent" />
      </div>
    </Layout>
  </Camera>
</Scene>
```
