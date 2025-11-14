import { ref, Ref } from 'vue'

interface ApiState<T> {
  data: Ref<T | null>
  loading: Ref<boolean>
  error: Ref<string | null>
}

interface UseApiReturn<T> extends ApiState<T> {
  execute: (url: string, options?: RequestInit) => Promise<T | null>
  reset: () => void
}

/**
 * Composable for making API requests with reactive state
 * @returns Object with data, loading, error state and execute function
 */
export function useApi<T = any>(): UseApiReturn<T> {
  const data = ref<T | null>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)

  const execute = async (url: string, options?: RequestInit): Promise<T | null> => {
    loading.value = true
    error.value = null
    data.value = null

    try {
      const response = await fetch(url, {
        headers: {
          'Content-Type': 'application/json',
          ...options?.headers,
        },
        ...options,
      })

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }

      const result = await response.json()
      data.value = result
      return result
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'An error occurred'
      return null
    } finally {
      loading.value = false
    }
  }

  const reset = () => {
    data.value = null
    loading.value = false
    error.value = null
  }

  return {
    data,
    loading,
    error,
    execute,
    reset,
  }
}