# Padrões do Brasil (`fab-padroes-brasil`)

## Edição terminal

Esta é a edição para agentes que constroem e editam apps da Fabapp AI pelo terminal (Claude Code, Codex, OpenCode,
Cursor, Gemini CLI) com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio (regras, código de `br.ts` e
`pix.ts`, LGPD, nota fiscal); o que mudou:

- As etapas viraram "O plano", "A construção" e "Mudanças depois". `currency` e `locale` vão na raiz do
  `fab.schema.json`, enviado com `fabapp push`.
- Os critérios de aceite (até 8, `kind:'code'`) viraram a lista de conferência do plano, sem teto.
- Correção de registros antigos (`propose_data_fill`, `read_records`): o token do CLI não grava nem lê registros; o
  dono corrige no CMS do Studio (ou por planilha) ou por uma tela de administração do app.
- Emissão automática de nota: a função de backend está disponível no mesmo plano que libera o CLI.
- Acrescentados: "Conferir antes de dizer pronto" (busca no código pelos erros do checklist e conferência na
  pré-visualização), "O que o dono faz no Studio" (gateway, cookies, WhatsApp, Google Maps, conector do emissor),
  `DECISOES.md`, primeiro movimento, contrato ao vivo e a regra das duas mãos. `references/fabapp-cli.md` é copiado
  pelo script de montagem.

Fundação brasileira de qualquer app da Fabapp: CPF e CNPJ (inclusive alfanumérico), telefone e WhatsApp, CEP e endereço, dinheiro, datas e fuso, feriados nacionais, Pix, LGPD e nota fiscal, decididos e prontos para o plano, a construção e a edição.

- **Categoria:** other
- **Etapas:** plan, build, edit
- **Tamanho:** corpo ~5.290 tokens (plan 1.846, build 3.642, edit 912), referências ~7.420 tokens (validador em 26/09/2026).

## Origem

Esta skill não deriva de uma skill open source específica: nasceu das análises internas da Equipe Fabapp.

| Fonte | O que foi usado | Licença |
|---|---|---|
| `fabapp-skills-referencia/analise/03-crm-e-negocio.md` §4.1 e §4.3 (Equipe Fabapp, a partir de hubspot/agent-cli-skills Apache 2.0, stripe/ai MIT, supabase/agent-skills MIT) | Regras BR da "skill fundação" e princípios de domain skill | Texto interno; nenhum trecho das skills de terceiros foi copiado |
| `fabapp-skills-referencia-2/04-copy/ANALISE.md` (seção "Como adaptar frameworks em inglês para o PT-BR") | Tratamento "você", concretude local, textos regulados | Texto interno |
| Receita Federal, IN RFB 2.229/2024 e notícias de 31/07/2026 (gov.br) | Formato e cálculo do CNPJ alfanumérico | Informação pública |

O código de `references/codigo-br.md` foi escrito pela Equipe Fabapp e testado com Node 24 (50 casos, todos passando) e com `tsc --strict --noUnusedLocals`. Na revisão de 26/09/2026 o bloco foi extraído de novo e reexecutado com Node 24 (CPF, CNPJ numérico e alfanumérico, 67 DDDs, celular e fixo, CEP, centavos, parcelas, Páscoa e feriados de 2025 a 2027). O `src/lib/pix.ts` de `references/lgpd-pix-nota-fiscal.md` reproduz byte a byte o exemplo oficial do Banco Central (chave `123e4567-e12b-12d1-a456-426655440000`, "Fulano de Tal", BRASILIA, txid `***`, CRC `1D3D`) e o vetor `123456789` → `29B1` do CRC16-CCITT.

## Confirmações em fonte oficial

- **CNPJ alfanumérico: CONFIRMADO.** Receita Federal (gov.br): "Implantação do CNPJ Alfanumérico ocorrerá a partir de 31 de julho" e "Receita Federal gera o primeiro CNPJ em formato alfanumérico" (31/07/2026, `00.000.000/E08G-12`). Cálculo: módulo 11, valor de cada caractere = código ASCII menos 48 (A = 17). A função valida esse CNPJ real e o exemplo oficial `12.ABC.345/01DE-35`. CNPJs numéricos continuam válidos e novos CNPJs ainda podem sair só com números.
- **IBS/CBS: CONFIRMADO SÓ EM FONTE SECUNDÁRIA (falta fonte oficial).** Blogs contábeis (Contmatic, Jettax, e-Auditoria) dizem: 2026 é ano de teste (CBS 0,9% e IBS 0,1%, informativo), regime regular preenche os campos nas notas desde 03/08/2026, Simples e MEI a partir de 04/01/2027 (NT 2025.002, LC 214/2025 art. 348). A skill foi escrita para não depender disso: o app nunca calcula imposto e só guarda em `taxes` o que o emissor devolver. Conferir no Portal da NF-e / Receita antes de citar datas ao dono.
- **Feriado de 20 de novembro nacional:** Lei 14.759/2023. Guarda de prontuário por 20 anos: Lei 13.787/2018. Dispensa de encarregado para agente de pequeno porte: Resolução CD/ANPD nº 2/2022. Prazo de 15 dias para cópia completa: LGPD art. 19, II.
- **ViaCEP:** conferido ao vivo em 26/09/2026: responde com `Access-Control-Allow-Origin: *` (dá para chamar do navegador), `{"erro": "true"}` para CEP inexistente e 400 para CEP malformado; a função trata os dois como "não achou".

