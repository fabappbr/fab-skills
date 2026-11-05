# Estilo: editorial serifado

Serifa alta, margens generosas, câmera que empurra devagar: uma página de revista em movimento, quieta e cara. Serve para clínica, advocacia, arquitetura, joalheria, hotel, moda e estética de alto padrão.

Referências: `references/examples/aurea.md` e `references/examples/aurea-opus.md` (a mesma clínica de dermatologia, duas leituras).

## Regras contáveis

- Paleta: `background` e `text` carregam a peça (creme e tinta, ou o inverso numa peça escura); `accent` num detalhe por cena (um fio, uma palavra em itálico). Sem marca: `#f7f3ec`, `#1c1a17`, `accent` `#c98a5a`.
- Tipo: título em serifada de alto contraste (Playfair Display, Fraunces) com `<Headline>` (o kit a põe de 400 a 600, nunca preta), `l` (150 px) ou `xl`; título em duas cores (`lead` na tinta quieta, a ideia com `underline`) em pelo menos **2 cenas**; itálico em no máximo **uma palavra por cena**; rótulo `<Eyebrow variant="rule">` acima.
- Tempo (30 qps): entradas de **18 a 26 quadros**, `outCubic` ou `inOutCubic`, `mask-up` por linha; câmera empurra de zoom 1 a 1,08 na cena inteira; cenas de 2,2 a 3,6 s.
- Composição: blocos `<Layout>` alinhados à esquerda na margem de 10%, `optical` ou `upper`; um fio que se desenha (`<PathDraw>`) em pelo menos **2 cenas**; um `split` com a foto sangrando o quadro; um `<Numeral>` gigante (o passo, a inicial) em uma ou duas cenas.
- Transições: `fade`, `match`, `push-*`, `shape-circle`; nenhum `whip` nem `stack`.
- Textura: `<Surface />` nas cenas claras (luz suave, curvas de nível, grão de 0,04 a 0,06); `<Burst>` só `sparks`, `count` até 20, uma vez; `blur-in` até 16.
- Evite: peso acima de 600, `scale-punch`, `slot`, `scramble`, cores saturadas, mais de 3 elementos por cena.
