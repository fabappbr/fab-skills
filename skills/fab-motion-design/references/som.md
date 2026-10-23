# Som

Boa parte das pessoas assiste sem som. A peça precisa funcionar muda (texto na tela diz tudo) e ficar melhor com som.

## A trilha

- Uma trilha por peça, gerada no clima do pedido ou escolhida da biblioteca. O kit recebe as batidas marcadas (`beats`) e as batidas fortes.
- Clima pelo tom da marca: alegre e animado pedem 105 a 125 bpm; aconchegante e elegante, 80 a 100 bpm; sóbrio, 85 a 100 bpm sem percussão forte.
- Volume da trilha em 70% quando há efeitos; fade de saída nos últimos 0,8 s.
- Nada de música conhecida, nem pedir "no estilo de" um artista.

## Cortes na batida

- Com `snapToBeat`, cada troca de cena vai para a batida mais próxima (até 4 quadros de ajuste). Escreva as durações pensando nisso: múltiplos de uma batida.
  - A 120 bpm, uma batida dura 0,5 s.
  - A 100 bpm, dura 0,6 s.
- A cena do pico (preço ou oferta) começa numa batida forte.
- A pausa antes do pico: a trilha baixa para 30% ou para por 0,4 a 0,8 s, e volta na batida forte do pico.

## Efeitos sonoros

O kit traz uma biblioteca fixa. A transição e o componente já tocam o efeito padrão; mude só com motivo.

| Efeito | Usar em |
|---|---|
| `whoosh` | Transições `slide`, `color-wipe`, `zoom` |
| `pop` | Selo entrando, corte seco, item de lista |
| `click` | `<Tap>` na tela do app |
| `cha-ching` | Preço chegando |
| `shimmer` | Logo, máscara da marca, fechamento |
| `impact` | O pico, uma vez só |

Regras:
- No máximo um efeito por segundo.
- `impact` no máximo uma vez por peça.
- Efeito sempre sincronizado com o movimento que o causa (no mesmo quadro).
- Ramos sóbrios (saúde, direito, contabilidade): só `whoosh` e `shimmer`, volume baixo.

## Legenda

Se o pedido ou a trilha tiverem fala (F2 em diante: narração), toda fala vira `<Caption>`. Sem fala, o texto da tela já cumpre o papel.
