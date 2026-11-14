package service

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
	"sim-kdo/backend/internal/dto"
	"sim-kdo/backend/internal/model"
	"sim-kdo/backend/internal/repository"
)

var (
	ErrNotFound     = errors.New("data tidak ditemukan")
	ErrConflict     = errors.New("data bertentangan")
	ErrValidation   = errors.New("data tidak valid")
	ErrUnauthorized = errors.New("email atau password salah")
)

type Service struct {
	Repo      *repository.Repository
	JWTSecret string
}

func New(repo *repository.Repository, jwtSecret string) *Service {
	return &Service{Repo: repo, JWTSecret: jwtSecret}
}

func (s *Service) Login(ctx context.Context, req dto.LoginRequest) (string, model.User, error) {
	var user model.User
	if err := s.Repo.Query(ctx).Where("email = ?", strings.TrimSpace(req.Email)).First(&user).Error; err != nil {
		return "", user, ErrUnauthorized
	}
	if bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password)) != nil {
		return "", user, ErrUnauthorized
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{"user_id": user.ID, "role": user.Role, "exp": time.Now().Add(8 * time.Hour).Unix()})
	signed, err := token.SignedString([]byte(s.JWTSecret))
	return signed, user, err
}

func (s *Service) User(ctx context.Context, id uint64) (model.User, error) {
	var user model.User
	if err := s.Repo.Query(ctx).First(&user, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return user, ErrNotFound
	} else if err != nil {
		return user, err
	}
	return user, nil
}

func (s *Service) ListGolongan(ctx context.Context) ([]model.Golongan, error) {
	var rows []model.Golongan
	err := s.Repo.Query(ctx).Order("tingkat, id").Find(&rows).Error
	return rows, err
}

func (s *Service) ListPD(ctx context.Context, search string, trash bool) ([]model.PerangkatDaerah, error) {
	var rows []model.PerangkatDaerah
	q := s.Repo.Query(ctx)
	if trash {
		q = q.Unscoped().Where("deleted_at IS NOT NULL")
	}
	if search != "" {
		q = q.Where("nama ILIKE ? OR kode ILIKE ?", "%"+search+"%", "%"+search+"%")
	}
	return rows, q.Order("nama").Find(&rows).Error
}

func (s *Service) SavePD(ctx context.Context, id uint64, req dto.PerangkatDaerahRequest) (model.PerangkatDaerah, error) {
	if req.Kode == "" || req.Nama == "" || req.Singkatan == "" || req.Jenis == "" {
		return model.PerangkatDaerah{}, ErrValidation
	}
	db := s.Repo.Query(ctx)
	var row model.PerangkatDaerah
	if id == 0 {
		row = model.PerangkatDaerah{Kode: req.Kode, Nama: req.Nama, Singkatan: req.Singkatan, Jenis: req.Jenis, Alamat: req.Alamat, Telepon: req.Telepon, Email: req.Email}
		return row, db.Create(&row).Error
	}
	if err := db.First(&row, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return row, ErrNotFound
	} else if err != nil {
		return row, err
	}
	row.Kode, row.Nama, row.Singkatan, row.Jenis, row.Alamat, row.Telepon, row.Email = req.Kode, req.Nama, req.Singkatan, req.Jenis, req.Alamat, req.Telepon, req.Email
	return row, db.Save(&row).Error
}

func (s *Service) DeletePD(ctx context.Context, id uint64, force bool) error {
	var row model.PerangkatDaerah
	db := s.Repo.Query(ctx)
	q := db
	if force {
		q = db.Unscoped()
	}
	if err := q.First(&row, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return ErrNotFound
	} else if err != nil {
		return err
	}
	if force {
		if !row.DeletedAt.Valid {
			return ErrConflict
		}
		return db.Unscoped().Delete(&row).Error
	}
	var count int64
	db.Model(&model.Pegawai{}).Where("perangkat_daerah_id = ?", id).Count(&count)
	db.Model(&model.Kendaraan{}).Where("perangkat_daerah_id = ?", id).Count(&count)
	if count > 0 {
		return ErrConflict
	}
	return db.Delete(&row).Error
}

