<template>
  <div class="max-w-4xl mx-auto">
    <div class="text-center mb-12">
      <h1 class="text-4xl font-bold text-gray-900 dark:text-white mb-4">
        Welcome to Vue 3 TypeScript Starter
      </h1>
      <p class="text-xl text-gray-600 dark:text-gray-300">
        A modern, fully-featured starter template with Composition API, Pinia, and more!
      </p>
    </div>

    <div class="grid md:grid-cols-2 gap-8">
      <!-- Counter Demo -->
      <div class="card">
        <h2 class="text-2xl font-semibold mb-4 text-gray-800 dark:text-gray-200">
          State Management Demo (Pinia)
        </h2>
        <div class="text-center">
          <div class="text-4xl font-bold text-primary-600 mb-4">
            {{ counterStore.count }}
          </div>
          <div class="space-x-3">
            <button
              class="btn btn-primary"
              @click="counterStore.increment"
            >
              Increment
            </button>
            <button
              class="btn btn-secondary"
              @click="counterStore.decrement"
            >
              Decrement
            </button>
            <button
              class="btn bg-gray-600 hover:bg-gray-700 text-white"
              @click="counterStore.reset"
            >
              Reset
            </button>
          </div>
        </div>
      </div>

      <!-- Form Demo -->
      <div class="card">
        <h2 class="text-2xl font-semibold mb-4 text-gray-800 dark:text-gray-200">
          Composable Demo (useLocalStorage)
        </h2>
        <form @submit.prevent="handleSubmit" class="space-y-4">
          <div>
            <label for="name" class="form-label">
              Your Name
            </label>
            <input
              id="name"
              v-model="name"
              type="text"
              class="form-input"
              placeholder="Enter your name"
            />
          </div>
          <button
            type="submit"
            class="w-full btn btn-primary"
          >
            Say Hello
          </button>
        </form>
        <div
          v-if="message"
          class="mt-4 p-3 bg-green-100 dark:bg-green-800 text-green-800 dark:text-green-200 rounded-md"
        >
          {{ message }}
        </div>
      </div>
    </div>

    <!-- Features Section -->
    <div class="mt-12">
      <h2 class="text-3xl font-bold text-center mb-8 text-gray-900 dark:text-white">
        Features Included
      </h2>
      <div class="grid md:grid-cols-3 gap-6">
        <div
          v-for="(feature, index) in features"
          :key="index"
          class="card text-center"
        >
          <div class="text-primary-600 text-4xl mb-4">{{ feature.icon }}</div>
          <h3 class="text-lg font-semibold mb-2 text-gray-800 dark:text-gray-200">
            {{ feature.title }}
          </h3>
          <p class="text-gray-600 dark:text-gray-400">{{ feature.description }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useCounterStore } from '@/stores/counter'
import { useLocalStorage } from '@/composables/useLocalStorage'

interface Feature {
  icon: string
  title: string
  description: string
}

const counterStore = useCounterStore()
const { value: name, setValue: setName } = useLocalStorage('userName', '')
const message = ref('')

const features: Feature[] = [
  {
    icon: '⚡',
    title: 'Vue 3 + TypeScript',
    description: 'Latest Vue 3 with full TypeScript support and Composition API'
  },
  {
    icon: '🎨',
    title: 'Tailwind CSS',
    description: 'Utility-first CSS framework for rapid UI development'
  },
  {
    icon: '🛣️',
    title: 'Vue Router',
    description: 'Official router for Vue.js with code-splitting support'
  },
  {
    icon: '🍍',
    title: 'Pinia',
    description: 'The Vue Store that you will enjoy using'
  },
  {
    icon: '🧪',
    title: 'Vitest',
    description: 'Blazing fast unit testing framework'
  },
  {
    icon: '🔧',
    title: 'Development Tools',
    description: 'ESLint, Prettier, and Vite for optimal DX'
  },
]

const handleSubmit = () => {
  if (name.value.trim()) {
    message.value = `Hello, ${name.value}! Welcome to our Vue 3 TypeScript starter.`
  }
}
</script>