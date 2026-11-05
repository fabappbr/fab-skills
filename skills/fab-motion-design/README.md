# Motion Design (`fab-motion-design`)

Skill que dirige a composição de vídeos curtos e carrosséis no Fabapp Motion: roteiro, ritmo, texto, movimento, som e autoconferência, sempre sobre o kit `@fab/motion`.

Criada pela Equipe Fabapp. Versão 1.10.0 (05/11/2026): composição e tipografia. O conteúdo de cada cena é um bloco só na grade de margens (`<Layout>`: centro óptico por padrão, terços, centro, e `split` com a foto inteira dentro das margens ou sangrando de propósito), a decoração (`<Ornament>`, `<Numeral>`) vive na zona livre e nunca encosta nas palavras, o título é `<Headline>` (a fonte no peso, espaçamento e entrelinha que ela pede, linhas equilibradas, duas cores com `lead`, régua com `underline`), o rótulo é `<Eyebrow variant="rule">` e a superfície é `<Surface>` (luz, curvas de nível e grão). As receitas de cena e as peças de referência foram refeitas sobre o `<Layout>`, e as regras de borda ficaram iguais às da conferência da plataforma (foto inteira nas margens ou sangrando por duas bordas; cartão arredondado nunca cortado por uma borda só). A 1.9.0 (04/11/2026): o som marca a animação. Os efeitos voltam por cima da trilha, agora uma biblioteca gravada (`whoosh`, `whoosh-long`, `impact`, `thud`, `tick`, `pop`, `stamp`, `riser`, `resolve`, `cha-ching`), cada um no quadro em que a coisa acontece, sutis e baixos na mistura, de 3 a 6 numa peça de 15 s, com pelo menos uma cena em silêncio; o dono desliga no editor (`<Soundtrack sfx={false} />`) e o pedido "sem efeitos sonoros" vale. A 1.8.0 (03/11/2026): a curva por intenção (entrada `outExpo` em 18 a 24 quadros, saída `inExpo` em 10 a 14, herói com mola de sobra 1,04 a 1,08, câmera `inOutCubic` longa, contador `outExpo`, nunca `linear` em entrada ou saída) e o ritmo que respira (pausa antes da chamada, acento a cada 8 a 10 s, nunca três cenas iguais seguidas). A 1.7.0 (03/11/2026): a referência de estilo, quando o dono manda um vídeo que ama (a peça segue paleta, tipografia, ritmo, transições, movimento e textura dele, nunca as palavras, o logo ou as pessoas). A 1.6.1 (03/11/2026): preço, data ou número escrito no pedido vira texto de tela exatamente como o dono escreveu (a 1.6.0 o deixava fora quando nenhum item o carregava). A 1.6.0 (02/11/2026) trouxe a interface demonstrada como herói (`<PromptBox>` e `<Checklist>` do kit, texto de 80 px ou mais, caixa de 92% da largura segura ou vazando) e as receitas de pedido digitado e da mágica acontecendo refeitas sobre elas; o kit passou a garantir o gancho assentado até o quadro 15, o `<Kinetic fit>` que enche cerca de 72% do quadro sem faixa, a chamada de 4 palavras em duas linhas sem encolher e o `<SocialPost>` com no máximo 60% da altura. A 1.5.0 trouxe o corte na batida da trilha, sem efeitos sobre a música, `<Kinetic fit>`, `<Icon>`, `<SocialPost>` e `<Picture>`, um esquema de cor por peça, o `carry` entre cenas e as receitas de cena. A 1.3.0 trouxe a composição em duas etapas (direção e animação em partes), as peças longas de até 120 s e o ajuste de cenas. A 1.2.0 trouxe a segunda camada do kit (motion design), as regras do validador, o ofício contável, os estilos e as peças de referência.

- **Edição motion:** não é usada pelo terminal. A plataforma injeta esta skill inteira (corpo e `references/`) em toda composição e todo ajuste por conversa do Motion, pelo `skills/inject.py`. O Jev pode somar a ela uma skill de estilo (`fab-estilo-*`).
- **Cerca de 100 KB** de texto (corpo e `references/*.md`), abaixo do teto de 60 mil tokens por chamada. As peças de `references/examples/` (cerca de 43 KB) ficam fora do texto de toda composição: a plataforma as entrega à parte (`motion.service.skill_examples`), para o compositor receber 1 ou 2 do estilo escolhido.
- **Kit:** `references/kit.md` descreve as exportações de `studio/src/motion/kit/index.ts`. O teste `studio/src/motion/kit/skillDocs.test.ts` da plataforma falha quando uma exportação falta aqui, quando o arquivo cita um componente que não existe ou quando um exemplo difere da peça de referência.

## Arquivos

| Arquivo | O que tem |
|---|---|
| `SKILL.md` | Contrato, fluxo, as 12 regras de motion, proibições, formato da resposta |
| `references/kit.md` | As duas camadas do kit (os 28 componentes da primeira e o motion design), a interface demonstrada, as propriedades e as regras do validador |
| `references/direcao.md` | A direção: o roteiro de planos em JSON, quantas cenas por duração, as peças longas em atos (só a chamada da direção lê) |
| `references/animacao-em-partes.md` | A animação: o formato da resposta de uma parte e do ajuste de cenas de uma peça longa |
| `references/roteiros.md` | 7 roteiros de vídeo, o carrossel, a conversão de duração e as peças longas (só a chamada da direção lê) |
| `references/tempo-e-movimento.md` | Molas por tom da marca, entradas, saídas, transições, curva de energia |
| `references/tipografia-e-layout.md` | Zonas seguras por formato, tamanhos, corte de texto, contraste |
| `references/som.md` | Trilha, corte na batida, pausa antes do pico, efeitos |
| `references/marca-e-dados.md` | O que vem de dado, mídia gerada, ramos com regra própria |
| `references/autoconferencia.md` | Lista antes de devolver, a nota de 10 pontos das baterias, sinais de cara de IA |
| `references/estilos/*.md` | Os 5 estilos (tipografia cinética, editorial, gráfico ousado e produto herói, cinematográfico, minimal luxo), cada um com regras contáveis |
| `references/examples/*.md` | As peças de referência da prova de teto, cópias exatas de `studio/src/motion/references/` (um teste da plataforma confere) |

## Referências usadas

- [claude-remotion-skill](https://github.com/haidrrrry/claude-remotion-skill): as regras fixas de movimento (nada linear, entradas com várias propriedades, escalonar 3 a 6 quadros, saída mais rápida, respiração, Ken Burns, tempo pelo `fps`, renderizar e inspecionar quadros).
- [huashu-motion](https://github.com/alchaincyf/huashu-motion): gancho em 3 s, crescendo no meio, pausa antes do momento mais forte, efeitos sonoros ligados ao movimento, a lista de sinais de "cara de IA" e a conferência antes e depois do render.
- [Remotion Agent Skills](https://www.remotion.dev/docs/ai/skills): skill enxuta com regras em arquivos de referência separados.
- Guias da Meta e do TikTok para Reels e anúncios em vídeo: zonas seguras de 9:16 (14% em cima, 35% embaixo, 6% nas laterais) e gancho nos primeiros 3 s ([resumo](https://www.cinerads.com/blog/meta-ads-video-creative-best-practices)).
- `fab-agencia/references/motion-e-interacao.md`: a ideia de personalidade de movimento por marca, adaptada de site para vídeo.

O que é nosso: o contrato de dados (preço e prova só de dado, foto real antes de mídia gerada), os roteiros para pequeno negócio brasileiro, as regras por ramo regulado e a nota de 10 pontos das baterias.
