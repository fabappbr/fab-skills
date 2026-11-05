# Receita de cena: gancho em pergunta

```tsx
/* Gancho em pergunta. 2 s = 4 batidas a 120 bpm. Abre a peça.
 * Plano: a pergunta É a dor do público, até 4 palavras, inteira no quadro 15, no bloco de cima de um <Layout place="split" bleed>;
 * a foto do assunto ocupa o resto do quadro e sangra pelas laterais e pela base, de propósito (sem canto arredondado).
 * Tamanhos: <Kinetic fit> (cerca de 220 px) na coluna da grade.
 * Movimento: scale-punch palavra a palavra (o kit assenta a cena 1 inteira até o quadro 15); câmera empurra 1 a 1,05; na batida 3 (quadro 30) o marca-texto
 * desenha "horas" (a ÚNICA ênfase). Nada de mode="type" aqui.
 * Leva: a foto sobe e vira o fundo da cena seguinte (carry "the photo rises into the frame", transição push-up).
 */
<Scene canvas duration={sec(2)} bg="background">
  <Camera keys={[{ at: 0, zoom: 1 }, { at: 60, zoom: 1.05, ease: "outQuint" }]}>
    <Layout place="split" bleed
            media={<Picture slot="hook-subject" prompt="hands editing a video on a laptop at night, warm screen light, close-up, no text" radius={0} />}>
      <Kinetic mode="scale-punch" fit color="ink" marks={{ horas: "marker" }} markAt={30}>
        {"Ainda perde\nhoras\neditando?"}
      </Kinetic>
    </Layout>
  </Camera>
</Scene>
```
