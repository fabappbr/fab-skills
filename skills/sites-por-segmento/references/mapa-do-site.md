# Mapa do site: árvore, menu, rodapé, endereços e links

## Profundidade por tipo de site

| Tipo | Profundidade | Seções principais | Padrão de endereço |
|---|---|---|---|
| Negócio local ou pequeno | 1 a 2 níveis | Início, Serviços, Sobre, Contato ou Agendar | `/servicos/:slug` |
| Comida | 1 a 2 níveis | Início, Cardápio, Reservas ou Pedir, Onde estamos | `/cardapio` |
| Loja | 2 a 3 níveis | Início, Produtos, Categorias, Carrinho | `/categorias/:slug`, `/produto/:slug` |
| Anúncios (imóveis, veículos) | 2 níveis | Início, Busca, Detalhe | `/imoveis/:slug` |
| Conteúdo ou blog | 2 a 3 níveis | Início, Blog, Categorias, Sobre | `/blog/:slug`, `/blog/categoria/:slug` |
| Produto digital | 2 a 3 níveis | Início, Recursos, Preços, Ajuda | `/recursos/:slug`, `/precos` |
| Ajuda ou documentação | 3 níveis | Ajuda, Seção, Artigo | `/ajuda/:secao/:artigo` |

Regra dos 3 cliques: toda página importante a até 3 cliques da inicial; se algo crítico está a 4 níveis, a árvore está errada. Seja o mais plano possível mantendo o menu limpo; se um grupo do menu passa de 20 itens, crie um nível.

Níveis: N0 inicial (`/`) · N1 seções (`/servicos`) · N2 páginas da seção (`/servicos/corte-masculino`) · N3 detalhe (só loja grande e ajuda).

## Modelos de árvore (adapte ao setor, nunca copie inteiro)

Negócio local:
```
Início (/)
├── Serviços (/servicos)
│   ├── Serviço A (/servicos/servico-a)
│   └── Serviço B (/servicos/servico-b)
├── Equipe (/equipe)            [se o cliente escolhe o profissional]
├── Agendar (/agendar)           [ação principal, botão no cabeçalho]
├── Onde estamos (/onde-estamos)
├── Depoimentos (/depoimentos)   [só com depoimentos reais autorizados]
├── Blog (/blog) > Post (/blog/:slug)   [só se o dono vai escrever]
└── Privacidade (/privacidade)
```
Cabeçalho (5 itens + ação): Serviços | Equipe | Onde estamos | Sobre | [Agendar horário]. Tudo alcançável pelo cabeçalho.

Loja:
```
Início (/)
├── Produtos (/produtos)
│   └── Categoria (/categorias/:slug) > Produto (/produto/:slug)
├── Ofertas (/ofertas)
├── Ajuda (/ajuda): Entrega, Trocas e devoluções (/trocas-e-devolucoes), Contato
├── Carrinho (/carrinho) · Minha conta (/conta)
├── Privacidade (/privacidade) · Termos (/termos)
```
Cabeçalho: Produtos (menu por categoria) | Ofertas | Ajuda | [ícone Carrinho] [ícone Conta]. Menu grande por categoria: 2 a 4 colunas, "Ver tudo" no fim, sem submenu dentro de submenu.

Conteúdo: `/blog`, `/blog/categoria/:slug`, `/blog/:slug`, `/newsletter` (ação), `/sobre`, `/contato`. Barra lateral no blog: categorias com contagem, mais lidos, inscrição.

Produto digital: `/recursos/:slug`, `/precos`, `/clientes` (só casos reais), `/ajuda`, `/blog`, `/entrar`, `/criar-conta`. Cabeçalho: Recursos | Preços | Ajuda | Blog | Entrar | [Começar grátis].

Ajuda: barra lateral fixa com seções recolhíveis, a atual aberta e destacada, busca no topo, "Anterior / Próximo" no fim de cada artigo.

## Menu do cabeçalho

- 4 a 7 itens; 8 ou mais paralisam e não cabem.
- Logo à esquerda levando à inicial; ação principal à direita, preenchida e com a cor da marca.
- Ordem por importância e uso; página atual com indicação visível (vinda da rota, `NavLink`).
- Menu dividido: navegação à esquerda, "Entrar" e "Criar conta" à direita.
- Rótulo claro vence rótulo criativo. Teste: um cliente entende o item sem clicar?
- Celular: menu numa `Sheet` com os mesmos itens, subitens em sanfona; ação principal visível sem abrir o menu (cabeçalho fixo ou barra no rodapé da tela); busca acessível no menu quando o setor usa busca.
- O menu é igual em todas as páginas (exceto área logada versus parte pública).

## Rodapé

Colunas por tema (3 a 5): **O negócio** (Sobre, Equipe, Trabalhe conosco) · **Atendimento** (Contato, Agendar, Perguntas frequentes) · **Visite** (endereço, horário dia a dia, telefone, WhatsApp) · **Legal** (Privacidade, Termos, Trocas). Embaixo: logo, © ano e razão social, CNPJ quando o dono informar, registro profissional quando o setor exige, redes.

