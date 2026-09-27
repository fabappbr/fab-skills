# Títulos, botões, funil e testes

## Fórmulas de título do herói

O título tem um trabalho: fazer a pessoa ler a próxima linha. As fórmulas são pontos de partida; o texto final soa como o negócio.

1. **Resultado + público + mecanismo.** "Sorriso alinhado em 12 meses, para adultos que não querem aparelho de metal, com alinhadores transparentes." Forte: difícil de confundir. Fraco: pode ficar longo. Use em setor lotado.
2. **Fim da dor.** "Chega de perder cliente por demora no orçamento. Responda em 5 minutos." Use quando a dor é conhecida e sentida.
3. **Afirmação surpreendente** (com prova logo abaixo). "A academia que as pessoas continuam frequentando depois de março."
4. **Fala direta com a situação.** "Seu ar-condicionado pingando na sala? Resolvemos hoje." Use quando o público é bem específico.
5. **A pergunta que ele já faz.** "Quanto custa abrir um MEI de verdade?" Boa para página que responde uma busca.
6. **Categoria sem a dor da categoria.** "Contabilidade sem papelada." A versão preguiçosa ("X, só que melhor") não serve.
7. **Número + resultado** (número real). "Carteira na mão em 3 etapas." Número inventado derruba a confiança.
8. **Promessa em primeira pessoa, tom de amigo.** "Ache um eletricista que seus vizinhos recomendam."

Das técnicas de conversão: problema, agitação e solução ("Cansado de X? Y faz Z"); especificidade vence genérico ("Como aumentamos as reservas em 63%" vence "Aumente suas reservas"); ângulo de novidade; "Como conseguir X sem Y"; pergunta. Prioridade do que testar num título: clareza da proposta, número específico, público, momento, gancho emocional.

**Subtítulo**, um de três trabalhos: o **mecanismo** (como cumpre a promessa), o **público** exato ("Para lojas que vendem pelo Instagram") ou a **prova** ("Nossos clientes respondem em minutos, não em horas").

**Evite:** pilha de adjetivos ("Moderno. Prático. Completo."), benefício vago ("Otimize seus processos"), só o nome da marca ("Acme: o futuro"), esperteza no lugar de clareza ("Onde o cuidado encontra a inovação"), "Bem-vindo ao...".

**Escolha entre 5 a 10 variações** de fórmulas diferentes, pela que: (1) o cliente-alvo se reconhece; (2) se diferencia de pelo menos 3 concorrentes; (3) prepara o resto da página, que cumpre a promessa; (4) soa como o negócio; (5) responde "por que isso importa hoje".

## Par título e botão

| Promessa do herói | Padrão do botão |
|---|---|
| Resultado específico | "Quero [o resultado]" |
| Economizar tempo ou dinheiro | "Economizar [a coisa]" |
| Ver como funciona | "Ver como funciona" |
| Experimentar | "Testar grátis" |
| Informação | "Receber o guia" |
| Falar com alguém | "Chamar no WhatsApp", "Agendar uma conversa" |
| Comprar | "Comprar com Pix", "Garantir o meu" |

Redução de compromisso: "Agendar avaliação gratuita" pesa menos que "Contratar"; "Ver preços" menos que "Comprar agora". Se a página promete "10 jeitos de X", o botão é "Quero os 10 jeitos", nunca "Saiba mais". O que testar no botão, nesta ordem: benefício versus ação, nível de compromisso, urgência real, tamanho e cor (só depois do texto), quantidade de botões.

## Tamanho do texto

Escreva tudo o que é preciso para passar a mensagem inteira, responder as objeções principais e dar prova suficiente, e nem uma palavra a mais. Texto longo funciona quando o público não conhece a categoria, a decisão é cara ou ele está comparando; curto quando a marca é conhecida, o produto é simples ou o visitante já chega convencido.

## Funis de negócio pequeno (o que o app mede)

