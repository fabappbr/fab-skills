# Convenções por setor (Brasil)

Como ler cada linha: **Formato** (um dos 11 abaixo) · **Tarefa e ação** (o que o herói entrega e o rótulo do botão) · **Densidade** · **Convenções** numeradas, com **(D)** nas que carregam densidade · **Confiança** · **Anti-padrões** · **Páginas** · **Dados** (modelos além de `business_profile`) · **Cunhas** possíveis (escolha uma). Onde o setor tem conselho profissional, o registro é sempre preenchido pelo dono, nunca inventado.

Formatos: serviço com agendamento · comida · loja com catálogo · loja de marca · anúncios e estoque · diretório · produto digital · instituição · experiência · serviço profissional · fornecedor B2B.

Setores com conselho profissional (CFM, CFO, CRP, CREFITO, CRN, CRMV, OAB, CRECI, CRC, CREF): o site sai **conservador por padrão** e o dono decide o que entra. Padrão: registro do responsável técnico (digitado pelo dono) no rodapé e em Sobre; especialidade só quando o dono informar o registro dela (ex.: RQE); sem promessa de resultado, "garantido", "sem dor", "promoção", "desconto" ou "o melhor da cidade"; sem preço, depoimento e antes e depois até o dono confirmar que o conselho dele permite (antes e depois também exige autorização escrita das pessoas). Você não afirma o teor da regra de nenhum conselho: pergunta, registra a resposta e o site reflete. A base americana trata "antes e depois" como obrigatório para dentista; aqui é opcional e desligado por padrão.

---

## Salão, barbearia, esmalteria, estética, design de sobrancelha
Formato: serviço com agendamento · Tarefa: agendar ("Agendar horário"); sem agenda online, "Chamar no WhatsApp" · Densidade: guiado por imagem, calor de lugar; nem catálogo, nem página de marketing.
1. Ação de agendar no herói e fixa em toda página.
2. **(D)** Foto do espaço ou do trabalho **deste** salão na primeira dobra, nunca banco de imagem.
3. Serviços agrupados (corte, barba, química, pacotes) com preço ("a partir de" se variar) e duração por item, a um clique da inicial. Pacote é item próprio com preço próprio. Duração honesta (degradê leva mais que corte social).
4. **(D)** Bloco de confiança agregado acima da dobra: anos de casa, nota com contagem, profissionais.
5. Equipe com rosto, nome, especialidades, acima do botão de agendar; ao agendar, escolhe o profissional antes do horário.
6. Endereço e horário no rodapé de toda página; "aberto agora".
7. Agendamento em uma tela: serviço, profissional, dia, horário. O acesso do cliente é criado na hora de confirmar, com o mínimo (nome, WhatsApp e login), porque o agendamento da plataforma grava quem reservou.
8. **(D)** Política de atraso, cancelamento e pagamento (Pix, cartão) escrita na tela de agendar.
9. Instagram e galeria de trabalhos.
10. Telefone ou WhatsApp como alternativa visível.
Confiança: nota com contagem, anos, equipe nomeada, acessibilidade do espaço. Anti-padrões: agenda em iframe de terceiro, preço só por mensagem, "nossa equipe" sem rostos, ilustração genérica. Páginas: `/`, `/servicos`, `/equipe`, `/agendar`, `/onde-estamos`, `/privacidade`. Dados: `service`, `availability`, `booking`, `professional`, `gallery_item`. Cunhas: agenda em primeiro lugar; equipe antes do horário; cardápio de serviços honesto; foto do salão real; confiança agregada no topo.

## Clínica e consultório (médico, dentista, psicólogo, fisioterapeuta, nutricionista)
Formato: serviço com agendamento · Tarefa: "Agendar consulta" (ou WhatsApp da recepção) · Densidade: guiado por imagem com registro institucional, sóbrio.
1. Ação de agendar no herói e fixa.
2. **(D)** Nome e registro do responsável técnico (CRM, CRO, CRP, CREFITO, CRN) no rodapé e em Sobre; cada profissional com o próprio registro.
3. **(D)** Convênios aceitos em lista visível (ou "atendimento particular"), perto da ação.
4. Especialidades e procedimentos em linguagem simples, 2 frases cada, sem promessa.
5. Profissionais com foto, nome, registro e formação.
6. Endereço com link para o mapa, horário, estacionamento, acessibilidade.
7. Preço da consulta só se o dono quiser mostrar, sem palavra de promoção.
8. Primeira consulta: o que levar, quanto tempo dura, como chegar.
9. Telefone da recepção e WhatsApp visíveis.
Confiança: registro, formação, anos de atuação, estrutura real. Anti-padrões: interface datada, agendamento confuso, gradiente roxo e rosa, antes e depois sem autorização, depoimento de paciente prometendo cura, "melhor clínica". Páginas: `/`, `/especialidades`, `/especialidades/:slug`, `/equipe`, `/convenios`, `/agendar`, `/onde-estamos`, `/privacidade`. Dados: `service`, `availability`, `booking`, `professional`, `insurance_plan`. Cunhas: convênios à vista; primeira consulta explicada; equipe com registro.