## Mapa de cobertura

| Função/técnica da fonte | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| CPF/CNPJ: só dígitos em texto | SKILL "No plano" (tabela) e "Na construção > CPF e CNPJ" | CNPJ normalizado em maiúsculas com letras; CPF só dígitos |
| Validar dígito verificador | `references/codigo-br.md` (`isValidCpf`, `isValidCnpj`) + `zod` | Código testado |
| Exibir com máscara | `formatCpf`, `formatCnpj`, tabela de exibições | Máscara só na tela; CPF mascarado em tela pública |
| CNPJ como texto aceitando letras (julho de 2026) | SKILL e código | Confirmado em gov.br; nunca `inputMode="numeric"` no CNPJ |
| `tipo_pessoa` PF/PJ decide o documento | Campo `person_type` e formulário condicional | `enum` da plataforma |
| Único por empresa (tenant) | "Duplicidade antes de criar" | Plataforma não tem unicidade: `count({ campo: valor })` antes do `create`, filtrando pela `organization` |
| Telefone em E.164 | `phone` + `PhoneInput` (já emite E.164) | Componente do kit |
| Celular com 9 dígitos começando em 9, DDD válido | `parseBrPhone` + 67 DDDs | Fixo com 8 dígitos de 2 a 5 |
| Flag `eh_whatsapp` e link wa.me | `is_whatsapp`, `whatsappLink`, botão "Chamar no WhatsApp" | Com integração ligada, `integrations.call('whatsapp', ...)` só para mensagem de serviço |
| Opt-in registrado para marketing | `marketing_opt_in`, `_at`, `_channel`; tela de envio filtra | Automação não filtra; o filtro fica na tela |
| Endereço com CEP e autopreenchimento (ViaCEP) | `lookupCep`, `CepField`, UF em enum | Fetch público no navegador, só o CEP sai; `AddressInput` (Google Maps) explicado como outra coisa |
| Dinheiro em inteiro de centavos, BRL, "R$ 1.234,56" | "Dinheiro" + `sumMoney`, `lineTotal`, `applyDiscountPercent`, `splitInstallments` | Campo `money` guarda reais; contas em centavos; `formatMoney` e `CurrencyInput` |
| Datas dd/mm/aaaa, fuso America/Sao_Paulo | "Datas, horas e fuso" + `todayBr` | `formatDate`/`formatDateTime` com `timeZone`; proibido `toISOString().slice` |
| Pix com txid, QR, copia e cola | "Pix e pagamento"; referência, `pixBrCode` | Com gateway, QR e copia e cola são da página do gateway; sem gateway, BR Code estático gerado por `src/lib/pix.ts` (testado contra o exemplo do Banco Central) com baixa manual |
| Confirmação só por webhook do PSP, nunca pelo redirect | SKILL e referência | Webhook já tratado pela plataforma; tela lê status com `useLive` |
| Boleto e cartão como alternativas | SKILL | Cartão sim; boleto NÃO existe como método do app (dito ao dono) |
| Pix Automático para recorrência | Referência, "Recorrência" | Não existe: assinatura é cartão; mensalidade por Pix = cobrança avulsa + automação `relative` |
| Conciliação automática | Referência | Feita pela plataforma no pagamento integrado; no Pix manual, o administrador confirma |
| LGPD: base legal por finalidade | Referência, tabela de bases | Cada dado com finalidade no plano |
| Consentimento separado para marketing | SKILL e referência | Caixa desmarcada, separada dos termos |
| Exportar e anonimizar a pedido | Referência (código de exportação JSON e regras de anonimização) | Anonimizar = `update`, campos não `required` para não dar 422 |
| Política de retenção | `/privacidade` item 4 | Fiscal 5 anos; prontuário 20 anos |
| Log de acesso | Referência, `access_log` opcional para clínica | Criado pela tela; não há log automático da plataforma |
| Dados de saúde sensíveis, acesso por papel | Modelo `health_record` com `role:clinician` | Regras de acesso reais da plataforma |
| Nota fiscal NFS-e / NF-e / NFC-e por tipo de negócio | SKILL e modelo `invoice` | O app guarda, não emite |
| Registrar regime (MEI, Simples, Presumido) | `tax_regime` | Acrescentado Lucro Real; só informativo |
| Guardar número, chave, status, XML/PDF | Modelo `invoice` | `file` para PDF e XML; `extractData` lê o PDF |
| Integrar com emissor terceiro | Referência, "Emissão automática" | Só por conector do dono + função de backend (plano pago mais alto) |
| Prever IBS/CBS | Campo `taxes` json | Sem cálculo; datas marcadas como fonte secundária |
| Tratamento "você" | "Texto e tratamento" | Da ANALISE de copy |
| Feriados nacionais | `nationalHolidays`, `closed_day` | Páscoa calculada; estaduais e municipais cadastrados pelo dono |
| Upsert por chave natural normalizada (§1.5) | Chaves normalizadas (CPF limpo, CNPJ maiúsculo, telefone E.164, e-mail minúsculo) | A importação em si é da peça de CSV do app |
| Seção "Não fazer" (§4.1) | "o que NÃO vamos construir" no plano e checklist final | |

Ficou de fora, com motivo: "estados derivados nunca editáveis", "ações em lote com prévia" e "próximo passo com data" (§4.1 itens 3 a 5 e 7) pertencem às skills de domínio (CRM, agendamento), não à fundação de formatos.

