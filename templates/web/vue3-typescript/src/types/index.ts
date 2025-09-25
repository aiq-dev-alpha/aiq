// Common types used throughout the application

export interface User {
  id: string
  name: string
  email: string
  avatar?: string
  createdAt: string
  updatedAt: string
}

export interface ApiResponse<T> {
  data: T
  message: string
  status: 'success' | 'error'
  timestamp: string
}

export interface NavigationItem {
  path: string
  label: string
  icon?: string
  children?: NavigationItem[]
}

export interface FormField {
  name: string
  type: 'text' | 'email' | 'password' | 'textarea' | 'select'
  label: string
  placeholder?: string
  required?: boolean
  options?: Array<{ value: string; label: string }>
}

export interface Theme {
  mode: 'light' | 'dark'
  primary: string
  secondary: string
}

// Component props types
export interface BaseComponentProps {
  class?: string
}

export interface ButtonProps extends BaseComponentProps {
  variant?: 'primary' | 'secondary' | 'danger'
  size?: 'sm' | 'md' | 'lg'
  disabled?: boolean
  loading?: boolean
}

export interface ModalProps extends BaseComponentProps {
  isOpen: boolean
  title?: string
}

// Utility types
export type Optional<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>
export type RequiredFields<T, K extends keyof T> = T & Required<Pick<T, K>>

// Error types
export interface AppError {
  code: string
  message: string
  details?: Record<string, unknown>
}

// Router meta types
declare module 'vue-router' {
  interface RouteMeta {
    title?: string
    requiresAuth?: boolean
    roles?: string[]
  }
}