## Academia e estúdio (musculação, pilates, crossfit, dança, luta)
Formato: serviço com agendamento · Tarefa: "Agendar aula experimental" ou "Ver planos" · Densidade: guiado por imagem, energia real.
1. Aula experimental no herói.
2. **(D)** Planos mensal, trimestral e anual com preço em R$ e o que inclui, lado a lado.
3. **(D)** Grade de aulas por dia e horário.
4. Professores com foto, nome e registro CREF.
5. Foto do espaço e dos equipamentos reais.
6. Endereço, horário de funcionamento por dia, estacionamento.
7. Regras de matrícula, cancelamento e fidelidade escritas.
Anti-padrões: plano "sob consulta", foto de banco de imagem, grade em imagem. Páginas: `/`, `/planos`, `/aulas`, `/professores`, `/aula-experimental`, `/onde-estamos`. Dados: `plan` (de exibição, ou canônico se vender assinatura), `class_session`, `professional`, `booking`.

## Pet shop, banho e tosa, veterinária
Formato: serviço com agendamento (loja se vender produtos) · Tarefa: "Agendar banho e tosa" / "Agendar consulta" · Densidade: guiado por imagem, acolhedor.
1. Agendar no herói, com porte do animal no formulário (pequeno, médio, grande).
2. **(D)** Serviços com preço por porte e duração.
3. Veterinária: **(D)** emergência e plantão com telefone em destaque; CRMV do responsável técnico.
4. Busca e entrega (leva e traz) com bairros atendidos, se houver.
5. Fotos reais dos animais atendidos (com autorização do tutor).
6. Endereço e horário.
Anti-padrões: serviço escondido, emergência sem telefone. Páginas: `/`, `/servicos`, `/agendar`, `/produtos` (se vender), `/onde-estamos`. Dados: `service`, `booking`, `pet` (se houver área do cliente).

## Serviço em domicílio (eletricista, encanador, diarista, dedetização, chaveiro, ar-condicionado, guincho)
Formato: serviço com agendamento · Tarefa: "Pedir orçamento no WhatsApp"; urgência (chaveiro, guincho, desentupidora): "Ligar agora" grande e fixo no celular · Densidade: direto, útil.
1. **(D)** Área de atendimento por bairro ou cidade no herói.
2. Contato de emergência em destaque quando o serviço é urgente, com horário (24h só se for verdade).
3. **(D)** Lista de serviços com preço inicial ou "orçamento sem compromisso" e prazo de atendimento.
4. Certificações e registros (NR-10 para eletricista, licença sanitária para dedetização), preenchidos pelo dono.
5. Fotos de trabalhos feitos.
6. Garantia do serviço escrita (prazo), se o dono oferecer.
7. Formas de pagamento (Pix, cartão, parcelamento).
Anti-padrões: contato escondido, sem área de atendimento, sem certificação. Páginas: `/`, `/servicos`, `/servicos/:slug`, `/area-de-atendimento`, `/orcamento`. Dados: `service`, `quote_request`.

## Restaurante, lanchonete, pizzaria, delivery
Formato: comida · Tarefa: ver o cardápio; depois "Pedir pelo WhatsApp", "Reservar mesa" ou links de apps de entrega (secundários) · Densidade: guiado por imagem, atmosfera.
1. **(D)** Foto de um prato, do salão ou de um momento, de ponta a ponta, na primeira dobra (um assunto, não colagem).
2. **(D)** Cardápio como página (nunca PDF), agrupado por categoria, com nome, descrição e preço de cada item, a um clique da inicial.
3. Descrição com ingrediente e preparo ("massa de fermentação natural, 48h"), não pilha de adjetivos; pratos da casa marcados.
4. Pedido ou reserva dentro do site, disponível do cabeçalho em toda página.
5. **(D)** Uma prova perto da ação: nota com contagem digitada pelo dono ou uma citação de publicação nomeada. Nunca parede de logos.
6. Endereço e horário acima da dobra; horário dia a dia; "aberto agora"; delivery com bairros, taxa e tempo médio.
7. Texto curto da cozinha (2 parágrafos, primeira pessoa), não história de marca.
8. Política de reserva, atraso e alérgenos escrita; aviso de alérgenos quando o dono informar.
9. Telefone como alternativa.
Com delivery próprio: destaque velocidade e bairros. Anti-padrões: cardápio em PDF ou imagem, horário desatualizado, foto ruim, reserva em widget externo. Páginas: `/`, `/cardapio`, `/reservas` ou `/pedir`, `/onde-estamos`, `/sobre`. Dados: `menu_category`, `menu_item` (com `price`, `image`, `is_signature`, `available`), `reservation` ou `order`. Cunhas: o cardápio é a página; reserva no site; foto de um assunto só; voz da cozinha; origem dos ingredientes nomeada.

