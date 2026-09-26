# Formulários em etapas

## Três formas, uma certa

- **Tudo numa página**: 30 campos de uma vez. A pessoa rola, vê o tamanho e vai embora antes de começar.
- **Teatro de progresso**: dividido em etapas arbitrárias ("Etapa 1: nome. Etapa 2: e-mail. Etapa 3: telefone"). Parece sofisticado, cansa igual e soa como truque.
- **Etapas de verdade**: cada etapa é um bloco de trabalho que a pessoa conclui com confiança, da menor para a maior exigência. É a única que vale o trabalho.

Teste: pergunte "o que você acabou de fazer?" no fim de uma etapa. "Contei sobre minha empresa" = etapa de verdade. "Digitei o nome da empresa num campo" = teatro.

## Quando vale dividir (as cinco condições)

1. Mais de 8 a 10 campos.
2. Os campos se agrupam em 3 a 5 blocos com assunto próprio.
3. O compromisso cresce: quem passou da etapa 2 aceita perguntas que assustariam no começo.
4. Respostas iniciais mudam o resto (pessoa física ou jurídica, com ou sem veículo).
5. Há um objetivo medível (mais cadastros completos, orçamentos mais qualificados).
Com as cinco, etapas. Com duas ou menos, página única. Não divida: 4 a 6 campos, campos sem grupo natural, público com pressa (contato, retorno rápido), formulário logo após uma conversa quente. Formulário que caiu para menos de 6 campos com o tempo volta a ser página única.

## Padrões de etapa

| Etapa | Conteúdo | Exigência | Posição |
|---|---|---|---|
| Identificação | nome, e-mail, WhatsApp | baixa | abre |
| Contexto | tipo de pessoa, empresa, situação atual | média | depois |
| Necessidade | o que quer, prazo, urgência | média a alta | meio |
| Detalhes | valores, documentos, medidas, requisitos | alta | fim |
| Revisão | resumo com "Editar" e o botão de enviar | baixa | última |

Exemplos:
- **Cadastro de cliente (gestão)**: Quem é (tipo, nome, CPF ou CNPJ, razão social e IE se PJ) · Contato (WhatsApp, e-mail, como prefere ser chamado) · Endereço (CEP, rua, número, complemento, bairro, cidade, UF) · Revisão.
- **Pedido de orçamento (visitante)**: Seu contato · O serviço (tipo, descrição, fotos) · Local e prazo · Revisão.
- **Matrícula**: Aluno · Responsável (só se menor de idade) · Turma e horário · Pagamento · Revisão.
- **Anamnese/ficha**: Dados pessoais · Histórico · Hábitos · Objetivos · Consentimento e revisão.
- **Assistente de configuração**: Boas-vindas · Dados da empresa · Serviços ou produtos · Horários · Equipe (adiável) · Pronto.

Nomes de etapa que funcionam: "Sobre você", "Sobre sua empresa", "O que você precisa", "Os detalhes", "Revise e envie". Não funcionam: "Etapa 1", "Informações", "Outros dados".

Evite: pergunta difícil ou sensível na primeira etapa; etapa tardia que refaz uma decisão já tomada; etapas sem nome; formulário que termina sem revisão.

## Indicador de progresso

| Tipo | Quando |
|---|---|
| "Etapa 2 de 4: Endereço" | sempre, acima do `Stepper` (é o que aparece no celular) |
| `Stepper` com nomes | 3 a 7 etapas com nomes claros |
| Barra `Progress` por campos preenchidos | etapas de tamanhos muito diferentes |
| Nenhum | só 2 etapas curtas |

Falhas: total que muda no meio ("4 de 5" vira "4 de 7"); "Quase lá" com metade pela frente; barra que corre no começo e se arrasta no fim; progresso sem dizer em que etapa se está; frase de estímulo repetida que soa condescendente; estimativa de tempo errada. Com etapas condicionais: calcule o total pelo caminho já definido pelas respostas, ou diga "4 a 5 etapas" desde o início. Indicador sempre visível sem rolar, no topo.

## Lógica condicional

