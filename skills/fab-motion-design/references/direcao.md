# Direção: o roteiro de planos

A peça nasce em duas etapas. Primeiro a **direção** decide o estilo, a trilha e o roteiro de planos, em JSON; depois a **animação** escreve as cenas a partir desse roteiro, em partes de cerca de 15 s. Esta página é da direção: ela não escreve código.

## O que a direção decide

- **Estilo:** um dos de `references/estilos/`, pelo pedido e pela marca. Se o dono escolheu um estilo, ele vale.
- **Trilha:** o clima da música em poucas palavras em inglês (`"warm acoustic guitar, 100 bpm"`), ou `null` para uma peça sem música (ramo sóbrio, ou o dono pediu sem música).
- **Momento marcante:** um só, com a cena em que acontece.
- **O roteiro de planos:** uma entrada por cena, na ordem, com:

| Campo | O que é |
|---|---|
| `id` | Nome curto da cena, em inglês, sem espaço (`hook`, `price`, `close`) |
| `title` | O que a cena diz, até 7 palavras, no idioma da peça. É o que o dono vê enquanto a peça é montada |
| `seconds` | A duração. A soma fecha com a duração da peça |
| `intent` | Por que a cena existe (gancho, prova, preço, pausa antes do pico, fecho) |
| `framing` | O que ocupa o quadro (o produto grande, a palavra sozinha, a tela dividida) |
| `camera` | O movimento da câmera (empurra devagar, recua, gira, parada com respiração) |
| `reveal` | Como o elemento principal entra (máscara de baixo, recorte em círculo, linha que se desenha) |
| `texts` | O texto da tela: `{"text": ...}` para palavras, `{"item": i, "field": "name"}` (ou `"price"`, `"photo"`) para dado de item, `{"cta": ..., "action": ...}` para a chamada final |
| `transition` | A transição de entrada da cena (a primeira não tem) |
| `sfx` | O efeito sonoro da entrada, ou `null` |
| `media` | `none`, `ai-image`, `ai-video` ou `photo` (a foto real do item) |

## Regras contáveis

1. **Preço só por referência.** `{"item": 0, "field": "price"}`, e só para item com preço. Nunca um preço ou um desconto escrito num `text`.
2. **Gancho até 2,5 s** com o produto, o benefício ou a oferta. Nunca logo, saudação ou "Conheça a".
3. **Tempo de leitura:** cada cena dura pelo menos `0,6 s + 0,3 s por palavra` e nunca menos que 1,2 s; no máximo 8 s.
4. **Ritmo:** durações variadas, uma cena mais calma e curta logo antes do momento mais forte.
5. **Fecho:** a última cena tem a `cta` e dura o tempo de leitura mais 1 s.
6. **Transições e efeitos:** nunca a mesma transição três vezes seguidas; efeito sonoro em parte das cenas, `impact` uma vez só.
7. **Mídia:** `photo` só de item com foto; `ai-video` em no máximo 2 cenas e só quando o pedido ou o estilo pede imagem em movimento.

## Quantas cenas

| Duração | Cenas | Duração média |
|---|---|---|
| 6 a 10 s | 3 a 5 | 2 a 2,5 s |
| 15 s | 5 a 7 | 2,2 a 3 s |
| 30 s | 9 a 13 | 2,5 a 3,2 s |
| 60 s | 16 a 22 | 3 a 3,6 s |
| 90 s | 22 a 30 | 3 a 4 s |
| 120 s | 28 a 40 | 3 a 4,2 s |

## Peças longas (45 s ou mais)

Uma peça longa não é uma peça curta esticada. Ela se conta em **atos**:

1. **Gancho** (2 a 3 cenas, até 8 s): a promessa da peça.
2. **Atos do meio** (2 a 4): cada um abre com uma cena curta de título (uma ou duas palavras grandes, 1,5 a 2 s) e trata de um assunto: um produto, um serviço, um diferencial, um passo.
3. **Pico:** o momento marcante, com a cena calma logo antes.
4. **Fecho:** a marca e a chamada.

Para não cansar:
- alterne o enquadramento (perto, longe, tela dividida, só tipografia) e o fundo a cada cena;
- repita um **motivo visual** da marca (uma forma, uma linha, uma cor) no começo de cada ato, para a peça parecer uma só;
- a cada 15 a 20 s, uma mudança de energia: fundo escuro para claro, câmera parada para câmera rápida;
- com muitos itens, um ato por grupo (até 4 itens por ato), nunca uma fila de cenas iguais.

A animação escreve a peça em partes de cerca de 15 s. Escreva cada cena completa no roteiro: quem anima uma parte só vê as cenas dela por inteiro e o título das outras.
