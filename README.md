# SIM-KDO

Sistem Informasi Manajemen Kendaraan Dinas Operasional (KDO) milik Perangkat Daerah sebagai bagian dari pengelolaan Barang Milik Daerah (BMD).

## Status

Proyek dikembangkan bertahap sesuai [rencana implementasi](docs/PLAN.md). Fase yang sudah selesai dicatat pada ringkasan setiap sesi.

## Stack

- Backend: Go, Gin, GORM, PostgreSQL
- Frontend: React, TypeScript, Vite, Tailwind CSS, shadcn/ui
- Runtime: Docker Compose

## Menjalankan proyek

Salin `.env.example` menjadi `.env` bila ingin mengubah konfigurasi default, lalu jalankan:

```bash
docker compose up -d --build
curl http://localhost:8080/api/v1/health
docker compose exec api /app/simkdo migrate up
docker compose exec api /app/simkdo seed
```

Backend lokal dapat dijalankan dari `backend/` dengan `go run ./cmd/simkdo serve` setelah PostgreSQL tersedia.

Health endpoint mengembalikan envelope JSON dan status koneksi API serta database.

Data seed demo menggunakan akun `admin@simkdo.test` dan `operator@simkdo.test`, keduanya dengan password `password`.

## Dokumentasi

- [Rencana implementasi](docs/PLAN.md)
- [ERD](docs/ERD.md)
- [API](docs/API.md)
- [Log penggunaan AI](docs/ai/PROMPTS.md)

## Penggunaan AI

Pengembangan mengikuti aturan pada [AGENTS.md](AGENTS.md). Perubahan AI ditinjau dan diverifikasi dengan perintah nyata sebelum digunakan.

## Kredit

Frontend akan menggunakan template shadcn-admin berlisensi MIT. Kredit dan lisensi lengkap akan dicantumkan saat template diimpor.
