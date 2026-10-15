# Fluxo de UX: modelos para o plano

O plano é o texto que você escreve e mostra ao dono antes de codar; ele aprova antes da construção.

Ordem obrigatória: casos de uso → mapa de telas → fluxo e estados de cada caso → rascunho das telas. Não pule etapas: o rascunho sem o mapa gera tela sem saída, e o mapa sem os estados gera lista que trava vazia.

## 1. Caso de uso

| Campo | Conteúdo |
|---|---|
| ID | UC-001, UC-002... |
| Nome | curto ("Fazer pedido") |
| Quem | cliente, atendente, admin, sistema (automação) |
| Antes | o que precisa ser verdade ("cliente logado", "há produtos ativos") |
| Caminho principal | passos numerados, um verbo por passo |
| Caminhos alternativos | erro, vazio, sem permissão, desistência, pagamento recusado |
| Depois | o que ficou verdade ("pedido `new` gravado, dono avisado") |

Exemplo:
- **UC-002 Fazer pedido** · Quem: cliente · Antes: logado, cardápio com itens.
- Principal: 1. abre a aba Cardápio; 2. toca num item; 3. escolhe quantidade na folha; 4. toca "Adicionar"; 5. abre Sacola; 6. toca "Pagar com Pix"; 7. paga; 8. vê "Pedido recebido".
- Alternativos: 2a. item esgotado → botão desabilitado com "Esgotado"; 6a. deslogado → login e volta à Sacola; 7a. pagamento não confirmado → mensagem e "Tentar de novo".
- Depois: `order` criado, automação avisa o dono, cliente acompanha em Pedidos.

## 2. Mapa de telas

```
ABAS (celular embaixo, computador lateral ou cabeçalho)
├── Início (/)                  [entrada; logado vê o resumo dele]
├── Cardápio (/cardapio)
│   └── Item (/cardapio/:id)    [camada: entra da direita, cabeçalho com voltar e título, sem abas]
├── Pedidos (/pedidos)
│   └── Pedido (/pedidos/:id)
└── Perfil (/perfil)
    ├── Meus dados (/perfil/dados)
    └── Notificações (/perfil/notificacoes)
FORA DA CASCA (sem abas)
├── Entrar (/login) · Criar conta (/cadastro) · Recuperar senha
└── Pagamento (/checkout)
```
Anote: tela de entrada, para onde vai quem já está logado, para onde volta cada tela fora da casca, quais telas são públicas.

Tabela de telas: Tela | Para quê | Casos de uso | Elementos principais | Saídas (para onde leva).

## 3. Fluxo de cada caso (texto)

Formas: `[Tela]` · `{Decisão?}` · `(Ação)` · `>Resultado`.
```
[Cardápio] → (toca item) → [Item] → (Adicionar) → {logado?}
  sim → [Sacola] → (Pagar com Pix) → {pago?} sim → >Pedido recebido → [Pedido]
                                            não → >Erro com "Tentar de novo" → [Sacola]
  não → [Entrar] → [Sacola]
```
Até 15 a 20 elementos; passou disso, quebre em subfluxos ("ver fluxo Pagamento"). Nomes de tela iguais em todos os fluxos.

## 4. Estados de cada tela

Tabela por tela:

| Estado | O que aparece |
|---|---|
| Carregando | `Skeleton` com o formato do conteúdo |
| Vazio | `EmptyState`: ícone, título, uma frase, uma ação ("Seu primeiro pedido aparece aqui. Ver cardápio") |
| Erro | `e.message` e "Tentar de novo"; o que estava na tela continua |
| Sucesso | o conteúdo; lista com 1 item e com muitos (paginação) |
| 401 deslogado | vai para entrar e volta para cá |
| 403 sem permissão | "Você não tem acesso a esta área" com saída para o Início |
| 409 ou 422 | mensagem no campo que causou |
| Sem conexão | erro com "Tentar de novo" (o app não funciona sem internet: não prometa modo offline) |

Formulário: vazio → preenchendo → validando (zod) → inválido (erro embaixo do campo) → enviando (botão com carregamento, campos travados) → sucesso (toast e próxima tela) ou erro do servidor (mensagem, dados mantidos) → de volta a preenchendo.

Tela com partes independentes (ex.: painel com dados e avisos): cada parte tem os seus estados; uma parte com erro não derruba a outra.

Sessão: logado ↔ sessão expirada → entrar de novo → volta à tela.

## 5. Dados de cada caso (sequência)

Lista por passo: quem age → o que o app chama → o que volta → o que aparece.
- Toca "Adicionar" → estado local da sacola → nenhuma chamada.
- Toca "Pagar com Pix" → `useCheckout` com o pedido → a plataforma cuida do pagamento → volta com status → "Pedido recebido" ou erro.
- Abre Pedidos → `useLive('order', { filter: { customer: meuId }, sort: '-created_at' })` → lista → estados da tabela 4.
Para cada chamada, os erros possíveis (401, 403, 409, 422, 402 quando a IA do app está sem saldo) e o que a tela faz.

## 6. Rascunho de cada tela (de cima para baixo)

```
TELA: Pedido (/pedidos/:id)            [dentro da aba Pedidos]
Cabeçalho do <Screen>: ← Voltar · "Pedido PED-0042" · [⋯ Mais]
Faixa de status: Badge "A caminho" + horário previsto
Itens: linhas de 48 px (nome, quantidade, R$)
Total: R$ 87,50 (Pix)
Barra de ação fixa embaixo (bottom-0, área segura; a camada não tem abas): [Falar com a loja]
Sem abas (camada aberta por LayerLink a partir de Pedidos; sai ao voltar)
Estados: Skeleton da faixa e das linhas; erro com "Tentar de novo"
Saídas: Voltar → Pedidos; Falar com a loja → WhatsApp; abas
```
Regras do rascunho: celular primeiro (375 px); a ação principal embaixo; o que é clicável marcado; nenhuma tela sem saída (voltar, abas ou ação); as abas só nas raízes, iguais em todas elas; toda camada com voltar e título.

## 7. Documento de entrega (no plano)

Resumo com: mapa de telas; inventário de telas (Tela | Para quê | Casos de uso); fluxos e estados por caso; tabela de ligações (De | Elemento | Para) para conferir que nada ficou sem saída; padrões de navegação que se repetem (abas, voltar, folhas); perguntas em aberto para o dono, como suposições do plano, cada uma com a alternativa.

Para o dono, em uma linha: "Seu app terá estas telas: Início, Cardápio, Pedidos e Perfil, com as abas embaixo."
