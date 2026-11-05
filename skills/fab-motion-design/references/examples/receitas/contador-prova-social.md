# Receita de cena: contador de prova social

```tsx
/* Contador de prova social. 2,5 s = 5 batidas. Só com número que o pedido ou os dados dão: sem número, o post sem contador.
 * Plano: o post É o herói: a imagem de um <Layout place="split">, 780 px de largura (72%) e até 60% da altura (o kit para
 * aí), inteiro dentro das margens, sob a frase do bloco de cima. Nada flutua sobre a linha das curtidas.
 * Tamanhos: frase de apoio 72 px acima; contagem do próprio <SocialPost> (algarismos tabulares).
 * Movimento: o post sobe em 14 quadros (outExpo); a contagem vai do quadro 8 ao 44 (termina antes de 60% da cena, 75
 * quadros) e fica parada no valor final; o coração bate a cada 15 quadros (a batida). Só o post se mexe depois de entrar.
 * Leva: nada (corte seco na batida).
 */
const PROOF_LIKES = 12480; // o número que o pedido deu

<Scene canvas duration={sec(2.5)} bg="background" transition="push-up">
  <Layout place="split" media={
    <Move keys={[{ at: 0, y: 260, opacity: 0 }, { at: 14, y: 0, opacity: 1, ease: "outExpo" }]}>
      <SocialPost likes={PROOF_LIKES} from={0} countAt={8} count={36} pulse={15} width={780}>
        <Picture slot="post-photo" prompt="bakery shop window with golden bread, morning light, close-up, no text" radius={0} />
      </SocialPost>
    </Move>}>
    <Kinetic mode="mask-up" size={72} color="ink">Seu post, assim:</Kinetic>
  </Layout>
</Scene>
```
