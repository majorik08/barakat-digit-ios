package ledger

import (
	"context"
	"errors"
	"time"

	core "core-ledger/api"
	"core-ledger/internal/db"
)

// Service implements core ledger operations. In v1 these are stubs to be expanded.
type Service struct {
	DB *db.DB
	core.UnimplementedCoreLedgerServer
}

func New(dbConn *db.DB) *Service {
	return &Service{DB: dbConn}
}

func (s *Service) QuoteTransfer(ctx context.Context, req *core.QuoteTransferRequest) (*core.QuoteTransferResponse, error) {
	// TODO: calculate fees, validate limits, check balance.
	expires := time.Now().Add(5 * time.Minute).UTC().Format(time.RFC3339)
	return &core.QuoteTransferResponse{
		Fee:     "0.00",
		Total:   req.Amount,
		QuoteId: "quote-demo",
		ExpiresAt: expires,
	}, nil
}

func (s *Service) PostTransfer(ctx context.Context, req *core.PostTransferRequest) (*core.PostTransferResponse, error) {
	// TODO: perform atomic postings + idempotency check.
	if req.IdempotencyKey == "" {
		return nil, errors.New("idempotency_key required")
	}
	return &core.PostTransferResponse{
		JournalId: "journal-demo",
		Status:    "posted",
	}, nil
}

func (s *Service) GetBalance(ctx context.Context, req *core.GetBalanceRequest) (*core.GetBalanceResponse, error) {
	// TODO: query balances projection.
	return &core.GetBalanceResponse{
		Available: "0.00",
		Reserved:  "0.00",
		Current:   "0.00",
		UpdatedAt: time.Now().UTC().Format(time.RFC3339),
	}, nil
}

func (s *Service) GetHistory(ctx context.Context, req *core.GetHistoryRequest) (*core.GetHistoryResponse, error) {
	// TODO: query journal entries and map to history items.
	return &core.GetHistoryResponse{Items: []*core.HistoryItem{}, NextCursor: ""}, nil
}

func (s *Service) Reverse(ctx context.Context, req *core.ReverseRequest) (*core.ReverseResponse, error) {
	// TODO: create reversal journal entry.
	return &core.ReverseResponse{ReversalJournalId: "reversal-demo", Status: "posted"}, nil
}

func (s *Service) GetLoanSchedule(ctx context.Context, req *core.GetLoanScheduleRequest) (*core.GetLoanScheduleResponse, error) {
	// TODO: query loan_payments for customer.
	return &core.GetLoanScheduleResponse{Items: []*core.LoanScheduleItem{}}, nil
}