## Padaria, café, confeitaria, doceria de encomenda
Formato: comida · Tarefa: "Ver cardápio" e "Encomendar" (bolos, festas) · Densidade: guiado por imagem, acolhedor.
1. **(D)** Cardápio com preço e fotos boas; sazonais marcados.
2. Encomenda com prazo mínimo, tamanhos e sabores, retirada ou entrega.
3. **(D)** Horário e endereço em destaque.
4. Pedido pelo WhatsApp com mensagem pronta.
Anti-padrões: foto escura, horário escondido. Dados: `menu_item`, `custom_order`.

## Loja com catálogo (roupa, calçado, material de construção, autopeças, papelaria, cosméticos)
Formato: loja com catálogo · Tarefa: caminho até o produto: busca, grade de categorias ou seletor de compatibilidade (autopeças: veículo) · Densidade: vitrine densa; herói de dois módulos é errado.
1. Tarefa de busca ou categoria no herói (não frase de marca), fixa no cabeçalho ao rolar.
2. **(D)** Faixa de categorias na primeira dobra: 4 a 6 entradas para catálogo focado, 8 a 12 para amplo, com imagem ou ícone e texto.
3. Filtros funcionando na listagem (preço, tamanho, cor, marca) e ordenação visível (menor preço, maior preço, nome).
4. Preço em todo cartão, sem "clique para ver"; parcelamento ("em até 3x sem juros" só se for verdade) e preço no Pix.
5. Avaliações perto do botão de comprar, ou substituto honesto (garantia, troca).
6. Carrinho real que persiste entre páginas; checkout pela plataforma (`useCheckout`), cartão e Pix.
7. **(D)** Faixa de ofertas perto do topo (1 ou 2 ofertas reais, cadastradas pelo dono).
8. **(D)** Sinal de profundidade do catálogo com número real: "312 produtos" vindo de `count()`, nunca inventado.
9. Frete: prazo e valor antes do pagamento; frete grátis acima de R$ X se for verdade.
10. Rodapé de loja: razão social, CNPJ, endereço e contato (informados pelo dono); política de troca e devolução escrita pelo dono, com o prazo de arrependimento em compra à distância que ele adota (lembre-o de conferir o prazo legal).
11. **(D)** Volume de vitrine compatível com o catálogo real: várias faixas de produtos, grade de categorias e ofertas, até onde o catálogo do dono permitir. Presença de um de cada não basta; nunca completar com produto inventado.
Anti-padrões: frete surpresa no fim, preço escondido, lista sem filtro em catálogo grande. Páginas: `/`, `/produtos`, `/categorias/:slug`, `/produto/:slug`, `/ofertas`, `/carrinho`, `/trocas-e-devolucoes`, `/privacidade`, `/termos`. Dados: `product`, `category`, `order`. Cunhas: preço total claro antes do fim; prazo real de entrega; avaliações verdadeiras incluindo as ruins.

## Loja de marca ou produto único (moda autoral, cosmético próprio, café especial)
Formato: loja de marca · Tarefa: ver o produto, ler a história, comprar · Densidade: expressivo, imagem grande, ar.
1. Foto grande do produto no herói.
2. História de quem faz, cedo na página.
3. Guia de tamanho, material ou modo de uso a um clique.
4. Avaliações focadas em qualidade e durabilidade.
5. Troca generosa e escrita.
Dados: `product`, `order`, `review`.

