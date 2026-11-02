# Receita de cena: gancho em pergunta

```tsx
/* Gancho em pergunta. 2 s = 4 batidas a 120 bpm. Abre a peça.
 * Plano: a pergunta É a dor do público, até 4 palavras, inteira no quadro 15; a foto do assunto vaza pela base e pelas laterais.
 * Tamanhos: <Kinetic fit> (cerca de 220 px); a foto com 1180 px de largura (passa das duas bordas).
 * Movimento: scale-punch de 9 quadros, 2 entre palavras (a última assenta no 15); câmera empurra 1 a 1,05; na batida 3 (quadro 30) o marca-texto
 * desenha "horas" (a ÚNICA ênfase). Nada de mode="type" aqui.
 * Leva: a foto sobe e vira o fundo da cena seguinte (carry "the photo rises into the frame", transição push-up).
 */
<Scene canvas duration={sec(2)} bg="background">
  <Camera keys={[{ at: 0, zoom: 1 }, { at: 60, zoom: 1.05, ease: "outQuint" }]}>
    <At x={0.5} y={0.86}>
      <Picture slot="hook-subject" prompt="hands editing a video on a laptop at night, warm screen light, close-up, no text"
               width={1180} height={760} radius={48} />
    </At>
    <Safe justify="flex-start">
      <Kinetic mode="scale-punch" fit step={2} dur={9} color="ink" align="center" marks={{ horas: "marker" }} markAt={30}>
        {"Ainda perde\nhoras\neditando?"}
      </Kinetic>
    </Safe>
  </Camera>
</Scene>
```
