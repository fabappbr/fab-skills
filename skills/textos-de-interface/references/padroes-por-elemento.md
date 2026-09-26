# Padrões por elemento, em três vozes de pequeno negócio

Vozes usadas nos exemplos: **Clínica** (cuidadosa, direta, confiável), **Restaurante de bairro** (acolhedor, rápido, do bairro), **Loja jovem** (animada, prática, direta). As três seguem as mesmas regras; muda só o tom.

## Títulos
- De marca: o nome do negócio.
- De conteúdo (o que está na tela): Clínica "Seus agendamentos", "Exames"; Restaurante "Cardápio de hoje", "Seus pedidos"; Loja "Sua sacola", "Favoritos".
- De categoria (várias ações): "Minha conta", "Ajuda", "Configurações da loja".
- De tarefa (uma ação): "Remarcar consulta", "Montar pedido", "Trocar um produto".

## Botões
- Principais: Clínica "Agendar consulta", "Enviar exame"; Restaurante "Fazer pedido", "Repetir pedido"; Loja "Adicionar à sacola", "Finalizar compra".
- Secundários: "Ver horários", "Voltar", "Agora não", "Pular".
- Destrutivos: "Cancelar consulta", "Excluir endereço", "Remover da sacola".
- Par honesto: "Manter consulta" / "Cancelar consulta" (nunca "Não" / "Sim").

## Links
- Navegação: "Ver todos os pedidos", "Ver histórico de consultas".
- Contexto: "Como funciona o reembolso", "Falar com a clínica pelo WhatsApp".

## Erros
- No campo: "O e-mail precisa ter @", "O número do cartão está incompleto", "Escolha uma data a partir de hoje", "Esse nome de usuário já existe", "A foto precisa ter até 10 MB".
- Desvio (dá para resolver): título "Não foi possível pagar"; corpo "O cartão foi recusado. Confira os dados ou use o Pix."; botão "Tentar outro cartão".
- Bloqueio: título "Sua assinatura venceu"; corpo "As aulas estão pausadas desde 15/03. Renove para voltar a assistir."; botão "Renovar assinatura".
- Sistema fora do ar: "O app está em manutenção e volta em cerca de 15 minutos. Seus dados estão guardados." (tempo só se for sabido).

## Sucesso
- Simples: "Consulta agendada.", "Pedido enviado.", "Endereço salvo.", "Pagamento aprovado."
- Com detalhe: título "Mesa reservada"; corpo "Mesa para 4 no sábado, 20/05, às 19h30. Você recebe um lembrete na véspera." (lembrete só se existir a automação)

## Estados vazios

| Tipo | Para quê | Forma | Exemplo |
|---|---|---|---|
| Primeiro uso | Ensinar e puxar a primeira ação | "Nenhum {item} ainda. {Benefício}." + botão | "Nenhum cliente ainda. Cadastre o primeiro para marcar horários." [Cadastrar cliente] |
| Limpo pela pessoa | Reconhecer que acabou | "{Tudo feito}. {Quando aparece mais}." | "Nenhum pedido pendente. Os novos aparecem aqui assim que chegarem." |
| Busca ou filtro sem resultado | Oferecer ajuste | "Nenhum {item} com {critério}. {Sugestão}." + ação | "Nenhum cliente com 'Souza'. Confira a grafia ou veja todos." [Limpar busca] |
| Sem acesso | Dizer por que e como conseguir | "{Item} não está disponível. {Por quê}. {Como ter}." | "Relatórios aparecem para administradores. Peça acesso ao dono da conta." |

Checklist: contexto claro (o que está vazio e por quê); uma ação só; tom do momento; benefício curto; sem "você não tem nada"; sem linguagem de sistema ("nenhum registro encontrado no banco"). Ilustração: primeiro uso, algo convidativo; limpo, algo de conclusão; sem resultado, algo neutro de busca (imagem decorativa pelo `AppImage` ou ícone do `lucide-react`).

Molde rápido: tipo; o que está vazio; por que; o que fazer; benefício. Rascunho: título "Nenhum orçamento salvo"; corpo "Salve orçamentos para enviar ao cliente em um toque."; botão "Criar orçamento".

## Mensagem de erro, molde

