import { createFileRoute, Link, useParams } from '@tanstack/react-router'
import { useQuery } from '@tanstack/react-query'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { api } from '@/lib/api'

export const Route = createFileRoute('/_authenticated/kendaraan/$id')({ component: KendaraanDetailPage })

type Kendaraan = {
  id: number; nomor_polisi: string; merk: string; tipe: string; kondisi: string; tahun_produksi: number; perangkat_daerah_id: number
  nomor_rangka: string; nomor_mesin: string; kode_barang: string; nomor_register: string; jenis: string; warna: string; bahan_bakar: string
  isi_silinder: number; tanggal_perolehan: string; nilai_perolehan: number; masa_berlaku_stnk: string; jatuh_tempo_pajak: string; keterangan: string
}

const fields: Array<[keyof Kendaraan, string]> = [
  ['nomor_polisi', 'Nomor polisi'], ['merk', 'Merk'], ['tipe', 'Tipe'], ['kondisi', 'Kondisi'], ['tahun_produksi', 'Tahun produksi'],
  ['jenis', 'Jenis'], ['warna', 'Warna'], ['bahan_bakar', 'Bahan bakar'], ['isi_silinder', 'Isi silinder'], ['nomor_rangka', 'Nomor rangka'],
  ['nomor_mesin', 'Nomor mesin'], ['kode_barang', 'Kode barang'], ['nomor_register', 'Nomor register'], ['perangkat_daerah_id', 'ID perangkat daerah'],
  ['tanggal_perolehan', 'Tanggal perolehan'], ['nilai_perolehan', 'Nilai perolehan'], ['masa_berlaku_stnk', 'Masa berlaku STNK'],
  ['jatuh_tempo_pajak', 'Jatuh tempo pajak'], ['keterangan', 'Keterangan'],
]

function KendaraanDetailPage() {
  const { id } = useParams({ from: '/_authenticated/kendaraan/$id' })
  const query = useQuery({ queryKey: ['kendaraan', id], queryFn: () => api<Kendaraan>(`/kendaraan/${id}`) })
  if (query.isLoading) return <div className='p-6'>Memuat detail kendaraan...</div>
  if (query.isError || !query.data) return <div className='p-6 text-destructive'>Detail kendaraan tidak ditemukan.</div>
  const kendaraan = query.data
  return <div className='space-y-4 p-6'><div className='flex items-center justify-between gap-3'><div><h1 className='text-2xl font-bold'>Detail kendaraan</h1><p className='text-muted-foreground'>{kendaraan.nomor_polisi} · {kendaraan.merk} {kendaraan.tipe}</p></div><Button asChild variant='outline'><Link to='/kendaraan'>Kembali</Link></Button></div><Card><CardHeader><CardTitle>Informasi kendaraan</CardTitle></CardHeader><CardContent className='grid gap-4 sm:grid-cols-2 lg:grid-cols-3'>{fields.map(([key, label]) => <div key={key} className='rounded border p-3'><p className='text-sm text-muted-foreground'>{label}</p><p className='font-medium'>{String(kendaraan[key] ?? '-')}</p></div>)}</CardContent></Card></div>
}
