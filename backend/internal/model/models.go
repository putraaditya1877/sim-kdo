package model

import (
	"time"

	"gorm.io/gorm"
)

type Timestamps struct {
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`
}

type User struct {
	ID           uint64 `gorm:"primaryKey" json:"id"`
	Name         string `json:"name"`
	Email        string `json:"email"`
	PasswordHash string `json:"-"`
	Role         string `json:"role"`
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

func (User) TableName() string { return "users" }

type Golongan struct {
	ID      uint64 `gorm:"primaryKey" json:"id"`
	Kode    string `json:"kode"`
	Pangkat string `json:"pangkat"`
	Ruang   string `json:"ruang"`
	Tingkat int16  `json:"tingkat"`
}

func (Golongan) TableName() string { return "golongan" }

type PerangkatDaerah struct {
	ID        uint64 `gorm:"primaryKey" json:"id"`
	Kode      string `json:"kode"`
	Nama      string `json:"nama"`
	Singkatan string `json:"singkatan"`
	Jenis     string `json:"jenis"`
	Alamat    string `json:"alamat"`
	Telepon   string `json:"telepon"`
	Email     string `json:"email"`
	Timestamps
}

func (PerangkatDaerah) TableName() string { return "perangkat_daerah" }

type Pegawai struct {
	ID                uint64 `gorm:"primaryKey" json:"id"`
	NIP               string `gorm:"column:nip" json:"nip"`
	Nama              string `json:"nama"`
	Jabatan           string `json:"jabatan"`
	GolonganID        uint64 `json:"golongan_id"`
	PerangkatDaerahID uint64 `json:"perangkat_daerah_id"`
	JenisKelamin      string `json:"jenis_kelamin"`
	Email             string `json:"email"`
	NoHP              string `json:"no_hp"`
	Timestamps
}

func (Pegawai) TableName() string { return "pegawai" }

type Kendaraan struct {
	ID                uint64    `gorm:"primaryKey" json:"id"`
	NomorPolisi       string    `json:"nomor_polisi"`
	KodeBarang        string    `json:"kode_barang"`
	NomorRegister     string    `json:"nomor_register"`
	Merk              string    `json:"merk"`
	Tipe              string    `json:"tipe"`
	Jenis             string    `json:"jenis"`
	TahunProduksi     int16     `json:"tahun_produksi"`
	Warna             string    `json:"warna"`
	NomorRangka       string    `json:"nomor_rangka"`
	NomorMesin        string    `json:"nomor_mesin"`
	BahanBakar        string    `json:"bahan_bakar"`
	IsiSilinder       int       `json:"isi_silinder"`
	Kondisi           string    `json:"kondisi"`
	TanggalPerolehan  time.Time `gorm:"type:date" json:"tanggal_perolehan"`
	NilaiPerolehan    float64   `json:"nilai_perolehan"`
	MasaBerlakuSTNK   time.Time `gorm:"type:date" json:"masa_berlaku_stnk"`
	JatuhTempoPajak   time.Time `gorm:"type:date" json:"jatuh_tempo_pajak"`
	PerangkatDaerahID uint64    `json:"perangkat_daerah_id"`
	Keterangan        string    `json:"keterangan"`
	Timestamps
}

func (Kendaraan) TableName() string { return "kendaraan" }

type PenugasanKendaraan struct {
	ID             uint64     `gorm:"primaryKey" json:"id"`
	KendaraanID    uint64     `json:"kendaraan_id"`
	PegawaiID      uint64     `json:"pegawai_id"`
	NomorBAST      string     `json:"nomor_bast"`
	TanggalMulai   time.Time  `gorm:"type:date" json:"tanggal_mulai"`
	TanggalSelesai *time.Time `gorm:"type:date" json:"tanggal_selesai"`
	Keterangan     string     `json:"keterangan"`
	Timestamps
}

func (PenugasanKendaraan) TableName() string { return "penugasan_kendaraan" }

type RiwayatKondisi struct {
	ID          uint64 `gorm:"primaryKey"`
	KendaraanID uint64
	KondisiLama string
	KondisiBaru string
	UserID      *uint64
	Catatan     string
	CreatedAt   time.Time
}

func (RiwayatKondisi) TableName() string { return "riwayat_kondisi" }

type Pemeliharaan struct {
	ID          uint64 `gorm:"primaryKey"`
	KendaraanID uint64
	Tanggal     time.Time `gorm:"type:date"`
	Jenis       string
	Bengkel     string
	Kilometer   int
	Biaya       float64
	Uraian      string
	Timestamps
}

func (Pemeliharaan) TableName() string { return "pemeliharaan" }
