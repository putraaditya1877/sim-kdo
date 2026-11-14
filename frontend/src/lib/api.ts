import { useAuthStore } from '@/stores/auth-store'

const API_BASE = import.meta.env.VITE_API_URL ?? '/api/v1'

export async function api<T>(path: string, options: RequestInit = {}): Promise<T> {
  const token = useAuthStore.getState().auth.accessToken
  const response = await fetch(`${API_BASE}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
  })
  const body = (await response.json()) as { success: boolean; message: string; data: T }
  if (!response.ok || !body.success) throw new Error(body.message)
  return body.data
}
