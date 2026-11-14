CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'operator')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE golongan (
    id BIGSERIAL PRIMARY KEY,
    kode VARCHAR(5) NOT NULL UNIQUE,
    pangkat VARCHAR(80) NOT NULL,
    ruang VARCHAR(20) NOT NULL,
    tingkat SMALLINT NOT NULL CHECK (tingkat BETWEEN 1 AND 4)
);

CREATE TABLE perangkat_daerah (
    id BIGSERIAL PRIMARY KEY,
    kode VARCHAR(30) NOT NULL,
    nama VARCHAR(180) NOT NULL,
    singkatan VARCHAR(30) NOT NULL,
    jenis VARCHAR(20) NOT NULL CHECK (jenis IN ('dinas', 'badan', 'kantor', 'satuan', 'inspektorat', 'biro', 'lainnya')),
    alamat VARCHAR(255) NOT NULL DEFAULT '',
    telepon VARCHAR(30) NOT NULL DEFAULT '',
    email VARCHAR(255) NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE TABLE pegawai (
    id BIGSERIAL PRIMARY KEY,
    nip CHAR(18) NOT NULL CHECK (TRIM(nip) ~ '^[0-9]{18}$'),
    nama VARCHAR(120) NOT NULL,
    jabatan VARCHAR(120) NOT NULL,
    golongan_id BIGINT NOT NULL REFERENCES golongan(id) ON DELETE RESTRICT,
    perangkat_daerah_id BIGINT NOT NULL REFERENCES perangkat_daerah(id) ON DELETE RESTRICT,
    jenis_kelamin CHAR(1) NOT NULL CHECK (jenis_kelamin IN ('L', 'P')),
    email VARCHAR(255) NOT NULL DEFAULT '',
    no_hp VARCHAR(30) NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE TABLE kendaraan (
    id BIGSERIAL PRIMARY KEY,
    nomor_polisi VARCHAR(20) NOT NULL CHECK (nomor_polisi ~ '^B [0-9]{1,4} [A-Z]{1,3}$'),
    kode_barang VARCHAR(40) NOT NULL,
    nomor_register VARCHAR(40) NOT NULL,
    merk VARCHAR(60) NOT NULL,
    tipe VARCHAR(80) NOT NULL,
    jenis VARCHAR(20) NOT NULL CHECK (jenis IN ('roda_2', 'roda_4', 'roda_6_lebih')),
    tahun_produksi SMALLINT NOT NULL CHECK (tahun_produksi BETWEEN 1980 AND 2100),
    warna VARCHAR(30) NOT NULL,
    nomor_rangka VARCHAR(80) NOT NULL,
    nomor_mesin VARCHAR(80) NOT NULL,
    bahan_bakar VARCHAR(20) NOT NULL CHECK (bahan_bakar IN ('bensin', 'solar', 'listrik', 'hybrid')),
    isi_silinder INT NOT NULL CHECK (isi_silinder >= 0),
    kondisi VARCHAR(20) NOT NULL CHECK (kondisi IN ('baik', 'rusak_ringan', 'rusak_berat')),
    tanggal_perolehan DATE NOT NULL,
    nilai_perolehan NUMERIC(15,2) NOT NULL CHECK (nilai_perolehan >= 0),
    masa_berlaku_stnk DATE NOT NULL,
    jatuh_tempo_pajak DATE NOT NULL,
    perangkat_daerah_id BIGINT NOT NULL REFERENCES perangkat_daerah(id) ON DELETE RESTRICT,
    keterangan TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE TABLE penugasan_kendaraan (
    id BIGSERIAL PRIMARY KEY,
    kendaraan_id BIGINT NOT NULL REFERENCES kendaraan(id) ON DELETE CASCADE,
    pegawai_id BIGINT NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
    nomor_bast VARCHAR(60) NOT NULL,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE,
    keterangan TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    CONSTRAINT ck_penugasan_tanggal CHECK (tanggal_selesai IS NULL OR tanggal_selesai >= tanggal_mulai)
);

CREATE TABLE riwayat_kondisi (
    id BIGSERIAL PRIMARY KEY,
    kendaraan_id BIGINT NOT NULL REFERENCES kendaraan(id) ON DELETE CASCADE,
    kondisi_lama VARCHAR(20),
    kondisi_baru VARCHAR(20) NOT NULL CHECK (kondisi_baru IN ('baik', 'rusak_ringan', 'rusak_berat')),
    user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    catatan TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE pemeliharaan (
    id BIGSERIAL PRIMARY KEY,
    kendaraan_id BIGINT NOT NULL REFERENCES kendaraan(id) ON DELETE CASCADE,
    tanggal DATE NOT NULL,
    jenis VARCHAR(30) NOT NULL CHECK (jenis IN ('servis_rutin', 'perbaikan', 'penggantian_suku_cadang', 'lainnya')),
    bengkel VARCHAR(120) NOT NULL,
    kilometer INT NOT NULL CHECK (kilometer >= 0),
    biaya NUMERIC(15,2) NOT NULL CHECK (biaya >= 0),
    uraian TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE UNIQUE INDEX uq_pd_kode_aktif ON perangkat_daerah (kode) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX uq_pd_nama_aktif ON perangkat_daerah (nama) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX uq_pegawai_nip_aktif ON pegawai (nip) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX uq_kendaraan_nopol_aktif ON kendaraan (nomor_polisi) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX uq_kendaraan_rangka_aktif ON kendaraan (nomor_rangka) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX uq_kendaraan_mesin_aktif ON kendaraan (nomor_mesin) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX uq_penugasan_aktif ON penugasan_kendaraan (kendaraan_id) WHERE tanggal_selesai IS NULL AND deleted_at IS NULL;

CREATE INDEX idx_pegawai_pd ON pegawai (perangkat_daerah_id);
CREATE INDEX idx_pegawai_nama ON pegawai (nama);
CREATE INDEX idx_kendaraan_pd ON kendaraan (perangkat_daerah_id);
CREATE INDEX idx_kendaraan_kondisi ON kendaraan (kondisi);
CREATE INDEX idx_kendaraan_pajak ON kendaraan (jatuh_tempo_pajak);
CREATE INDEX idx_penugasan_pegawai ON penugasan_kendaraan (pegawai_id);
