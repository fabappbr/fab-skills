# Estilo: editorial

Uma página de revista em movimento: serifada, muito respiro, câmera lenta, linhas finas que se desenham. Serve para serviços e profissionais (clínica, advocacia, consultoria, arquitetura, estética).

Referências: `references/examples/aurea.md` e `references/examples/aurea-opus.md` (a mesma clínica de dermatologia, duas leituras).

## Regras contáveis

- Título na fonte `heading`, peso **300 a 400**, de **150 px** ou mais (`fit={[150, 210]}`: o teto de 210 deixa respiro à serifa leve; o kit só o sobe o bastante para a linha chegar a cerca de 72% do quadro); itálico em **uma palavra por cena** no máximo.
- Entradas lentas: `dur` de **18 a 26 quadros**, `step` de 5 a 8; modos `mask-up` por linha, `blur-in` e `fade`. Nada de `scale-punch`, `slot` nem `scramble`.
- Cenas de **2,2 a 3,6 s**; câmera com deslocamento de no máximo **zoom 1,1** e 40 px.
- Pelo menos **2 linhas que se desenham** (`<PathDraw>`: moldura, sublinhado, onda, seta) na peça.
- Uma palavra marcada (`marks`: `circle`, `marker` ou `underline`) em **no máximo 2 cenas**.
- Sobretítulo (48 a 52 px, caixa alta, espaçado) acima do título em pelo menos **2 cenas**, num componente seu que recebe o texto (`<Eyebrow>` local, `<Masthead label>`).
- Transições calmas: `match`, `fade`, `push-*`, `shape-circle`; nenhum `whip` nem `stack`.
- Textura discreta: `<Grain amount>` de 0,04 a 0,06; `<Burst>` só `sparks`, no máximo um na peça.
- Efeitos sonoros (só em peça sem trilha): só `whoosh`, `click` e `shimmer`; no máximo **4** na peça.
