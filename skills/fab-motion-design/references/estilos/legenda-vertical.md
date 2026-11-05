# Estilo: legenda vertical

Legendas grandes em 9:16 para quem assiste sem som; as palavras carregam a mensagem inteira, uma frase por vez. Serve para dica, depoimento, bastidor, oferta falada e qualquer peça de Reels ou Stories.

Referência: ainda não há peça de referência deste estilo.

## Regras contáveis

- Paleta: fundo escuro ou foto, texto branco, `accent` o marca-texto da legenda (a palavra falada, uma faixa atrás dela). Sem marca: `#0b0b0b`, `#ffffff`, marca-texto `#ffe14d`.
- Tipo: sem serifa pesada (Montserrat, Poppins, Archivo), peso **800 a 900**, caixa de frase, legendas de **150 a 190 px** em 1 ou 2 linhas de no máximo **3 palavras**, palavras-herói de 180 a 300 px; contorno escuro de 8 a 12 px ou uma caixa atrás de cada legenda.
- Tempo (30 qps): um bloco de legenda a cada **12 a 20 quadros**, cada um entrando em 4 a 6 quadros (`scale-punch` ou `mask-up`), a palavra da vez em `accent`; nada digitado letra a letra.
- Composição: legendas num `<Layout place="optical" align="center">`, nunca nos 35% de baixo (os botões do Reels) nem nos 14% de cima; a foto ou o produto como fundo sangrando ou num `split`.
- Transições: `cut`, `match`, `push-up`; toda troca de cena cai numa troca de legenda.
- Textura: nenhuma sobre as legendas; `<Vignette>` até 0,5 nas cenas com foto; sem `<Grain>` sobre texto, sem `<Burst>`.
- Evite: legenda com mais de 3 palavras por linha, peso fino, parágrafo centralizado, texto no terço de baixo.
