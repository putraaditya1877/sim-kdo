package seed

import (
	"fmt"
	"time"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
	"sim-kdo/backend/internal/model"
)

func Run(db *gorm.DB) error {
	return db.Transaction(func(tx *gorm.DB) error {
		if err := users(tx); err != nil {
			return err
		}
		golongan, err := golongan(tx)
		if err != nil {
			return err
		}
		pd, err := perangkatDaerah(tx)
		if err != nil {
			return err
		}
		pegawai, err := pegawai(tx, golongan, pd)
		if err != nil {
			return err
		}
		kendaraan, err := kendaraan(tx, pd)
		if err != nil {
			return err
		}
		return penugasan(tx, pegawai, kendaraan)
	})
}

func users(db *gorm.DB) error {
	hash, err := bcrypt.GenerateFromPassword([]byte("password"), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	for _, user := range []model.User{
		{Name: "Admin SIM-KDO", Email: "admin@simkdo.test", PasswordHash: string(hash), Role: "admin"},
		{Name: "Operator SIM-KDO", Email: "operator@simkdo.test", PasswordHash: string(hash), Role: "operator"},
	} {
		if err := db.Where("email = ?", user.Email).FirstOrCreate(&user).Error; err != nil {
			return err
		}
	}
	return nil
}

func golongan(db *gorm.DB) (map[string]uint64, error) {
	rows := []struct {
		kode, pangkat, ruang string
		tingkat              int16
	}{
		{"I/a", "Juru Muda", "I/a", 1}, {"I/b", "Juru Muda Tingkat I", "I/b", 1}, {"I/c", "Juru", "I/c", 1}, {"I/d", "Juru Tingkat I", "I/d", 1},
		{"II/a", "Pengatur Muda", "II/a", 2}, {"II/b", "Pengatur Muda Tingkat I", "II/b", 2}, {"II/c", "Pengatur", "II/c", 2}, {"II/d", "Pengatur Tingkat I", "II/d", 2},
		{"III/a", "Penata Muda", "III/a", 3}, {"III/b", "Penata Muda Tingkat I", "III/b", 3}, {"III/c", "Penata", "III/c", 3}, {"III/d", "Penata Tingkat I", "III/d", 3},
		{"IV/a", "Pembina", "IV/a", 4}, {"IV/b", "Pembina Tingkat I", "IV/b", 4}, {"IV/c", "Pembina Utama Muda", "IV/c", 4}, {"IV/d", "Pembina Utama Madya", "IV/d", 4}, {"IV/e", "Pembina Utama", "IV/e", 4},
	}
	ids := make(map[string]uint64, len(rows))
	for _, row := range rows {
		item := model.Golongan{Kode: row.kode, Pangkat: row.pangkat, Ruang: row.ruang, Tingkat: row.tingkat}
		if err := db.Where("kode = ?", row.kode).FirstOrCreate(&item).Error; err != nil {
			return nil, err
		}
		ids[row.kode] = item.ID
	}
	return ids, nil
}

func perangkatDaerah(db *gorm.DB) (map[int]uint64, error) {
	rows := []struct{ kode, nama, singkatan, jenis string }{
		{"DISDIK", "Dinas Pendidikan", "DISDIK", "dinas"}, {"DINKES", "Dinas Kesehatan", "DINKES", "dinas"}, {"DBM", "Dinas Bina Marga", "DBM", "dinas"}, {"DSDA", "Dinas Sumber Daya Air", "DSDA", "dinas"},
		{"DCKTRP", "Dinas Cipta Karya Tata Ruang dan Pertanahan", "DCKTRP", "dinas"}, {"DISHUB", "Dinas Perhubungan", "DISHUB", "dinas"}, {"DLH", "Dinas Lingkungan Hidup", "DLH", "dinas"}, {"DINSOS", "Dinas Sosial", "DINSOS", "dinas"},
		{"GULKAR", "Dinas Penanggulangan Kebakaran dan Penyelamatan", "GULKAR", "dinas"}, {"DISTAMHUT", "Dinas Pertamanan dan Hutan Kota", "DISTAMHUT", "dinas"}, {"BPAD", "Badan Pengelolaan Aset Daerah", "BPAD", "badan"}, {"BAPENDA", "Badan Pendapatan Daerah", "BAPENDA", "badan"},
		{"BPBD", "Badan Penanggulangan Bencana Daerah", "BPBD", "badan"}, {"INSPEKTORAT", "Inspektorat", "INSPEKTORAT", "inspektorat"}, {"SATPOLPP", "Satuan Polisi Pamong Praja", "SATPOLPP", "satuan"}, {"BIROUMUM", "Biro Umum Sekretariat Daerah", "BIROUMUM", "biro"},
	}
	ids := make(map[int]uint64, len(rows))
	for i, row := range rows {
		item := model.PerangkatDaerah{Kode: row.kode, Nama: row.nama, Singkatan: row.singkatan, Jenis: row.jenis, Alamat: "Jakarta", Email: fmt.Sprintf("%s@jakarta.go.id", row.kode)}
		if err := db.Where("kode = ?", row.kode).FirstOrCreate(&item).Error; err != nil {
			return nil, err
		}
		ids[i] = item.ID
	}
	return ids, nil
}

func pegawai(db *gorm.DB, golongan map[string]uint64, pd map[int]uint64) ([]model.Pegawai, error) {
	items := make([]model.Pegawai, 0, 40)
	for i := 1; i <= 40; i++ {
		gender := "L"
		genderCode := "1"
		if i%2 == 0 {
			gender, genderCode = "P", "2"
		}
		nip := fmt.Sprintf("198001%02d200801%s%03d", ((i-1)%28)+1, genderCode, i)
		item := model.Pegawai{NIP: nip, Nama: fmt.Sprintf("Pegawai Fiktif %02d", i), Jabatan: "Pengurus Barang", GolonganID: golongan[[]string{"II/c", "III/a", "III/b", "III/c"}[i%4]], PerangkatDaerahID: pd[(i-1)%16], JenisKelamin: gender, Email: fmt.Sprintf("pegawai%02d@simkdo.test", i)}
		if err := db.Where("nip = ?", nip).FirstOrCreate(&item).Error; err != nil {
			return nil, err
		}
		items = append(items, item)
	}
	return items, nil
}

func kendaraan(db *gorm.DB, pd map[int]uint64) ([]model.Kendaraan, error) {
	items := make([]model.Kendaraan, 0, 50)
	brands := []struct {
		merk, tipe, jenis, fuel string
		cc                      int
	}{{"Toyota", "Avanza", "roda_4", "bensin", 1496}, {"Toyota", "Kijang Innova", "roda_4", "solar", 2393}, {"Honda", "Vario", "roda_2", "bensin", 160}, {"Mitsubishi", "L300", "roda_4", "solar", 2477}, {"Suzuki", "Ertiga", "roda_4", "bensin", 1462}}
	for i := 1; i <= 50; i++ {
		b := brands[(i-1)%len(brands)]
		condition := "baik"
		if i%5 == 0 {
			condition = "rusak_ringan"
		}
		if i%17 == 0 {
			condition = "rusak_berat"
		}
		item := model.Kendaraan{NomorPolisi: fmt.Sprintf("B %04d %s", 1000+i, string(rune('A'+(i-1)%26))+string(rune('A'+(i/26)%26))), KodeBarang: fmt.Sprintf("1.3.2.02.01.01.%03d", i), NomorRegister: fmt.Sprintf("REG-%03d", i), Merk: b.merk, Tipe: b.tipe, Jenis: b.jenis, TahunProduksi: int16(2012 + i%14), Warna: "Hitam", NomorRangka: fmt.Sprintf("RANGKA-SIMKDO-%03d", i), NomorMesin: fmt.Sprintf("MESIN-SIMKDO-%03d", i), BahanBakar: b.fuel, IsiSilinder: b.cc, Kondisi: condition, TanggalPerolehan: time.Date(2012+i%14, time.January, 10, 0, 0, 0, 0, time.UTC), NilaiPerolehan: float64(12000000 + i*3500000), MasaBerlakuSTNK: time.Date(2027, time.Month((i%12)+1), 20, 0, 0, 0, 0, time.UTC), JatuhTempoPajak: time.Date(2026, time.Month((i%12)+1), 20, 0, 0, 0, 0, time.UTC), PerangkatDaerahID: pd[(i-1)%16]}
		if err := db.Where("nomor_polisi = ?", item.NomorPolisi).FirstOrCreate(&item).Error; err != nil {
			return nil, err
		}
		items = append(items, item)
	}
	return items, nil
}

func penugasan(db *gorm.DB, pegawai []model.Pegawai, kendaraan []model.Kendaraan) error {
	for i := 0; i < 30; i++ {
		vehicle := kendaraan[i]
		if vehicle.Kondisi == "rusak_berat" {
			continue
		}
		item := model.PenugasanKendaraan{KendaraanID: vehicle.ID, PegawaiID: pegawai[i%len(pegawai)].ID, NomorBAST: fmt.Sprintf("BAST-SIMKDO-%03d", i+1), TanggalMulai: time.Date(2025, time.January, 2+i, 0, 0, 0, 0, time.UTC), Keterangan: "Penugasan seed"}
		if i%3 != 0 {
			end := item.TanggalMulai.AddDate(0, 3, 0)
			item.TanggalSelesai = &end
		}
		if err := db.Where("nomor_bast = ?", item.NomorBAST).FirstOrCreate(&item).Error; err != nil {
			return err
		}
	}
	return nil
}
