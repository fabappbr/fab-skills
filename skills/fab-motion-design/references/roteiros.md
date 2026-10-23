# Roteiros

Cada roteiro é uma estrutura testada de cenas. Escolha um e ajuste as durações para a duração pedida. A soma tem que fechar. Os tempos abaixo são para 15 s; a tabela no fim converte para 6, 10 e 30 s.

## Promo do dia

Para: oferta com prazo curto, um produto.

| # | Cena | Tempo | O que diz | Componentes |
|---|---|---|---|---|
| 1 | Gancho | 1,8 s | A urgência + o produto aparecendo | `Eyebrow` + `Product` (`spring`) |
| 2 | Nome | 2,4 s | O nome do produto | `Title` (palavra) + `BrandShape` |
| 3 | Pausa | 0,6 s | Nada novo: desacelera, trilha baixa | o produto respira |
| 4 | Preço | 3,2 s | Preço de/por e selo | `Price` (gg) + `Badge` |
| 5 | Prazo | 2,4 s | Até quando | `Title` ou `Countdown` |
| 6 | Ação | 4,6 s | Peça no WhatsApp | `EndCard` + `CallToAction` |

## Produto em destaque

Para: lançamento ou produto novo, sem urgência.

1. Gancho (2 s): detalhe do produto em zoom lento, uma palavra de impacto.
2. O que é (3 s): nome e uma qualidade concreta ("massa de fermentação natural").
3. Como é (3 s): segunda foto ou o produto girando leve, uma prova (`Rating` se houver).
4. Preço (3 s): `Price` sozinho na tela.
5. Ação (4 s): `EndCard`.

## Conheça o app

Para: levar o cliente a pedir pelo app. Só com projeto.

1. Gancho (2 s): o resultado ("Seu pedido em 3 toques"), celular entrando.
2. Toque 1 (3 s): `AppScreen` na lista, `Tap` no produto.
3. Toque 2 (3 s): `AppScreen` no carrinho, `Tap` em pagar.
4. Pronto (3 s): tela de confirmação, `Caption` "Pago no Pix".
5. Ação (4 s): `CallToAction action="open-app"` + `QrCode` se o pedido falar de loja física.

## Depoimento

Para: prova social. Só com `reviews` reais.

1. Gancho (2,5 s): a frase mais forte da avaliação, grande.
2. Quem disse (2,5 s): nome e estrelas.
3. O produto (3 s): `Product` do item citado (se houver).
4. Nota geral (3 s): `Rating` com média e total.
5. Ação (4 s): `EndCard`.

Sem avaliações reais, este roteiro não pode ser usado. Diga isso no comentário da folha de ritmo e use "Produto em destaque".

## Horário e aviso

Para: feriado, horário especial, mudança de endereço. Geralmente 6 s.

1. Gancho (2 s): o dia, grande.
2. O horário (2,5 s): `Hours`.
3. Ação (1,5 s): logo e contato.

## Lista de ofertas

Para: feira, mercado, cardápio do dia, vários itens.

1. Gancho (2 s): "Ofertas de domingo" + forma da marca.
2. a 5. Um item por cena (2 s cada): `Product` + `Price`. Até 4 itens; mais que isso, use `ProductGrid` numa cena de 3 s.
6. Ação (3 s ou o que sobrar): prazo e `CallToAction`.

## Antes e depois

Para: serviço com resultado visível (estética, reforma, jardinagem, limpeza).

1. Gancho (2 s): o "depois" já aparecendo pela metade.
2. Comparativo (5 s): `Compare variant="wipe"` indo e voltando uma vez.
3. O que foi feito (3 s): `List` com até 3 linhas.
4. Ação (5 s): `EndCard` com "Peça um orçamento".

Fotos de antes e depois são do dono. Nunca gere nenhuma das duas.

## Carrossel

| Slide | Papel | O que tem |
|---|---|---|
| 1 | capa | Gancho em até 5 palavras, forma da marca saindo pela borda direita, "Arraste" pequeno |
| 2 a n-1 | item | Um item por slide: foto, nome, preço. Alterne a posição da foto (cima, baixo) a cada slide. |
| n | final | Prazo, endereço ou contato, `CallToAction`. A forma da marca volta pela esquerda. |

Regras: 2 a 10 slides; o mesmo fundo em todos os slides de item; o gancho da capa nunca repete o título de um slide de item; `continues` em todos menos no último.

## Convertendo a duração

Proporção de cada parte do roteiro (vale para todos os roteiros de vídeo):

| Parte | 6 s | 10 s | 15 s | 30 s |
|---|---|---|---|---|
| Gancho | 1,5 s | 1,8 s | 1,8 a 2,5 s | 2,5 s |
| Miolo | 3 s, 1 ou 2 cenas | 5,5 s, 2 ou 3 cenas | 8 a 9 s | 21 s, até 6 cenas |
| Ação | 1,5 s | 2,7 s | 3 a 4,6 s | 6,5 s |

Em 6 s, corte a pausa e o prazo. Em 30 s, repita o miolo com outro item ou outra prova, nunca com o mesmo texto.
