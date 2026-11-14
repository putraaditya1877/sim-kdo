import { Building2, Car, LayoutDashboard, Users } from 'lucide-react'
import { type SidebarData } from '../types'

export const sidebarData: SidebarData = {
  user: {
    name: 'Pengguna SIM-KDO',
    email: 'admin@simkdo.test',
    avatar: '/avatars/shadcn.jpg',
  },
  teams: [],
  navGroups: [
    {
      title: 'SIM-KDO',
      items: [
        {
          title: 'Dashboard',
          url: '/',
          icon: LayoutDashboard,
        },
        {
          title: 'Kendaraan',
          url: '/kendaraan',
          icon: Car,
        },
        {
          title: 'Perangkat Daerah',
          url: '/perangkat-daerah',
          icon: Building2,
        },
        {
          title: 'Pegawai',
          url: '/pegawai',
          icon: Users,
        },
      ],
    },
  ],
}
