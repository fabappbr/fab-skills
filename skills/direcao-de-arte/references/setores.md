# O setor decide o que o app precisa ter (nunca a cara)

Use esta tabela para os REQUISITOS da direção: o que a primeira dobra precisa provar, a ação principal, o que não
pode faltar e o que afasta o cliente. A cor e a fonte continuam vindo do mundo escolhido, não do setor. Registro
profissional, preço, depoimento e nota nunca são inventados: o lugar fica marcado para o dono preencher.

| Setor | Ação principal (um texto só) | Não pode faltar | Afasta o cliente |
|---|---|---|---|
| Salão, barbearia, esmalteria, estética | "Agendar horário" | serviços com duração e preço "a partir de" (`service`), profissionais, horários livres (`availability`, `booking`), galeria de trabalhos (`list` de `image`), endereço, horário, link do WhatsApp e do Instagram | preço escondido, agenda que pede cadastro antes de mostrar horário, foto de banco |
| Restaurante, lanchonete, padaria, café, marmita | "Ver cardápio" ou "Fazer pedido" | cardápio por categoria com foto e preço em R$, horário em destaque ("aberto agora"), pedido ou link do delivery, taxa por bairro, endereço com link do Google Maps, Pix | foto ruim de comida, horário desatualizado, cardápio em PDF |
| Clínica, consultório, dentista, psicologia, fisioterapia, nutrição | "Agendar consulta" | especialidades, convênios aceitos, agendamento, profissional responsável com registro (CRM, CRO, CRP, CREFITO, CRN) preenchido pelo dono, endereço, WhatsApp, orientação de preparo | promessa de resultado ou cura, antes e depois (os conselhos restringem; só com decisão do dono e aviso), jargão, contraste baixo para público mais velho |
| Academia, estúdio, personal, luta, dança | "Aula experimental" | planos mensal e anual com preço, grade de aulas por dia e horário, professores com CREF preenchido pelo dono, check-in ou reserva de vaga, endereço | gamificação que o dono não pediu, promessa de corpo, grade em imagem |
| Imobiliária, corretor, aluguel de temporada | "Falar com o corretor" | busca por bairro, filtros (quartos, faixa de preço em R$, venda ou aluguel), galeria de fotos por imóvel, código do imóvel na mensagem do WhatsApp, CRECI no rodapé preenchido pelo dono, localização por link do Google Maps (não há mapa pronto) | foto escura ou torta, imóvel sem preço nem bairro, formulário longo |
| Escola, curso, reforço, autoescola, idiomas | "Fazer matrícula" | turmas e horários, calendário, área do aluno ou do responsável (curso com `course`, `module`, `lesson`), proposta pedagógica, contato da secretaria | jargão, informação de matrícula escondida, texto longo sem hierarquia |
| Loja, moda, brechó, artesanato, presentes | "Comprar" | catálogo com foto grande, variações (tamanho, cor), estoque, preço em R$ com parcelamento só se o dono informar, Pix e cartão (`useCheckout`), frete ou retirada, política de troca | foto pequena, preço só no carrinho, cadastro obrigatório antes de ver |
| Pet shop, banho e tosa, veterinário | "Agendar banho" ou "Agendar consulta" | ficha do pet (espécie, porte, idade, foto), agenda, lembrete de vacina e retorno (automação `relative`), telefone de emergência em destaque no veterinário | ficha genérica sem o pet, emergência escondida |
| Igreja, ONG, associação, comunidade | "Ver horários" ou "Quero ajudar" | horários de culto, missa ou encontro, agenda de eventos, doação por Pix (compra avulsa) ou link, pedidos de oração ou contato, prestação de contas (ONG) | informação desatualizada, doação sem transparência, letra pequena |
| Advocacia, contabilidade, consultoria, despachante | "Agendar conversa" | áreas de atuação, profissional com OAB ou CRC preenchido pelo dono, formulário de contato de visitante (leitura só do admin), documentos necessários por serviço | preço e promessa de ganho de causa (a OAB proíbe publicidade mercantil), captação agressiva, depoimento inventado |
| Serviço em casa (encanador, eletricista, diarista, reforma, jardinagem) | "Pedir orçamento" | bairros atendidos, serviços com fotos de trabalhos feitos, atendimento de urgência e horário, orçamento pelo WhatsApp com a descrição e a foto do problema, formas de pagamento | só formulário sem telefone, área de atendimento escondida |
| Evento, buffet, festa, fotografia, casamento | "Consultar data" | portfólio em galeria grande, pacotes, datas disponíveis, pedido de orçamento com data, local e número de convidados | portfólio pequeno, pacote sem o que inclui |
| Hotel, pousada, hostel | "Ver disponibilidade" | quartos com fotos e comodidades, consulta de datas, localização e como chegar, políticas (check-in, pet, cancelamento) | reserva complicada, foto ruim do quarto |
| Oficina, auto center, lava-jato | "Pedir orçamento" | serviços, orçamento, acompanhamento do serviço por status, histórico por placa, horário | status só por ligação |
| Delivery próprio, mercado de bairro | "Fazer pedido" | cardápio ou catálogo do dia, horário de corte, taxa por bairro, status do pedido (`order`), Pix | pedido sem confirmação, taxa surpresa |
| Ferramenta interna, CRM, estoque, financeiro, agenda da equipe | a tarefa do dia ("Novo pedido", "Ligar hoje") | tabela com filtro e ordem no servidor, status com cor e texto, busca com espera de 300ms, ações em lote, estados vazio, carregando e erro | decoração, herói com slogan, fonte de exibição em dado, cor sem texto |

Ações de conversão no Brasil: o WhatsApp é quase sempre a porta principal de negócio local. Sem a integração ligada,
use o link `https://wa.me/55DDDNUMERO?text=` com a mensagem pronta (o serviço escolhido, a data, o código do imóvel).
Formas de pagamento, endereço, horário e Instagram aparecem sempre que existirem, porque são o que o cliente procura
primeiro. Dinheiro em R$ 1.234,56, data em dd/mm/aaaa, hora em 24h, telefone (11) 91234-5678.
