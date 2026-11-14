# SIM-KDO

Sistem Informasi Manajemen Kendaraan Dinas Operasional (KDO) milik Perangkat Daerah sebagai bagian dari pengelolaan Barang Milik Daerah (BMD).

## Status

Proyek dikembangkan bertahap sesuai [rencana implementasi](docs/PLAN.md). Fase yang sudah selesai dicatat pada ringkasan setiap sesi.

## Stack

- Backend: Go, Gin, GORM, PostgreSQL
- Frontend: React, TypeScript, Vite, Tailwind CSS, shadcn/ui
- Runtime: Docker Compose

## Menjalankan proyek

Salin `.env.example` menjadi `.env` bila ingin mengubah konfigurasi default, lalu jalankan dari root repo:

```bash
docker compose up -d --build
docker compose exec api /app/simkdo migrate up
docker compose exec api /app/simkdo seed
docker compose ps
```

Web tersedia di [http://localhost:3000](http://localhost:3000), API di port `8080`, dan PostgreSQL di port `5432`.
Health check:

```bash
curl http://localhost:8080/api/v1/health
curl http://localhost:3000/api/v1/health
```

Backend lokal dapat dijalankan dari `backend/` dengan `go run ./cmd/simkdo serve` setelah PostgreSQL tersedia.

Health endpoint mengembalikan envelope JSON dan status koneksi API serta database.

Data seed demo menggunakan akun `admin@simkdo.test` dan `operator@simkdo.test`, keduanya dengan password `password`.

## Akun demo dan endpoint

Akun seed: `admin@simkdo.test` dan `operator@simkdo.test`, keduanya memakai password `password`.

Endpoint utama: `POST /api/v1/auth/login`, `GET /api/v1/auth/me`, `GET /api/v1/dashboard`, `GET /api/v1/golongan`, serta CRUD/trash/restore untuk `/api/v1/perangkat-daerah`, `/api/v1/pegawai`, dan `/api/v1/kendaraan`. Penugasan tersedia di `/api/v1/penugasan` dengan endpoint penyelesaian `POST /api/v1/penugasan/:id/selesai`.

Pemeliharaan, riwayat kondisi, dan export CSV dipangkas dari implementasi batas waktu.

## Dokumentasi

- [Rencana implementasi](docs/PLAN.md)
- [ERD](docs/ERD.md)
- [API](docs/API.md)
- [Log penggunaan AI](docs/ai/PROMPTS.md)

## Penggunaan AI

Claude Code (Claude Opus 5.5) digunakan untuk perencanaan. OpenAI Codex (GPT-5.6 Luna) digunakan untuk implementasi. Proses mengikuti [AGENTS.md](AGENTS.md), rencana pada [docs/PLAN.md](docs/PLAN.md), dan log prompt pada [docs/ai/PROMPTS.md](docs/ai/PROMPTS.md). Kode diverifikasi dengan Docker, curl, build, lint, test, dan vet yang relevan.

## Kredit

Frontend menggunakan template [shadcn-admin](https://github.com/satnaing/shadcn-admin) berlisensi MIT, yang diimpor melalui `degit` lalu dibersihkan dari halaman demo yang tidak dipakai.
