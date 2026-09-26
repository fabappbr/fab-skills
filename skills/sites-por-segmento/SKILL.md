---
name: sites-por-segmento
description: "Faz o site do negócio, feito na Fabapp AI pelo terminal (CLI @fabappai/cli), parecer do ramo dele: a barbearia com serviços, preço e botão de agendar; o restaurante com cardápio de verdade e horário; a clínica com convênios e o registro do responsável; a imobiliária com busca por bairro e CRECI; a loja com Pix, frete e troca. Decide os blocos obrigatórios de cada setor, a ação principal (WhatsApp, agendar, pedir, orçamento, ligar), os sinais de confiança, os cuidados com conselhos (CFM, CFO, OAB, CRECI; o dono confirma o que publica) e o mapa do site: páginas, menu, endereços e rodapé. Use quando o dono pedir um site ou página para qualquer negócio: salão, barbearia, clínica, dentista, psicólogo, restaurante, delivery, padaria, loja, academia, pet shop, imobiliária, escola, curso, creche, autoescola, advogado, contabilidade, igreja, ONG, pousada, eletricista, encanador, diarista, fornecedor. Use também quando o site 'ficou genérico', 'não parece do meu ramo' ou ele perguntar que páginas precisa."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Sites por Segmento
  edition: terminal
---

# Sites por Segmento

Um site tecnicamente limpo ainda pode parecer errado para o ramo. A causa quase nunca é cor ou fonte: é composição. Faltam as coisas que todo site crível daquele setor tem (o cardápio com preço, o horário acima da dobra, o registro do conselho, as fotos do lugar de verdade) e sobra o visual arejado de startup aplicado a tudo.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

Esta skill decide **o que o site precisa TER** para o setor: a tarefa principal, a densidade, as vitrines, os caminhos, os sinais de confiança, as convenções obrigatórias e a arquitetura das páginas. Ela **não decide a cara**: paleta e fontes vêm da marca (combinadas com o dono e gravadas no `theme` do `fab.config.json`), e o setor nunca vira estereótipo de cor (clínica azul, pet shop colorido, advocacia azul-marinho com dourado). Se o dono quiser acabamento de agência premiada com animações e a skill `fab-agencia` estiver instalada, sugira usá-la também; esta aqui funciona sozinha.

Aplique a tabela do setor em `references/convencoes-por-setor.md` e os modelos de árvore, menu, rodapé e endereço em `references/mapa-do-site.md`. Leia as duas inteiras antes da conversa.

## Os sete eixos (valem em todas as partes)

Decida cada eixo por escrito, nesta ordem. O sétimo é a conferência que pega o que os seis deixaram passar.

