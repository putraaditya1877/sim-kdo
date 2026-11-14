package dto

type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type PerangkatDaerahRequest struct {
	Kode      string `json:"kode"`
	Nama      string `json:"nama"`
	Singkatan string `json:"singkatan"`
	Jenis     string `json:"jenis"`
	Alamat    string `json:"alamat"`
	Telepon   string `json:"telepon"`
	Email     string `json:"email"`
}

type PegawaiRequest struct {
	NIP               string `json:"nip"`
	Nama              string `json:"nama"`
	Jabatan           string `json:"jabatan"`
	GolonganID        uint64 `json:"golongan_id"`
	PerangkatDaerahID uint64 `json:"perangkat_daerah_id"`
	JenisKelamin      string `json:"jenis_kelamin"`
	Email             string `json:"email"`
	NoHP              string `json:"no_hp"`
}

type KendaraanRequest struct {
	NomorPolisi       string  `json:"nomor_polisi"`
	KodeBarang        string  `json:"kode_barang"`
	NomorRegister     string  `json:"nomor_register"`
	Merk              string  `json:"merk"`
	Tipe              string  `json:"tipe"`
	Jenis             string  `json:"jenis"`
	TahunProduksi     int16   `json:"tahun_produksi"`
	Warna             string  `json:"warna"`
	NomorRangka       string  `json:"nomor_rangka"`
	NomorMesin        string  `json:"nomor_mesin"`
	BahanBakar        string  `json:"bahan_bakar"`
	IsiSilinder       int     `json:"isi_silinder"`
	Kondisi           string  `json:"kondisi"`
	TanggalPerolehan  string  `json:"tanggal_perolehan"`
	NilaiPerolehan    float64 `json:"nilai_perolehan"`
	MasaBerlakuSTNK   string  `json:"masa_berlaku_stnk"`
	JatuhTempoPajak   string  `json:"jatuh_tempo_pajak"`
	PerangkatDaerahID uint64  `json:"perangkat_daerah_id"`
	Keterangan        string  `json:"keterangan"`
}

type PenugasanRequest struct {
	KendaraanID    uint64 `json:"kendaraan_id"`
	PegawaiID      uint64 `json:"pegawai_id"`
	NomorBAST      string `json:"nomor_bast"`
	TanggalMulai   string `json:"tanggal_mulai"`
	TanggalSelesai string `json:"tanggal_selesai"`
	Keterangan     string `json:"keterangan"`
}
