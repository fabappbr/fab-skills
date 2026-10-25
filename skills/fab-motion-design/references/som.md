# Som

Boa parte das pessoas assiste sem som. A peça precisa funcionar muda (o texto na tela diz tudo) e ficar melhor com som.

## A trilha

- Uma trilha por peça, instrumental, gerada no clima do tom da marca. Para pedi-la, escreva `soundtrack="track"` na `<Sequence>`.
- A plataforma corta a trilha no tamanho da peça, entra suave e faz o fade nos últimos 1,5 s. Você não controla batida nem tempo da música: escreva as durações pelo tempo de leitura, não pela música.
- O volume padrão é 0,6, abaixo dos efeitos. Só mude (`<Soundtrack volume={0.4} />`) se o pedido falar de música mais baixa ou mais alta.
- Peça sem trilha: omita `soundtrack`. Serve para ramos sóbrios e para quem vai pôr a própria música na rede social.
- Nada de música conhecida, nem "no estilo de" um artista.

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
