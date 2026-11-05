# Receita de cena: a mágica acontecendo (o processo)

```tsx
/* A mágica acontecendo. 2,5 s = 5 batidas; uma etapa assenta a cada batida (15 quadros), o quadro se enche sozinho.
 * Plano: a lista de etapas É o herói, e nenhum título concorre com ela: um bloco <Layout> no centro óptico com um rótulo
 * e o <Checklist> do kit (nunca div à mão) na largura da coluna, linhas de 80 px, check de 112 px, a barra enchendo sob cada linha.
 * Batidas: as linhas assentam nos quadros 0, 15, 30 e 45 (só a linha nova se mexe; as que assentaram ficam paradas).
 * A câmera empurra devagar enquanto a lista cresce.
 * Leva: a câmera mergulha na última linha, que vira a cena seguinte: a PRÓXIMA cena entra com transition="zoom-through"
 * e carry "dive into the last check" (a transição vai na cena que entra). Esta entra com push-left.
 */
<Scene canvas duration={sec(2.5)} bg="primary" transition="push-left">
  <Camera keys={[{ at: 0, zoom: 1 }, { at: 55, zoom: 1.06, ease: "outQuint" }, { at: 75, y: 220, zoom: 3, ease: "inExpo" }]}>
    <Layout>
      <Eyebrow variant="rule">Em segundos</Eyebrow>
      <Checklist items={[{ label: "Roteiro escrito", at: 0 }, { label: "Imagens geradas", at: 15 },
                         { label: "Trilha na batida", at: 30 }, { label: "Vídeo pronto", at: 45 }]} />
    </Layout>
  </Camera>
</Scene>
```
