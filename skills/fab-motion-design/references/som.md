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

**O som marca a animação.** Um efeito no quadro exato em que a coisa acontece dá à peça cara de intenção: o selo que cai e estala, o logo que carimba, a palavra que troca com um tique. Os efeitos são uma biblioteca gravada, mixada por baixo da trilha (baixos na mistura, e a música abaixa um pouco em cada efeito), e tocam com trilha ou sem ela. Nenhum componente toca efeito sozinho: o som é a folha de efeitos que você escreve.

Dois lugares para um efeito:

- `sfx` na `<Scene>`: toca no primeiro quadro da cena, no corte.
- `hits` na `<Scene>`: efeitos em quadros da própria cena, para o que acontece dentro dela: `hits={[{ at: 24, kind: "thud" }, { at: 40, kind: "pop" }]}`. O `at` é o quadro da cena (de 0 até a duração); fora dela, o efeito não toca.

**A regra do quadro:** o `at` é sempre o quadro em que a coisa acontece na tela. Um elemento que entra em `at` assenta 20 quadros depois (a entrada do kit), então o som do assento vai em `at + 20`; a troca de palavra e o toque no botão soam no quadro deles. Nunca um efeito num quadro em que nada se move. O movimento e o pouso são trabalhos diferentes: o sopro acompanha o movimento, o baque marca o contato.

| Efeito | Usar quando |
|---|---|
| `whoosh` | o ar curto de um movimento ou de um corte que se move (`push-*`, `whip-*`, `zoom-through`, `slide`, `color-wipe`); nunca em `match` nem em `fade` |
| `whoosh-long` | um movimento de câmera ou uma revelação longa |
| `impact` | o pico da peça quando ele é uma pancada de verdade, uma vez só; no pico comum, prefira o `thud` |
| `thud` | o herói pousa macio (o celular que sobe e para, o produto que cai) |
| `tick` | uma palavra troca no `<WordSwap>`, um passo, um botão pressionado |
| `pop` | entra um selo, um item, uma forma |
| `stamp` | o logo ou um selo carimba |
| `riser` | uma subida que termina exatamente no pico |
| `resolve` | o nome da marca assenta, o fechamento |
| `cha-ching` | o preço ou a venda (no quadro em que o `<PriceTag>` termina o punch) |

A plataforma alinha o som ao quadro: o `whoosh` chega ao máximo no `at`, e o `riser` termina no `at`. Por isso o `riser` vai na cena do pico, com `at` no quadro do pico (o mesmo do `thud` ou do `impact`), e sobe durante a cena anterior. Use o `riser` em peça de 10 s ou mais.

Quantos:
- Por cena: no máximo um `sfx` e até 3 `hits` (o kit ignora o que passar disso).
- Sutil por padrão: a peça se lê com o som desligado; o efeito confirma um pouso, nunca o anuncia.
- Numa peça de 15 s, de 3 a 6 efeitos no total (na proporção para outras durações), e pelo menos uma cena em silêncio. Nunca um `whoosh` em todo corte.
- `impact` no máximo uma vez por peça, seja em `sfx` ou em `hits` (o kit toca só o primeiro).
- O movimento maior leva o som mais presente; gesto pequeno leva um `tick`.
- Ramos sóbrios (saúde, direito, contabilidade): só `whoosh`, `tick` e `resolve`, no máximo 4 na peça, ou nenhum.

**A escolha do dono:** o pedido que diz "sem efeitos sonoros" não leva efeito nenhum. No editor, o dono desliga os efeitos e isso fica escrito como `<Soundtrack sfx={false} />`: mantenha assim ao ajustar a peça. Numa peça sem trilha, não escreva `<Soundtrack>` para desligar os efeitos (ele pede uma trilha): basta não escrever `sfx` nem `hits`. Os nomes antigos `click` e `shimmer` ainda tocam (como `tick` e `resolve`), mas escreva os novos.

## Legenda

Sem narração (ainda não existe), o texto da tela já cumpre o papel da legenda. Não repita o título num `<Caption>`.