## Imobiliária e corretor
Formato: anúncios e estoque · Tarefa: "Buscar imóvel" com filtros no herói · Densidade: grade densa de anúncios.
1. **(D)** Busca no herói: venda ou aluguel, bairro, tipo, quartos, faixa de preço em R$.
2. Linha de filtros ativos (chips) que persiste na listagem; filtros no endereço da página (`?bairro=...`) para compartilhar.
3. **(D)** Cartão com foto, preço, bairro, quartos, vagas, área e quantidade de fotos.
4. Detalhe com galeria, descrição, condomínio e IPTU, localização (link para o mapa), contato do corretor.
5. **(D)** CRECI da imobiliária (CRECI-J) e do corretor no rodapé e nos anúncios.
6. Data do anúncio ou "atualizado em"; salvar favorito.
7. Contato por WhatsApp com a referência do imóvel na mensagem.
Anti-padrões: foto ruim, anúncio vencido, sem CRECI, sem filtro. Páginas: `/`, `/imoveis`, `/imoveis/:slug`, `/anunciar-meu-imovel`, `/corretores`, `/contato`. Dados: `property` (com `list of image`, `geo`, `enum` venda/aluguel, `money`), `lead`.

## Loja de veículos
Formato: anúncios e estoque · Tarefa: buscar por marca, modelo, ano e preço.
1. **(D)** Busca e filtros no herói.
2. Cartão com foto, preço, ano, km, câmbio.
3. Detalhe com várias fotos, laudo ou procedência quando houver, simulação de financiamento só como link ou contato (sem calcular juros inventados).
4. Contato com referência do carro.
Dados: `vehicle`, `lead`.

## Escola, curso livre, idiomas, preparatório
Formato: instituição (escola regular) ou produto (curso) · Tarefa: "Agendar visita", "Fazer matrícula" ou "Ver cursos" · Densidade: calmo editorial.
1. **(D)** Cursos ou séries com duração, horário, formato (presencial, online) e valor ou "consulte".
2. Proposta pedagógica em linguagem simples.
3. Calendário de matrículas e início de turmas.
4. Professores com formação.
5. Escola regular: ato de autorização da Secretaria de Educação preenchido pelo dono; curso livre não promete diploma reconhecido pelo MEC.
6. Área do aluno ou dos pais, se houver (com login).
Páginas: `/`, `/cursos`, `/cursos/:slug`, `/matricula`, `/calendario`, `/sobre`. Dados: `course`, `enrollment_request`.

## Creche e escola infantil
Formato: instituição · Tarefa: "Agendar visita".
1. **(D)** Segurança à vista: rotina, equipe, protocolos, alimentação.
2. Comunicação com os pais (agenda, avisos) descrita.
3. Fotos do espaço (sem rosto de criança sem autorização).
4. Faixas etárias, turnos, período integral.
Anti-padrões: informação de segurança escondida, visual genérico.

## Autoescola
Formato: serviço com agendamento · Tarefa: "Quero me matricular" ou WhatsApp.
1. **(D)** Categorias (A, B, AB, D, E) com o que está incluso e preço ou "consulte".
2. Etapas do processo até a carteira explicadas em passos simples (sem prometer prazo do Detran).
3. Credenciamento no Detran do estado, preenchido pelo dono.
4. Frota e horários de aula prática.
5. Endereço e horário.

## Advocacia
Formato: serviço profissional · Tarefa: "Fale com um advogado" (contato) · Densidade: calmo, sóbrio, informativo.
Padrão conservador (o dono decide o que a OAB dele permite; você não afirma a regra): conteúdo informativo; **sem valor de honorários, sem promessa de resultado, sem "consulta grátis" como isca, sem citar casos e clientes, sem depoimentos de clientes**, sem ostentação. Qualquer um desses blocos só entra se o dono confirmar que pode publicar.
1. **(D)** Áreas de atuação, cada uma com página explicando em linguagem simples o que resolve.
2. **(D)** Advogados com foto, nome e número da OAB (e o registro da sociedade, se houver).
3. Como funciona o primeiro contato.
4. Conteúdo informativo (artigos) como prova de conhecimento.
5. Endereço, contato, atendimento online.
Anti-padrões: credencial escondida, visual datado, "ganhamos 98% das causas". Páginas: `/`, `/areas-de-atuacao`, `/areas-de-atuacao/:slug`, `/equipe`, `/artigos`, `/contato`. Dados: `practice_area`, `lawyer`, `post`, `lead`.

## Contabilidade
Formato: serviço profissional · Tarefa: "Pedir proposta" ou "Falar com um contador".
1. **(D)** Serviços por tipo de cliente (MEI, Simples Nacional, empresa, pessoa física, abertura de empresa).
2. Como funciona a troca de contador, passo a passo (objeção de esforço).
3. CRC do escritório e do responsável técnico, preenchido pelo dono.
4. Planos ou "a partir de" se o dono quiser.
5. Área do cliente ou canal de envio de documentos, se houver.
Páginas: `/`, `/servicos`, `/servicos/:slug`, `/trocar-de-contador`, `/contato`.