| Padrão | Exemplo | Uso |
|---|---|---|
| Mostrar ou esconder campo | PJ mostra CNPJ, razão social, IE; PF mostra CPF e data de nascimento | o mais comum |
| Pular etapa inteira | sem veículo, pula "Dados do veículo"; maior de idade, pula "Responsável" | categorias inteiras irrelevantes |
| Adaptar palavras | "paciente" em clínica, "aluno" em escola | quando o mesmo formulário serve ramos diferentes |
| Adaptar o destino | "Urgente" avisa o admin na hora; "Orçamento" vai para a fila | roteamento depois de enviar |
| Caminhos diferentes | pessoa ou empresa com formulários distintos | raro; só quando as necessidades são muito diferentes |

Regras: cada condição precisa tirar atrito real; campo escondido não valida nem é enviado; aparecer e sumir sem pular a tela (espaço reservado ou transição curta); teste o caminho mais comum e cada ramo (um que dispara, um que não); mais de 5 condições num formulário pede revisão. Em formulário novo, comece simples.

## Rascunho e retomada

| Forma | Como | Quando |
|---|---|---|
| Conta (logado) | registro com `status: "draft"` e `last_step`, atualizado a cada "Continuar" | padrão para quem está logado; funciona em qualquer aparelho |
| Aparelho (visitante) | `localStorage` com chave do formulário, validade de 7 dias, dentro de `try/catch` | formulário público longo |
| Link por e-mail | não usado: exigiria gravar dados de visitante sem login; quem precisa retomar em outro aparelho faz login |

Vale oferecer quando o formulário leva mais de 5 minutos, pede documento que a pessoa pode não ter à mão ou é feito em mais de uma sessão. Não vale para contato de 1 minuto.

Transparência: dizer o que fica salvo, onde, por quanto tempo e como apagar ("Suas respostas ficam só neste aparelho por 7 dias. Apagar agora"). Documento, cartão e dado de saúde não vão para o `localStorage`. Antes de etapa que pede documento: "Vai precisar do comprovante de endereço. Pode salvar e voltar depois."

Retomada: volta na etapa em que parou, com os valores, e oferece "Começar de novo". Retomada que volta ao início ou com respostas trocadas é pior que não ter rascunho.

## Validação

| Momento | O que valida |
|---|---|
| Ao sair do campo | formato (e-mail, CPF, telefone) |
| Enquanto digita | só depois de um erro no campo, e contadores de caracteres |
| Ao "Continuar" | todos os campos da etapa |
| Ao enviar | tudo, incluindo regras entre campos ("data final depois da inicial", "soma das parcelas = total") |

Mensagens: específicas e com saída ("Informe o DDD, ex.: (11) 91234-5678", "Use um valor entre 1 e 1.000", "O CPF tem 11 números"), nunca "Inválido" ou "Erro"; ao lado do campo, com ícone além da cor; resumo no topo ao enviar com links para os campos; anunciadas para leitor de tela.

Não seja rígido demais: aceite e-mail com "+", nomes com acento, apóstrofo e hífen, telefone com ou sem formatação, CEP com ou sem hífen. Valide o que o negócio realmente precisa.

## Brasil: máscaras e dígitos verificadores (`src/lib/br.ts`)

```ts
export const onlyDigits = (v: string) => v.replace(/\D/g, "");
export const maskCPF = (v: string) => onlyDigits(v).slice(0, 11)
  .replace(/(\d{3})(\d)/, "$1.$2").replace(/(\d{3})(\d)/, "$1.$2").replace(/(\d{3})(\d{1,2})$/, "$1-$2");
export const maskCNPJ = (v: string) => onlyDigits(v).slice(0, 14)
  .replace(/^(\d{2})(\d)/, "$1.$2").replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3")
  .replace(/\.(\d{3})(\d)/, ".$1/$2").replace(/(\d{4})(\d)/, "$1-$2");
export const maskCEP = (v: string) => onlyDigits(v).slice(0, 8).replace(/(\d{5})(\d)/, "$1-$2");
export function isCPF(v: string) {
  const d = onlyDigits(v); if (d.length !== 11 || /^(\d)\1+$/.test(d)) return false;
  const dv = (n: number) => { let s = 0; for (let i = 0; i < n; i++) s += +d[i] * (n + 1 - i); const r = (s * 10) % 11; return r === 10 ? 0 : r; };
  return dv(9) === +d[9] && dv(10) === +d[10];
}
export function isCNPJ(v: string) {
  const d = onlyDigits(v); if (d.length !== 14 || /^(\d)\1+$/.test(d)) return false;
  const dv = (n: number) => { const w = n === 12 ? [5,4,3,2,9,8,7,6,5,4,3,2] : [6,5,4,3,2,9,8,7,6,5,4,3,2];
    const s = w.reduce((a, x, i) => a + x * +d[i], 0); const r = s % 11; return r < 2 ? 0 : 11 - r; };
  return dv(12) === +d[12] && dv(13) === +d[13];
}
```

