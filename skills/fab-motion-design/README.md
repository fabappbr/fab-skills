# Motion Design (`fab-motion-design`)

Skill que dirige a composição de vídeos curtos e carrosséis no Fabapp Motion: roteiro, ritmo, texto, movimento, som e autoconferência, sempre sobre o kit `@fab/motion`.

Criada pela Equipe Fabapp. Versão 1.2.0 (29/10/2026): a segunda camada do kit (motion design), as regras do validador, o ofício contável, os estilos e as peças de referência.

- **Edição motion:** não é usada pelo terminal. A plataforma injeta esta skill inteira (corpo e `references/`) em toda composição e todo ajuste por conversa do Motion, pelo `skills/inject.py`. O Jev pode somar a ela uma skill de estilo (`fab-estilo-*`).
- **Cerca de 60 KB** de texto (corpo e `references/*.md`), abaixo do teto de 60 mil tokens por chamada. As peças de `references/examples/` (cerca de 43 KB) ficam fora do texto de toda composição: a plataforma as entrega à parte (`motion.service.skill_examples`), para o compositor receber 1 ou 2 do estilo escolhido.
- **Kit:** `references/kit.md` descreve as exportações de `studio/src/motion/kit/index.ts`. O teste `studio/src/motion/kit/skillDocs.test.ts` da plataforma falha quando uma exportação falta aqui, quando o arquivo cita um componente que não existe ou quando um exemplo difere da peça de referência.

## Arquivos

| Arquivo | O que tem |
|---|---|
| `SKILL.md` | Contrato, fluxo, as 12 regras de motion, proibições, formato da resposta |
| `references/kit.md` | As duas camadas do kit (os 28 componentes da primeira e o motion design), as propriedades e as regras do validador |
| `references/roteiros.md` | 7 roteiros de vídeo, o carrossel e a conversão de duração |
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

O que é nosso: o contrato de dados (preço e prova só de dado, mídia gerada nunca é o produto), os roteiros para pequeno negócio brasileiro, as regras por ramo regulado e a nota de 10 pontos das baterias.
