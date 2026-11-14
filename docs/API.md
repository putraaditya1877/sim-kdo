# API SIM-KDO

Dokumentasi endpoint akan dilengkapi setelah API selesai dibangun dan diuji.

Base URL: `/api/v1`.

## Health

`GET /api/v1/health` tidak memerlukan autentikasi dan memeriksa koneksi PostgreSQL.

Respons sehat:

```json
{"success":true,"message":"API dan database sehat","data":{"api":"up","db":"up"}}
```
