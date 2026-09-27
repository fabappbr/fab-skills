# Conversão no Brasil: pesquisa, texto, chamada para ação e o que a lei pede

Bonito é o ingresso; converter é o que o dono paga. Leia antes da pesquisa (Fase 3) e antes de ligar os dados (Fase 8).

## A pesquisa com a voz do cliente

Antes de desenhar, encontre a linguagem exata que os compradores do nicho usam para as dores, os desejos e as hesitações.

**Onde procurar, priorizando fontes brasileiras quando o público é brasileiro:**
- Avaliações do Google Maps dos concorrentes da região (as de 2 a 4 estrelas dizem mais que as de 5).
- Reclame Aqui, para o que dá errado no setor.
- iFood, Booking, Airbnb, Doctoralia, GetNinjas, Mercado Livre, conforme o nicho.
- Grupos e fóruns do nicho, comentários de Instagram e YouTube de perfis do setor.
- Para SaaS: G2, Capterra, Product Hunt, e as páginas de concorrentes.

Um punhado de fontes basta. Colete as frases recorrentes EXATAS em três listas: dores, resultados desejados, objeções. Sem busca na web disponível, peça ao usuário para colar algumas avaliações ou nomear as objeções que mais ouve.

**Use o que encontrou de três formas:**
- O texto do site fala nas palavras dos compradores.
- A página inteira afunila para UMA chamada para ação; cada seção conquista o próximo scroll.
- A mobília de confiança responde às objeções reais: prova, passos claros, FAQ, garantia, e o contato final.

**Regra de posicionamento aprendida em construção real:** quando o assunto do site é uma pessoa (o dono, o chef, o artista, o profissional), o hero apresenta essa pessoa na voz confiante dela, e a linguagem de dor trabalha nas seções abaixo. Um gancho de dor como primeiras palavras sobre o rosto de alguém soa como reclamação alheia.

## O texto

- **Curto, concreto, humano.** Dimensionado para um relance. Uma ideia por frase.
- **Na voz da marca.** Uma casa de luxo e uma marca de streetwear são ambas simples, mas não soam nada iguais. O pacote de design define o registro.
- **Específico vence genérico:** "Orçamento em 48 horas" vence "atendimento ágil"; "312 casamentos desde 2014" vence "ampla experiência".
- **O título do hero diz o que é e para quem**, em linguagem de cliente, não de departamento de marketing. O subtítulo diz como ou onde. A chamada para ação diz o que acontece ao clicar ("Pedir orçamento no WhatsApp", não "Saiba mais").
- **Prova perto da promessa:** número, depoimento, logotipo de cliente, selo, foto real.
- **Sem travessões e sem as palavras de estoque** (a lista está no gate de texto do SKILL.md).

## A arquitetura que converte (ponto de partida)

1. **Hero:** o que é, para quem, a chamada para ação principal, e um sinal de prova.
2. **O problema ou o desejo**, nas palavras do cliente.
3. **A oferta:** serviços, produto ou método, com o que o cliente recebe.
4. **Como funciona:** três ou quatro passos claros.
5. **Prova:** depoimentos reais, números, cases, antes e depois.
6. **O momento interativo** (onde a ideia da marca é vivida).
7. **FAQ** que responde às objeções da pesquisa.
8. **A chamada final:** formulário, WhatsApp ou agendamento.
9. **Rodapé:** contato, endereço, horários, redes, CNPJ quando houver, política de privacidade, declaração de marca fictícia quando for o caso.

Reordene e funda seções pelo conceito; duas vizinhas nunca com o mesmo esqueleto.

## A chamada para ação

Escolha UMA como principal e diga ao usuário, com clareza, onde a mensagem do visitante termina:

| Destino | Quando | Como |
|---|---|---|
| **WhatsApp** | Serviços locais, varejo, a maioria dos negócios brasileiros | Link `https://wa.me/55DDDNUMERO?text=` com a mensagem pronta codificada por `encodeURIComponent`, `trackEvent("Contact")` no clique |
| **Formulário de lead** | Serviços com qualificação (orçamento, consultoria, B2B) | Model `lead` + automação de e-mail (em `plataforma-fabapp.md`); o lead fica no CMS do Studio |
| **Agendamento** | Clínicas, salões, consultores | `<SlotPicker/>` e `<AvailabilityManager/>` do SDK, com um model de agendamento |
| **Compra** | Produto com checkout | Hooks de pagamento do SDK com o gateway que o dono conectar, ou link para a loja existente |
| **Ligação** | Emergências (encanador, guincho, chaveiro) | `tel:+55...` grande e fixo no celular |

