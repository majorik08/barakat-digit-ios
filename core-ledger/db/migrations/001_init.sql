-- Core Ledger schema (PostgreSQL)

CREATE TABLE customers (
  id              UUID PRIMARY KEY,
  phone           TEXT UNIQUE NOT NULL,
  email           TEXT,
  first_name      TEXT,
  last_name       TEXT,
  middle_name     TEXT,
  status          TEXT NOT NULL DEFAULT 'active',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE wallet_accounts (
  id              UUID PRIMARY KEY,
  customer_id     UUID NOT NULL REFERENCES customers(id),
  currency        TEXT NOT NULL,
  status          TEXT NOT NULL DEFAULT 'active',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_wallet_accounts_customer ON wallet_accounts(customer_id);

CREATE TABLE ledger_accounts (
  id              UUID PRIMARY KEY,
  code            TEXT UNIQUE NOT NULL,
  name            TEXT NOT NULL,
  type            TEXT NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE journal_entries (
  id                UUID PRIMARY KEY,
  external_id       TEXT NOT NULL,
  type              TEXT NOT NULL,
  status            TEXT NOT NULL,
  description       TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX ux_journal_external_id ON journal_entries(external_id);

CREATE TABLE postings (
  id                UUID PRIMARY KEY,
  journal_id         UUID NOT NULL REFERENCES journal_entries(id),
  account_type       TEXT NOT NULL,
  account_id         UUID NOT NULL,
  amount             NUMERIC(20,2) NOT NULL,
  direction          TEXT NOT NULL,
  currency           TEXT NOT NULL,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_postings_journal ON postings(journal_id);
CREATE INDEX idx_postings_account ON postings(account_type, account_id);

CREATE TABLE balances (
  account_type       TEXT NOT NULL,
  account_id         UUID NOT NULL,
  currency           TEXT NOT NULL,
  balance            NUMERIC(20,2) NOT NULL DEFAULT 0,
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (account_type, account_id, currency)
);

CREATE TABLE holds (
  id                UUID PRIMARY KEY,
  wallet_account_id UUID NOT NULL REFERENCES wallet_accounts(id),
  amount            NUMERIC(20,2) NOT NULL,
  currency          TEXT NOT NULL,
  status            TEXT NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE limits (
  id                UUID PRIMARY KEY,
  wallet_account_id UUID NOT NULL REFERENCES wallet_accounts(id),
  daily_limit       NUMERIC(20,2) NOT NULL DEFAULT 0,
  monthly_limit     NUMERIC(20,2) NOT NULL DEFAULT 0,
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE audit_log (
  id             UUID PRIMARY KEY,
  actor_type     TEXT NOT NULL,
  actor_id       UUID,
  action         TEXT NOT NULL,
  metadata       JSONB NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Loans (debit only, no credit cards)
CREATE TABLE loans (
  id              UUID PRIMARY KEY,
  customer_id     UUID NOT NULL REFERENCES customers(id),
  wallet_account_id UUID NOT NULL REFERENCES wallet_accounts(id),
  principal       NUMERIC(20,2) NOT NULL,
  outstanding     NUMERIC(20,2) NOT NULL,
  interest_rate   NUMERIC(5,2) NOT NULL,
  term_months     INT NOT NULL,
  status          TEXT NOT NULL DEFAULT 'active',
  next_due_date   DATE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE loan_payments (
  id              UUID PRIMARY KEY,
  loan_id         UUID NOT NULL REFERENCES loans(id),
  amount          NUMERIC(20,2) NOT NULL,
  due_date        DATE NOT NULL,
  status          TEXT NOT NULL DEFAULT 'due',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
