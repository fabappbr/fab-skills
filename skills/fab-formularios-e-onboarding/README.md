# Formulários e Onboarding (`fab-formularios-e-onboarding`)

## Edição terminal

Esta é a edição para agentes que constroem pelo terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio. O que mudou:

- Topo com primeiro movimento (`references/fabapp-cli.md`), contrato ao vivo e a regra das duas mãos; `DECISOES.md` guarda formato dos formulários, momento "entendi" e checklist.
- Dados de exemplo: o CLI não grava registros. Onde o Studio propunha o preenchimento para o dono aprovar, o agente escreve os exemplos em `src/lib/exemplos.ts` e deixa no app um botão "Carregar exemplos" (admin) que os grava com `is_sample: true`; ou o dono cadastra ou importa no CMS do Studio.
- Schema no `fab.schema.json` (`fabapp pull`, editar, `fabapp push`) antes do código; `react-hook-form` e `@hookform/resolvers` entram com `npm install` dentro de `.fabapp/workspace`.
- Plano mostrado ao dono antes de codar; critérios de aceite viraram a lista de conferência, sem teto; `assumptions` viraram as suposições do plano.
- `fab-padroes-brasil` virou recomendação ("se estiver instalada"), com a regra essencial escrita aqui.
- A conferência final ganhou o preenchimento de ponta a ponta na pré-visualização do `fabapp dev` e a publicação com tratamento de 422 e 409.

Decide quando e como dividir formulários longos em etapas (progresso honesto, validação por etapa, rascunho, revisão, CPF ou CNPJ, máscaras) e faz o app gerado nunca abrir vazio (momento "entendi", checklist de primeiros passos, dados de exemplo removíveis, pular e retomar, medição).

- **Categoria**: other
- **Etapas**: plan, build, edit
- **Tamanho aproximado** (validador): corpo ~3.780 tokens (plano ~1.670, construção ~2.670, edição ~1.350); referências ~5.870 tokens.

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| multi-step-form-design (SKILL.md e 9 referências) | https://github.com/rampstackco/claude-skills (`skills/multi-step-form-design`, commit 3d4510a) | MIT, Copyright (c) 2026 RampStack Co. |
| onboarding-wizard-design (SKILL.md e 9 referências) | https://github.com/rampstackco/claude-skills (`skills/onboarding-wizard-design`, commit 3d4510a) | MIT, Copyright (c) 2026 RampStack Co. |

Texto reescrito como obra derivada. Licença MIT: "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."

## Verificações na plataforma que moldaram a skill

- `Stepper` do kit esconde nomes abaixo de `sm`: daí "Etapa 2 de 4: Endereço" em texto.
- `Field`/`FieldGroup` já fazem rótulo acima, `hint` e `error` com `aria-invalid`.
- Validação do servidor dá 422 para obrigatório faltando: por isso campos de etapas seguintes não são `required` no schema quando há rascunho.
- O build não grava registros: dados de exemplo são propostos (`propose_data_fill`) com `is_sample: true`.
- `trackEvent` vai para as ferramentas de análise que o dono ligar; a medição dentro do app usa os próprios dados (`last_step` do rascunho, primeiro registro criado).
- CEP: busca opcional no ViaCEP direto do navegador (só o CEP sai do app, nenhum dado da pessoa; mesma regra da skill fab-padroes-brasil), com os campos digitáveis se falhar; `AddressInput` quando o dono liga o Google Maps.

## Mapa de cobertura