- **WhatsApp:** Anúncio/Instagram/Google → Landing → Clique no WhatsApp (`conversion_event`) → Conversa → Orçamento → Fechou (`lead.status`, quando o dono registra).
- **Formulário:** Landing → Formulário enviado (`lead`) → Contatado → Proposta → Fechou.
- **Agendamento:** Landing → Escolheu serviço → Escolheu horário → Confirmou (`booking`) → Compareceu.
- **Compra:** Landing → Produto → Carrinho → Checkout (`checkout_start`) → Pago (`order`) → Recompra.
- **Conteúdo:** Visita → Leitura → Inscrição → Volta.

Funil completo de referência: Descoberta → Interesse → Consideração → Intenção → Avaliação → Compra → Retenção → Indicação.

**Artéria entupida** = passo com muito volume e pouca passagem. Conta: oportunidade = volume do passo × (taxa esperada − taxa atual) × valor de cada venda. Exemplo: 600 carrinhos × (65% − 50%) = 90 compras a mais possíveis. Ataque o maior valor primeiro; em geral 80% do vazamento está em 20% dos passos.

| Onde entope | Causas típicas |
|---|---|
| Início → categoria | Proposta confusa, menu ruim |
| Categoria → produto | Apresentação fraca, escolha demais |
| Produto → carrinho | Falta informação, susto de preço |
| Carrinho → checkout | Custo surpresa, exigir cadastro, desconfiança |
| Checkout → pago | Formulário longo, forma de pagamento, frete |
| Clique no WhatsApp → orçamento | Demora para responder, mensagem sem contexto |

**Elos que faltam** (e o conserto real na Fabapp): contato antes da compra (formulário curto antes do WhatsApp em serviço caro); lembrete de agendamento (automação `relative` com `offset_days: -1`, canal `email` ou `push`); aviso ao dono de lead novo (automação `data created`); pedido de avaliação depois do atendimento (e-mail com link para `/depoimento`); oferta complementar no carrinho; programa de indicação. Mapa de venda casada: produto A → complemento natural → quando oferecer (carrinho, depois da compra).

Referências internacionais (só para dimensionar, não são metas do dono): abandono de carrinho ~70%, abandono de checkout ~25%, recompra 25% a 40%; contato para lead qualificado 20% a 30%; teste grátis para pago 15% a 25%.

**Origem:** guarde `utm_source` e `utm_campaign` da URL no lead (atribuição pelo último toque, a mais simples). Se o dono quiser saber a primeira origem, guarde também a primeira vista no navegador (`first_source`), dentro de `try/catch`.

## Pesquisa que o dono consegue fazer

- **Pergunta única depois da compra** ("O que quase fez você desistir?", "O que te convenceu?", "Como você nos descreveria para um amigo?"): página `/pesquisa` com uma pergunta aberta, gravando em `survey_answer` (`access` de visitante: read `role:admin`, create `public`, update e delete `role:admin`), linkada no e-mail de confirmação. Uma pergunta só (duas no máximo), aberta, sem incomodar.
- **Teste de 5 segundos:** mostre a primeira dobra a 5 pessoas por 5 segundos e pergunte: do que é a página? O que você faria? De quem é?
- **Teste com 5 clientes:** peça para achar um serviço, pedir o orçamento, entender a oferta; note onde hesitam, o que dizem, onde clicam esperando outra coisa.
- **Mapa de calor e gravações:** o dono liga o Microsoft Clarity no Studio (a plataforma injeta o código; nunca o escreva no app; outras ferramentas de gravação não estão integradas). O que olhar: cliques de raiva (vários seguidos), cliques mortos (em algo que não é link), volta imediata, campo onde abandonam o formulário, até onde rolam.

| Achado | Ação |
|---|---|
| Botão sem clique | Mudar posição e texto |
| Conteúdo importante abaixo de onde param de rolar | Subir o conteúdo |
| Clicam em algo que não é link | Virar link ou tirar |
| Param de rolar cedo | Melhorar a primeira dobra |

Ordem: números do app primeiro (grátis), a pergunta única, as mensagens do WhatsApp, 10 a 20 gravações, 5 testes com clientes. Sinais de alerta: saída acima de 70% numa página chave, celular convertendo muito menos que computador, muito tráfego e pouca conversão.

## Hipótese e prioridade (ICE)

Formato: "Se mudarmos [X], então [métrica Y] melhora porque [motivo vindo da pesquisa]". Antes de testar, defina a métrica principal (decide a vencedora), as secundárias (acompanhamento) e a de proteção (não pode cair, ex.: leads fechados).

