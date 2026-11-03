# Som

Boa parte das pessoas assiste sem som. A peça precisa funcionar muda (o texto na tela diz tudo) e ficar melhor com som.

## A trilha

- Uma trilha por peça, instrumental, gerada no clima do tom da marca. Para pedi-la, escreva `soundtrack="track"` na `<Sequence>`.
- A plataforma corta a trilha no tamanho da peça, entra suave e faz o fade nos últimos 1,5 s.

## Cortar na batida

A música é o metrônomo da peça. Um corte fora do tempo parece erro de edição, mesmo para quem não sabe dizer por quê.

- **O andamento:** o bpm escrito no clima da trilha (`"upbeat electronic, 120 bpm"`); sem bpm, ou com a trilha padrão da marca, conte **120**. Uma batida dura `60 / bpm` segundos: 0,5 s (15 quadros) a 120, 0,6 s (18 quadros) a 100, 0,4 s (12 quadros) a 150.
- **Cada troca de cena cai numa batida**, com folga de 2 quadros: as durações são batidas inteiras (a 120 bpm, 1,5, 2, 2,5, 3 s). A direção já escreve assim e a plataforma acerta para a grade o que errar por pouco, sem encurtar nenhuma cena abaixo do tempo de leitura.
- **O pico cai num tempo forte:** num múltiplo de 4 batidas desde o início (2 s, 4 s, 6 s a 120 bpm).
- **Dentro da cena, as batidas internas também:** a palavra do `<WordSwap>` troca a cada batida ou a cada duas (`every={15}` ou `every={30}` a 120 bpm), o contador assenta numa batida, o soco da câmera cai numa batida. `useBeat(bpm)` dá um pulso que acompanha a grade.
- O tempo de leitura continua valendo: a cena dura pelo menos a leitura, arredondada para a batida seguinte.
- O volume padrão é 0,6. Só mude (`<Soundtrack volume={0.4} />`) se o pedido falar de música mais baixa ou mais alta.
- Peça sem trilha: omita `soundtrack`. Serve para ramos sóbrios e para quem vai pôr a própria música na rede social.
- Nada de música conhecida, nem "no estilo de" um artista: o gerador recusa.

## Orientar a trilha

Se o pedido falar da música (estilo, energia, instrumentos, andamento), diga isso em `<Soundtrack mood="…" />`, dentro da `<Sequence>`, em poucas palavras **em inglês**, que é como o gerador entende melhor:

```tsx
<Sequence soundtrack="track">
  <Soundtrack mood="upbeat electronic, bright synths, 120 bpm" />
  …
</Sequence>
```

- Descreva gênero, clima, instrumentos e andamento: `"acoustic guitar and light percussion, warm, 100 bpm"`, `"cinematic piano, hopeful, slow build"`.
- Nunca nome de artista, banda, música ou filme.
- Sem nada sobre música no pedido, omita o `mood`: a plataforma usa o tom da marca.

## A escolha do dono

O dono também escolhe a trilha no editor, e a escolha fica escrita no próprio `<Soundtrack>`:

- `take="<id>"`: uma versão gerada que ele escolheu (outra versão do mesmo estilo, ou uma anterior).
- `src="upload:<id>"`: a música que ele enviou.
- `volume={…}`: o volume que ele ajustou.

Regras ao ajustar uma peça:
- Mantenha `take`, `src` e `volume` exatamente como estão, a menos que o pedido fale da música.
- Pedido de música mais alta ou mais baixa: mude só o `volume`.
- Pedido de outro estilo de música: escreva o `mood` novo e tire `take` e `src`, para gerar uma trilha nova.
- Pedido de tirar a música: remova o `<Soundtrack>` e o `soundtrack` da `<Sequence>`.
- Nunca invente um `take` ou um `src`: os ids vêm do editor.

## Efeitos sonoros

**Peça com trilha não leva efeito.** A música já marca os cortes, e os efeitos do kit são sons sintéticos (bipes, cliques, sopros) que, por cima da trilha, soam amadores. Numa peça com `<Soundtrack>` ou `soundtrack="track"`, não escreva `sfx` nem `hits`: a plataforma não os toca. Só quando o pedido pede efeitos sonoros escreva `<Soundtrack sfx />` e use os efeitos com parcimônia (o dono também liga e desliga isso no editor).

Peça **sem** trilha pode ter efeitos. O kit tem uma biblioteca fixa. Há dois lugares para um efeito, e nenhum componente toca efeito sozinho:

- `sfx` na `<Scene>`: toca no primeiro quadro da cena, junto com a entrada (e a transição) dela.
- `hits` na `<Scene>`: efeitos em quadros da própria cena, para o que acontece dentro dela: `hits={[{ at: 14, kind: "click" }, { at: 28, kind: "click" }]}`. O `at` é o quadro da cena (de 0 até a duração); fora dela, o efeito não toca.

| Efeito | Usar quando |
|---|---|
| `whoosh` | a cena entra com movimento (`push-*`, `whip-*`, `zoom-through`, `slide`, `color-wipe`, `zoom`) |
| `pop` | entra um selo, um item novo, uma forma que salta, um corte seco |
| `click` | uma palavra troca no `<WordSwap>`, uma escolha, um botão, um passo |
| `cha-ching` | o preço assenta (no quadro em que o `<PriceTag>` termina o punch) |
| `shimmer` | a marca se revela, o fechamento, uma marca que se desenha |
| `impact` | o pico, uma vez só: o produto que cai, a palavra mais forte |

Regras:
- Por cena: no máximo um `sfx` e até 3 `hits`, e nem toda cena precisa de efeito. Numa peça de 15 s, de 4 a 8 efeitos no total bastam.
- Um `hits` cai no quadro em que a coisa acontece na tela (o mesmo `at` do movimento, mais a duração da entrada quando o som é do assento). Som fora do movimento parece erro.
- `impact` no máximo uma vez por peça, seja em `sfx` ou em `hits`.
- Ramos sóbrios (saúde, direito, contabilidade): só `whoosh`, `click` e `shimmer`, e no máximo 4 na peça.
- Numa peça sem trilha, `<Soundtrack sfx={false} />` não se aplica: basta não escrever efeitos.

## Legenda

Sem narração (ainda não existe), o texto da tela já cumpre o papel da legenda. Não repita o título num `<Caption>`.
