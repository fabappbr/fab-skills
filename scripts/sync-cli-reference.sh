#!/usr/bin/env bash
# Copia docs/fabapp-cli.md (o contrato da plataforma pelo terminal, fonte única) para references/fabapp-cli.md de
# todas as skills. Rode depois de editar docs/fabapp-cli.md e antes de commitar.
set -euo pipefail
cd "$(dirname "$0")/.."
for d in skills/*/; do
  mkdir -p "${d}references"
  cp docs/fabapp-cli.md "${d}references/fabapp-cli.md"
done
echo "fabapp-cli.md copiado para $(ls -d skills/*/ | wc -l | tr -d ' ') skills"