| Função/técnica da original | Onde está | Adaptação |
|---|---|---|
| Multi-step: decisão página única vs etapas (8 a 10 campos, agrupamento, compromisso crescente, condicionais, métrica; 4 a 6 campos, pressa, conversa quente) | Decisão 1; ref. formulários "Quando vale dividir" | |
| Multi-step: custo de construção e manutenção, custo de oportunidade | Fora | Custo de engenharia não se aplica a app gerado; o equivalente é "corte campos em vez de dividir" |
| Multi-step: pré-condição de agrupamento, exemplos certos e forçados | Decisão 2; ref. formulários | Exemplos brasileiros |
| Multi-step: padrão híbrido (curto + complemento depois) | Decisão 1 | |
| Multi-step: aposentar ou voltar a página única | Edição; ref. formulários | |
| Multi-step: três formas (tudo numa página, teatro, etapas de verdade) e teste da frase | Decisão 2; ref. formulários "Três formas" | |
| Multi-step: padrões de etapa (identidade, contexto, necessidade, detalhe, confirmação), sequência, 3 a 7 campos, nomes de etapa, transições, exemplos por uso | Decisões 2 e 3; ref. formulários "Padrões de etapa"; esqueleto | Exemplos de cadastro, orçamento, matrícula, anamnese |
| Multi-step: indicador (contador, barra, lista, nenhum, híbrido), honestidade, 5 falhas, posição, celular, mensagens | Decisão 4; ref. formulários "Indicador" | `Stepper` + texto + `Progress` |
| Multi-step: lógica condicional (mostrar/esconder, pular etapa, adaptar linguagem, adaptar destino, caminhos), preferência pela simplicidade, testes, falhas | Decisão 7; build "Condicional"; ref. formulários "Lógica condicional" | PF/PJ, menor de idade, veículo |
| Multi-step: salvar e retomar (e-mail, conta, sessão anônima, híbrido), confiança, momento de oferecer, retomada, medição, dados sensíveis | Build "Rascunho"; ref. formulários "Rascunho e retomada" | Conta = registro `draft`; aparelho = `localStorage`; link por e-mail trocado por login (não se grava dado de visitante sem conta) |
| Multi-step: validação (por etapa, no fim, híbrida, em tempo real), mensagens, lugar, momento, entre campos, rigidez, acessibilidade, celular | Decisão 5; build; ref. formulários "Validação" | `zod`, `trigger`, `Field` |
| Multi-step: medição por etapa, pontos de queda e remediação, caminhos condicionais, segmentos, tempo, testes A/B, queda como filtro | Build "Medir"; edição; ref. formulários "Onde as pessoas param" | `trackEvent` + `count` por `last_step`. Teste A/B fica fora (a plataforma não tem divisão de tráfego) |
| Multi-step: anti-padrões (14) e falhas comuns com diagnóstico | Ref. formulários "Anti-padrões"; edição | |
| Multi-step: 12 considerações | "Conferência antes do finish" | |
| Multi-step: "se o dado não existe, declare a lacuna" | Regra geral da equipe (não inventar) aplicada à medição | |
| Onboarding: decisão assistente vs ajuda no contexto (5 condições, contraexemplos) | Plano "Assistente ou só checklist"; ref. primeiros passos | |
| Onboarding: tutorial demais, pular no vazio, revelação na hora certa, teste | Decisões 8 e 9; ref. primeiros passos | |
| Onboarding: arquitetura de passos, sequência, momento "entendi" no passo 3 a 5, campos por passo, transições, exemplos por produto, manutenção | Build "Assistente"; ref. primeiros passos "Passos do assistente" | Manutenção = revisar o assistente em cada edição que muda a configuração |
| Onboarding: momento "entendi" (ação, único, visível, honesto), identificação, tempo até valor, valor intermediário, por público, anti-padrões, validação | Plano; ref. primeiros passos "O momento entendi" | Tabela por ramo; pesquisa com clientes e análise de coortes viram conferência pelos dados do app |
| Onboarding: revelação progressiva (padrões, obrigatório agora, sob demanda, ramificação, híbrido), padrões honestos, densidade, ajuda, celular | Ref. primeiros passos "Mostrar só o necessário" | |
| Onboarding: pular e retomar (4 formas, peso visual, retomadas, lembretes, texto, medição) | Decisão 9; build; ref. primeiros passos "Pular e retomar" | `appUser.fields.onboarding_step`, checklist lido dos dados |
| Onboarding: variações por tipo (admin, funcionário, técnico, tamanho), 2 a 3 no máximo | Build; ref. primeiros passos "Tipos de pessoa" | Cliente final no lugar de técnico/não técnico |
| Onboarding: medição (eventos, pular vs desistir, painel, A/B, queda como filtro) | Build "Medir"; ref. primeiros passos "Medição" | A/B fora pelo mesmo motivo |
| Onboarding: anti-padrões e falhas comuns | Ref. primeiros passos | |
| Onboarding: 12 considerações | "Conferência antes do finish" | |
| szilu 16 (checklist 4 a 6 itens, itens pré-marcados, dados de exemplo rotulados, estados vazios como onboarding) | Build "Checklist"; ref. primeiros passos | Complemento útil trazido da skill de UX usada no pacote |
| Análise 02: dois onboardings; o do funcionário da PME com checklist (importar planilha, primeiro serviço, convidar colega) e dados de exemplo removíveis | Plano; build; ref. primeiros passos | O onboarding do dono na Fabapp é da plataforma, fora do escopo |
| Análise 02: lógica condicional brasileira (CPF ou CNPJ e IE), rótulo acima | Decisão 7; ref. formulários "Brasil" | Máscaras e dígitos verificadores em `src/lib/br.ts` |