func (s *Service) RestorePD(ctx context.Context, id uint64) error {
	var row model.PerangkatDaerah
	db := s.Repo.Query(ctx).Unscoped()
	if err := db.First(&row, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return ErrNotFound
	} else if err != nil {
		return err
	}
	if !row.DeletedAt.Valid {
		return ErrConflict
	}
	var count int64
	s.Repo.Query(ctx).Model(&model.PerangkatDaerah{}).Where("(kode = ? OR nama = ?)", row.Kode, row.Nama).Count(&count)
	if count > 0 {
		return ErrConflict
	}
	return s.Repo.Query(ctx).Unscoped().Model(&model.PerangkatDaerah{}).Where("id = ?", id).Update("deleted_at", nil).Error
}

func (s *Service) ListPegawai(ctx context.Context, search string, trash bool) ([]model.Pegawai, error) {
	var rows []model.Pegawai
	q := s.Repo.Query(ctx)
	if trash {
		q = q.Unscoped().Where("deleted_at IS NOT NULL")
	}
	if search != "" {
		q = q.Where("nama ILIKE ? OR nip ILIKE ?", "%"+search+"%", "%"+search+"%")
	}
	return rows, q.Order("nama").Find(&rows).Error
}

func (s *Service) SavePegawai(ctx context.Context, id uint64, req dto.PegawaiRequest) (model.Pegawai, error) {
	if req.NIP == "" || req.Nama == "" || req.GolonganID == 0 || req.PerangkatDaerahID == 0 || (req.JenisKelamin != "L" && req.JenisKelamin != "P") {
		return model.Pegawai{}, ErrValidation
	}
	db := s.Repo.Query(ctx)
	row := model.Pegawai{NIP: req.NIP, Nama: req.Nama, Jabatan: req.Jabatan, GolonganID: req.GolonganID, PerangkatDaerahID: req.PerangkatDaerahID, JenisKelamin: req.JenisKelamin, Email: req.Email, NoHP: req.NoHP}
	if id == 0 {
		return row, db.Create(&row).Error
	}
	if err := db.First(&row, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return row, ErrNotFound
	} else if err != nil {
		return row, err
	}
	row.NIP, row.Nama, row.Jabatan, row.GolonganID, row.PerangkatDaerahID, row.JenisKelamin, row.Email, row.NoHP = req.NIP, req.Nama, req.Jabatan, req.GolonganID, req.PerangkatDaerahID, req.JenisKelamin, req.Email, req.NoHP
	return row, db.Save(&row).Error
}

func (s *Service) DeletePegawai(ctx context.Context, id uint64, force bool) error {
	var row model.Pegawai
	db := s.Repo.Query(ctx)
	q := db
	if force {
		q = db.Unscoped()
	}
	if err := q.First(&row, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return ErrNotFound
	} else if err != nil {
		return err
	}
	if force {
		if !row.DeletedAt.Valid {
			return ErrConflict
		}
		return db.Unscoped().Delete(&row).Error
	}
	var count int64
	db.Model(&model.PenugasanKendaraan{}).Where("pegawai_id = ? AND tanggal_selesai IS NULL AND deleted_at IS NULL", id).Count(&count)
	if count > 0 {
		return ErrConflict
	}
	return db.Delete(&row).Error
}

func (s *Service) RestorePegawai(ctx context.Context, id uint64) error {
	var row model.Pegawai
	db := s.Repo.Query(ctx).Unscoped()
	if err := db.First(&row, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return ErrNotFound
	} else if err != nil {
		return err
	}
	if !row.DeletedAt.Valid {
		return ErrConflict
	}
	var count int64
	s.Repo.Query(ctx).Model(&model.Pegawai{}).Where("nip = ?", row.NIP).Count(&count)
	if count > 0 {
		return ErrConflict
	}
	return s.Repo.Query(ctx).Unscoped().Model(&model.Pegawai{}).Where("id = ?", id).Update("deleted_at", nil).Error
}

func parseDate(value string) (time.Time, error) { return time.Parse("2006-01-02", value) }

