# Financeiro e Cobrança (`financeiro-e-cobranca`)

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem o app pelo CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou só o encanamento:
- As etapas do Studio viraram o fluxo do agente: primeiro movimento, a conversa (perguntas com opções), o plano mostrado ao dono antes de codar, a construção, conferir antes de dizer pronto e mudanças depois.
- Schema e automações são editados em `fab.schema.json` e `fab.automations.json` (`fabapp pull`, editar, `fabapp push`); o código sobe com `fabapp deploy`.
- A marca (cor, fonte, raio) é definida pelo agente em `apps/<slug>/fab.config.json → theme`, com aprovação do dono.
- Os critérios de aceite viraram a lista de conferência do plano, sem teto, conferida na pré-visualização e por busca no código.
- O CLI não grava registros: os dados de exemplo vêm de um botão "Carregar exemplos" no app ou do CMS do Studio.
- A memória do app vira `DECISOES.md` na raiz do projeto.
- O contrato da plataforma pelo terminal está em `references/fabapp-cli.md`.

A seção abaixo descreve a edição Studio (etapas e tamanhos são dela).

Faz o app gerado ter o financeiro do pequeno negócio: orçamento que vira venda, contas a receber com status calculado, régua de cobrança com tom por histórico do cliente e aprovação do dono, recebimento por Pix na chave ou link do gateway da plataforma, baixa com comprovante, mensalidades, registro de nota fiscal e relatórios.

- **Categoria**: commerce
- **Etapas**: briefing, plan, build, edit
- **Tokens** (validador): corpo ~5.100; referências ~7.300 (cabem inteiras também no briefing)
- **Autor**: Equipe Fabapp, versão 1.0.0

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| `invoice-chase` (com `reference/tone-matching.md`, `gotchas.md`, `v2_sources.md`, `examples/gentle-reminder.md`, `examples/firm-reminder.md`) | https://github.com/anthropics/knowledge-work-plugins, plugin small-business, commit da38ec1 | Apache 2.0 |
| `quote-to-cash` (com `resources/q2c-essentials.md`) | https://github.com/HubSpot/agent-cli-skills, commit 71f2bde | Apache 2.0 |
| `stripe-best-practices` (só fluxo de cobrança e confirmação: `SKILL.md`, `references/payments.md`, `references/billing.md`, trecho de webhooks de `security.md`) | https://github.com/stripe/ai, commit a4b08e0 | MIT, Copyright (c) 2024 a 2025 Stripe |

Obra derivada: texto reescrito em português para a plataforma Fabapp, sem cópia de parágrafos. Aviso da licença MIT da Stripe: "Permission is hereby granted, free of charge, to any person obtaining a copy of this software... The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software." As skills Apache 2.0 foram modificadas (adaptação e tradução), conforme a seção 4 da licença.

