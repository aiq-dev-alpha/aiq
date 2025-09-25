import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useCounterStore = defineStore('counter', () => {
  // State
  const count = ref(0)

  // Getters
  const doubleCount = computed(() => count.value * 2)
  const isEven = computed(() => count.value % 2 === 0)

  // Actions
  function increment() {
    count.value++
  }

  function decrement() {
    count.value--
  }

  function incrementBy(amount: number) {
    count.value += amount
  }

  function reset() {
    count.value = 0
  }

  return {
    count,
    doubleCount,
    isEven,
    increment,
    decrement,
    incrementBy,
    reset,
  }
}, {
  persist: {
    key: 'vue-counter',
    storage: localStorage,
  },
})