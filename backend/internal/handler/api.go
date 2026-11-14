package handler

import (
	"errors"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgconn"
	"sim-kdo/backend/internal/dto"
	"sim-kdo/backend/internal/httpx"
	"sim-kdo/backend/internal/service"
)

type API struct{ Service *service.Service }

func NewAPI(svc *service.Service) *API { return &API{Service: svc} }

func (a *API) Login(c *gin.Context) {
	var req dto.LoginRequest
	if c.ShouldBindJSON(&req) != nil {
		httpx.Failure(c, 400, "JSON tidak valid", nil)
		return
	}
	token, user, err := a.Service.Login(c.Request.Context(), req)
	if err != nil {
		httpx.Failure(c, 401, "Email atau password salah", nil)
		return
	}
	httpx.Success(c, 200, "Login berhasil", gin.H{"token": token, "user": gin.H{"id": user.ID, "name": user.Name, "email": user.Email, "role": user.Role}})
}

func (a *API) Me(c *gin.Context) {
	id, _ := c.Get(middlewareUserID())
	user, err := a.Service.User(c.Request.Context(), id.(uint64))
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Profil pengguna", gin.H{"id": user.ID, "name": user.Name, "email": user.Email, "role": user.Role})
}

// middlewareUserID menjaga handler tidak bergantung pada string context internal.
func middlewareUserID() string { return "user_id" }

func (a *API) Golongan(c *gin.Context) {
	rows, err := a.Service.ListGolongan(c.Request.Context())
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Daftar golongan", rows)
}
func (a *API) Dashboard(c *gin.Context) {
	data, err := a.Service.Dashboard(c.Request.Context())
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Ringkasan dashboard", data)
}

func idParam(c *gin.Context) (uint64, bool) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil || id == 0 {
		httpx.Failure(c, 400, "ID tidak valid", nil)
		return 0, false
	}
	return id, true
}
func writeError(c *gin.Context, err error) {
	status := 500
	switch {
	case errors.Is(err, service.ErrNotFound):
		status = 404
	case errors.Is(err, service.ErrConflict):
		status = 409
	case errors.Is(err, service.ErrValidation):
		status = 422
	case errors.Is(err, service.ErrUnauthorized):
		status = 401
	default:
		var pgErr *pgconn.PgError
		if errors.As(err, &pgErr) {
			if pgErr.Code == "23505" || pgErr.Code == "23503" {
				status = 409
			}
			if pgErr.Code == "23514" {
				status = 422
			}
		}
	}
	httpx.Failure(c, status, err.Error(), nil)
}
func bind(c *gin.Context, value any) bool {
	if c.ShouldBindJSON(value) != nil {
		httpx.Failure(c, 400, "JSON tidak valid", nil)
		return false
	}
	return true
}

func (a *API) ListPD(c *gin.Context) {
	rows, err := a.Service.ListPD(c, c.Query("search"), false)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Daftar perangkat daerah", rows)
}
func (a *API) TrashPD(c *gin.Context) {
	rows, err := a.Service.ListPD(c, c.Query("search"), true)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Trash perangkat daerah", rows)
}
func (a *API) SavePD(c *gin.Context) {
	var req dto.PerangkatDaerahRequest
	if !bind(c, &req) {
		return
	}
	row, err := a.Service.SavePD(c, 0, req)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 201, "Perangkat daerah berhasil disimpan", row)
}
func (a *API) UpdatePD(c *gin.Context) {
	id, ok := idParam(c)
	if !ok {
		return
	}
	var req dto.PerangkatDaerahRequest
	if !bind(c, &req) {
		return
	}
	row, err := a.Service.SavePD(c, id, req)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Perangkat daerah berhasil diubah", row)
}
func (a *API) GetPD(c *gin.Context) {
	id, ok := idParam(c)
	if !ok {
		return
	}
	rows, err := a.Service.ListPD(c, "", false)
	if err != nil {
		writeError(c, err)
		return
	}
	for _, row := range rows {
		if row.ID == id {
			httpx.Success(c, 200, "Detail perangkat daerah", row)
			return
		}
	}
	writeError(c, service.ErrNotFound)
}
func (a *API) DeletePD(c *gin.Context) {
	id, ok := idParam(c)
	if ok {
		if err := a.Service.DeletePD(c, id, false); err != nil {
			writeError(c, err)
			return
		}
		httpx.Success(c, 200, "Perangkat daerah dipindahkan ke trash", nil)
	}
}
func (a *API) RestorePD(c *gin.Context) {
	id, ok := idParam(c)
	if ok {
		if err := a.Service.RestorePD(c, id); err != nil {
			writeError(c, err)
			return
		}
		httpx.Success(c, 200, "Perangkat daerah dipulihkan", nil)
	}
}
func (a *API) ForcePD(c *gin.Context) {
	id, ok := idParam(c)
	if ok {
		if err := a.Service.DeletePD(c, id, true); err != nil {
			writeError(c, err)
			return
		}
		httpx.Success(c, 200, "Perangkat daerah dihapus permanen", nil)
	}
}

