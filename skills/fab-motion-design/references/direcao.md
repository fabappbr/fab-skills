# Direção: o roteiro de planos

A peça nasce em duas etapas. Primeiro a **direção** decide o estilo, a trilha e o roteiro de planos, em JSON; depois a **animação** escreve as cenas a partir desse roteiro, em partes de cerca de 15 s. Esta página é da direção: ela não escreve código.

## O que a direção decide

- **Estilo:** um dos de `references/estilos/`, pelo pedido e pela marca. Se o dono escolheu um estilo, ele vale.
- **Trilha:** o clima da música em poucas palavras em inglês, terminando no andamento (`"warm acoustic guitar, 100 bpm"`), ou `""` para a trilha padrão da marca (conte 120 bpm), ou `null` para uma peça sem música (ramo sóbrio, ou o dono pediu sem música). O andamento é a grade dos cortes.
- **Momento marcante:** um só, com a cena em que acontece.
- **O roteiro de planos:** uma entrada por cena, na ordem, com:

| Campo | O que é |
|---|---|
| `id` | Nome curto da cena, em inglês, sem espaço (`hook`, `price`, `close`) |
| `title` | O que a cena diz, até 7 palavras, no idioma da peça. É o que o dono vê enquanto a peça é montada |
| `seconds` | A duração. A soma fecha com a duração da peça |
| `intent` | Por que a cena existe (gancho, prova, preço, pausa antes do pico, fecho) |
| `framing` | O que ocupa o quadro e onde o bloco fica: `optical`, `upper`, `lower`, `center` ou `split` (as palavras em cima, a foto no resto); por exemplo `"split: words above the bottle photo"`, `"optical: two-tone headline, numeral 01 above"` |
| `camera` | O movimento da câmera (empurra devagar, recua, gira, parada com respiração) |
| `reveal` | Como o elemento principal entra (máscara de baixo, recorte em círculo, linha que se desenha). Em cena com mais de 3 s, as batidas internas: `"word lands, then swaps, then the card rises"` |
| `texts` | O texto da tela: `{"text": ...}` para palavras, `{"item": i, "field": "name"}` (ou `"price"`, `"photo"`) para dado de item, `{"cta": ..., "action": ...}` para a chamada final |
| `transition` | A transição de entrada da cena (a primeira não tem) |
| `carry` | O que atravessa o corte e chega NESTA cena vindo da anterior, até 8 palavras em inglês (`"the orange button grows into the frame"`), ou `null`. Pelo menos 1 em cada 3 cortes leva alguma coisa |
| `sfx` | O efeito sonoro do corte que entra nesta cena (quadro 0), ou `null` |
| `cue` | Os efeitos dentro da cena, até 3: `[{"at": 24, "kind": "thud", "on": "phone lands"}]`, com `at` no quadro em que a coisa acontece (veja `som.md`), ou `[]` |
| `media` | O FUNDO da cena: `none`, `ai-image`, `ai-video` ou `photo` (a foto real do item) |
| `pictures` | Opcional. As imagens geradas que entram COMO ELEMENTO da cena (a foto dentro do post, a tela do celular, a polaroide, o produto, o lugar), uma descrição curta em inglês para cada, até 3 por cena |

## Regras contáveis

