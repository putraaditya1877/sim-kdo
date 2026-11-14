package service

import "testing"

func TestParseDate(t *testing.T) {
	if _, err := parseDate("2026-01-31"); err != nil {
		t.Fatalf("tanggal valid ditolak: %v", err)
	}
	if _, err := parseDate("31-01-2026"); err == nil {
		t.Fatal("tanggal dengan format salah seharusnya ditolak")
	}
}
