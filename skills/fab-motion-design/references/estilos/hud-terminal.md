# Estilo: HUD terminal

Dados em fonte monoespaçada, colchetes e grades, números que rolam: uma sala de controle numa tela escura. Serve para tecnologia, finanças, resultado em números, games e segurança.

Referência: ainda não há peça de referência deste estilo.

## Regras contáveis

- Paleta: fundo preto esverdeado, texto menta claro, `accent` o verde fósforo dos valores vivos, `primary` o preenchimento escuro dos painéis. Sem marca: `#05080a`, `#d8ffe9`, `accent` `#39ff88`, painel `#0f2a1f`.
- Tipo: linhas de dados na monoespaçada do sistema (`fontFamily: "ui-monospace, Menlo, monospace"`) com números tabulares; o herói na fonte `heading`, peso 700, CAIXA ALTA, de **150 a 240 px**; rótulos de 60 px, `tracking` 0,12em, entre [ colchetes ].
- Tempo (30 qps): `<AnimatedNumber>` rola por **18 a 30 quadros** e assenta até 60% da cena; modos `scramble` ou `type` nos rótulos, 1 letra por quadro; um cursor pisca a cada 8 quadros.
- Composição: `<Grid>` com `alpha` de 0,08 a 0,12 em toda cena; colchetes nos cantos emolduram o herói; valores numa grade de 4 colunas com margens de 64 px; um número enorme e cortado.
- Transições: `cut`, `whip-*`, `zoom-through`; no máximo uma `shape-rect`.
- Textura: linhas de varredura como `<Lines angle={0}>` com `alpha` até 0,08; `<Glow>` só no valor em destaque, `intensity` até 0,5; nenhum `<Burst>`.
- Evite: serifada, formas arredondadas e fofas, cores pastel, mola com sobra.