1. **Tarefa principal é o maior e o primeiro elemento.** O visitante chega com um trabalho a fazer (agendar, ver o cardápio, achar o imóvel, pedir orçamento). Esse trabalho é o elemento interativo maior e mais alto do herói. O herói tem **uma** ação principal; as secundárias ficam abaixo da dobra ou no cabeçalho. A tarefa é alcançável sem rolar no celular (é onde está o cliente brasileiro). Em página comercial, uma versão compacta da ação fica fixa: no cabeçalho no computador e numa barra no rodapé da tela no celular. Se a tarefa não puder ser o herói (regra do conselho, pedido do dono), ponha o equivalente mais próximo e registre o motivo nas suposições do plano. Nunca empurre em silêncio para baixo da dobra.
2. **Densidade do setor, não densidade padrão.** Escolha um registro: *vitrine densa* (loja, catálogo, estoque), *guiado por imagem* (comida, hospedagem, experiência, beleza), *calmo editorial* (instituição, advocacia, conteúdo), *arejado de marketing* (produto digital). Diga no plano quantos módulos entram na primeira dobra e por quê. O erro mais comum é o visual arejado de SaaS num setor que pede vitrine.
3. **Vitrine do que se vende.** Quantas categorias, serviços ou itens aparecem antes de rolar, e em que forma. Escolha **uma** forma de mostrar profundidade (grade de categorias com imagem, menu suspenso por categoria, filtros laterais na listagem, trilha de navegação) e se comprometa; nunca empilhe três. Plana (um nível) para catálogo pequeno; hierárquica (categoria e subcategoria juntas) para catálogo grande. Ícone, imagem, texto ou híbrido conforme a tabela do setor.
4. **Caminhos: quem sabe o que quer e quem quer olhar.** Liste os caminhos do setor (por categoria, marca, bairro, preço, ocasião, público, profissional) e dê a cada um: primário (no herói ou no menu), secundário (cabeçalho ou abaixo da dobra) ou ausente. Não invente caminho que o setor não usa. Busca: no cabeçalho com largura visível, na lateral da listagem, ou nenhuma, conforme o setor.
5. **A postura se mantém da primeira à última dobra.** O tom do herói continua no menu, nos cartões, nos estados vazios, nos sinais de confiança e no rodapé. Estado vazio escrito no mesmo tom, nunca texto genérico. Se o herói usa foto real do lugar, o resto da página não troca para ilustração abstrata.
6. **Sinais de confiança onde o setor os procura.** Avaliação perto da ação de compra, área de atendimento no herói, registro profissional no rodapé e na página Sobre, horário e endereço no rodapé de toda página. Junte os sinais num **bloco agregado** acima da dobra (anos de casa, registro, nota com contagem) em vez de espalhar.
7. **Síntese: a lista de convenções do setor.** Para cada convenção numerada da tabela do setor, marque: presente, ausente com motivo, ou resolvida em outro lugar. As marcadas **(D)** carregam densidade: sem uma delas o site parece genérico mesmo passando no resto.
   - Faltam **3 ou mais** convenções, ou **qualquer (D)**: a composição está errada. Volte aos eixos 1 a 6; não é caso de polimento.
   - Faltam 1 ou 2: nomeie o motivo (posicionamento escolhido, restrição do dono, ou descuido a corrigir antes de entregar).
   - Acertar 8 de 10 (ou a proporção do setor) põe o site no nível do mercado. O diferencial é **uma** cunha da tabela do setor (ex.: "preço e duração de todo serviço à vista"). Duas cunhas diluem; nenhuma é aceitável se o site cumpre a lista, e o plano diz isso.

## Nada inventado, e onde moram os fatos

Depoimento, nota do Google, número de clientes, prêmio, anos de casa, CNPJ, CRM, CRO, CRECI, OAB, preço: só o que o dono informar. Os fatos do negócio moram num modelo de registro único **`business_profile`** ("Dados do negócio") no `fab.schema.json`, com `access` `{"read":"public","create":"role:admin","update":"role:admin","delete":"role:admin"}` e campos conforme o setor: `name`, `whatsapp` (phone), `phone`, `email`, `address` (text) ou `location` (geo), `hours` (json com cada dia), `service_area` (text), `founded_year` (number), `legal_name`, `cnpj`, `responsible_name`, `responsible_registry` (ex.: "CRO-SP 12345"), `rating_value` (number), `rating_count` (number), `google_review_url` (url, o link para avaliar no Google), `instagram` (url), `delivery_links` (json). Este é o único cadastro de dados do negócio do app: as skills `copy-que-vende`, `landing-que-converte` e `reputacao-e-avaliacoes`, se instaladas, leem daqui. Cada bloco que depende de um fato **só aparece quando o campo está preenchido**; no painel do admin, uma lista "Falta preencher" mostra o que está vazio. Nada de texto de exemplo publicado como se fosse real. Conteúdo que muda (serviços, profissionais, itens do cardápio, imóveis, produtos, depoimentos com autorização) é modelo próprio, editável pelo dono.

**Você não grava registros.** O CLI escreve definição e código, nunca registros (ver "Registros" em `references/fabapp-cli.md`). Os fatos que o dono contou na conversa não viram registro pela sua mão: ele cadastra no CMS do Studio (aba de dados, que também importa planilha) ou numa tela de administração do próprio app (formulário do `business_profile` e dos modelos de conteúdo, usada por ele logado como admin). Nunca diga "cadastrei os dados"; entregue a lista do que cadastrar e onde, com os valores que ele já passou prontos para copiar.

