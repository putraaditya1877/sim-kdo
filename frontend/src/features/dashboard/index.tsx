import { useQuery } from '@tanstack/react-query'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { api } from '@/lib/api'

type DashboardData = {
  total_kendaraan: number
  baik: number
  rusak_ringan: number
  rusak_berat: number
  penugasan_aktif: number
}

export function Dashboard() {
  const query = useQuery({ queryKey: ['dashboard'], queryFn: () => api<DashboardData>('/dashboard') })
  const data = query.data
  const cards = [
    ['Total kendaraan', data?.total_kendaraan],
    ['Kondisi baik', data?.baik],
    ['Rusak ringan', data?.rusak_ringan],
    ['Rusak berat', data?.rusak_berat],
    ['Penugasan aktif', data?.penugasan_aktif],
  ] as const
  const kondisi = [
    ['Baik', data?.baik ?? 0, 'bg-emerald-500'],
    ['Rusak ringan', data?.rusak_ringan ?? 0, 'bg-amber-500'],
    ['Rusak berat', data?.rusak_berat ?? 0, 'bg-red-500'],
  ] as const

  return <div className='space-y-6 p-6'><div><h1 className='text-2xl font-bold'>Dashboard SIM-KDO</h1><p className='text-muted-foreground'>Ringkasan kendaraan dinas operasional.</p></div><div className='grid gap-4 sm:grid-cols-2 lg:grid-cols-5'>{cards.map(([title, value]) => <Card key={title}><CardHeader><CardTitle className='text-sm'>{title}</CardTitle></CardHeader><CardContent><div className='text-3xl font-bold'>{query.isLoading ? '...' : value ?? 0}</div></CardContent></Card>)}</div><Card><CardHeader><CardTitle>Komposisi kondisi kendaraan</CardTitle></CardHeader><CardContent><div className='space-y-3'>{kondisi.map(([label, value, color]) => <div key={label} className='flex items-center gap-3'><span className={`h-3 w-3 rounded-full ${color}`} /><span className='w-32'>{label}</span><div className='h-3 flex-1 rounded bg-muted'><div className={`h-3 rounded ${color}`} style={{ width: `${data?.total_kendaraan ? (value / data.total_kendaraan) * 100 : 0}%` }} /></div><span>{value}</span></div>)}</div></CardContent></Card></div>
}
