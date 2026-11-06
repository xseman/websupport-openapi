# Websupport OpenAPI

Hand-written OpenAPI 3.0 specifications for the Websupport REST API, built from
the official documentation (which is not published in OpenAPI format for v1).

## Layout

- `openapi.yaml` – API v1, single source of truth, 4-space indent, camelCase path params.
- `openapi.v2.yaml` – API v2, cleaned copy of the official `docs/v2.openapi.json`.
- `docs/` – GitHub Pages site (Swagger UI) and mirrors of the official docs
  (`v1.*.md`, `v2.intro.md`, `v2.openapi.json`), refreshed with `docs/fetch-docs.sh`.
- `scripts/validate.sh` – validates both specs (xseman/openapi-generator `validate` + Redocly lint).
- `scripts/signature.sh` – signed request example; credentials come from `.env` (see `.env.example`).
- `client/` – locally generated client, gitignored.

## Rules

- The official documentation is the authority; never invent endpoints or fields.
  Note obvious doc typos in descriptions instead of silently correcting them.
- Do not split the specs into modules or add a bundling step.
- Run `./scripts/validate.sh` after every spec change. Redocly warnings
  `no-ambiguous-paths` and `operation-4xx-response` are expected; do not rename
  documented paths to silence them.
- Never hardcode API keys or secrets; `.env` is gitignored.

## Further instructions (read when relevant)

- Aligning a spec with the documentation, gap analysis, schema extraction:
  read `docs/instructions/documentation.instructions.md` first.
