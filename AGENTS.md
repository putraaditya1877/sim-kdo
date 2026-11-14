# AGENTS.md — Instruksi untuk Agen AI

File ini berisi aturan yang **wajib** diikuti oleh agen AI (Codex, Claude Code, dll.) saat mengerjakan repo ini. File ini sekaligus menjadi dokumentasi penggunaan AI sesuai ketentuan ujian.

## Konteks Proyek
SIM-KDO adalah sistem pengelolaan Kendaraan Dinas Operasional (KDO) milik Perangkat Daerah (PD) sebagai bagian dari pengelolaan Barang Milik Daerah (BMD). Proyek ini adalah ujian praktik Junior Programmer (track fullstack).

**Sumber kebenaran: [docs/PLAN.md](docs/PLAN.md).** Baca seluruhnya sebelum mulai. Kalau ada keputusan yang belum diatur di sana, pilih solusi paling sederhana yang benar, lalu catat keputusannya di ringkasan fase.

## Aturan Keras
1. **Jangan membuka, membaca, menyalin, atau meng-commit `soal.text`.** File itu berisi kredensial pribadi. Pastikan file itu tercantum di `.gitignore` sebelum commit pertama.
2. Jangan menaruh secret di repo. Pakai `.env` (di-ignore) dan sediakan `.env.example`.
3. **`git push` wajib atas persetujuan pemilik repo.** Di akhir setiap fase, tulis ringkasan singkat lalu tanya: "Fase Fx selesai. Boleh push ke origin main?" dan tunggu jawaban. Push hanya setelah disetujui. Jangan pernah `git push --force`, jangan ubah remote, dan jangan rewrite history.
4. Kerjakan **semua fase berurutan dari F1 sampai F9** (tabel §9 di PLAN.md). Di akhir setiap fase: verifikasi, commit, minta persetujuan push (aturan 3). Setelah pemilik menjawab (setuju atau tidak), push jika disetujui lalu **langsung lanjut** ke fase berikutnya tanpa perlu diminta lagi. Selain untuk persetujuan push, berhenti hanya jika benar-benar terblokir (mis. Docker mati) dan jelaskan apa yang dibutuhkan.
5. Jangan menandai pekerjaan sebagai selesai sebelum perintah verifikasinya benar-benar dijalankan dan lulus. Jika ada yang gagal atau dilewati, laporkan apa adanya.
6. Jangan memakai nama atau NIP orang sungguhan di data seed.
7. Jangan menambah dependency di luar stack PLAN.md tanpa alasan kuat. Kalau terpaksa, sebutkan di ringkasan.

## Stack
- Backend: Go 1.25, Gin, GORM (pgx), golang-migrate (SQL di-embed), JWT, swaggo. Folder `backend/`.
- Database: PostgreSQL 17 lewat Docker Compose.
- Frontend: template shadcn-admin (Vite + React + TS + Tailwind + shadcn/ui + TanStack Router/Query). Folder `frontend/`. Pakai package manager bawaan template (pnpm via `corepack enable`).
- Lingkungan: Windows 10, Docker Desktop. Path repo mengandung spasi (`F:\Lowker\BPAD DKI\sim-kdo`), jadi selalu beri tanda kutip pada path.

## Perintah
```bash
# seluruh stack
docker compose up -d --build
docker compose exec api /app/simkdo seed
docker compose logs -f api

# backend (dari folder backend/)
go build ./...
go vet ./...
gofmt -l .                       # harus kosong
go test ./...
swag init -g cmd/simkdo/main.go -o docs

# frontend (dari folder frontend/)
pnpm install
pnpm lint
pnpm build
pnpm dev
```

## Konvensi Backend
- Alur lapisan: `handler` (parse + validasi + respons) → `service` (aturan bisnis, transaksi) → `repository` (query). Handler tidak boleh menyentuh GORM langsung.
- Semua respons memakai envelope di `internal/httpx` (`success`, `message`, `data`, `meta`, `errors`).
- Error domain didefinisikan sebagai sentinel/typed error di `service` (mis. `ErrNotFound`, `ErrConflict`), lalu dipetakan ke status HTTP di satu tempat (`httpx`). Error Postgres: 23505 → 409, 23503 → 409, 23514 → 422.
- Pesan validasi dalam Bahasa Indonesia dan memakai nama field JSON (snake_case).
- Teruskan `context.Context` dari request ke repository (`db.WithContext(ctx)`).
- Skema DB **hanya** lewat file migrasi SQL. Jangan pakai `AutoMigrate`.
- Kolom sort harus lewat whitelist. Jangan menyambung string input ke SQL.
- Setiap handler publik diberi anotasi swag.
- Nama domain memakai Bahasa Indonesia (`Kendaraan`, `Pegawai`, `PerangkatDaerah`, `Penugasan`). Istilah teknis memakai Bahasa Inggris (`repository`, `service`, `handler`).

## Konvensi Frontend
- Hapus halaman demo template yang tidak dipakai. Jangan biarkan data dummy template tampil.
- Struktur per fitur: `src/features/<entitas>/` (komponen, schema zod, hooks query, tipe).
- Semua data diambil dari API asli lewat TanStack Query. Jangan ada data hardcode di halaman.
- Label UI dalam Bahasa Indonesia. Format Rupiah dan tanggal memakai `id-ID`.
- Error 422 dari server dipetakan ke field form. Error lain ditampilkan sebagai toast.
- Tipe TypeScript harus ketat. Hindari `any`.

## Git
- Conventional Commits dengan scope: `feat(be): ...`, `feat(fe): ...`, `feat(db): ...`, `test(be): ...`, `docs: ...`, `chore(infra): ...`, `fix(...)`, `refactor(...)`. Deskripsi singkat dalam Bahasa Indonesia.
- Commit kecil dan bermakna, beberapa commit per fase (mis. migrasi, model, seeder dipisah). Jangan satu commit raksasa.
- Sebelum commit: kode BE sudah lolos `gofmt` dan build, kode FE sudah lolos lint dan build untuk bagian yang disentuh.
- Template pihak ketiga diimpor dalam commit tersendiri yang menyebut sumber dan lisensinya.

## Definition of Done per Fase
- Kriteria "Selesai jika" di PLAN.md §9 terpenuhi dan sudah diverifikasi dengan perintah nyata.
- Build, lint, dan test (yang relevan) hijau.
- README/docs diperbarui jika ada perintah, env, atau endpoint baru.
- Perubahan sudah di-commit, working tree bersih.

## Format Ringkasan Fase
Di akhir setiap fase, tulis:
1. Apa yang dikerjakan (poin singkat)
2. Daftar commit (`git log --oneline` untuk fase ini)
3. Perintah verifikasi yang dijalankan beserta hasilnya
4. Keputusan desain atau penyimpangan dari PLAN.md
5. Hal yang perlu dilakukan pemilik repo (mis. push, screenshot, isi env)
6. Rencana fase berikutnya
