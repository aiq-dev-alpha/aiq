<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <TheNavbar />
    <main class="container mx-auto px-4 py-8">
      <RouterView />
    </main>
  </div>
</template>

<script setup lang="ts">
import TheNavbar from '@/components/TheNavbar.vue'
import { RouterView } from 'vue-router'
</script>