func (s *Service) SaveKendaraan(ctx context.Context, id uint64, req dto.KendaraanRequest) (model.Kendaraan, error) {
	start, err := parseDate(req.TanggalPerolehan)
	if err != nil {
		return model.Kendaraan{}, ErrValidation
	}
	stnk, err := parseDate(req.MasaBerlakuSTNK)
	if err != nil {
		return model.Kendaraan{}, ErrValidation
	}
	pajak, err := parseDate(req.JatuhTempoPajak)
	if err != nil {
		return model.Kendaraan{}, ErrValidation
	}
	if req.NomorPolisi == "" || req.NomorRangka == "" || req.NomorMesin == "" || req.PerangkatDaerahID == 0 {
		return model.Kendaraan{}, ErrValidation
	}
	db := s.Repo.Query(ctx)
	row := model.Kendaraan{NomorPolisi: req.NomorPolisi, KodeBarang: req.KodeBarang, NomorRegister: req.NomorRegister, Merk: req.Merk, Tipe: req.Tipe, Jenis: req.Jenis, TahunProduksi: req.TahunProduksi, Warna: req.Warna, NomorRangka: req.NomorRangka, NomorMesin: req.NomorMesin, BahanBakar: req.BahanBakar, IsiSilinder: req.IsiSilinder, Kondisi: req.Kondisi, TanggalPerolehan: start, NilaiPerolehan: req.NilaiPerolehan, MasaBerlakuSTNK: stnk, JatuhTempoPajak: pajak, PerangkatDaerahID: req.PerangkatDaerahID, Keterangan: req.Keterangan}
	if id == 0 {
		return row, db.Create(&row).Error
	}
	if err := db.First(&row, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return row, ErrNotFound
	} else if err != nil {
		return row, err
	}
	row.NomorPolisi, row.KodeBarang, row.NomorRegister, row.Merk, row.Tipe, row.Jenis, row.TahunProduksi, row.Warna, row.NomorRangka, row.NomorMesin, row.BahanBakar, row.IsiSilinder, row.Kondisi, row.TanggalPerolehan, row.NilaiPerolehan, row.MasaBerlakuSTNK, row.JatuhTempoPajak, row.PerangkatDaerahID, row.Keterangan = req.NomorPolisi, req.KodeBarang, req.NomorRegister, req.Merk, req.Tipe, req.Jenis, req.TahunProduksi, req.Warna, req.NomorRangka, req.NomorMesin, req.BahanBakar, req.IsiSilinder, req.Kondisi, start, req.NilaiPerolehan, stnk, pajak, req.PerangkatDaerahID, req.Keterangan
	return row, db.Save(&row).Error
}

func (s *Service) ListKendaraan(ctx context.Context, search string, trash bool) ([]model.Kendaraan, error) {
	var rows []model.Kendaraan
	q := s.Repo.Query(ctx)
	if trash {
		q = q.Unscoped().Where("deleted_at IS NOT NULL")
	}
	if search != "" {
		q = q.Where("nomor_polisi ILIKE ? OR merk ILIKE ? OR tipe ILIKE ?", "%"+search+"%", "%"+search+"%", "%"+search+"%")
	}
	return rows, q.Order("nomor_polisi").Find(&rows).Error
}
func (s *Service) DeleteKendaraan(ctx context.Context, id uint64, force bool) error {
	var row model.Kendaraan
	db := s.Repo.Query(ctx)
	q := db
	if force {
		q = db.Unscoped()
	}
	if err := q.First(&row, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return ErrNotFound
	} else if err != nil {
		return err
	}
	if force {
		if !row.DeletedAt.Valid {
			return ErrConflict
		}
		return db.Unscoped().Delete(&row).Error
	}
	var count int64
	db.Model(&model.PenugasanKendaraan{}).Where("kendaraan_id = ? AND tanggal_selesai IS NULL AND deleted_at IS NULL", id).Count(&count)
	if count > 0 {
		return ErrConflict
	}
	return db.Delete(&row).Error
}
func (s *Service) RestoreKendaraan(ctx context.Context, id uint64) error {
	var row model.Kendaraan
	db := s.Repo.Query(ctx).Unscoped()
	if err := db.First(&row, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return ErrNotFound
	} else if err != nil {
		return err
	}
	if !row.DeletedAt.Valid {
		return ErrConflict
	}
	var count int64
	s.Repo.Query(ctx).Model(&model.Kendaraan{}).Where("nomor_polisi = ?", row.NomorPolisi).Count(&count)
	if count > 0 {
		return ErrConflict
	}
	return s.Repo.Query(ctx).Unscoped().Model(&model.Kendaraan{}).Where("id = ?", id).Update("deleted_at", nil).Error
}

