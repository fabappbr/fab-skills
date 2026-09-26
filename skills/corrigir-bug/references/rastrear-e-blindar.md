# Rastrear a causa, blindar as camadas, esperar pela condição

## 1. Rastrear para trás até a origem

O defeito costuma aparecer longe de onde nasce. O instinto é consertar onde o erro aparece: isso trata o sintoma.

**Passo a passo:**

1. **Observe o sintoma exato.** "Ao salvar o pedido, erro: campo customer obrigatório."
2. **Ache a causa imediata.** Que linha produz isso? `collection('order').create({ items, total })`: não há `customer`.
3. **Pergunte: quem chamou com esse valor?** `NovoPedido.onSubmit` monta o objeto a partir do estado `form`.
4. **Continue subindo.** De onde vem `form.customer`? Do `Combobox` de cliente, que chama `onChange(cliente.nome)`.
5. **Ache o gatilho original.** O componente de escolha devolve o NOME, não o id; e o objeto enviado usa `customerId`, não `customer`. Duas diferenças, uma origem: o formulário foi escrito sem conferir os ids do schema.

**Conserto na origem:** o `Combobox` devolve o id, e o objeto usa o id de campo do schema (`customer`). Não "consertar" desligando o `required` do campo: isso apaga o sintoma e cria pedidos sem cliente.

**Quando não dá para seguir de cabeça, instrumente antes da operação suspeita:** mostre na tela, temporariamente, o objeto que vai ser enviado, ou deixe o `toast.error(e.message)` do `catch` com a mensagem inteira. Registre ANTES da operação que falha, não depois, e inclua o contexto (qual registro, qual pessoa, qual papel). Tire essa instrumentação quando achar a causa, menos o erro visível, que fica.

**Quando não sabe qual mudança quebrou:** divida ao meio. Liste o que a última edição tocou (arquivos, campos, regras). Confira metade: o defeito depende dela? Se sim, divida essa metade; se não, a outra. Em poucas rodadas de leitura sobra uma mudança.

Regra: **nunca conserte só onde o erro aparece.** Se dá para subir mais um nível, suba. Se chegou à origem, conserte lá e depois blinde as camadas.

## 2. Blindar em camadas

Depois de achar e consertar a origem, uma validação só parece suficiente, mas outro caminho do código (outra tela, a importação, uma edição futura) passa por fora dela. Valide em cada camada por onde o dado passa, para o defeito ficar impossível.

| Camada | Para quê | No app Fabapp |
|---|---|---|
| 1. Entrada | Recusar o óbvio na porta | `zod` no formulário: obrigatório, formato (e-mail, telefone, CPF), faixa (preço > 0), mensagem abaixo do campo |
| 2. Regra do negócio | Garantir que faz sentido para a operação | Guarda no handler antes de chamar o SDK: "não agenda no passado", "não cria pedido sem itens", "confere duplicidade com `count`" |
| 3. Servidor | O que não pode depender da tela | Schema (`required`, tipo, `enum`) e regra `access` certa. Para regra que precisa ser confiável (preço, estoque, limite), função de backend |
| 4. Registro visível | Saber o que houve quando as outras falham | Todo `catch` mostra `e.message`; estados vazio e de erro dizem o motivo |

**Aplicando:** (1) siga o caminho do dado: onde nasce, por onde passa; (2) liste cada ponto de passagem; (3) ponha a validação de cada camada; (4) confira cada camada pensando em como a anterior poderia ser contornada (a importação de planilha pula o formulário; a camada 3 pega).

As quatro camadas se completam: caminhos diferentes pulam a entrada, a regra do negócio pega casos de borda, o servidor não depende da tela, e o registro visível mostra o que escapou.

## 3. Esperar pela condição, nunca por tempo

Atraso fixo ("espera 1 segundo e carrega") funciona no celular rápido e falha no lento. Espere a coisa que importa.

| Situação | Errado | Certo |
|---|---|---|
| Dado ainda não chegou | `setTimeout(() => setLista(...), 1000)` | `const itens = await collection('x').list(...)`, Skeleton enquanto `loading` |
| Lista deve refletir mudanças de outras pessoas | `setInterval(() => list(), 5000)` | `useLive(model, { filter, sort, limit })` |
| Depois de salvar, mostrar o novo item | recarregar depois de um tempo | usar o registro devolvido pelo `create` |
| Pagamento confirmar | "espera 5 s e marca pago" | ler o status gravado pela plataforma com `useLive` |
| Tela depende do login | atraso para "dar tempo" do login | `isLoading` do `useAuth`: Skeleton até terminar |

**Espera por tempo é correta** só quando o comportamento É de tempo: a busca com espera de ~300 ms depois da última tecla, um toast que some sozinho, uma animação. Nesses casos, escreva no código por que aquele número (ex.: `// espera 300 ms depois da última tecla para não buscar a cada letra`).

Erros comuns: esperar sem limite (sempre ter o estado de erro e o "tentar de novo"); guardar o valor antes e conferir o valor velho (leia o valor atual quando a resposta chegar).