Real onde o site toca, honesto onde depende do dono: formulário, validação, filtro e carrinho funcionam de verdade; nenhum dado de exemplo publicado como real (se houver registro de teste, ele é marcado como exemplo e apagado depois); nenhuma confirmação falsa ("Agendado!" sem agendamento gravado) e nenhum pagamento simulado.

## Antes de começar

- Rode o primeiro movimento de `references/fabapp-cli.md`, leia `DECISOES.md` e rode `fabapp pull` para ter `fab.schema.json`, `fab.automations.json` e `apps/<slug>/fab.config.json` atuais no disco.
- Leia `references/convencoes-por-setor.md` e `references/mapa-do-site.md`.

## A conversa: descobrir o setor e o que o site precisa ter

Identifique o setor pela conversa e ache a linha dele na tabela de convenções. Pergunte ao dono com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela, uma mensagem curta com as opções numeradas. Pergunte só o que muda o site: até 6 perguntas; pule as que o pedido já respondeu. Recomendada primeiro e marcada "(Recomendado)". Escolha entre estas:

1. **"Qual é a principal coisa que você quer que o cliente faça no site?"** Opções pela tabela do setor, por exemplo para salão: "Agendar um horário direto no site (Recomendado)" / "Chamar no WhatsApp" / "Ligar". Para restaurante: "Ver o cardápio e pedir pelo WhatsApp (Recomendado)" / "Fazer reserva de mesa" / "Pedir pelo iFood ou outro app".
2. **"Os preços aparecem no site?"** "Sim, o preço de cada serviço (Recomendado)" / "Só 'a partir de'" / "Não, só sob consulta". Em setor com conselho profissional (advocacia, saúde), a pergunta muda: "Seu conselho permite divulgar preço, promoção ou depoimento de cliente no site?" "Não sei, deixar o site sem isso por enquanto (Recomendado)" / "Sim, posso mostrar preço" / "Sim, posso mostrar preço e depoimentos". Você não afirma o teor da regra; o dono é quem responde, e o site sai conservador até ele confirmar.
3. **"Você tem fotos reais do seu espaço e da sua equipe?"** "Tenho e vou mandar (Recomendado)" / "Ainda não, use imagens provisórias que eu troco depois". Diga que foto do lugar de verdade é o que faz o site parecer do negócio e não de qualquer um. Fotos entram pelo Studio (nos slots de imagem ou nos campos de imagem dos registros), nunca como arquivo no workspace.
4. **Setores regulados, pergunta aberta:** "Qual é o nome e o número de registro do responsável técnico (ex.: CRO-SP 12345)?" Use o conselho do setor (CRM, CRO, CRP, CREFITO, CRN, CRMV, CREF, CRECI, OAB, CRC, credenciamento no Detran). Se ele não souber agora, registre como suposição e o bloco fica escondido até ele preencher.
5. **"Onde você atende?"** para serviço em domicílio e delivery: "Por bairros (vou listar) (Recomendado)" / "A cidade toda" / "Várias cidades". Para ponto físico: confirme endereço e horário de cada dia.
6. **Uma pergunta da tabela do setor** que muda a estrutura: convênios aceitos (clínica), venda ou aluguel (imobiliária), delivery próprio ou app (restaurante), aula experimental (academia), matrícula online (escola), antes e depois (estética e saúde: "Mostrar fotos de antes e depois?" "Não mostrar (Recomendado)" / "Sim, tenho autorização escrita dos pacientes e sigo as regras do meu conselho").

**A barra do mercado.** Se o dono citar concorrentes ou sites que admira, abra 2 ou 3 com a ferramenta de leitura de páginas da web da sua ferramenta (ou `curl`) e anote o que todos carregam (tarefa no herói, densidade, sinais de confiança) e o que nenhum faz bem. O que todos fazem vira convenção obrigatória deste site, acima da tabela padrão; o que nenhum faz bem é candidato a cunha. Sem concorrente citado, vale a tabela do setor. Se o formato do negócio não estiver claro (ex.: loja que também agenda), pergunte qual é a atividade principal: construir com as convenções do formato errado é exatamente o site "fora do ramo".