Rodapé mínimo (landing, site de uma página): logo · © · Privacidade · Contato. Rodapé expandido (conteúdo e loja grande): colunas extras de categorias ou posts mais lidos. Nunca despejar 50 links sem grupo.

## Endereços (URLs)

1. Legível por gente: `/servicos/limpeza-de-pele`, não `/s/a123`.
2. Hífen, nunca sublinhado.
3. Reflete a árvore.
4. Sem barra no fim (escolha uma forma e mantenha).
5. Sempre minúsculo e sem acento (`/servicos`, não `/Serviços`).
6. Curto e descritivo: `/blog/como-escolher-protetor`, não a frase inteira do título.

Erros comuns: data no endereço de post (`/blog/2026/09/10/...`); aninhar demais (`/produtos/categoria/sub/item/detalhe`); trocar endereço sem manter o antigo como rota que leva ao novo (`<Navigate replace/>` dentro do app; não existe 301 configurável); id no endereço público (`/produto/12345`); conteúdo por parâmetro (`/blog?id=123`); padrões misturados (`/servicos/x` e `/solucoes/y` para a mesma coisa). Filtro de listagem pode e deve ir em parâmetro (`/imoveis?bairro=centro&quartos=2`), porque é estado da busca, não página.

Slug: campo `slug` (text) no modelo, gerado do nome sem acento e com hífen; antes de criar, confira duplicidade com `collection('service').count({ slug })` e acrescente `-2` se existir. A página busca por `list({ filter: { slug }, limit: 1 })`.

| Tipo de página | Padrão | Exemplo |
|---|---|---|
| Inicial | `/` | |
| Serviço | `/servicos/:slug` | `/servicos/corte-masculino` |
| Produto | `/produto/:slug` | `/produto/tenis-corrida-azul` |
| Categoria | `/categorias/:slug` | `/categorias/calcados` |
| Post | `/blog/:slug` | `/blog/cuidados-pos-tatuagem` |
| Legal | `/:pagina` | `/privacidade`, `/termos` |
| Landing de campanha | `/:slug` | `/dia-das-maes` |
| Comparação | `/comparar/:slug` | `/comparar/plano-a-ou-b` |

## Trilha (breadcrumb)

Espelha o endereço: `/servicos/corte-masculino` → Início › Serviços › Corte masculino. Todo segmento é link, menos a página atual; se o título da página já aparece como h1 logo abaixo, a página atual pode sair da trilha. Separador único em todo o site. Trilha que não bate com o endereço é erro. Os dados estruturados da trilha a plataforma gera quando `seo.breadcrumbs` está ligado: você escreve `"breadcrumbs": true` em `apps/<slug>/fab.config.json → seo` e envia com `fabapp push`.

## Links internos

Quatro tipos: navegação (cabeçalho, rodapé, lateral), no texto ("veja nossos [pacotes de noiva](/servicos/noiva)"), hub e raios (posts sobre pele apontando para `/servicos/limpeza-de-pele`) e entre seções (a página do serviço linka o caso real e o post).

Regras: nenhuma página órfã (toda página tem pelo menos um link de entrada); texto do link descritivo ("nossos pacotes de noiva"), nunca "clique aqui" ou "saiba mais"; cerca de 5 a 10 links internos a cada 1.000 palavras de texto; as páginas mais importantes recebem mais links; "Relacionados" no fim de posts e produtos. Hub e raios: o hub linka todos os raios, cada raio volta ao hub e os raios se linkam quando fizer sentido. Links do cabeçalho pesam mais para o buscador; rodapé serve para páginas de apoio; links sempre como `<Link>` de verdade (navegação só por JavaScript o buscador não segue).

Conferência de links: todas as páginas com link de entrada; nenhum link quebrado; textos descritivos; trilha em todas as páginas de segundo nível; relacionados nos posts; serviços ligados aos casos e posts.

## Anti-padrões de navegação e a correção

| Problema | Correção |
|---|---|
| 8 ou mais itens no cabeçalho | Agrupar em menu por seção |
| Menu dentro de menu dentro de menu | No máximo um nível suspenso |
| Ícone sem rótulo | Ícone sempre com texto |
| Navegação principal escondida em hambúrguer no computador | Links visíveis a partir de `md` |
| Menu diferente de página para página | Um `NAV` único usado em tudo |
| Rodapé como despejo de links | Colunas por tema |
| Cliente não acha a página | Rótulo mais claro, busca se o setor usa |
| Página de apoio sem link | Rodapé ou seção de recursos |

## Como mostrar no plano

1. Árvore em texto com endereço em cada nó (formato acima).
2. Tabela: Página | Endereço | Mãe | Onde aparece | Prioridade (alta, média, baixa).
3. Menu: itens em ordem, com a ação à direita; rodapé: colunas e links; trilha: onde aparece.
4. Links internos: hubs e raios, ligações entre seções, links recomendados nas páginas-chave.
5. SEO: título e descrição de cada página estática em `seo.pages` do `fab.config.json`; rotas dinâmicas com `<FabHead>`.
Para o dono, resuma em uma linha: "Seu site terá estas páginas: Início, Serviços e preços, Agendar, Onde estamos."
