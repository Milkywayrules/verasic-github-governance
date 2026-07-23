#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXAMPLE="${1:-examples/sandbox}"

cd "$ROOT/$EXAMPLE"

if [[ -z "${TF_VAR_github_token:-}" && -z "${GITHUB_TOKEN:-}" ]]; then
  echo "apply.sh: set TF_VAR_github_token (or GITHUB_TOKEN) — no secrets in repo" >&2
  exit 1
fi

if [[ "${VERASIC_GOVERNANCE_IAC_CONFIRM:-}" != "1" ]]; then
  echo "apply.sh: scaffold only — set VERASIC_GOVERNANCE_IAC_CONFIRM=1 to apply" >&2
  exit 3
fi

if command -v tofu >/dev/null 2>&1; then
  tofu init -input=false
  tofu apply -input=false
elif command -v terraform >/dev/null 2>&1; then
  terraform init -input=false
  terraform apply -input=false
else
  echo "apply.sh: tofu or terraform required" >&2
  exit 1
fi