**Site anterior.** Se o dono já tem site, pergunte: "Tem alguma página do site antigo que clientes acessam muito ou que está no Instagram e no Google?" "Não sei, pode seguir (Recomendado)" / "Sim, vou passar os endereços". Os caminhos informados (a parte depois do domínio) viram, no plano, rotas antigas que levam à página nova dentro do app. Diga ao dono o limite em uma frase: isso só funciona se o site novo ficar no mesmo domínio; a plataforma não tem redirecionamento 301 configurável de um domínio para outro.

Anote em `DECISOES.md`: o setor, a ação principal, as páginas previstas em palavras simples ("Início, Serviços e preços, Agendar, Onde estamos"), os fatos que o dono já deu (sem dado pessoal de cliente) e, em Decisões, o que ele confirmou sobre o conselho. Lembre o dono, em uma frase, que o setor tem conselho com regras de publicidade e que ele confirma o que pode publicar (preço, promoção, depoimento, antes e depois); o site sai sem esses blocos até ele confirmar. Cor e fonte seguem a marca do negócio, nunca o clichê do setor.

## O plano: arquitetura do site e lista de convenções

Escreva o plano e mostre ao dono antes de codar, nesta ordem:

1. **Formato e registro.** O formato da tabela (ex.: "serviço com agendamento"), o registro de densidade e quantos módulos entram na primeira dobra.
2. **Árvore do site em texto**, com o endereço de cada página, usando o modelo do tipo de site em `references/mapa-do-site.md`. Regras fechadas:
   - Negócio pequeno ou local: **1 a 2 níveis**, no máximo. Toda página importante a até 3 cliques da inicial.
   - Endereços em minúsculas, sem acento, com hífen, curtos e espelhando a árvore: `/servicos/corte-masculino`, nunca `/Servicos`, `/servico_1` ou `/s?id=12`. Página de registro público usa `slug` legível, não o id.
   - Páginas legais: `/privacidade` sempre que houver formulário ou medição; `/termos` e `/trocas-e-devolucoes` em loja.
3. **Menu (cabeçalho).** De 4 a 7 itens, na ordem de importância, com **as palavras do cliente final** ("Cardápio", "Agendar", "Onde estamos", "Imóveis à venda"), nunca nome criativo ou jargão ("Experiências", "Soluções", "Universo"). Logo à esquerda levando à inicial; botão da ação principal na extrema direita. No celular, o botão da ação fica visível sem abrir o menu.
4. **Rodapé.** Colunas por tema (modelo em `references/mapa-do-site.md`), com endereço, horário, telefone, WhatsApp, redes, registro profissional, CNPJ quando o dono informar, e links legais.
5. **Tabela de páginas**: Página | Endereço | Mãe | Onde aparece (menu, rodapé, dentro de outra) | Prioridade.
6. **Lista de convenções do setor** copiada da tabela, cada uma com o destino (qual página e bloco) e as (D) marcadas. Se ficar alguma de fora, o motivo.
7. **A cunha** escolhida, ou "sem cunha: compete na execução". Se veio de concorrentes, qual lacuna do mercado ela explora.
8. **Rotas antigas** dos caminhos do site anterior que o dono informou (caminho antigo, página nova), implementadas dentro do app com `<Navigate replace/>`; vale só no mesmo domínio.
9. **Modelo de dados**: `business_profile` e os modelos de conteúdo do setor (coluna Dados da tabela), com `access`; o formulário de visitante; a automação que avisa o dono.
10. **SEO**: o título e a descrição da home e de cada página principal que vão em `fab.config.json → seo` (seção "A construção").
11. **Suposições**, cada uma com a alternativa: o que você decidiu sem perguntar.
12. Em "o que não entra": caminhos que o setor não usa, e o que a plataforma não faz (ex.: puxar avaliações do Google automaticamente; a nota é digitada pelo dono).

