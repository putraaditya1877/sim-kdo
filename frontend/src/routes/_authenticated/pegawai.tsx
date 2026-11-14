import { useState } from 'react'
import { createFileRoute } from '@tanstack/react-router'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { toast } from 'sonner'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { api } from '@/lib/api'

export const Route = createFileRoute('/_authenticated/pegawai')({ component: PegawaiPage })
type Pegawai = { id: number; nip: string; nama: string; jabatan: string; golongan_id: number; perangkat_daerah_id: number; jenis_kelamin: string; email: string; no_hp: string }

function PegawaiPage() {
  const client = useQueryClient(); const [form, setForm] = useState<Partial<Pegawai>>({ jenis_kelamin: 'L', golongan_id: 9, perangkat_daerah_id: 1 }); const [editing, setEditing] = useState<number | null>(null)
  const query = useQuery({ queryKey: ['pegawai'], queryFn: () => api<Pegawai[]>('/pegawai') })
  const save = useMutation({ mutationFn: (value: Pegawai) => api(`/pegawai${editing ? `/${editing}` : ''}`, { method: editing ? 'PUT' : 'POST', body: JSON.stringify(value) }), onSuccess: () => { toast.success('Pegawai tersimpan'); setEditing(null); setForm({ jenis_kelamin: 'L', golongan_id: 9, perangkat_daerah_id: 1 }); void client.invalidateQueries({ queryKey: ['pegawai'] }) }, onError: (e) => toast.error(e.message) })
  const remove = useMutation({ mutationFn: (id: number) => api(`/pegawai/${id}`, { method: 'DELETE' }), onSuccess: () => { toast.success('Pegawai dihapus'); void client.invalidateQueries({ queryKey: ['pegawai'] }) } })
  const set = (key: keyof Pegawai, value: string) => setForm((old) => ({ ...old, [key]: ['golongan_id', 'perangkat_daerah_id'].includes(key) ? Number(value) : value }))
  return <div className='space-y-4 p-6'><h1 className='text-2xl font-bold'>Pegawai</h1><Card><CardHeader><CardTitle>{editing ? 'Ubah pegawai' : 'Tambah pegawai'}</CardTitle></CardHeader><CardContent><div className='grid gap-3 md:grid-cols-3'>{[['nip', 'NIP 18 digit'], ['nama', 'Nama'], ['jabatan', 'Jabatan'], ['golongan_id', 'ID golongan'], ['perangkat_daerah_id', 'ID perangkat daerah'], ['jenis_kelamin', 'Jenis kelamin L/P'], ['email', 'Email'], ['no_hp', 'No. HP']].map(([key, label]) => <Input key={key} placeholder={label} value={String(form[key as keyof Pegawai] ?? '')} onChange={(e) => set(key as keyof Pegawai, e.target.value)} />)}</div><div className='mt-3 flex gap-2'><Button onClick={() => save.mutate(form as Pegawai)}>Simpan</Button>{editing && <Button variant='outline' onClick={() => { setEditing(null); setForm({ jenis_kelamin: 'L', golongan_id: 9, perangkat_daerah_id: 1 }) }}>Batal</Button>}</div></CardContent></Card><Card><CardHeader><CardTitle>Daftar aktif</CardTitle></CardHeader><CardContent className='space-y-2'>{(query.data ?? []).map((row) => <div className='flex items-center justify-between rounded border p-3' key={row.id}><div><b>{row.nama}</b> · {row.nip}<p className='text-sm text-muted-foreground'>{row.jabatan}</p></div><div className='flex gap-2'><Button size='sm' variant='outline' onClick={() => { setEditing(row.id); setForm(row) }}>Ubah</Button><Button size='sm' variant='destructive' onClick={() => remove.mutate(row.id)}>Hapus</Button></div></div>)}</CardContent></Card></div>
}
