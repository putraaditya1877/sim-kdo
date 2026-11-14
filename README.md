# SIM-KDO

Sistem Informasi Manajemen Kendaraan Dinas Operasional (KDO) milik Perangkat Daerah sebagai bagian dari pengelolaan Barang Milik Daerah (BMD).

## Status

Proyek dikembangkan bertahap sesuai [rencana implementasi](docs/PLAN.md). Fase yang sudah selesai dicatat pada ringkasan setiap sesi.

## Stack

- Backend: Go, Gin, GORM, PostgreSQL
- Frontend: React, TypeScript, Vite, Tailwind CSS, shadcn/ui
- Runtime: Docker Compose

## Menjalankan proyek

Instruksi setup Docker dan setup manual akan dilengkapi setelah scaffold backend dan frontend tersedia.

## Dokumentasi

- [Rencana implementasi](docs/PLAN.md)
- [ERD](docs/ERD.md)
- [API](docs/API.md)
- [Log penggunaan AI](docs/ai/PROMPTS.md)

## Penggunaan AI

Pengembangan mengikuti aturan pada [AGENTS.md](AGENTS.md). Perubahan AI ditinjau dan diverifikasi dengan perintah nyata sebelum digunakan.

## Kredit

Frontend akan menggunakan template shadcn-admin berlisensi MIT. Kredit dan lisensi lengkap akan dicantumkan saat template diimpor.