func (s *Service) ListPenugasan(ctx context.Context, trash bool) ([]model.PenugasanKendaraan, error) {
	var rows []model.PenugasanKendaraan
	q := s.Repo.Query(ctx)
	if trash {
		q = q.Unscoped().Where("deleted_at IS NOT NULL")
	}
	return rows, q.Order("tanggal_mulai DESC").Find(&rows).Error
}
func (s *Service) SavePenugasan(ctx context.Context, id uint64, req dto.PenugasanRequest) (model.PenugasanKendaraan, error) {
	start, err := parseDate(req.TanggalMulai)
	if err != nil {
		return model.PenugasanKendaraan{}, ErrValidation
	}
	var vehicle model.Kendaraan
	var employee model.Pegawai
	db := s.Repo.Query(ctx)
	if db.First(&vehicle, req.KendaraanID).Error != nil || db.First(&employee, req.PegawaiID).Error != nil {
		return model.PenugasanKendaraan{}, ErrNotFound
	}
	if vehicle.PerangkatDaerahID != employee.PerangkatDaerahID {
		return model.PenugasanKendaraan{}, ErrConflict
	}
	if vehicle.Kondisi == "rusak_berat" {
		return model.PenugasanKendaraan{}, ErrConflict
	}
	var active int64
	db.Model(&model.PenugasanKendaraan{}).Where("kendaraan_id = ? AND tanggal_selesai IS NULL AND deleted_at IS NULL AND id <> ?", req.KendaraanID, id).Count(&active)
	if id == 0 && active > 0 {
		return model.PenugasanKendaraan{}, ErrConflict
	}
	row := model.PenugasanKendaraan{KendaraanID: req.KendaraanID, PegawaiID: req.PegawaiID, NomorBAST: req.NomorBAST, TanggalMulai: start, Keterangan: req.Keterangan}
	var tanggalSelesai *time.Time
	if req.TanggalSelesai != "" {
		end, e := parseDate(req.TanggalSelesai)
		if e != nil || end.Before(start) {
			return row, ErrValidation
		}
		row.TanggalSelesai = &end
		tanggalSelesai = &end
	}
	if id == 0 {
		return row, db.Create(&row).Error
	}
	if err := db.First(&row, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return row, ErrNotFound
	} else if err != nil {
		return row, err
	}
	row.KendaraanID, row.PegawaiID, row.NomorBAST, row.TanggalMulai, row.TanggalSelesai, row.Keterangan = req.KendaraanID, req.PegawaiID, req.NomorBAST, start, tanggalSelesai, req.Keterangan
	return row, db.Save(&row).Error
}
func (s *Service) FinishPenugasan(ctx context.Context, id uint64, date string) error {
	end, err := parseDate(date)
	if err != nil {
		return ErrValidation
	}
	var row model.PenugasanKendaraan
	db := s.Repo.Query(ctx)
	if err := db.First(&row, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return ErrNotFound
	} else if err != nil {
		return err
	}
	if end.Before(row.TanggalMulai) {
		return ErrValidation
	}
	return db.Model(&row).Update("tanggal_selesai", end).Error
}
func (s *Service) DeletePenugasan(ctx context.Context, id uint64) error {
	var row model.PenugasanKendaraan
	db := s.Repo.Query(ctx)
	if err := db.First(&row, id).Error; errors.Is(err, gorm.ErrRecordNotFound) {
		return ErrNotFound
	} else if err != nil {
		return err
	}
	return db.Delete(&row).Error
}

func (s *Service) Dashboard(ctx context.Context) (map[string]int64, error) {
	result := map[string]int64{}
	for key, query := range map[string]*gorm.DB{"total_kendaraan": s.Repo.Query(ctx).Model(&model.Kendaraan{}), "baik": s.Repo.Query(ctx).Model(&model.Kendaraan{}).Where("kondisi = ?", "baik"), "rusak_ringan": s.Repo.Query(ctx).Model(&model.Kendaraan{}).Where("kondisi = ?", "rusak_ringan"), "rusak_berat": s.Repo.Query(ctx).Model(&model.Kendaraan{}).Where("kondisi = ?", "rusak_berat"), "penugasan_aktif": s.Repo.Query(ctx).Model(&model.PenugasanKendaraan{}).Where("tanggal_selesai IS NULL")} {
		var count int64
		if err := query.Count(&count).Error; err != nil {
			return nil, err
		}
		result[key] = count
	}
	return result, nil
}

func (s *Service) ErrMessage(err error) string {
	if errors.Is(err, ErrNotFound) {
		return "Data tidak ditemukan"
	}
	if errors.Is(err, ErrConflict) {
		return "Operasi ditolak karena konflik data atau aturan bisnis"
	}
	if errors.Is(err, ErrValidation) {
		return "Data tidak valid"
	}
	if errors.Is(err, ErrUnauthorized) {
		return "Email atau password salah"
	}
	return fmt.Sprint(err)
}
