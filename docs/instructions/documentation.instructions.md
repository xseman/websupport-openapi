---
applyTo: "openapi*.yaml"
---

# Websupport REST API v1

Available documentation pages are mirrored as markdown in the `docs` folder
(`docs/fetch-docs.sh`). Raw markdown is also served at
`https://rest.websupport.sk/docs/<page>.md`.

- [User management](https://rest.websupport.sk/docs/v1.user)
- [Service management](https://rest.websupport.sk/docs/v1.service)
- [Invoice management](https://rest.websupport.sk/docs/v1.invoice)
- [Ordering new services](https://rest.websupport.sk/docs/v1.order)
- [DNS management](https://rest.websupport.sk/docs/v1.zone)
- [Hosting management](https://rest.websupport.sk/docs/v1.hosting)
- [VPS management](https://rest.websupport.sk/docs/v1.vps)

API v2 (`openapi.v2.yaml`) is derived from the official OpenAPI file
`https://rest.websupport.sk/v2/docs/openapi.json` (mirror: `docs/v2.openapi.json`)
and the intro page `https://rest.websupport.sk/v2/docs/intro`
(mirror: `docs/v2.intro.md`).

## Documentation Analysis

For each provided documentation URL, analyze the content structure, available
endpoints, request/response examples, parameter definitions, and schema
information.

## Gap Identification

Compare the current OpenAPI specification against the web documentation to identify

- Missing endpoints or operations
- Incomplete parameter definitions
- Missing or inadequate response schemas
- Absent request body schemas
- Missing error responses
- Incomplete examples

## Schema Extraction

Extract detailed schema information from the documentation examples, including

- Request body structures
- Response body structures
- Parameter formats and constraints
- Error response formats

## Conversion Strategy

Develop a systematic approach for converting each documentation section into
OpenAPI components.

## Implementation Plan

Create step-by-step instructions for updating the OpenAPI specification.

To validate the schema run `./scripts/validate.sh` (xseman/openapi-generator `validate`).
