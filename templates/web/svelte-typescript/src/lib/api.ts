import axios, { type AxiosInstance } from 'axios';

// Create axios instance with defaults
const api: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
});

// Request interceptor for auth
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Handle unauthorized access
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// API methods
export const apiClient = {
  // Auth
  login: (email: string, password: string) =>
    api.post('/auth/login', { email, password }),

  register: (data: { email: string; password: string; name: string }) =>
    api.post('/auth/register', data),

  logout: () => api.post('/auth/logout'),

  // Users
  getProfile: () => api.get('/users/profile'),

  updateProfile: (data: Partial<{ name: string; email: string }>) =>
    api.put('/users/profile', data),

  // Generic CRUD operations
  getAll: (resource: string) => api.get(`/${resource}`),

  getOne: (resource: string, id: string) => api.get(`/${resource}/${id}`),

  create: (resource: string, data: any) => api.post(`/${resource}`, data),

  update: (resource: string, id: string, data: any) =>
    api.put(`/${resource}/${id}`, data),

  delete: (resource: string, id: string) => api.delete(`/${resource}/${id}`)
};

export default api;