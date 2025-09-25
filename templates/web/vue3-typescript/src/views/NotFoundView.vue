<template>
  <div class="text-center py-16">
    <div class="mb-8">
      <h1 class="text-9xl font-bold text-primary-600 mb-4">404</h1>
      <h2 class="text-3xl font-semibold text-gray-900 dark:text-white mb-4">
        Page Not Found
      </h2>
      <p class="text-xl text-gray-600 dark:text-gray-400 mb-8 max-w-md mx-auto">
        The page you're looking for doesn't exist or has been moved.
      </p>
    </div>

    <div class="space-x-4">
      <RouterLink
        to="/"
        class="btn btn-primary no-underline"
      >
        Go Home
      </RouterLink>
      <button
        class="btn btn-secondary"
        @click="goBack"
      >
        Go Back
      </button>
    </div>

    <div class="mt-12 text-6xl">🔍</div>
  </div>
</template>

<script setup lang="ts">
import { RouterLink, useRouter } from 'vue-router'

const router = useRouter()

const goBack = () => {
  if (window.history.length > 1) {
    router.go(-1)
  } else {
    router.push('/')
  }
}
</script>