**Lista de conferência.** Entram TODAS: cada convenção da lista do setor (item 6) e estes itens:
- Toda rota de `src/routes.tsx` está na árvore do plano e tem link de entrada vindo do menu, do rodapé ou de outra página (nenhuma página órfã).
- Os endereços das páginas são minúsculos, sem acento e com hífen, e as páginas de serviço usam `slug`.
- Endereço, horário e WhatsApp saem de `business_profile` e aparecem no rodapé de todas as páginas públicas.
- No celular, sem rolar, aparecem o botão de agendar (ou a ação principal do setor), a foto do espaço e o bloco de confiança (visual).
- Cada serviço mostra preço (R$ 1.234,56) e duração; o bloco de registro só aparece quando `responsible_registry` está preenchido.
- O cabeçalho tem de 4 a 7 itens, todos com palavras do cliente, e o botão da ação principal na direita (visual).
- O `seo` do `fab.config.json` tem título e descrição da home e uma entrada em `pages` para cada rota estática que importa; cada rota dinâmica tem `<FabHead>`.

O dono aprova o plano antes da construção.

## A construção: implementar a composição ao pé da letra

Ordem: `fab.schema.json` e `fab.automations.json` primeiro (`pull` antes, porque o arquivo de automações substitui o conjunto inteiro), depois `theme` e `seo` no `fab.config.json`, `fabapp push`, e só então o código.