Regras:
- O botão principal aparece no hero, se repete no fim e, no celular, pode ficar fixo no rodapé da tela (com espaço reservado para não cobrir conteúdo).
- A mensagem pronta do WhatsApp identifica a origem ("Oi, vim pelo site e quero um orçamento de...").
- Formulário curto: nome, contato e uma pergunta aberta. Cada campo a mais custa conversão.
- Estado de sucesso honesto: diga o que acontece agora e em quanto tempo.

## LGPD e privacidade

- **Formulário que coleta dado pessoal** mostra, junto do botão, uma linha dizendo para que o dado será usado e um link para a política de privacidade.
- **Página de política de privacidade** (rota `/privacidade`) em linguagem simples: quem é o controlador (nome e contato do negócio), que dados coleta, para quê, por quanto tempo, com quem compartilha (a plataforma que hospeda, as integrações de analytics), e como o titular pede acesso ou exclusão. Marque a rota com `index: false` só se o dono preferir; ela pode ser indexada.
- **Analytics, pixel ou chat** exigem o card de consentimento de cookies conectado pelo dono no Studio, que só libera a medição depois do aceite.
- **Nunca** colete CPF, dado de saúde ou dado sensível num formulário de site sem necessidade clara e dita ao usuário.
- Você não é advogado: a política é um ponto de partida honesto, e diga ao usuário que revisar com um profissional é recomendado.

## Nichos regulados: confira antes de escrever

Alguns setores têm regras de publicidade dos seus conselhos. Quando o nicho for um destes, avise o usuário em uma linha, escreva o texto dentro das regras conhecidas, e recomende que ele confira as normas atuais do conselho:

| Nicho | Órgão | Cuidados comuns |
|---|---|---|
| Advocacia | OAB (Provimento 205/2021 e Código de Ética) | Publicidade informativa e sóbria; sem promessa de resultado, sem captação de clientela, sem menção a valores de honorários como chamariz, sem depoimentos de clientes sobre causas |
| Medicina | CFM (Resolução de publicidade médica vigente) | Sem garantia de resultado; regras específicas para antes e depois e depoimentos; exibir nome, CRM e RQE do responsável técnico |
| Odontologia | CFO | Nome e CRO do responsável; restrições a preço como chamariz e a antes e depois |
| Psicologia | CFP | Sem promessa de cura; CRP visível |
| Nutrição, fisioterapia, estética | CFN, COFFITO, conselhos regionais | Sem promessa de resultado; registro profissional visível |
| Imóveis | CRECI | Número do CRECI da imobiliária ou corretor |
| Finanças e investimentos | CVM, Bacen | Sem promessa de rentabilidade; avisos de risco |
| Alimentos e bebidas alcoólicas | Anvisa, Conar | Avisos obrigatórios em bebida alcoólica; sem alegações de saúde |

Estas são diretrizes gerais, não parecer jurídico. As normas mudam.

## SEO local e descoberta

- **Título e descrição** com o serviço e o lugar ("Marcenaria sob medida em Curitiba").
- **Nome, endereço e telefone** idênticos no site, no Perfil da Empresa no Google e nas redes.
- **Dados estruturados:** o `seo.structured` da plataforma escreve JSON-LD do site e da organização. Para um negócio local, confira na documentação ao vivo se o tipo `LocalBusiness` com endereço, horário e área atendida é gerado; se não for, diga ao usuário e registre o endereço completo no rodapé em HTML semântico (`<address>`).
- **Perfil da Empresa no Google:** recomende ao dono criar ou atualizar, com o link do site novo. É a maior alavanca de busca local e fica fora do site.
- **Uma página por serviço principal** no Nível 2, cada uma com título, descrição e `h1` próprios.
- **`llms.txt`** (o toggle `seo.ai`) ajuda assistentes de IA a descreverem o negócio corretamente.
