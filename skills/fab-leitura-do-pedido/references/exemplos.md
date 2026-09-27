# Exemplos da leitura do pedido

## Exemplo 1: pedido arquitetural, do começo à entrega

**Pedido do dono:** "quero um app pra minha clínica odontológica, pros pacientes marcarem consulta"

**Tamanho e leitura provisória (primeira resposta):**
"Isso é um app novo, com várias telas. Vou entender tudo antes e te mostrar o plano para você aprovar. Por enquanto
entendi assim: app de agendamento para uma clínica odontológica, em que o paciente marca consulta pelo celular e a
recepção organiza a agenda, com tom calmo e confiável."

**Nota inicial (em silêncio): 38**
- Funcional 14 de 30: sabe-se o que entra (consulta) e a ação principal (marcar); não se sabe o passo a passo nem o
  que o paciente vê depois de marcar.
- Operação 8 de 25: pacientes usam; não se sabe se a recepção usa o app, se há WhatsApp, se há vários dentistas.
- Completude 4 de 25: nada sobre cancelar, faltar, remarcar.
- Contexto 12 de 20: problema implícito (agenda por telefone), público claro, sem medida de sucesso.

**Rodada 1 (ferramenta de perguntas de opção, 4 perguntas):**
1. "Quem mexe na agenda do lado da clínica?" (single)
   - A recepção, pelo próprio app (Recomendado)
   - Só eu, direto no app
   - Cada dentista cuida da sua
2. "A clínica tem mais de um dentista atendendo?" (single)
   - Sim, e o paciente escolhe com quem (Recomendado)
   - Sim, mas a recepção distribui
   - Não, sou só eu
3. "Quando o paciente precisa desmarcar, o que acontece?" (single)
   - Ele desmarca sozinho até 24h antes (Recomendado)
   - Ele pede pelo WhatsApp e a recepção desmarca
   - Não pode desmarcar pelo app
4. "Como você vai saber que o app está ajudando?" (single)
   - Menos ligação e mensagem para marcar (Recomendado)
   - Menos faltas
   - Mais consultas por semana

**Respostas:** 1 recomendada, 2 recomendada, 3 "pede pelo WhatsApp", 4 "menos faltas".

**Nota refeita: 76.** Faltam: lembrete de consulta, o que o visitante sem conta vê, preços. Rodada 2 com 2
perguntas:
5. "Quer que o paciente receba um lembrete antes da consulta?" (single)
   - Sim, por e-mail e notificação no celular, 1 dia antes (Recomendado)
   - Não precisa
6. "O que alguém sem conta pode ver?" (single)
   - A página da clínica, os tratamentos e os dentistas; marcar pede conta (Recomendado)
   - Só a tela de entrar

**Nota final: 88.** O resto vira suposição.

**Mensagem antes do plano:**

> **Entendi assim:** app de agendamento para uma clínica odontológica com vários dentistas, em que o paciente escolhe
> o dentista e marca pelo celular e a recepção organiza a agenda, com tom calmo e confiável, puxando para app de
> saúde, limpo e claro.
>
> **Você disse:**
> - Os pacientes marcam consulta pelo app e escolhem o dentista.
> - A recepção mexe na agenda pelo app.
> - Para desmarcar, o paciente pede pelo WhatsApp.
> - O que importa é ter menos faltas.
> - Lembrete 1 dia antes, por e-mail e notificação.
>
> **Eu assumi (corrija se não for):**
> - Assumi consultas de 30 minutos. Se não for, cada tratamento tem sua duração.
> - Assumi que o preço não aparece no app. Se for aparecer, você cadastra por tratamento.
> - Assumi que o paciente vê só as próprias consultas. Se não for, me diga quem mais vê.

**Verdade do produto:**
- Informados: clínica odontológica, vários dentistas, recepção, WhatsApp para desmarcar.
- Inferidos: público adulto da região (vira suposição, não texto do app).
- Não informado, não inventar: nome e CRO de cada dentista, CNPJ, endereço, horário de funcionamento, preços,
  depoimentos, "antes e depois", nota no Google.

**Modos:**
- Início público: persuadir, 3/2/5 (confiança em saúde).
- Tratamentos e dentistas: persuadir, 3/2/5.
- Marcar consulta (paciente): operar, 4/3/4.
- Minhas consultas (paciente): operar, 4/3/4.
- Agenda da recepção: operar, 3/2/7.
- Orientações antes e depois da consulta: ler, 4/2/3.

**Trecho do plano:**
- A **Visão geral** termina com: "Fatos informados: clínica odontológica com vários dentistas; recepção usa o app; desmarcar
  pelo WhatsApp. Não informado, não inventar: CRO dos dentistas, CNPJ, endereço, horário, preços, depoimentos, antes e
  depois. Dentistas e horários vêm do cadastro; CNPJ e endereço aparecem como '[preencher: X]' até o dono completar."
- **Suposições**: as três de cima, mais "Assumi que o paciente cria conta com e-mail e senha. Se não for, pode entrar
  com código no e-mail."
- **Próximos passos**: "Adicionar lista de espera para horários que vagarem, sem mudar a agenda atual."
- **Avisos**: "O CNPJ, o endereço e o CRO de cada dentista aparecem como '[preencher]' até você completar."

**Itens da lista de conferência que o plano recebe desta leitura (além do fluxo):**
- (no código) Nenhum texto afirma CRO, CNPJ, preço, depoimento ou nota que o dono não informou.
- (no código) O CRO aparece no card do dentista só quando o campo do cadastro está preenchido.
- (na tela) A agenda da recepção abre direto no dia de hoje, sem herói.
- (na tela) No início público, o botão "Marcar consulta" aparece na primeira tela do celular.
- (no código) Desmarcar leva ao WhatsApp da clínica com a mensagem pronta (link wa.me com o texto).

## Exemplo 2: sondagem

**Pedido do dono:** "dá pra mandar lembrete automático no WhatsApp um dia antes?"

**Classificação:** sondagem. Resposta, não app:

"Essa é uma dúvida de viabilidade, então te respondo sem construir nada. Lembrete automático 1 dia antes, sem ninguém
clicar, dá por e-mail, por notificação no celular e por SMS. Pelo WhatsApp,
sozinho, sem ninguém clicar, hoje não dá. O que dá no WhatsApp: na agenda do dia, um botão 'Lembrar' ao lado de cada
horário abre o WhatsApp com a mensagem pronta; com o WhatsApp conectado no Studio, o mesmo botão envia direto. Minha
recomendação: lembrete automático por e-mail e notificação, mais o botão do WhatsApp na agenda."

Se o dono responder "então faz", isso é um pedido novo: limitado se o app e a agenda já existem, arquitetural se não.

## Exemplo 3: pedido limitado

**Pedido do dono (app já existe):** "coloca um campo de observação no agendamento"

**Classificação:** limitado, porque o fluxo de agendamento existe no app.

**Desenho curto:** "É um ajuste pequeno no que já existe. Vou pôr um campo 'Observação' (texto, opcional) no
formulário de agendamento; a recepção vê a observação no detalhe do horário e na agenda aparece um ícone quando há
observação. Nada mais muda." Uma pergunta só se muda o app: "O paciente também vê a observação?" (Não, só a clínica
(Recomendado) / Sim).

Se a resposta revelar algo maior ("e a observação tem que ir pro prontuário"), a catraca sobe: "Isso é maior do que
parecia, porque cria o prontuário. Vou tratar como parte nova do app."