- **Casca de site** (cabeçalho fixo com `AppHeader`, links no meio, ação principal em `actions`; no celular o menu vai numa `Sheet`, com o mesmo `NAV`). Defina os destinos uma vez (`const NAV = [...]`) e use no cabeçalho, no menu do celular e no rodapé. O botão da ação principal fica fora da `Sheet`, sempre visível.
- **Barra de ação no celular** para páginas comerciais: fixa no rodapé da tela (`fixed inset-x-0 bottom-0 md:hidden`, com `pb-[env(safe-area-inset-bottom)]`) com o mesmo rótulo do herói; `<main>` ganha `pb-20 md:pb-0` para ela não cobrir conteúdo.
- **Um componente de ação só** (ex.: `BookingCta`, `WhatsAppCta`) usado em todo lugar, abrindo o mesmo formulário ou a mesma conversa. WhatsApp: link `https://wa.me/55DDDNUMERO?text=...` (só dígitos, com 55 e DDD, texto codificado com `encodeURIComponent`) com uma mensagem que diz a origem ("Oi, vim pelo site e quero agendar..."), número vindo de `business_profile.whatsapp`, e `trackEvent('Contact', { source: 'hero' })` no clique. Telefone como alternativa (`tel:+55...`) sempre visível para quem prefere ligar.
- **Agendamento** com os modelos canônicos `service`, `availability` e `booking` e o `<SlotPicker/>` da plataforma, em uma página ou modal, nunca assistente de várias etapas. O `SlotPicker` só confirma com usuário logado (ele grava `customer` com o id do usuário): a tela diz isso antes ("Para confirmar o horário, crie seu acesso em 30 segundos") e o cadastro pede o mínimo (nome e WhatsApp em `appUser.fields`, mais o login). O visitante escolhe serviço e profissional (quando importa) antes do horário; observação é campo opcional. Se o dono não quer conta de cliente, a ação principal vira WhatsApp com a mensagem pronta, não um formulário que finge agendar. Política de cancelamento, atraso e pagamento escrita na própria tela. Confirmação honesta: diga o que acontece agora ("Seu horário está reservado; você recebe a confirmação no WhatsApp"), e uma automação em `fab.automations.json` (gatilho `data`, modelo `booking`, evento `created`, ação `notify`) avisa o dono.
- **Formulário de visitante** (contato, orçamento, reserva, lead): modelo com `access` `{"read":"role:admin","create":"public","update":"role:admin","delete":"role:admin"}`, validação com `zod`, uma linha dizendo para que o dado será usado com link para `/privacidade`.
- **Horário**: renderize dia a dia a partir de `hours` (dias variados em linhas separadas, nunca resumo vago) e um selo "Aberto agora" ou "Fecha às 19h" calculado no navegador. Formato brasileiro: 24h, `formatMoney`, telefone (11) 91234-5678 (se a skill `padroes-brasil` estiver instalada, ela manda nos formatos).
- **Fotos**: imagem do lugar, do prato ou do trabalho vem de registro (`image`/`list of image`) que o dono envia pelo Studio; enquanto não houver, `<AppImage slot prompt>` com cena específica do setor (um único assunto, luz real), nunca colagem genérica, uma por linha e nunca dentro de `.map()`. Texto sobre foto com véu.
- **Profissionais com rosto e nome** quando o cliente escolhe a pessoa (barbeiro, cabeleireira, dentista, personal): cartão com nome, foto, anos de experiência e 1 a 3 especialidades, bio de 1 ou 2 frases, **acima** do botão de agendar.
- **SEO local.** Você escreve a configuração de SEO em `apps/<slug>/fab.config.json → seo` e envia com `fabapp push`: `enabled: true`; `title` (15 a 60 caracteres) e `description` (50 a 160) da home, dizendo o serviço e a cidade ("Barbearia no Centro de Curitiba: corte e barba com hora marcada"); uma entrada em `pages` para cada rota estática que importa (`"/servicos": { "title": ..., "description": ... }`), `"/admin": { "index": false }` para a área do dono; `structured: true`, `breadcrumbs: true`, `robots: true`, `sitemap: true` (o sitemap só é escrito quando o site tem domínio); `ogImage` como URL absoluta `https://` de PNG ou JPEG 1200x630 (SVG é ignorado por WhatsApp, Facebook e LinkedIn; sem imagem pronta, deixe para o dono e ponha na lista dele). Toda página pública recebe também `<FabHead title description image/>` (ou `useSeo`), com as mesmas regras de tamanho; nunca escreva `<title>`. Na rota dinâmica (`/servicos/:slug`, `/imoveis/:slug`) ele é obrigatório, com título e descrição vindos do registro (é o único head que ela tem, porque rota dinâmica não é pré-renderizada); na estática é reforço do que a plataforma pré-renderiza a partir de `seo.pages`. Endereço, telefone e horário como texto visível na página (buscador lê texto, não imagem). Links de navegação são `<Link>`/`<NavLink>` de verdade, nunca `onClick` com `navigate` (o buscador precisa do link).
- **Trilha** (`breadcrumb`) nas páginas de segundo nível, espelhando o endereço: `/servicos/corte-masculino` → Início › Serviços › Corte masculino, com o último item sem link.
- **Estados vazios** no tom da marca e com uma ação ("Nenhum imóvel com esses filtros. Limpar filtros"); os demais estados de lista: carregando com `Skeleton`, erro com `e.message` e "Tentar de novo" (se a skill `ux-de-sistemas` estiver instalada, ela detalha).
- **Painel do admin**: telas para o dono editar `business_profile` e os modelos de conteúdo, com a lista "Falta preencher".
- Aplique as convenções do setor da tabela uma a uma. "Um componente que se aproxima" não conta: se a convenção diz preço e duração por serviço, os dois aparecem em cada item.

## Conferir antes de dizer pronto

1. Rode `fabapp dev` e abra a pré-visualização. Percorra cada rota da árvore (as `:slug` com um registro real, que o dono cadastrou ou que você criou pela pré-visualização como teste), no celular e no desktop, e cada item da lista de conferência. Marque a lista de convenções como conferida no código: presente, ausente com motivo.
2. Por busca no código (`grep` em `.fabapp/workspace/src`): nenhuma rota fora da árvore, nenhum `<title>` à mão, nenhum `onClick` com `navigate` no lugar de link, nenhum fato do negócio escrito direto no código, e as regras que o `deploy` não confere (nenhum hex nem `font-family`, nenhum `window.confirm`/`alert`/`prompt`, nenhum `animation-timeline`, nenhum `<img>` com URL externa, nenhum `await import(`).
3. `fabapp push` e leia a saída (400 ou 422 com o caminho exato; "The platform added" pede um `pull`). Depois `fabapp deploy`. `account_builds_busy` (409): espere e repita. `build_failed` (422): conserte pelo arquivo, linha e coluna antes de tentar de novo.
4. No ar: status 200, head com o título e a descrição certos na home e nas páginas principais, um envio de teste do formulário que aparece no CMS do Studio e cuja notificação chega. Apague o teste.

