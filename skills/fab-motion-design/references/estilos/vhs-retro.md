# Estilo: VHS retrô

Grão de fita, linhas de varredura, franja cromática e código de tempo; nostálgico, alto, de madrugada. Serve para bar, balada, música, moda, games e promoção relâmpago.

Referência: ainda não há peça de referência deste estilo.

## Regras contáveis

- Paleta: fundo roxo profundo ou preto, texto branco quente, `primary` e `accent` os dois tubos de neon. Sem marca: `#120c1e`, `#f6ecff`, `primary` `#3a1460`, `accent` `#ff4f9a`.
- Tipo: display condensada (Bebas Neue, Oswald), CAIXA ALTA, peso **700 a 800**, herói de **180 a 340 px**, com uma cópia deslocada **4 a 6 px** em `accent` atrás (a franja cromática); um rótulo REC ou código de tempo de 60 px num canto.
- Tempo (30 qps): entradas de 6 a 10 quadros com `snap`; uma tremida horizontal de 2 a 6 px por **3 quadros** em todo corte; linhas de tracking descem em 20 a 30 quadros, uma vez por cena.
- Composição: `<Layout align="center">`, palavras dentro de 80% da largura; rótulos de canto dentro da área segura.
- Transições: `cut`, `whip-*`, `zoom`; um chiado de 4 quadros antes do pico.
- Textura: `<Grain>` de **0,10 a 0,12** em toda cena, varredura como `<Lines angle={0}>` com `alpha` de 0,06 a 0,1, `<Vignette>` de 0,5 a 0,7, `<LightLeak>` no máximo **2** vezes, desfoque até 6; nenhum `<Burst>`.
- Evite: fundo chapado e limpo, serifada fina, `fade` lento, mais de duas cores de neon.
