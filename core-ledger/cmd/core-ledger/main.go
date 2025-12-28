package main

import (
	"context"
	"log"
	"net"

	core "core-ledger/api"
	"core-ledger/internal/config"
	"core-ledger/internal/db"
	"core-ledger/internal/ledger"
	"google.golang.org/grpc"
)

func main() {
	cfg := config.Load()

	ctx := context.Background()
	dbConn, err := db.Connect(ctx, cfg.DBURL)
	if err != nil {
		log.Fatalf("db connect failed: %v", err)
	}
	defer dbConn.Close()

	lis, err := net.Listen("tcp", cfg.GRPCAddr)
	if err != nil {
		log.Fatalf("listen failed: %v", err)
	}

	grpcServer := grpc.NewServer()
	core.RegisterCoreLedgerServer(grpcServer, ledger.New(dbConn))

	log.Printf("core-ledger grpc listening on %s", cfg.GRPCAddr)
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("grpc serve failed: %v", err)
	}
}
