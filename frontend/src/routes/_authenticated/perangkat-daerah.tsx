import { useState } from 'react'
import { createFileRoute } from '@tanstack/react-router'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { toast } from 'sonner'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { api } from '@/lib/api'

export const Route = createFileRoute('/_authenticated/perangkat-daerah')({ component: PerangkatDaerahPage })
type PD = { id: number; kode: string; nama: string; singkatan: string; jenis: string; alamat: string; telepon: string; email: string }

function PerangkatDaerahPage() {
  const client = useQueryClient(); const [form, setForm] = useState<Partial<PD>>({ jenis: 'dinas' }); const [editing, setEditing] = useState<number | null>(null)
  const query = useQuery({ queryKey: ['pd'], queryFn: () => api<PD[]>('/perangkat-daerah') })
  const save = useMutation({ mutationFn: (value: PD) => api(`/perangkat-daerah${editing ? `/${editing}` : ''}`, { method: editing ? 'PUT' : 'POST', body: JSON.stringify(value) }), onSuccess: () => { toast.success('Perangkat daerah tersimpan'); setEditing(null); setForm({ jenis: 'dinas' }); void client.invalidateQueries({ queryKey: ['pd'] }) }, onError: (e) => toast.error(e.message) })
  const remove = useMutation({ mutationFn: (id: number) => api(`/perangkat-daerah/${id}`, { method: 'DELETE' }), onSuccess: () => { toast.success('Perangkat daerah dihapus'); void client.invalidateQueries({ queryKey: ['pd'] }) } })
  const set = (key: keyof PD, value: string) => setForm((old) => ({ ...old, [key]: value }))
  return <div className='space-y-4 p-6'><h1 className='text-2xl font-bold'>Perangkat Daerah</h1><Card><CardHeader><CardTitle>{editing ? 'Ubah perangkat daerah' : 'Tambah perangkat daerah'}</CardTitle></CardHeader><CardContent><div className='grid gap-3 md:grid-cols-3'>{[['kode', 'Kode'], ['nama', 'Nama'], ['singkatan', 'Singkatan'], ['jenis', 'Jenis'], ['alamat', 'Alamat'], ['telepon', 'Telepon'], ['email', 'Email']].map(([key, label]) => <Input key={key} placeholder={label} value={String(form[key as keyof PD] ?? '')} onChange={(e) => set(key as keyof PD, e.target.value)} />)}</div><div className='mt-3 flex gap-2'><Button onClick={() => save.mutate(form as PD)}>Simpan</Button>{editing && <Button variant='outline' onClick={() => { setEditing(null); setForm({ jenis: 'dinas' }) }}>Batal</Button>}</div></CardContent></Card><Card><CardHeader><CardTitle>Daftar aktif</CardTitle></CardHeader><CardContent className='space-y-2'>{(query.data ?? []).map((row) => <div className='flex items-center justify-between rounded border p-3' key={row.id}><div><b>{row.kode}</b> · {row.nama}<p className='text-sm text-muted-foreground'>{row.jenis}</p></div><div className='flex gap-2'><Button size='sm' variant='outline' onClick={() => { setEditing(row.id); setForm(row) }}>Ubah</Button><Button size='sm' variant='destructive' onClick={() => remove.mutate(row.id)}>Hapus</Button></div></div>)}</CardContent></Card></div>
}