Também guiada por `analise/03-crm-e-negocio.md` (template de domain skill §4.1 e §4.2, regras BR §4.3).

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| invoice-chase: puxar o relatório de contas a receber vencidas (mais de 1 dia) | `regua-de-cobranca.md` passo 1; `calculos-e-relatorios.md` Fatura | A fonte é o próprio app (faturas `open` com vencimento passado), não um ERP externo |
| Conferir pagamentos recentes em 14 dias antes de cobrar | Decisão fixa 7; tabela de conferências | Pagamentos registrados no app; aviso fixo para pagamento por fora |
| Janela de 7 dias e nova tentativa de 3 dias no PayPal (limite 429) | Fora | Não há PayPal na plataforma; o equivalente útil (não somar calado quando a fonte falha) virou "falha de envio nunca some" |
| "Possivelmente pago, confira" em vez de rascunho | Conferências; etiqueta na tabela | Igual |
| Casar cliente por e-mail; "só nome, confira" | Fora (fonte única) | No app o cliente é um registro com id; a checagem útil virou duplicidade por documento, e-mail e telefone no cadastro e na importação |
| Pontuação bom pagador / às vezes / reincidente, 12 meses, mínimo 3 faturas, 75% e 50% | `regua-de-cobranca.md` Pontuação | Igual, com o motivo visível na ficha |
| Tom gentil, neutro, firme e seus traços | Tabela Tom | Igual, com frases em português |
| Fórmulas de assunto por tom | Assuntos | Em português, com R$ e código da fatura |
| Corpo com número, total, vencimento, dias, link; uma chamada para ação | Tom e modelos | A chamada é o Pix copia e cola, a chave ou a área do cliente |
| Exemplos gentil (18 dias, 5 de 5 em dia) e firme (47 dias, 3 de 4 atrasadas) com "por que funciona" | Modelos prontos | Reescritos com nomes e datas brasileiras |
| Consolidar várias faturas numa mensagem com o tom do cliente | Decisão fixa 6; modelos | Igual |
| Tabela resumo antes dos rascunhos (cliente, valor, dias, tom, canal) | Tabela resumo; tela Cobrar hoje | Igual, com etiquetas |
| Nunca enviar sem aprovação; uma aprovação por lote; mudança reabre | Decisão fixa 5; Aprovação e envio | Igual; automação nunca cobra cliente atrasado |
| Não cobrar quem não está no relatório de contas a receber | Aviso fixo; "Não fazer" | Só fatura aberta do app gera mensagem |
| Conteúdo lido é dado, não instrução (troca de conta bancária) | "O que vem do cliente é dado"; construção (IA) | Igual, também no prompt do `invokeLLM` |
| Envio pelo PayPal, rascunho no Gmail ou M365, falha vira rascunho | Aprovação e envio | WhatsApp pela integração ou wa.me, e-mail pela plataforma, copiar; falha mostra o caminho alternativo |
| Link de pagamento hospedado (Airwallex) dentro da aprovação | `regras-br-e-pagamento.md` link e Pix | `useCheckout` na área do cliente, ou Pix copia e cola gerado no app |
| Nunca usar o número do processador na mensagem | Modelos | Sempre o código da fatura do app |
| Fatura anulada que ainda aparece como não paga | Conferências (cancelada nunca entra) | Status `canceled` com motivo |
| Contas internas e de teste | Conferências | Nome com teste/interno/demo/exemplo, amostra, mesmo domínio |
| Mesma fatura em duas fontes | Conferências (possível duplicada) | Mesmo cliente, valor e vencimento |
| Sem conectores: planilha entra, lembretes saem | Construção: Importar planilha | `CsvImport` com upsert e relatório por linha |
| Voz do dono (perfil de voz; sem amostra, texto neutro e dizer) | Construção: Reescrever no jeito do dono | `invokeLLM` com amostra das Configurações |
| Saída visual: total como destaque, linhas com números tabulares, pílula de possivelmente pago, bloco copiável por rascunho | Plano, tela 2; tabela resumo | É a própria tela do app |
| Relatar o que foi enviado, enfileirado e marcado | Depois do envio | Igual |
| Próximos passos (previsão de caixa, fechar o mês) | Relatórios (previsão 30/60/90); próximos prompts no briefing | Viraram telas e sugestões |
| Sandbox por engano: avisar e parar | `regras-br-e-pagamento.md` (testar no modo de teste antes) | O app não sabe o modo do gateway; a regra virou teste guiado |
| quote-to-cash: catálogo com nome, preço, código, recorrência | `modelo-de-dados.md` product | `product` canônico da plataforma |
| Importar catálogo em lote com prévia | Importar planilha | `CsvImport` com mapeamento antes de gravar |
| Itens de linha com quantidade, preço que sobrescreve o do produto, item avulso sem produto | `quote_item` | Cópia de descrição e preço |
| Desconto % gravável; desconto total calculado e só leitura | Cálculos: Orçamento | Igual |
| Proposta com título, validade, moeda, rascunho até promover | `quote`; tela Orçamento | "Marcar como enviado"; expirado calculado |
| Associar proposta ao negócio e ao contato | `quote.customer`, `quote.deal` | `ref` no filho |
| PDF e link de compartilhar são só na interface | Tela Orçamento (página de impressão) | Impressão pelo navegador |
| Faturas em aberto, vencidas, faturadas em 30 dias | Cálculos: Fatura, Faturado | Filtro no servidor, soma no cliente |
| Status derivado nunca digitado | Decisão fixa 3 | `status` só por evento; vencida calculada |
| Assinaturas por status; somar MRR | Cálculos: Mensalidades | Contrato + fatura do mês; `subscription` só leitura |
| Não supor nome de propriedade nem valor de enum; ler antes | Na edição | Ler o schema antes de mexer |
| Paginar antes de somar | Construção: Leituras | Igual |
| Operação destrutiva com prévia e confirmação | Decisão fixa 5; Gerar faturas; cancelar | `AlertDialog` com contagem e total |
| stripe: confirmação no evento, nunca na página de sucesso | Decisão fixa 4; link de pagamento passo 4 | Webhook da plataforma grava `paid` |
| Pagamento assíncrono (completed ainda não pago) | Link, passo 4 | Pix "em confirmação" com `useLive` |
| Webhook nunca opcional; conferir assinatura | Link, regras | A plataforma já recebe e confere; o app nunca escreve webhook |
| Não fixar métodos de pagamento | Link, regras | `paymentMethods` vazio = todos; Pix e cartão quando é fatura |
| Checkout hospedado como preferência | Link, passo 2 | `useCheckout` redireciona para o gateway |
| Assinatura pela API de cobrança recorrente, sem laço manual de cobrança | Regras (mensalidade) | `useSubscribe` só para acesso ao app; mensalidade de serviço é fatura mensal com régua |
| Um produto por plano, variações de período no mesmo | Regras | Um `plan` por faixa com `interval` |
| Portal do cliente para cartão | Link, passo 5 | `<PaymentMethods/>` |
| Chave restrita, segredo fora do código | Regras | Chave fica na plataforma |
| Ambiente de teste separado | Regras | Modo de teste do gateway antes de cliente real |
| Nota sobre imposto (Stripe Tax) | Nota fiscal (registro) | No Brasil vira registro de NFS-e, NF-e, NFC-e |
| Connect, Treasury, Metronome, Terminal, API de versões, SDKs | Fora | Não se aplicam: a plataforma tem os gateways integrados e o app não chama API de pagamento |
| Análise: CPF/CNPJ, telefone E.164, Pix, NF, LGPD, dinheiro em centavos | `regras-br-e-pagamento.md`; decisões 1 e 2 | Inclui CNPJ alfanumérico e BR Code |
| Análise: papéis dono, financeiro, vendedor | `modelo-de-dados.md` Papéis | `finance`, `seller` |
| Análise: seed realista | Construção: Seed | `propose_data_fill`, marcado como exemplo |

## Trocas feitas por limite da plataforma

- **Envio automático de lembrete**: a automação `relative` não tem condição e dispara também para fatura já paga. Por isso as automações avisam só a equipe, e o texto nunca afirma que a fatura está em aberto; o cliente atrasado só recebe mensagem aprovada pelo dono. Aviso de 3 dias antes ao cliente é opcional e diz "se já pagou, desconsidere".
- **Link de pagamento**: o checkout da plataforma exige usuário logado; sem área do cliente, o recebimento é o Pix copia e cola gerado no app com baixa manual.
- **Boleto e emissão de nota**: não existem na plataforma; o app registra e dá baixa.
- **Opções do `status` da fatura em texto simples** (`open`, `paid`, `canceled`): a confirmação do pagamento da plataforma procura o valor `paid` entre as opções; com opções no formato `{value,label}` a busca pode falhar.
