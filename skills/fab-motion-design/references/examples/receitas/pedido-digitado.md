# Receita de cena: pedido digitado (demonstração de interface)

```tsx
/* Pedido digitado. 3 s = 6 batidas. O ÚNICO lugar de digitação: uma cena que demonstra um pedido, nunca o gancho.
 * Plano: a caixa do pedido É o herói, e nenhum título concorre com ela: um bloco <Layout> no centro óptico com um rótulo e o
 * <PromptBox> do kit (nunca div à mão) na largura da coluna (width="bleed" vaza pelas duas bordas), texto de 88 px (nunca abaixo de 80).
 * Batidas: 0 a caixa sobe (12 quadros); 6 a digitação começa (1 quadro por letra, cerca de 1 s); 60 a caixa afunda
 * 4 quadros (antecipação) e volta com sobra no 76; dali ela cresce a partir do botão até cobrir o quadro e vira o fundo
 * da cena seguinte (carry "the button grows into the next frame", corte seco).
 */
<Scene canvas duration={sec(3)} bg="background" transition="push-up">
  <Layout>
    <Eyebrow variant="rule">Você pede</Eyebrow>
    <Move origin="50% 85%"
          keys={[{ at: 0, y: 80, opacity: 0 }, { at: 12, y: 0, opacity: 1, ease: "outBack" },
                 { at: 60, scale: 1 }, { at: 64, scale: 0.96 }, { at: 76, scale: 1, ease: "outBack" },
                 { at: 90, scale: 9, ease: "inExpo" }]}>
      <PromptBox button="Gerar" at={6} color="primary">Quero um vídeo da minha padaria</PromptBox>
    </Move>
  </Layout>
</Scene>
```
