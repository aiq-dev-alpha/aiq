import axios, { AxiosError, AxiosResponse } from 'axios'
import { store } from '@store/index'
import { logout } from '@store/slices/authSlice'

const API_URL = import.meta.env.VITE_API_URL || '/api'

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Request interceptor
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => Promise.reject(error)
)

// Response interceptor
api.interceptors.response.use(
  (response: AxiosResponse) => response,
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      store.dispatch(logout())
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export const authService = {
  login: (email: string, password: string) =>
    api.post('/auth/login', { email, password }),

  register: (data: { email: string; password: string; name: string }) =>
    api.post('/auth/register', data),

  logout: () => api.post('/auth/logout'),

  getCurrentUser: () => api.get('/auth/me'),
}

export const postsService = {
  getAll: (params?: { page?: number; limit?: number }) =>
    api.get('/posts', { params }),

  getById: (id: string) => api.get(`/posts/${id}`),

  create: (data: { title: string; content: string }) =>
    api.post('/posts', data),

  update: (id: string, data: { title?: string; content?: string }) =>
    api.put(`/posts/${id}`, data),

  delete: (id: string) => api.delete(`/posts/${id}`),
}

export default api