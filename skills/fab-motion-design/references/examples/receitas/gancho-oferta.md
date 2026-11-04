# Receita de cena: gancho de oferta

```tsx
/* Gancho de oferta. 2,5 s = 5 batidas. Abre a peça com o valor: o produto e o preço do item, lidos no quadro 14.
 * Plano: o produto recortado grande, à direita, vazando pela base; nome e preço à esquerda (um eixo só).
 * Tamanhos: nome 90 px (apoio), <PriceTag size={300}> (herói, 3,3 vezes o apoio); produto com 1000 px de altura.
 * Movimento: o produto cai em 10 quadros e assenta com sobra (outBack); o nome entra no quadro 4, o preço no 8 com punch.
 * Respiração só no produto (o foco). Nenhuma decoração de ambiente: a textura é o produto.
 * Leva: o produto, no mesmo lugar e tamanho, para a cena seguinte (carry "the product, same place", transition="match").
 */
<Scene canvas duration={sec(2.5)} bg="primary">
  <At x={0.66} y={0.82}>
    <Move keys={[{ at: 0, y: -700 }, { at: 10, y: 0, ease: "outBack" }]}>
      <Product item={items[0]} cutout height={1000} motion="float" />
    </Move>
  </At>
  <Safe align="flex-start" justify="flex-start" gap={16}>
    <Kinetic mode="mask-up" at={4} size={90} color="ink" upper>{items[0]?.name ?? ""}</Kinetic>
    <PriceTag item={items[0]} size={300} role="accent" at={8} entrance="punch" />
  </Safe>
</Scene>
```
