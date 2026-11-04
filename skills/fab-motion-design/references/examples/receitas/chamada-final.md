# Receita de cena: chamada final

```tsx
/* Chamada final. 3,5 s = 7 batidas: tempo de leitura mais 1 s, com o último segundo PARADO.
 * Plano: o campo de cor da cena anterior varre e já é o fundo (`primary`, dentro do esquema da peça); marca em cima, a chamada como herói no meio do quadro.
 * Tamanhos: nome da marca em <Kinetic fit>; <CallToAction variant="bar" size={72}> (bloco largo, mais de 150 px de altura).
 * Movimento: marca no quadro 0 (entrada do kit, 18 a 24 quadros pelo tom, outExpo); o botão entra no 8, afunda 3 quadros (antecipação) no 20 e
 * assenta com sobra no 30; a partir do quadro 75 nada mais se move. Nenhuma ênfase extra: o botão é o foco.
 * Leva: entra com transition="color-wipe" (carry "the primary field wipes in").
 */
<Scene canvas duration={sec(3.5)} bg="primary" transition="color-wipe">
  <Safe gap={48}>
    <Kinetic mode="mask-up" fit color="ink" align="center">{brand.name}</Kinetic>
    <Move keys={[{ at: 20, scale: 1 }, { at: 23, scale: 0.96 }, { at: 30, scale: 1, ease: "outBack" }]}>
      <CallToAction action="link" text="Crie o seu agora" variant="bar" size={72} color="accent" delay={8} />
    </Move>
  </Safe>
</Scene>
```
