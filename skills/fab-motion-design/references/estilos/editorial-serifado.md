# Estilo: editorial serifado

Serifa alta, margens generosas, câmera que empurra devagar: uma página de revista em movimento, quieta e cara. Serve para clínica, advocacia, arquitetura, joalheria, hotel, moda e estética de alto padrão.

Referências: `references/examples/aurea.md` e `references/examples/aurea-opus.md` (a mesma clínica de dermatologia, duas leituras).

## Regras contáveis

- Paleta: `background` e `text` carregam a peça (creme e tinta, ou o inverso numa peça escura); `accent` num detalhe por cena (um fio, uma palavra em itálico). Sem marca: `#f7f3ec`, `#1c1a17`, `accent` `#c98a5a`.
- Tipo: título em serifada de alto contraste (Playfair Display, Fraunces), peso **300 a 500**, herói de **150 a 210 px**, itálico em no máximo **uma palavra por cena**; sobretítulo de 48 a 52 px em CAIXA ALTA, `tracking` 0,2em, na fonte do corpo.
- Tempo (30 qps): entradas de **18 a 26 quadros**, `outCubic` ou `inOutCubic`, `mask-up` por linha; câmera empurra de zoom 1 a 1,08 na cena inteira; cenas de 2,2 a 3,6 s.
- Composição: margens de **96 px** em 1080 de largura, bloco de texto numa coluna à esquerda com 60 a 70% da largura, um fio que se desenha (`<PathDraw>`) em pelo menos **2 cenas**, uma foto cortada sangrando o quadro.
- Transições: `fade`, `match`, `push-*`, `shape-circle`; nenhum `whip` nem `stack`.
- Textura: `<Grain>` de 0,04 a 0,06; `<Burst>` só `sparks`, `count` até 20, uma vez; `blur-in` até 16.
- Evite: peso acima de 600, `scale-punch`, `slot`, `scramble`, cores saturadas, mais de 3 elementos por cena.
