import { useMemo, useState } from 'react'
import { createFileRoute } from '@tanstack/react-router'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { toast } from 'sonner'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { api } from '@/lib/api'

export const Route = createFileRoute('/_authenticated/kendaraan')({ component: KendaraanPage })

type Kendaraan = {
  id: number
  nomor_polisi: string
  merk: string
  tipe: string
  kondisi: string
  tahun_produksi: number
  perangkat_daerah_id: number
  nomor_rangka: string
  nomor_mesin: string
  kode_barang: string
  nomor_register: string
  jenis: string
  warna: string
  bahan_bakar: string
  isi_silinder: number
  tanggal_perolehan: string
  nilai_perolehan: number
  masa_berlaku_stnk: string
  jatuh_tempo_pajak: string
  keterangan: string
}

const emptyForm: Partial<Kendaraan> = { nomor_polisi: '', merk: '', tipe: '', kondisi: 'baik', tahun_produksi: 2024, perangkat_daerah_id: 1, kode_barang: '1.3.2.02.01.01.999', nomor_register: 'REG-FE', nomor_rangka: 'RANGKA-FE', nomor_mesin: 'MESIN-FE', jenis: 'roda_4', warna: 'Hitam', bahan_bakar: 'bensin', isi_silinder: 1496, tanggal_perolehan: '2024-01-01', nilai_perolehan: 0, masa_berlaku_stnk: '2027-01-01', jatuh_tempo_pajak: '2026-12-31', keterangan: '' }

function KendaraanPage() {
  const queryClient = useQueryClient()
  const [search, setSearch] = useState('')
  const [page, setPage] = useState(1)
  const [trash, setTrash] = useState(false)
  const [form, setForm] = useState<Partial<Kendaraan>>(emptyForm)
  const [editing, setEditing] = useState<number | null>(null)
  const query = useQuery({ queryKey: ['kendaraan', search, trash], queryFn: () => api<Kendaraan[]>(`/kendaraan${trash ? '/trash' : `?search=${encodeURIComponent(search)}`}`) })
  const rows = useMemo(() => (query.data ?? []).filter((row) => row.nomor_polisi.toLowerCase().includes(search.toLowerCase())), [query.data, search])
  const pageRows = rows.slice((page - 1) * 10, page * 10)
  const save = useMutation({ mutationFn: (payload: Kendaraan) => api<Kendaraan>(editing ? `/kendaraan/${editing}` : '/kendaraan', { method: editing ? 'PUT' : 'POST', body: JSON.stringify(payload) }), onSuccess: () => { toast.success('Kendaraan tersimpan'); setForm(emptyForm); setEditing(null); void queryClient.invalidateQueries({ queryKey: ['kendaraan'] }) }, onError: (error) => toast.error(error.message) })
  const remove = useMutation({ mutationFn: (id: number) => api(`/kendaraan/${id}`, { method: 'DELETE' }), onSuccess: () => { toast.success('Kendaraan dipindahkan ke trash'); void queryClient.invalidateQueries({ queryKey: ['kendaraan'] }) } })
  const restore = useMutation({ mutationFn: (id: number) => api(`/kendaraan/${id}/restore`, { method: 'PATCH' }), onSuccess: () => { toast.success('Kendaraan dipulihkan'); void queryClient.invalidateQueries({ queryKey: ['kendaraan'] }) } })
  const force = useMutation({ mutationFn: (id: number) => api(`/kendaraan/${id}/force`, { method: 'DELETE' }), onSuccess: () => { toast.success('Kendaraan dihapus permanen'); void queryClient.invalidateQueries({ queryKey: ['kendaraan'] }) } })
  const set = (key: keyof Kendaraan, value: string) => setForm((current) => ({ ...current, [key]: ['tahun_produksi', 'perangkat_daerah_id', 'isi_silinder', 'nilai_perolehan'].includes(key) ? Number(value) : value }))

  return <div className='space-y-4 p-6'><div className='flex items-center justify-between'><div><h1 className='text-2xl font-bold'>Kendaraan</h1><p className='text-muted-foreground'>Kelola data kendaraan dinas operasional.</p></div><Button variant={trash ? 'default' : 'outline'} onClick={() => { setTrash(!trash); setPage(1) }}>{trash ? 'Kembali ke aktif' : 'Buka trash'}</Button></div><Card><CardHeader><CardTitle>{editing ? 'Ubah kendaraan' : 'Tambah kendaraan'}</CardTitle></CardHeader><CardContent><div className='grid gap-3 md:grid-cols-4'>{[['nomor_polisi', 'Nomor polisi'], ['merk', 'Merk'], ['tipe', 'Tipe'], ['tahun_produksi', 'Tahun'], ['tanggal_perolehan', 'Tanggal perolehan'], ['masa_berlaku_stnk', 'Masa STNK'], ['jatuh_tempo_pajak', 'Jatuh tempo pajak'], ['nomor_rangka', 'Nomor rangka'], ['nomor_mesin', 'Nomor mesin']].map(([key, label]) => <Input key={key} placeholder={label} type={key.includes('tanggal') || key.includes('masa') || key.includes('jatuh') ? 'date' : 'text'} value={String(form[key as keyof Kendaraan] ?? '')} onChange={(event) => set(key as keyof Kendaraan, event.target.value)} />)}</div><div className='mt-3 flex gap-2'><Button onClick={() => save.mutate(form as Kendaraan)} disabled={save.isPending}>{editing ? 'Simpan perubahan' : 'Tambah kendaraan'}</Button>{editing && <Button variant='outline' onClick={() => { setEditing(null); setForm(emptyForm) }}>Batal</Button>}</div></CardContent></Card><Card><CardHeader><div className='flex gap-2'><Input placeholder='Cari nomor polisi' value={search} onChange={(event) => { setSearch(event.target.value); setPage(1) }} /><span className='py-2 text-sm text-muted-foreground'>{rows.length} data</span></div></CardHeader><CardContent><div className='space-y-2'>{pageRows.map((row) => <div key={row.id} className='flex flex-wrap items-center justify-between gap-2 rounded border p-3'><div><p className='font-medium'>{row.nomor_polisi} · {row.merk} {row.tipe}</p><p className='text-sm text-muted-foreground'>{row.kondisi} · {row.tahun_produksi}</p></div><div className='flex gap-2'>{trash ? <><Button size='sm' onClick={() => restore.mutate(row.id)}>Pulihkan</Button><Button size='sm' variant='destructive' onClick={() => force.mutate(row.id)}>Hapus permanen</Button></> : <><Button size='sm' variant='outline' onClick={() => { setEditing(row.id); setForm(row) }}>Ubah</Button><Button size='sm' variant='destructive' onClick={() => remove.mutate(row.id)}>Hapus</Button></>}</div></div>)}</div><div className='mt-4 flex justify-between'><Button variant='outline' disabled={page === 1} onClick={() => setPage(page - 1)}>Sebelumnya</Button><span className='py-2 text-sm'>Halaman {page}</span><Button variant='outline' disabled={page * 10 >= rows.length} onClick={() => setPage(page + 1)}>Berikutnya</Button></div></CardContent></Card></div>
}
