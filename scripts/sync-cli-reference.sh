#!/usr/bin/env bash
# Copia docs/fabapp-cli.md (o contrato da plataforma pelo terminal, fonte única) para references/fabapp-cli.md de
# todas as skills. Rode depois de editar docs/fabapp-cli.md e antes de commitar.
set -euo pipefail
cd "$(dirname "$0")/.."
for d in skills/*/; do
  # fab-agencia tem o próprio contrato (references/plataforma-fabapp.md)
  [ "$d" = "skills/fab-agencia/" ] && continue
  mkdir -p "${d}references"
  cp docs/fabapp-cli.md "${d}references/fabapp-cli.md"
done
echo "fabapp-cli.md copiado para as skills (menos fab-agencia)"
