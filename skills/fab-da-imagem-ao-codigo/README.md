# Da Imagem ao Código (`fab-da-imagem-ao-codigo`)

## Edição terminal

Esta é a edição para agentes que constroem pelo terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) com o CLI `@fabappai/cli`. O conhecimento (fichas, tabelas, motor de combinação, pacotes, checagem de clareza, perguntas ao dono) é o mesmo da edição Studio. O que mudou:

- **O agente vê a imagem.** No Studio a imagem vira uma descrição em texto feita por um modelo de visão; no terminal o agente abre o arquivo com a própria ferramenta de leitura e lê os pixels. A imagem é a especificação; pedir prints melhores continua valendo quando ela está pequena ou cortada. Os prints ficam em `referencias/` na raiz do projeto, nunca no workspace.
- **A marca vai para o tema pelo agente.** O que ia para a `brand` do briefing (ou para a aba Marca e o patch de tema da edição) o agente grava em `apps/<slug>/fab.config.json → theme` (`primary`, `bg`, `card`, `text`, `accent`, `primaryFg`, `mode`, `titleFont`, `bodyFont`, `titleTracking`, `radius` em número) e envia com `fabapp push`. No código continuam só tokens e classes. O logo o dono sobe no Studio.
- **Export do Claude Design:** o agente lê o HTML e extrai o tema ele mesmo (no Studio a plataforma aplicava sozinha).
- **Sem `place_image` nem `show_references`:** foto do dono vira slot `AppImage` que ele troca no Studio; referências de sites vêm da busca na web da ferramenta do agente ou de links do dono.
- **Etapas viraram o fluxo do agente:** conversa, plano mostrado ao dono (com a lista de conferência inteira, sem o teto de 8 critérios), construção, conferência seção a seção contra a imagem na pré-visualização do `fabapp dev` e por busca no código, publicação com `fabapp deploy`, e mudanças depois.
- A memória do app é o arquivo `DECISOES.md` na raiz do projeto.

O mapa de cobertura e as notas abaixo descrevem a edição Studio, de onde esta foi convertida.

Método para transformar um print, mockup, desenho ou export do Claude Design que o dono anexa num app fiel à referência: leitura profunda seção a seção, marca extraída para o briefing, plano com ficha por seção, construção sem deriva e conferência seção a seção. Sem anexo, a composição é escrita no plano antes do código.

- Categoria: visual
- Etapas: briefing, plan, build, edit
- Tokens (validador): ver a última linha deste arquivo
- Complementa a `fab-agencia` (direção de arte própria para sites); esta skill parte da referência do dono.

## Origem

- `image-to-code-skill` (nome original `image-to-code`) do repositório taste-skill, https://github.com/Leonxlnx/taste-skill, commit c184364 (baixado em 24/09/2026).
- Licença: MIT. Copyright (c) 2026 Leonxlnx. "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND."
- Obra derivada, reescrita em português para a plataforma Fabapp. Análise usada: `analise/01` seção 3.

## Como a plataforma recebe a imagem (fato que moldou a adaptação)

Conferido no código (`ingest/service.py`): a imagem anexada passa por um modelo de visão que escreve uma descrição (até ~800 tokens; no briefing, com um roteiro de estrutura: tipo de tela, regiões, navegação, componentes, textos, cores e tom). O briefing, o plano e o build leem essa descrição como `[imagem N]`, não os pixels. O export HTML do Claude Design chega como código desempacotado, e o tema do design (cores, fontes, pesos, raio) é aplicado ao app pela plataforma. Por isso "gerar mais imagens" virou "pedir prints melhores ao dono" e "gerar a imagem primeiro" virou "escrever a composição no plano primeiro".

## Mapa de cobertura