- No campo: exigência do campo.
- Desvio: título com a ação que falhou; corpo com causa e recuperação; botão com a recuperação.
- Bloqueio: o que está indisponível; por quê; quando volta (se souber); tranquilizar sobre os dados; botão.
- Gravidade: dinheiro, segurança e dado perdido pedem tom sério e claro ("O pagamento não passou. Nada foi cobrado."); coisa pequena pede leveza sem drama ("Não carregou a prévia. Toque para tentar de novo.").

Checklist: sem culpa ("inválido", "ilegal", "errado", "erro" como palavra solta); acolhe sem drama; problema específico; recuperação exata; o mais importante primeiro; voz ativa ("Não conseguimos salvar", não "As alterações não puderam ser salvas"); sem código técnico como mensagem.

Molde rápido: o que falhou; por que (se souber); o que fazer. Exemplo: "Não deu para enviar o convite. Confira o e-mail e tente de novo."

## Notificações
- Pedem ação: título "Sua consulta é amanhã"; corpo "Dra. Ana, 14h. Confirme ou remarque até as 18h de hoje." (prazo só se for regra do dono)
- Informativas: "Seu pedido saiu para entrega", "Nova avaliação no seu perfil".
- Pela automação `notify`: `title` com a mudança, `body` com `{{campo}}`, `link` para a tela do registro.

## Formulários
- Rótulos: "Nome completo", "Telefone", "Data de nascimento", "Observações (opcional)".
- Ajuda: "Usamos para lembrar do seu horário", "Aparece no recibo", "Só a clínica vê".
- Placeholder: "(11) 91234-5678", "nome@exemplo.com", "Ex.: alergia a dipirona".
- Interruptor: nome "Lembretes por WhatsApp"; descrição "Um dia antes de cada consulta".
- Caixa de seleção: "Lembrar este cartão", "Receber ofertas por e-mail" (nunca pré-marcada).

## Instruções
- Fixa: "Leve um documento com foto no dia da consulta."
- Sob demanda (ícone de ajuda): "O que é sinal? É o valor pago na reserva e descontado da conta final."

## Onboarding

Princípios: mostrar valor cedo; um recurso por vez; opcional sempre pulável; comemorar o primeiro ganho; curto (o dono quer usar, não ler).

Fluxo: Boas-vindas, configuração mínima, primeiro resultado, próximo passo. Cada tela responde: onde estou (progresso "Passo 2 de 4"), o que faço, por que importa, posso pular.

| Tela | Molde | Exemplo |
|---|---|---|
| Boas-vindas | Nome + valor + 2 ou 3 benefícios + ação | "Sua agenda da barbearia num só lugar." Benefícios: marcar pelo celular; lembrete automático; ver o dia de relance. [Começar] |
| Configuração | Só o essencial + por que pede | "Qual o horário de funcionamento? Usamos para mostrar só horários livres." [Continuar] [Fazer depois] |
| Primeiro recurso | Ação real, até 20 palavras | "Cadastre seu primeiro serviço. Ele aparece para o cliente escolher." [Cadastrar serviço] [Pular] |
| Primeiro ganho | Reconhece + próximo passo | "Primeiro serviço cadastrado. Quer compartilhar o link da agenda?" [Copiar link] [Ir para o painel] |

Checklist por passo: foco único; valor claro; ação clara; pulável; progresso visível; corpo até 30 palavras; tom encorajador sem tratar a pessoa como criança. Onboarding inteiro em menos de 2 minutos e com um resultado real na primeira sessão.

Erros a evitar: 10 telas antes de usar; lista de 20 recursos; sem "Pular"; voz passiva ("Sua conta foi criada" vira "Conta criada. Agora cadastre seu primeiro serviço."); corporativês.

## Pedido de permissão
"Ative a localização para ver as unidades mais perto de você." [Permitir] [Agora não] ("Agora não" é menos definitivo que "Não permitir"). No app dentro da casca de celular, peça a permissão no momento em que o recurso é usado (`takePhoto`, `getLocation`, `registerPush`), nunca na abertura.

## Diferença de voz, resumo
- Clínica: direta, informativa, antecipa dúvidas, transparente sobre problema.
- Restaurante: calorosa, rápida, fala do bairro; comemoração em texto, sem exclamação.
- Loja jovem: energética, celebra ações, ainda assim sem exclamação em toast e sem emoji decorativo, salvo se o próprio dono já usa emoji na marca.
