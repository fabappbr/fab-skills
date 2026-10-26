# Som

Boa parte das pessoas assiste sem som. A peça precisa funcionar muda (o texto na tela diz tudo) e ficar melhor com som.

## A trilha

- Uma trilha por peça, instrumental, gerada no clima do tom da marca. Para pedi-la, escreva `soundtrack="track"` na `<Sequence>`.
- A plataforma corta a trilha no tamanho da peça, entra suave e faz o fade nos últimos 1,5 s. Você não controla batida nem tempo da música: escreva as durações pelo tempo de leitura, não pela música.
- O volume padrão é 0,6, abaixo dos efeitos. Só mude (`<Soundtrack volume={0.4} />`) se o pedido falar de música mais baixa ou mais alta.
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

O kit tem uma biblioteca fixa. O efeito toca no começo da cena que o declara (`sfx` na `<Scene>`), junto com a entrada dela; nenhum componente toca efeito sozinho.

| Efeito | Usar na cena que |
|---|---|
| `whoosh` | entra com `slide`, `color-wipe` ou `zoom` |
| `pop` | traz um selo, um item novo, um corte seco |
| `click` | mostra uma escolha, um botão, um passo |
| `cha-ching` | mostra o preço |
| `shimmer` | revela a marca, o fechamento |
| `impact` | é o pico, uma vez só |

Regras:
- No máximo um efeito por cena, e nem toda cena precisa de um. Três ou quatro numa peça de 15 s bastam.
- `impact` no máximo uma vez por peça.
- Ramos sóbrios (saúde, direito, contabilidade): só `whoosh` e `shimmer`, ou nenhum.
- `<Soundtrack sfx={false} />` silencia todos os efeitos de uma vez, quando o pedido pede "sem efeitos".

## Legenda

Sem narração (ainda não existe), o texto da tela já cumpre o papel da legenda. Não repita o título num `<Caption>`.
