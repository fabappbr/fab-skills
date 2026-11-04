# Receita de cena: revelação do produto

```tsx
/* Revelação do produto. 3 s = 6 batidas, com uma batida interna a cada 1 s.
 * Plano: o produto chega pelo corte casado da cena anterior, no mesmo lugar; um círculo abre a foto real atrás dele.
 * Tamanhos: foto em círculo de 1240 px (passa das bordas: é o campo da cena); qualidade concreta em <Kinetic fit>, apoio 64 px.
 * Batidas: 0 a foto abre por shape circle (14 quadros); 30 a qualidade entra por mask-up; 60 o apoio assenta, 2 quadros
 * por palavra. Câmera recua 1,06 a 1 (continua o movimento da cena anterior).
 * Leva: entra com transition="match" no produto (carry "the product, same place and size").
 */
<Scene canvas duration={sec(3)} bg="background" transition="match">
  <Camera keys={[{ at: 0, zoom: 1.06 }, { at: 90, zoom: 1, ease: "outCubic" }]}>
    <At x={0.5} y={0.72}>
      <Reveal shape="circle" from="center" at={0} dur={14}>
        <Picture type="photo" slot="product-photo" src={items[0]?.photo_url} shape="circle" width={1240} />
      </Reveal>
    </At>
    <Safe justify="flex-start" gap={20}>
      <Kinetic mode="mask-up" fit at={30} color="ink" align="center">{"Massa de\nfermentação"}</Kinetic>
      <Kinetic mode="mask-up" at={60} step={2} size={64} color="ink" align="center">natural, feita toda manhã</Kinetic>
    </Safe>
  </Camera>
</Scene>
```
