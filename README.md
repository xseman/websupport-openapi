# Websupport REST API v1

## Why

The actual Websupport API documentation is not in OpenAPI format, which makes it
hard to integrate to your favourite language or tool. This repository contains
an OpenAPI 3.0 specification for the Websupport API based on the [documentation]
which might be outdated or incomplete.

[documentation]: https://rest.websupport.sk/docs/index

## OpenAPI

I would greatly appreciate any contributions or updates to the [OpenAPI
definition][openapi] to address any issues.

[openapi]: ./openapi.yaml

| File                                 | API | Source                                                              |
| ------------------------------------ | --- | ------------------------------------------------------------------- |
| [openapi.yaml](./openapi.yaml)       | v1  | hand-written from the [v1 documentation][documentation]             |
| [openapi.v2.yaml](./openapi.v2.yaml) | v2  | cleaned copy of the [official v2 OpenAPI file][v2-json] (see below) |

## API v2

Websupport also publishes an [API v2][v2-docs] with its own machine-readable
[OpenAPI file][v2-json] (Swagger UI) and an [intro page][v2-intro]. The v1
documentation marks the DNS record and FTP account endpoints as **deprecated**
in favour of v2.

[v2-docs]: https://rest.websupport.sk/v2/docs
[v2-json]: https://rest.websupport.sk/v2/docs/openapi.json
[v2-intro]: https://rest.websupport.sk/v2/docs/intro

[openapi.v2.yaml](./openapi.v2.yaml) is a cleaned copy of the official file
(verbatim mirror in [docs/v2.openapi.json](./docs/v2.openapi.json)): it adds
`servers`, global `security`, the `X-Date` header, readable `operationId`s
(the official ids are kept in `x-original-operationId`), descriptions and
notes on inconsistencies in the official file. Nothing was invented beyond
what the official file or intro page states.

### What v2 covers and what is missing

v2 is not a replacement for v1 yet. It contains 13 operations in four areas;
everything else still exists only in v1.

| Area                                                     | v1                                                            | v2                                                                                                                                            |
| -------------------------------------------------------- | ------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| Credentials check                                        | –                                                             | `GET /v2/check`                                                                                                                               |
| Users, billing profiles, domain profiles, password reset | 15 operations                                                 | **missing**                                                                                                                                   |
| Services (list, detail, `autoExtend`)                    | 3 operations                                                  | **missing**                                                                                                                                   |
| Invoices, invoice PDF, invoice payments                  | 8 operations                                                  | **missing**                                                                                                                                   |
| Ordering, validation, order payments, payment cards      | 13 operations                                                 | **missing**                                                                                                                                   |
| DNS zones                                                | list + detail (`id`, `name`, `updateTime`)                    | detail only (`name`, `lastCheck`, `dnssecSigning`); **no zone list**                                                                          |
| DNS records                                              | list, get by id, create, update, delete (deprecated); 8 types | paginated/filterable/sortable list, create, update, delete; 15 types (adds CAA, DNSSEC, CERT, LOC, SSHFP, TLSA, DS); **no single-record GET** |
| Dynamic DNS                                              | –                                                             | `GET /nic/update` (parameters undocumented)                                                                                                   |
| Hosting list/detail, vhosts, size/domain/FTP stats       | 8 operations                                                  | **missing**; only `POST /v2/service/{service}/assign-domain`                                                                                  |
| Databases, DB users, DB stats                            | 8 operations                                                  | **missing**                                                                                                                                   |
| Mailboxes, mail size stats                               | 7 operations                                                  | **missing**                                                                                                                                   |
| FTP accounts                                             | list, detail, create, update, delete (deprecated)             | paginated list, detail, create, update, delete                                                                                                |
| Shell consoles                                           | 2 operations                                                  | **missing**                                                                                                                                   |
| VPS (detail, VNC, reboot, stats, snapshots)              | 11 operations                                                 | **missing**                                                                                                                                   |

### Protocol differences

| Topic               | v1                                                                           | v2                                                                                                                                   |
| ------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Base URL            | `https://rest.websupport.sk/v1`                                              | `https://rest.websupport.sk` (paths carry `/v2`, DynDNS is `/nic/update`)                                                            |
| Signature           | HMAC-SHA1 of `{method} {path} {unix timestamp}`, same secret                 | identical algorithm                                                                                                                  |
| Timestamp header    | `Date`                                                                       | `X-Date`                                                                                                                             |
| Resource addressing | `/user/{userId}/zone/{domainName}/…`, `/user/{userId}/hosting/{hostingId}/…` | `/v2/service/{service}/…` (service identifier; format not documented)                                                                |
| Pagination          | `page`, `pagesize`; response `{items, pager}`                                | `page`, `rowsPerPage`, `sortBy`, `descending`, `filters[...]`; response `{currentPage, rowsPerPage, totalPages, totalRecords, data}` |
| Write responses     | `200`/`201` with `{status, item, errors}` envelope                           | `204` without body; validation errors as `422`                                                                                       |
| Error body          | `{code, message}`; validation errors often `200` + `status: error`           | RFC 7807 style `{type, status, title}`; `422` adds `violations[]`                                                                    |
| DNS record fields   | `prio`, `weight`, `port`, `ttl`                                              | `priority`, `weight`, `port`, `ttl`                                                                                                  |
| Languages           | `Accept-Language`: `en_us`, `sk`, `cs_cz`, `hu`                              | same                                                                                                                                 |

### Auth

See [documentation][auth-documentation] with examples.

[auth-documentation]: https://rest.websupport.sk/docs/v1.intro

You may also explore [signature.sh](./scripts/signature.sh), which is based
on the examples provided in the documentation. It reads `WS_API_KEY` and
`WS_API_SECRET` from `.env` in the repository root (copy `.env.example`,
`.env` is gitignored):

```sh
cp .env.example .env   # fill in the key and secret from admin.websupport.sk
./scripts/signature.sh                  # GET /v1/user/self
./scripts/signature.sh /v1/user/self/zone "?pagesize=1"
```

### Validation

```sh
./scripts/validate.sh
```

Runs [xseman/openapi-generator](https://github.com/xseman/openapi-generator)
`validate` (binary from `$OPENAPI_GENERATOR` or `openapi-generator` on PATH)
on both specifications.

### Docs

The `docs/v1.*.md` and `docs/v2.intro.md` files are local mirrors of the
official documentation pages and `docs/v2.openapi.json` is the official v2
OpenAPI file, all fetched with [docs/fetch-docs.sh](./docs/fetch-docs.sh).
Refresh them before updating the specifications.
