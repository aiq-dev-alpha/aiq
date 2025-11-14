<template>
  <nav class="bg-white dark:bg-gray-800 shadow-lg">
    <div class="container mx-auto px-4">
      <div class="flex justify-between items-center py-4">
        <RouterLink
          to="/"
          class="text-2xl font-bold text-primary-600 dark:text-primary-400 no-underline"
        >
          Vue 3 TS Starter
        </RouterLink>

        <!-- Desktop Navigation -->
        <div class="hidden md:flex space-x-8">
          <RouterLink
            v-for="link in navLinks"
            :key="link.path"
            :to="link.path"
            :class="[
              'px-3 py-2 rounded-md text-sm font-medium transition-colors duration-200 no-underline',
              isActive(link.path)
                ? 'bg-primary-100 text-primary-700 dark:bg-primary-900 dark:text-primary-200'
                : 'text-gray-700 hover:text-primary-600 dark:text-gray-300 dark:hover:text-primary-400'
            ]"
          >
            {{ link.label }}
          </RouterLink>
        </div>

        <!-- Mobile menu button -->
        <button
          class="md:hidden p-2 rounded-md text-gray-600 hover:text-primary-600"
          @click="toggleMobileMenu"
        >
          <svg
            class="h-6 w-6"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              v-if="!isMobileMenuOpen"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4 6h16M4 12h16M4 18h16"
            />
            <path
              v-else
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>
      </div>

      <!-- Mobile Navigation -->
      <div v-show="isMobileMenuOpen" class="md:hidden pb-4">
        <RouterLink
          v-for="link in navLinks"
          :key="link.path"
          :to="link.path"
          :class="[
            'block px-3 py-2 rounded-md text-base font-medium transition-colors duration-200 no-underline',
            isActive(link.path)
              ? 'bg-primary-100 text-primary-700 dark:bg-primary-900 dark:text-primary-200'
              : 'text-gray-700 hover:text-primary-600 dark:text-gray-300 dark:hover:text-primary-400'
          ]"
          @click="closeMobileMenu"
        >
          {{ link.label }}
        </RouterLink>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { RouterLink, useRoute } from 'vue-router'

interface NavLink {
  path: string
  label: string
}

const route = useRoute()
const isMobileMenuOpen = ref(false)

const navLinks: NavLink[] = [
  { path: '/', label: 'Home' },
  { path: '/about', label: 'About' },
  { path: '/contact', label: 'Contact' },
]

const isActive = (path: string) => {
  return computed(() => route.path === path).value
}

const toggleMobileMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value
}

const closeMobileMenu = () => {
  isMobileMenuOpen.value = false
}
</script>