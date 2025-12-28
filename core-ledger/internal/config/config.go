package config

import "os"

// Config holds runtime configuration for the core-ledger service.
type Config struct {
	GRPCAddr string
	DBURL    string
}

func Load() Config {
	cfg := Config{
		GRPCAddr: getEnv("CORE_LEDGER_GRPC_ADDR", ":8081"),
		DBURL:    getEnv("CORE_LEDGER_DB_URL", "postgres://core:core@localhost:5432/core?sslmode=disable"),
	}
	return cfg
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
