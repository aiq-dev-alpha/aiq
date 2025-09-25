<template>
  <div class="max-w-2xl mx-auto">
    <div class="text-center mb-8">
      <h1 class="text-4xl font-bold text-gray-900 dark:text-white mb-4">
        Contact Us
      </h1>
      <p class="text-xl text-gray-600 dark:text-gray-300">
        Get in touch with us using the form below.
      </p>
    </div>

    <div class="card">
      <div v-if="isSubmitted" class="text-center py-8">
        <div class="text-6xl mb-4">✅</div>
        <h2 class="text-2xl font-semibold text-green-600 mb-2">
          Thank you for your message!
        </h2>
        <p class="text-gray-600 dark:text-gray-400">
          We'll get back to you as soon as possible.
        </p>
      </div>

      <form v-else @submit.prevent="handleSubmit" class="space-y-6">
        <div>
          <label for="name" class="form-label">
            Full Name *
          </label>
          <input
            id="name"
            v-model="formData.name"
            type="text"
            class="form-input"
            placeholder="Enter your full name"
            required
          />
        </div>

        <div>
          <label for="email" class="form-label">
            Email Address *
          </label>
          <input
            id="email"
            v-model="formData.email"
            type="email"
            class="form-input"
            placeholder="Enter your email address"
            required
          />
        </div>

        <div>
          <label for="message" class="form-label">
            Message *
          </label>
          <textarea
            id="message"
            v-model="formData.message"
            class="form-input"
            rows="5"
            placeholder="Enter your message"
            required
          />
        </div>

        <button
          type="submit"
          class="w-full btn btn-primary"
        >
          Send Message
        </button>
      </form>
    </div>

    <div class="mt-8 grid md:grid-cols-2 gap-6">
      <div class="card text-center">
        <div class="text-primary-600 text-3xl mb-3">📧</div>
        <h3 class="font-semibold text-gray-800 dark:text-gray-200 mb-2">
          Email
        </h3>
        <p class="text-gray-600 dark:text-gray-400">
          hello@example.com
        </p>
      </div>

      <div class="card text-center">
        <div class="text-primary-600 text-3xl mb-3">🌐</div>
        <h3 class="font-semibold text-gray-800 dark:text-gray-200 mb-2">
          Website
        </h3>
        <p class="text-gray-600 dark:text-gray-400">
          www.example.com
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'

interface FormData {
  name: string
  email: string
  message: string
}

const formData = reactive<FormData>({
  name: '',
  email: '',
  message: '',
})

const isSubmitted = ref(false)

const handleSubmit = () => {
  // Here you would typically send the data to a server
  console.log('Form submitted:', formData)
  isSubmitted.value = true

  // Reset form after 3 seconds
  setTimeout(() => {
    isSubmitted.value = false
    Object.assign(formData, { name: '', email: '', message: '' })
  }, 3000)
}
</script>