Nota de 1 a 10 em cada eixo; prioridade = média (ou ponderada: (Impacto×2 + Confiança×1,5 + Facilidade) / 4,5).
- **Impacto:** 10 = pode dobrar a conversão; 7 a 9 = +30% a +50%; 4 a 6 = +10% a +30%; 1 a 3 = menos de 10%.
- **Confiança:** 10 = comprovado antes; 7 a 9 = pesquisa forte; 4 a 6 = hipótese razoável; 1 a 3 = palpite.
- **Facilidade:** 10 = só texto; 7 a 9 = mudança de layout; 4 a 6 = funcionalidade nova; 1 a 3 = obra grande.

| Ideia | I | C | F | Nota |
|---|---|---|---|---|
| Título com a fala dos clientes | 8 | 9 | 10 | 9,0 |
| Vídeo de depoimento | 7 | 7 | 6 | 6,7 |
| Refazer o agendamento | 9 | 6 | 3 | 6,0 |
| Cor do botão | 2 | 2 | 10 | 4,7 |

Filtro do 10x: "isso poderia multiplicar o resultado?" Vale testar oferta nova, proposta nova, página refeita. Não vale: cor de botão, tamanho de fonte, trocar foto.

## Teste A/B na Fabapp (receita)

- **Duas versões, não mais.** Multivariado só com 100 mil visitas por mês numa página já vencedora; não é o caso de negócio pequeno.
- **Sorteio:** `src/lib/variant.ts` com `getVariant()`: se a URL tem `?v=a` ou `?v=b`, usa e guarda; senão lê a versão guardada no navegador; senão sorteia 50/50 e guarda. Leitura e escrita do navegador dentro de `try/catch` (sem acesso, sorteia de novo sem quebrar). Com o teste desligado, sempre `a`.
- **Configuração do teste no registro `business_profile`** (editável no admin): `ab_active` (boolean), `ab_hypothesis` (text), `ab_start` (date), `ab_end` (date). A data de fim é fixada antes de começar: no mínimo 14 dias corridos (duas semanas inteiras, com dias úteis e fins de semana), respeitando sazonalidade.
- **Uma variação por prop** no mesmo componente (`<Hero variant={v} />`); o resto da página idêntico.
- **Registro:** todo `conversion_event` e todo `lead` levam `variant`; `trackEvent` também.
- **Leitura honesta**, na página "Resultados da página": com o sorteio 50/50, compare as conversões de cada versão (A e B). Mostre as contagens desde o início, mas só declare vencedora **depois de `ab_end`**, e só se `A + B ≥ 30` e `|B − A| / √(A + B) ≥ 1,96` (95% de confiança). Fora disso: "Sem diferença clara". Mostre também a diferença em %: uma vitória de 2% não compensa mudar nada (significância prática).
- **Por que mudar muito:** com 5% de conversão, detectar uma melhora de 20% pede cerca de 25 mil visitas por versão; uma melhora de 50% pede cerca de 4 mil. Mudança ousada aparece com muito menos tráfego.

Erros que invalidam: espiar e parar cedo quando "parece que ganhou" (infla o falso positivo); chamar resultado com pouco dado (500 visitas, 15 contra 20 conversões não decide nada); testar 20 variações (uma "ganha" por acaso); rodar de novo até dar o resultado desejado; esconder resultado inconclusivo. Decida tamanho e duração antes e reporte o que der.

**Documente** (em `DECISOES.md`, seção Decisões): antes, a hipótese, a métrica principal, a duração; depois, os números, a conclusão, o aprendizado, o próximo passo. Tabela de aprendizados: Teste | Hipótese | Resultado | Aprendizado | Onde aplicar (ex.: "Título com a fala do cliente | +27% | clientes querem resultado, não recurso | todas as páginas"). A vencedora vira a nova versão única. Teste sem vencedor ensina: volte à pesquisa e tente algo mais ousado; o problema da página continua lá. Um teste que ensina vale mais que uma vitória que ninguém entende.

**Espalhe o que ganhou:** o título vencedor vai para o anúncio, a mensagem pronta do WhatsApp e os e-mails do app.
