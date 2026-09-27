# Fab Agência (`fab-agencia`)

Skill que cria e publica na [Fabapp AI](https://fabapp.ai) sites com acabamento de grande agência: direção de arte
própria, tipografia com personalidade, movimento coreografado, texto que converte e engenharia medida (Lighthouse,
acessibilidade, SEO).

Criada por Felipe Santos, Fabapp AI. Versão 1.4.0.

- Edição terminal: o agente constrói pelo CLI `@fabappai/cli` e publica com `fabapp deploy`.
- `references/plataforma-fabapp.md` é o contrato da plataforma que esta skill usa (ela não carrega o
  `fabapp-cli.md` comum às outras skills do repositório).
- Novidades desde a 1.1.0 (o repositório antigo `fabappbr/skills-fab-agencia`): a Fase 5 fecha as decisões por
  escrito ("Decisões, não tabelas"), o plano de motion virou requisito, e o kit de motion da plataforma
  (`@/components/ui/motion`: `Parallax`, `ScrollScale`, `Pin`, `Marquee`, `Counter`, `TextReveal`) é a primeira
  camada, testada em Chrome e Safari.

## Usar

Abra a ferramenta numa pasta vazia (que vai virar a pasta do site). No Claude Code, digite `/fab-agencia` (ou
`/fab-skills:fab-agencia` se instalou pelo marketplace). Em qualquer ferramenta, você também pode só pedir: "crie um
site para a minha cafeteria".

A primeira resposta da skill é sempre o checklist de configuração (Node, CLI da Fabapp e login). Se ela começar
perguntando sobre a sua marca, a skill não foi carregada: confira a pasta.

## Requisitos

- Node.js 20 ou mais novo
- Uma conta na Fabapp AI num plano que autoriza o CLI (Builder ou maior)
- Google Chrome (opcional, usado no autoteste)

## Instalação

Veja o [README do repositório](../../README.md). Só esta skill, com o instalador:

```bash
npx skills add fabappbr/fab-skills -s fab-agencia -g
```

## Licença

MIT, como o restante do repositório. Texto original da Fabapp AI.
