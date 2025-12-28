# Core Ledger v1 (Go + Postgres)

This is a starter implementation of the Core Ledger service. It exposes gRPC endpoints and uses Postgres as the source of truth. The current version contains safe stubs that will be extended with full ledger logic and idempotency.

## Layout
- `api/` – gRPC proto definitions
- `cmd/core-ledger` – service entrypoint
- `internal/ledger` – core ledger service implementation
- `db/migrations` – SQL schema migrations

## Environment
- `CORE_LEDGER_GRPC_ADDR` (default `:8081`)
- `CORE_LEDGER_DB_URL` (default `postgres://core:core@localhost:5432/core?sslmode=disable`)

## Build
```
go mod tidy

go build ./cmd/core-ledger
```

## Run
```
CORE_LEDGER_DB_URL=postgres://core:core@localhost:5432/core?sslmode=disable \
CORE_LEDGER_GRPC_ADDR=:8081 \
./core-ledger
```

## Next steps
- Implement atomic posting (double-entry) with idempotency
- Add quote/confirm logic and limits
- Wire loan schedule queries
- Add migrations runner and Docker compose
