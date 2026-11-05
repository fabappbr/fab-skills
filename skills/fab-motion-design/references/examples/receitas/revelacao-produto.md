# Receita de cena: revelação do produto

```tsx
/* Revelação do produto. 3 s = 6 batidas, com uma batida interna a cada 1 s.
 * Plano: o produto chega pelo corte casado da cena anterior; um círculo abre a foto real, a imagem de um
 * <Layout place="split" bleed> que ocupa o resto do quadro sob a frase, sangrando pelas laterais e pela base.
 * Tamanhos: qualidade concreta em <Headline> (150 px), apoio 64 px.
 * Batidas: 0 a foto abre por shape circle (14 quadros); 30 a qualidade entra por mask-up; 60 o apoio assenta, 2 quadros
 * por palavra. Câmera recua 1,06 a 1 (continua o movimento da cena anterior).
 * Leva: entra com transition="match" no produto (carry "the product, same place and size").
 */
<Scene canvas duration={sec(3)} bg="background" transition="match">
  <Camera keys={[{ at: 0, zoom: 1.06 }, { at: 90, zoom: 1, ease: "outCubic" }]}>
    <Layout place="split" bleed media={
      <Reveal shape="circle" from="center" at={0} dur={14}>
        <Picture type="photo" slot="product-photo" src={items[0]?.photo_url} radius={0} />
      </Reveal>}>
      <Headline at={30}>Massa de fermentação</Headline>
      <Kinetic mode="mask-up" at={60} step={2} size={64} font="body" color="ink">feita toda manhã</Kinetic>
    </Layout>
  </Camera>
</Scene>
```