| Função/técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| Diretiva central: imagem primeiro, análise depois, código por último | Abertura; "como a referência chega"; plano | Imagem do dono ou composição escrita vêm antes do código |
| Lista de padrões ruins da IA (colagem, texto miúdo, herói escuro centrado, cartões, zigue-zague, caixas aninhadas, pílulas) | Construção (herói, caixas, ritmo); ref. seção 6 | Mantido |
| Qualidades exigidas (premium, legível, construível, limpo na primeira tela) | Construção; critérios de aceite | Viraram critérios conferíveis |
| 1. Nove controles de base (8/3/8/9/9/9/10/10/9) e interpretação por palavras | Tabela "padrões de partida" | Mantido; "empenho em gerar imagens" virou empenho em obter referência legível |
| 2. Regra obrigatória de imagem primeiro | "Como a referência chega"; Sem anexo | Sem geração de mockup na plataforma: composição escrita no plano |
| 3. Gerar imagens suficientes | Briefing passo 2 ("uma referência legível por seção"); plano sem anexo (um bloco por seção) | Pedido de prints ao dono; blocos escritos por seção |
| 4. Uma imagem por seção (tabela 1 a 10) | Briefing passo 2; plano | Um print por seção; um bloco de composição por seção |
| 5. Não recortar imagens antigas | Briefing passo 2 | Print novo da seção em tela cheia em vez de recorte |
| 6. Regerar seção pouco clara como imagem nova | Briefing passo 2; plano ("reescreva o bloco vago") | Pedido de novo print; reescrita do bloco |
| 7. Imagem extra de detalhe | Plano (segundo bloco para seção complexa); ordem de resolução passo 5/6 | Mantido por escrito e por pedido |
| 8. Padrão de análise limpa (10 perguntas por seção) | Plano, Ficha de leitura; ref. seção 1 | Mantido |
| 9. Análise profunda (30+ itens) | Ref. seção 1, integral | Mantido e agrupado |
| 10. Fluxo em 8 passos | Briefing, plano, construção em sequência | Distribuído pelas etapas |
| 11. Quando disparar imagem primeiro; quando código direto | `description` (gatilhos); "Sem anexo" | Pedido técnico ou com design pronto não passa por composição |
| 12. Motor de combinação (tema, fundo, tipo, herói, seções, 4 componentes, 2 movimentos) | Plano sem anexo; ref. seção 3 | Cada componente de assinatura e movimento mapeado para construção real e kit de motion |
| 13. Referência de site comunica layout, hierarquia etc. | Ref. seção 3, último parágrafo | Aplicado ao bloco escrito |
| 14. Minimalismo do herói, título 1 a 3 linhas, sem enfeites | Construção, Herói; critério visual | Mantido; exceção para app de uso diário (regra da plataforma) |
| 15. Primeira tela num notebook pequeno | Construção, Herói; critério 1280x720 | Mantido |
| 16. Anti caixa aninhada | Construção, Caixas; critério | Mantido |
| 17. Reduzir microinterface de enfeite | Construção, Caixas e enfeites | Mantido |
| 18. Geração por seção (herói 1, 4, 8, 12) | Briefing passo 2; exemplos na ref. seção 8 | Por print ou bloco |
| 19. Sistema de imagens do site | Construção, Imagens | `AppImage` com prompt da mesma cena; `place_image` para foto do dono |
| 20. Molduras de mídia fixas | Construção, Imagens; critério `aspect-*` | Mantido |
| 21. Extração de texto | Ref. seção 1 (Texto); briefing passo 3 e 4 | Só texto do dono vai literal; de terceiros vira texto próprio; fatos viram marcador |
| 22. Extração de tipografia | Ref. seção 1; tabela de fontes e tamanhos | Fonte pela aparência para Google Fonts na `brand` |
| 23. Extração de espaço | Ref. seção 1; tabela px para Tailwind | Mantido |
| 24. Extração de botões e componentes | Ref. seção 1 | Mantido |
| 25. Extração de cor | Briefing passo 5; tabela de cor por papel | Hex na `brand`; tokens no código |
| 26. Disciplina de cópia | Construção, Disciplina de cópia | Mantido |
| 27. Contra a deriva | Construção, Contra a deriva | Mantido |
| 28. Resolução de detalhe faltante (7 passos) | Construção, "Quando um detalhe continua incerto" | Passos 5 e 6 viraram outra imagem anexada e pedido no `finish` |
| 29. Anti-slop (layout, visual, tipografia, conteúdo, marca falsa, complexidade falsa, densidade) | Ref. seção 6 | Clichês reescritos em PT-BR |
| 30. Tipografia primeiro | Ref. seção 6, parágrafo final | Mantido |
| 31. Ritmo de seções | Construção, Ritmo e densidade | Mantido |
| 32. Disciplina de densidade e espaço | Construção, Ritmo e densidade | Mantido |
| 33. Pacotes de 4, 8 e 12 seções | Ref. seção 4 | Adaptados a negócio brasileiro (endereço, horário, WhatsApp, pagamentos); nada de logos falsos |
| 34. Consistência entre várias imagens | Ref. seção 5 | Mantido; a mais recente vence em conflito |
| 35. Checagem de clareza (21 itens) | Ref. seção 7 | Adaptada aos 21 itens da Fabapp |
| 36. Comportamento de resposta (22 passos) | Briefing, plano e construção em ordem | Distribuído pelas etapas |
| 37. Três exemplos | Ref. seção 8 | Reescritos para prints do dono e sem anexo |
| 38. Objetivo final | Abertura | Mantido |
| (sem equivalente) Referência de outra empresa | "Como a referência chega"; briefing passo 3 | Copiar estrutura e estilo, nunca marca, texto, foto ou número alheio |
| (sem equivalente) Edição com print novo ou print marcado | "Na edição" | Método só nas seções afetadas; cor pelo patch de tema; logo por `set_brand`; fonte e raio na aba Marca |

## O que ficou de fora ou foi trocado

- Gerar imagens de design (mockups) pela própria IA: a plataforma não gera mockup. Trocado por pedir prints ao dono, pedir o export do Claude Design, mostrar sites reais com `show_references` e escrever a composição por seção no plano.
- Regras específicas do Codex: não se aplicam; o espírito (legibilidade por seção) ficou no pedido de prints.
- Ver pixels diretamente: o build lê a descrição de visão; a skill trata a descrição como especificação e manda perguntar o que ela não trouxe.
- Hex e nomes de fonte no código: proibidos pela plataforma; vão na `brand` do briefing.

## Tokens

Ver a saída do validador da edição terminal.