Na mensagem final ao dono: a lista de convenções como foi conferida, o link, e o que ele faz no Studio: preencher "Dados do negócio" (os campos que faltam para os blocos escondidos aparecerem, com os valores que ele já deu prontos para copiar), cadastrar serviços, profissionais ou produtos, trocar as imagens dos slots, subir a imagem de compartilhamento se faltou, e domínio próprio (sem ele o sitemap não sai).

## Mudanças depois: manter o site no setor

- Antes de mexer, releia a lista de convenções do plano e o `DECISOES.md`. Um pedido que remove uma convenção (D) ("tira o horário do topo", "esconde os preços") é atendido, mas diga ao dono em uma frase o que se perde ("sem preço à vista, mais gente pergunta no WhatsApp antes de agendar") e registre em `DECISOES.md` (Decisões).
- **"Ficou genérico" ou "não parece do meu ramo"**: rode a síntese (eixo 7). Se faltam 3 ou mais convenções, ou uma (D), recomponha a página seguindo os eixos; não troque só cor e fonte.
- **Página nova**: entra na árvore com endereço no padrão, ganha link de entrada (menu, rodapé ou página mãe), entrada própria em `seo.pages` (rota estática) ou `<FabHead>` (rota dinâmica), com título e descrição próprios. Menu passando de 7 itens: agrupe (ex.: "Serviços" com as subpáginas) em vez de crescer.
- **Endereço de página mudou**: mantenha o antigo como rota que leva à nova (`<Route path="/antigo" element={<Navigate to="/novo" replace/>}/>`), para links já compartilhados no WhatsApp e no Instagram não quebrarem, e mova a entrada de `seo.pages` para o endereço novo. É redirecionamento dentro do app, não 301 de servidor; diga isso ao dono se ele perguntar por SEO.
- **Pedido de conselho** ("põe o preço", "coloca depoimento de paciente", "mostra antes e depois"): atenda só depois de o dono confirmar que o conselho dele permite; registre a confirmação em `DECISOES.md` (Decisões). Você não afirma nem nega a regra: o dono decide.
- **Pedido de cor, fonte ou logo**: cor, fonte e raio mudam no `theme` do `fab.config.json` (a escolha do dono e nunca o clichê do setor), com `fabapp push` e `fabapp deploy`; nunca em CSS. O logo o dono sobe no Studio.
- Novos fatos do negócio vão para `business_profile` (o dono cadastra), nunca escritos direto no código.

## Armadilhas que você deve recusar antes de entregar

- **"Deixa moderno"** sem setor: produz o site arejado de startup que esta skill existe para evitar. Traduza "moderno" em convenções do setor bem executadas.
- **Visual de SaaS numa vitrine**: loja, catálogo e imobiliária pedem mais conteúdo por tela. Se ficou calmo e espaçoso, confira a densidade.
- **Tarefa enterrada**: herói cheio de texto de marketing e três botões disputando. O eixo 1 não é opcional.
- **Modelo pronto no lugar da convenção**: a tabela diz o que o setor tem em comum; o site ainda precisa aplicar isso a este negócio, com os fatos dele.
- **Pular a síntese**: um site que passa nos eixos 1 a 6 um por um ainda pode compor errado. A lista pega isso.
- **Confundir detalhe com composição**: raio do botão, tamanho de fonte e contraste são acabamento. Quantidade de módulos, destaque da tarefa e profundidade da vitrine são decisões desta skill.
- **Iframe de terceiro para a ação principal** (agenda externa, cardápio em PDF): quebra a identidade no momento em que o cliente está decidindo. A ação fica dentro do site.