func (a *API) ListPegawai(c *gin.Context) {
	rows, err := a.Service.ListPegawai(c, c.Query("search"), false)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Daftar pegawai", rows)
}
func (a *API) TrashPegawai(c *gin.Context) {
	rows, err := a.Service.ListPegawai(c, c.Query("search"), true)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Trash pegawai", rows)
}
func (a *API) SavePegawai(c *gin.Context) {
	var req dto.PegawaiRequest
	if !bind(c, &req) {
		return
	}
	row, err := a.Service.SavePegawai(c, 0, req)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 201, "Pegawai berhasil disimpan", row)
}
func (a *API) UpdatePegawai(c *gin.Context) {
	id, ok := idParam(c)
	if !ok {
		return
	}
	var req dto.PegawaiRequest
	if !bind(c, &req) {
		return
	}
	row, err := a.Service.SavePegawai(c, id, req)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Pegawai berhasil diubah", row)
}
func (a *API) GetPegawai(c *gin.Context) {
	id, ok := idParam(c)
	if !ok {
		return
	}
	rows, err := a.Service.ListPegawai(c, "", false)
	if err != nil {
		writeError(c, err)
		return
	}
	for _, row := range rows {
		if row.ID == id {
			httpx.Success(c, 200, "Detail pegawai", row)
			return
		}
	}
	writeError(c, service.ErrNotFound)
}
func (a *API) DeletePegawai(c *gin.Context) {
	id, ok := idParam(c)
	if ok {
		if err := a.Service.DeletePegawai(c, id, false); err != nil {
			writeError(c, err)
			return
		}
		httpx.Success(c, 200, "Pegawai dipindahkan ke trash", nil)
	}
}
func (a *API) RestorePegawai(c *gin.Context) {
	id, ok := idParam(c)
	if ok {
		if err := a.Service.RestorePegawai(c, id); err != nil {
			writeError(c, err)
			return
		}
		httpx.Success(c, 200, "Pegawai dipulihkan", nil)
	}
}
func (a *API) ForcePegawai(c *gin.Context) {
	id, ok := idParam(c)
	if ok {
		if err := a.Service.DeletePegawai(c, id, true); err != nil {
			writeError(c, err)
			return
		}
		httpx.Success(c, 200, "Pegawai dihapus permanen", nil)
	}
}

func (a *API) ListKendaraan(c *gin.Context) {
	rows, err := a.Service.ListKendaraan(c, c.Query("search"), false)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Daftar kendaraan", rows)
}
func (a *API) TrashKendaraan(c *gin.Context) {
	rows, err := a.Service.ListKendaraan(c, c.Query("search"), true)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Trash kendaraan", rows)
}
func (a *API) SaveKendaraan(c *gin.Context) {
	var req dto.KendaraanRequest
	if !bind(c, &req) {
		return
	}
	row, err := a.Service.SaveKendaraan(c, 0, req)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 201, "Kendaraan berhasil disimpan", row)
}
func (a *API) UpdateKendaraan(c *gin.Context) {
	id, ok := idParam(c)
	if !ok {
		return
	}
	var req dto.KendaraanRequest
	if !bind(c, &req) {
		return
	}
	row, err := a.Service.SaveKendaraan(c, id, req)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Kendaraan berhasil diubah", row)
}
func (a *API) GetKendaraan(c *gin.Context) {
	id, ok := idParam(c)
	if !ok {
		return
	}
	rows, err := a.Service.ListKendaraan(c, "", false)
	if err != nil {
		writeError(c, err)
		return
	}
	for _, row := range rows {
		if row.ID == id {
			httpx.Success(c, 200, "Detail kendaraan", row)
			return
		}
	}
	writeError(c, service.ErrNotFound)
}
func (a *API) DeleteKendaraan(c *gin.Context) {
	id, ok := idParam(c)
	if ok {
		if err := a.Service.DeleteKendaraan(c, id, false); err != nil {
			writeError(c, err)
			return
		}
		httpx.Success(c, 200, "Kendaraan dipindahkan ke trash", nil)
	}
}
func (a *API) RestoreKendaraan(c *gin.Context) {
	id, ok := idParam(c)
	if ok {
		if err := a.Service.RestoreKendaraan(c, id); err != nil {
			writeError(c, err)
			return
		}
		httpx.Success(c, 200, "Kendaraan dipulihkan", nil)
	}
}
func (a *API) ForceKendaraan(c *gin.Context) {
	id, ok := idParam(c)
	if ok {
		if err := a.Service.DeleteKendaraan(c, id, true); err != nil {
			writeError(c, err)
			return
		}
		httpx.Success(c, 200, "Kendaraan dihapus permanen", nil)
	}
}

func (a *API) ListPenugasan(c *gin.Context) {
	rows, err := a.Service.ListPenugasan(c, false)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Daftar penugasan", rows)
}
func (a *API) SavePenugasan(c *gin.Context) {
	var req dto.PenugasanRequest
	if !bind(c, &req) {
		return
	}
	row, err := a.Service.SavePenugasan(c, 0, req)
	if err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 201, "Penugasan berhasil disimpan", row)
}
func (a *API) FinishPenugasan(c *gin.Context) {
	id, ok := idParam(c)
	if !ok {
		return
	}
	var req struct {
		TanggalSelesai string `json:"tanggal_selesai"`
	}
	if !bind(c, &req) {
		return
	}
	if err := a.Service.FinishPenugasan(c, id, req.TanggalSelesai); err != nil {
		writeError(c, err)
		return
	}
	httpx.Success(c, 200, "Penugasan selesai", nil)
}
func (a *API) DeletePenugasan(c *gin.Context) {
	id, ok := idParam(c)
	if ok {
		if err := a.Service.DeletePenugasan(c, id); err != nil {
			writeError(c, err)
			return
		}
		httpx.Success(c, 200, "Penugasan dihapus", nil)
	}
}