1. **Preço só por referência.** `{"item": 0, "field": "price"}`, e só para item com preço. Nunca um preço ou um desconto escrito num `text`.
2. **Gancho até 2,5 s** com o produto, o benefício ou a oferta: as palavras dele SÃO o valor, em até 4 palavras inteiras na tela até o quadro 15 (0,5 s). Nunca logo, saudação, "Conheça a" nem texto digitado letra a letra (digitação é de uma cena posterior que demonstra um pedido, uma busca, um chat).
3. **Tempo de leitura:** cada cena dura pelo menos `0,6 s + 0,3 s por palavra` e nunca menos que 1,2 s; no máximo 8 s.
4. **Ritmo:** durações variadas, uma cena mais calma e curta logo antes do momento mais forte. Até 30 s, um corte a cada 1,5 a 3 s; cena com mais de 3 s escreve no `reveal` ou na `camera` uma batida interna pelo menos a cada 1 s ("A, then B, then C"), senão a plataforma avisa (a pausa antes do fecho, no item 5, é a exceção: segura de propósito).
5. **Respiro e acento:** numa peça de 15 s ou mais, nunca três cenas seguidas com a mesma duração; um acento a cada 8 a 10 s (a cena mais curta da peça, uma batida inteira abaixo da mediana e de no máximo 1,5 s, nunca abaixo de uma batida, ou uma troca de família de transição); numa peça de 15 s ou mais, a cena antes do fecho é a pausa, com pelo menos 1,5 vez a duração mediana, uma ideia só e movimento lento. A plataforma alonga a pausa que o roteiro esquecer, tirando batidas da vizinha mais longa (`references/tempo-e-movimento.md`).
6. **Corte na batida:** cada troca de cena cai na grade de batidas do andamento da trilha (120 bpm: 0,5 s; 100 bpm: 0,6 s), então as durações são batidas inteiras, e o pico cai num tempo forte (múltiplo de 4 batidas). A plataforma acerta para a grade o que errar por pouco.
7. **Sem molde repetido:** nunca 3 cenas seguidas com o mesmo enquadramento, a mesma receita de fundo ou o herói no mesmo lugar; uma palavra heroica vive numa cena só; pelo menos 2 cenas com um visual vazando pela borda; pelo menos 30% das cenas sem `Grid`, `Dots` nem `Glow`.
8. **Composição:** o conteúdo de cada cena é um bloco só na grade de margens, no lugar que o `framing` nomeia (`references/tipografia-e-layout.md`). Nunca palavras grudadas no topo com a foto grudada embaixo e o meio vazio: cena com foto é `split`. Decoração (uma forma, um numeral gigante) fica na zona livre acima ou abaixo do bloco, nunca encostada nas palavras; nunca formas estacionadas nas bordas para "preencher". Não repita a mesma colocação três cenas seguidas.
9. **Fecho:** a última cena tem a `cta` e dura o tempo de leitura mais 1 s.
10. **Transições e efeitos:** nunca a mesma transição três vezes seguidas. O som marca a animação, com trilha ou sem: um efeito por momento para onde o olho vai, no quadro em que ele assenta, nunca num quadro parado. `whoosh` só em corte que se move (nunca em `match` nem `fade`), no pico um `thud` (o `impact`, uma vez só, quando o pico é uma pancada de verdade), e em peça de 10 s ou mais um `riser` na cena do pico com `at` no quadro do pico. Sutil por padrão: a peça se lê com o som desligado; o efeito confirma um pouso, nunca o anuncia. De 3 a 6 efeitos numa peça de 15 s, pelo menos uma cena em silêncio; ramos sóbrios só `whoosh`, `tick` e `resolve`, no máximo 4. Pedido "sem efeitos sonoros": todo `sfx` `null` e todo `cue` vazio.
11. **Mídia:** `photo` só de item com foto, e a cena que mostra esse item usa a foto. `ai-image` e `ai-video` podem mostrar fundo, textura, cenário e o produto sem foto; `ai-video` onde o movimento ajuda (o dono confirma o preço de cada vídeo). Quando o pedido manda mostrar coisas (uma vitrine, um prato, um ambiente, um antes e depois), cada uma vira uma entrada de `pictures` na cena que a mostra, descrita de forma concreta (assunto, cenário, luz). Fundos `ai-image` e `pictures` somam no limite de imagens incluídas (`generated_images_included`); gaste-as primeiro no assunto.

## Quantas cenas

Menos cenas que o mínimo da tabela volta para a direção corrigir. Uma peça de 30 s em 8 cenas de 4,5 a 5,7 s parece apresentação de slides.

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
- a cada 15 a 20 s, uma mudança de energia: câmera parada para câmera rápida, fundo liso para foto, cor de fundo para a principal (sempre dentro do esquema claro ou escuro da peça);
- com muitos itens, um ato por grupo (até 4 itens por ato), nunca uma fila de cenas iguais.

A animação escreve a peça em partes de cerca de 15 s. Escreva cada cena completa no roteiro: quem anima uma parte só vê as cenas dela por inteiro e o título das outras.
