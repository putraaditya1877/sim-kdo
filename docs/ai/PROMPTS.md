# Log Penggunaan AI

| Alat | Model | Peran |
|---|---|---|
| Claude Code (ekstensi VS Code) | Claude Opus 5.5 | Membaca soal, menyusun rencana implementasi ([docs/PLAN.md](../PLAN.md)), menulis [AGENTS.md](../../AGENTS.md), dan menyusun prompt untuk Codex |
| OpenAI Codex | GPT-5.6 Luna | Mengimplementasikan kode per fase sesuai PLAN.md |

Semua hasil AI sudah ditinjau, dijalankan, dan diuji oleh pemilik repo sebelum di-push.

---

## Prompt 1 — Kickoff (F0 + F1)

```
Kamu akan membangun proyek SIM-KDO (Sistem Informasi Manajemen Kendaraan Dinas
Operasional) untuk ujian praktik Junior Programmer track fullstack.

Langkah pertama, baca dua file ini secara lengkap:
1. AGENTS.md: aturan kerja yang wajib kamu ikuti
2. docs/PLAN.md: rencana implementasi dan sumber kebenaran (stack, ERD,
   endpoint, aturan bisnis, fase)

PENTING: jangan buka atau commit file soal.text karena berisi kredensial.

Setelah membaca, tulis ringkasan pemahamanmu dalam maksimal 10 poin, termasuk
risiko teknis yang kamu lihat di lingkungan Windows + Docker Desktop. Lalu
langsung kerjakan:

- F0 Setup repo: git init (branch main), cek .gitignore sudah mengabaikan
  soal.text, buat kerangka README.md dan folder docs sesuai PLAN.md §3.
  Pastikan `git status` tidak menampilkan soal.text sebelum commit pertama.
- F1 Scaffold backend + Docker DB: go mod di backend/ (module: sim-kdo/backend),
  config dari env, koneksi GORM ke Postgres, endpoint GET /api/v1/health yang
  juga ping DB, envelope respons di internal/httpx, middleware recovery +
  request log + CORS, Dockerfile multi-stage (non-root), docker-compose.yml
  berisi service db dan api, serta .env.example di root dan backend/.

Verifikasi dengan `docker compose up -d --build` lalu panggil
http://localhost:8080/api/v1/health (harus 200 dan DB "up"). Jalankan juga
go build, go vet, gofmt -l.

Commit kecil-kecil (Conventional Commits). Jangan push. Setelah F1 selesai,
BERHENTI dan tulis ringkasan sesuai "Format Ringkasan Fase" di AGENTS.md.
```

## Prompt 2..n — Lanjut fase berikutnya

Ganti `Fx` dengan nomor fase (F2 sampai F9):

```
Lanjut kerjakan fase Fx sesuai docs/PLAN.md §9, dengan aturan di AGENTS.md.

Sebelum mulai, cek `git status` harus bersih dan baca ulang bagian PLAN.md
yang relevan untuk fase ini. Kerjakan sampai kriteria "Selesai jika" benar-benar
terverifikasi dengan perintah nyata. Commit kecil-kecil, jangan push.
Setelah selesai, BERHENTI dan tulis ringkasan fase.
```

Tambahan khusus per fase (tempel di bawah prompt di atas jika perlu):

- **F2**: `Tunjukkan output migrate up, migrate down, migrate up lagi, lalu seed dua kali (harus idempoten). Tampilkan jumlah baris per tabel.`
- **F3/F4**: `Sertakan contoh curl untuk setiap endpoint baru beserta status code-nya, termasuk kasus gagal (401, 403, 404, 409, 422).`
- **F5**: `Tampilkan output lengkap go test ./... -v (ringkas bagian PASS) dan pastikan swagger.yaml + koleksi Postman ada di docs/api/.`
- **F6**: `Impor template dengan npx degit satnaing/shadcn-admin frontend dalam commit tersendiri, lalu bersihkan di commit berikutnya. Pastikan pnpm lint dan pnpm build lulus, dan login ke API asli berhasil lewat http://localhost:3000.`
- **F9**: `Buat dump dengan cara pg_dump -f + docker compose cp (jangan redirect > di PowerShell). Uji dari nol: docker compose down -v, up --build, seed, lalu cek FE dan API. Lengkapi README sesuai checklist PLAN.md §10.`

## Prompt perbaikan (jika ada bug)

```
Ada masalah: <jelaskan gejala, langkah reproduksi, dan pesan error/log>.
Cari akar masalahnya dulu, jelaskan penyebabnya, baru perbaiki. Tambahkan test
yang mencegah bug ini muncul lagi jika memungkinkan. Commit dengan tipe fix(...).
```

## Prompt review sebelum submit

```
Lakukan review akhir terhadap seluruh repo sebagai penilai ujian, berdasarkan
bobot penilaian di docs/PLAN.md §1 dan checklist §10. Daftar temuan diurutkan
dari yang paling berdampak pada nilai. Jangan ubah apa pun dulu, cukup laporkan.
```
