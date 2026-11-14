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
	ID           uint64 `gorm:"primaryKey"`
	Name         string
	Email        string
	PasswordHash string
	Role         string
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

func (User) TableName() string { return "users" }

type Golongan struct {
	ID      uint64 `gorm:"primaryKey"`
	Kode    string
	Pangkat string
	Ruang   string
	Tingkat int16
}

func (Golongan) TableName() string { return "golongan" }

type PerangkatDaerah struct {
	ID        uint64 `gorm:"primaryKey"`
	Kode      string
	Nama      string
	Singkatan string
	Jenis     string
	Alamat    string
	Telepon   string
	Email     string
	Timestamps
}

func (PerangkatDaerah) TableName() string { return "perangkat_daerah" }

type Pegawai struct {
	ID                uint64 `gorm:"primaryKey"`
	NIP               string `gorm:"column:nip"`
	Nama              string
	Jabatan           string
	GolonganID        uint64
	PerangkatDaerahID uint64
	JenisKelamin      string
	Email             string
	NoHP              string
	Timestamps
}

func (Pegawai) TableName() string { return "pegawai" }

type Kendaraan struct {
	ID                uint64 `gorm:"primaryKey"`
	NomorPolisi       string
	KodeBarang        string
	NomorRegister     string
	Merk              string
	Tipe              string
	Jenis             string
	TahunProduksi     int16
	Warna             string
	NomorRangka       string
	NomorMesin        string
	BahanBakar        string
	IsiSilinder       int
	Kondisi           string
	TanggalPerolehan  time.Time `gorm:"type:date"`
	NilaiPerolehan    float64
	MasaBerlakuSTNK   time.Time `gorm:"type:date"`
	JatuhTempoPajak   time.Time `gorm:"type:date"`
	PerangkatDaerahID uint64
	Keterangan        string
	Timestamps
}

func (Kendaraan) TableName() string { return "kendaraan" }

type PenugasanKendaraan struct {
	ID             uint64 `gorm:"primaryKey"`
	KendaraanID    uint64
	PegawaiID      uint64
	NomorBAST      string
	TanggalMulai   time.Time  `gorm:"type:date"`
	TanggalSelesai *time.Time `gorm:"type:date"`
	Keterangan     string
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