## Igreja e comunidade religiosa
Formato: instituição · Tarefa: "Horários de culto" ou "missa", "Como chegar" · Densidade: acolhedor, claro.
1. **(D)** Horários das celebrações por dia, acima da dobra.
2. Endereço com link para o mapa.
3. Agenda de eventos e grupos.
4. Mensagens ou pregações (vídeo ou texto).
5. Contribuição: chave Pix como texto com botão copiar, e o CNPJ da instituição.
6. Primeira visita: o que esperar.
Anti-padrões: horário escondido, visual datado. Dados: `event`, `sermon`.

## ONG e associação
Formato: instituição · Tarefa: o pedido do momento ("Doar", "Ser voluntário").
1. Missão em uma frase acima da dobra e um pedido claro.
2. **(D)** Impacto com números informados pelo dono e fonte.
3. Transparência: CNPJ, relatórios e prestação de contas linkados.
4. Diretoria e equipe acessíveis pelo rodapé.
5. Sem imagem apelativa que soe manipuladora.

## Hotel, pousada, hospedagem
Formato: experiência · Tarefa: "Ver disponibilidade" ou "Reservar pelo WhatsApp".
1. **(D)** Galeria dos quartos reais por tipo, com capacidade e comodidades.
2. Tarifa "a partir de" por temporada, se o dono quiser.
3. Localização e como chegar, atrações próximas.
4. Políticas de check-in, check-out, cancelamento, pets, crianças.
5. Nota com contagem digitada pelo dono.
Anti-padrões: foto ruim, reserva complicada.

## Passeio, turismo, evento, espaço de festas
Formato: experiência · Tarefa: "Reservar data" ou "Ver disponibilidade".
1. Reservar ou consultar data no herói.
2. **(D)** "O que esperar" e "o que levar" antes da escolha.
3. Restrições claras (idade, acessibilidade, clima).
4. Política de cancelamento e de chuva visível.
5. Fotos reais recentes; nada de imagem que não corresponda à experiência.

## Fotógrafo, arquiteto, designer, marcenaria sob medida
Formato: serviço profissional · Tarefa: "Pedir orçamento".
1. **(D)** Portfólio em imagem grande, por tipo de trabalho.
2. Pacotes ou "a partir de", com o que está incluso.
3. Processo em passos e prazo médio.
4. Agenda de datas, se aplicável.

## Fornecedor B2B e indústria
Formato: fornecedor B2B · Tarefa: ver produtos com especificação e "Pedir cotação" ou "Falar com a engenharia" · Densidade: técnico, média densidade.
1. Foto do produto em uso ou em estúdio no herói, com frase de capacidade e o botão.
2. **(D)** Especificações em tabela HTML em cada produto, nunca só em PDF fechado por formulário (o PDF fica como download extra).
3. Listagem com nome, frase, 3 a 6 especificações e imagem por linha.
4. Detalhe com tabela completa, certificações do produto, aplicações e botão de cotação ligado ao produto.
5. **(D)** Aplicações com setor e resultado em número informado pelo dono ("ciclo 20% menor"), nunca "líder global".
6. Página da empresa com fundação, sede, certificações (ISO etc.).
7. **(D)** Formulário de cotação no site com até 6 campos (nome, empresa, e-mail, cargo, produto, necessidade); telefone opcional.
8. "O que acontece depois" honesto ("um técnico responde em 1 dia útil") e telefone visível.
9. Preço sob cotação dito com clareza; nunca preço inventado.
10. **(D)** Imagem real em cada produto: principal e pelo menos uma secundária (outro ângulo, detalhe, em uso).
Dados: `product` com `specs` (json), `application`, `quote_request`.

## Produto digital ou app por assinatura
Formato: produto digital · Tarefa: "Começar grátis", "Assinar" ou instalar.
1. Ação no herói e no cabeçalho.
2. Recursos em seções de rolagem com imagem do produto real (tela verdadeira).
3. **(D)** Preços claros, com a linha entre grátis e pago.
4. Nota de loja ou contagem de usuários só se for real.
5. Sem captura de tela falsa.

## Diretório ou marketplace de prestadores
Formato: diretório · Tarefa: dizer o que precisa e onde; ver prestadores ranqueados.
1. Seletor de serviço como primeira interação, localização cedo.
2. **(D)** Cartão do prestador com foto, nota com contagem, tempo de resposta.
3. Selo do que é verificado e do que é aberto.
4. Caminhos: por categoria e por local (primários), por nome (secundário).
Dados: `provider`, `category`, `review`, `request`.