Schema `zod` com a condição de pessoa:

```ts
const who = z.discriminatedUnion("person_type", [
  z.object({ person_type: z.literal("individual"), name: z.string().min(2, "Informe o nome"),
    document: z.string().refine(isCPF, "Confira o CPF: são 11 números") }),
  z.object({ person_type: z.literal("company"), name: z.string().min(2, "Informe o nome fantasia"),
    legal_name: z.string().min(2, "Informe a razão social"),
    document: z.string().refine(isCNPJ, "Confira o CNPJ: são 14 números"), state_registration: z.string().optional() }),
]);
```

Grave `document` só com dígitos e confira duplicidade com `count({ document })` antes de criar.

## Esqueleto do formulário em etapas

```tsx
const steps = [
  { id: "who", title: "Quem é", fields: ["person_type", "name", "document", "legal_name"] },
  { id: "contact", title: "Contato", fields: ["phone", "email"] },
  { id: "address", title: "Endereço", fields: ["zip", "street", "number", "city", "state"], when: (v) => v.needs_delivery },
  { id: "review", title: "Revisão", fields: [] },
].filter((s) => !s.when || s.when(values));
const next = async () => {
  const ok = await form.trigger(steps[i].fields as any);
  if (!ok) return;                                   // foco vai ao primeiro erro
  await saveDraft({ ...form.getValues(), last_step: i + 1 });
  trackEvent("form_step_done", { form: "customer", step: steps[i].id });
  goTo(i + 1);                                       // atualiza ?etapa=, rola ao topo, foca o título
};
```
Rodapé da etapa: "Voltar" (`variant="outline"`, à esquerda) e "Continuar" (principal, à direita; largura total no celular). Na revisão, o principal diz a ação: "Cadastrar cliente", "Enviar pedido de orçamento".

## Onde as pessoas param e o que fazer

| Ponto | Causas comuns | Correções |
|---|---|---|
| Primeiro campo | parece longo; não se sabe o que ganha; quebrado no celular; parece pouco confiável | dizer o ganho no topo ("Receba o orçamento em até 1 dia útil"); etapas escondem o tamanho; aviso de privacidade curto; ou voltar a página única |
| Meio | etapa pesada; pergunta sensível; sem progresso; demora | cortar campos da etapa; suavizar a pergunta ("Quanto você investe hoje nisso?" em vez de "Qual seu orçamento?"); indicador; dividir a etapa |
| Envio | botão vago; medo do que vem depois; erro surpresa; falta um dado | botão com a ação; dizer o que acontece depois; validar antes; mover o pedido do dado difícil para antes, com aviso |

Medição: `form_step_view`, `form_step_done`, `form_submit` com `{ form, step }`; com rascunho, `count({ status: "draft", last_step: n })` mostra a etapa onde mais param. Mais de 10 minutos no total ou mais de 2 minutos numa etapa costuma derrubar a conclusão. Queda de quem não é público do negócio é filtro, não defeito: olhe a qualidade de quem termina.

## Anti-padrões (reprovar na revisão)

Tudo numa página; teatro de progresso; etapas de 1 ou 2 campos; formulário sem indicador; interrogatório (25 campos em 5 etapas, metade dispensável); validação rígida demais; quebrado no celular; rascunho sem explicar o que guarda; total de etapas que muda; ansiedade no envio; popup no meio do preenchimento; formulário que apaga tudo no erro; validação lenta a cada tecla; sem suporte a preenchimento automático do navegador; retomada que volta ao início; condições demais; botão desabilitado sem dizer por quê.
