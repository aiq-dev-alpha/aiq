import { ref, watch, Ref } from 'vue'

/**
 * Reactive localStorage composable
 * @param key - The localStorage key
 * @param defaultValue - Default value if key doesn't exist
 * @returns Object with reactive value and setter function
 */
export function useLocalStorage<T>(
  key: string,
  defaultValue: T
): { value: Ref<T>; setValue: (newValue: T) => void } {
  // Get initial value from localStorage or use default
  const storedValue = localStorage.getItem(key)
  const initialValue = storedValue ? JSON.parse(storedValue) : defaultValue

  // Create reactive reference
  const value = ref<T>(initialValue)

  // Watch for changes and update localStorage
  watch(
    value,
    (newValue) => {
      try {
        localStorage.setItem(key, JSON.stringify(newValue))
      } catch (error) {
        console.error(`Error setting localStorage key "${key}":`, error)
      }
    },
    { deep: true }
  )

  // Listen for storage events (changes from other tabs)
  window.addEventListener('storage', (e) => {
    if (e.key === key && e.newValue !== null) {
      try {
        value.value = JSON.parse(e.newValue)
      } catch (error) {
        console.error(`Error parsing localStorage key "${key}":`, error)
      }
    }
  })

  const setValue = (newValue: T) => {
    value.value = newValue
  }

  return {
    value,
    setValue,
  }
}