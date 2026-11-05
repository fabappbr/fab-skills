# Estilo: keynote escuro

Palco quase preto, um único destaque e luz que varre devagar o produto ou a frase. Serve para lançamento de produto, tecnologia, evento, anúncio de novidade e marca com clima premium.

Referência: `references/examples/launch.md` (as texturas das cenas 1 e 7).

## Regras contáveis

- Paleta: fundo quase preto (luminância abaixo de 0,02), texto quase branco; `accent` é a ÚNICA cor e mora na luz (um `<Glow>`, uma varredura, uma palavra). Sem marca: `#0a0a0c`, `#f5f5f7`, destaque `#5b9dff`.
- Tipo: grotesca, peso **600 a 800**, caixa de frase, herói de **150 a 260 px** centralizado, apoio de 60 a 72 px com 70% de opacidade.
- Tempo (30 qps): revelações de **18 a 24 quadros**, `inOutCubic`; varreduras de luz de **40 a 60 quadros**; um respiro de preto (6 a 10 quadros) antes do pico; câmera empurra de zoom 1 a 1,06 por cena.
- Composição: **um herói por cena**, `<Layout place="optical" align="center">`, com 25% de quadro vazio em volta; produto ou celular iluminado de um lado, num `split`.
- Transições: `fade`, `match`, `zoom-through` no pico; no máximo **1** `whip-*`.
- Textura: `<Glow intensity>` até 0,6, `<Vignette>` de 0,4 a 0,6, `<Grain>` até 0,05, desfoque nas entradas até 12; `<Burst>` só `sparks`, `count` até 24, uma vez.
- Evite: fundo claro, mais de um destaque, `<Marquee>`, `<Dots>`, padrões carregados, mola com sobra.
