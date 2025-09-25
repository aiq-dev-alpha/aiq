<template>
  <div class="max-w-3xl mx-auto">
    <div class="text-center mb-8">
      <h1 class="text-4xl font-bold text-gray-900 dark:text-white mb-4">
        About This Template
      </h1>
      <p class="text-xl text-gray-600 dark:text-gray-300">
        Learn more about the technologies and architecture used in this starter template.
      </p>
    </div>

    <div class="space-y-8">
      <div class="card">
        <h2 class="text-2xl font-semibold mb-4 text-gray-800 dark:text-gray-200">
          Technology Stack
        </h2>
        <div class="grid md:grid-cols-2 gap-4">
          <div>
            <h3 class="font-medium text-gray-800 dark:text-gray-200 mb-2">Frontend</h3>
            <ul class="space-y-1 text-gray-600 dark:text-gray-400">
              <li>• Vue 3 with Composition API</li>
              <li>• TypeScript for type safety</li>
              <li>• Vite for fast development</li>
              <li>• Tailwind CSS for styling</li>
              <li>• Vue Router for navigation</li>
            </ul>
          </div>
          <div>
            <h3 class="font-medium text-gray-800 dark:text-gray-200 mb-2">State Management</h3>
            <ul class="space-y-1 text-gray-600 dark:text-gray-400">
              <li>• Pinia for global state</li>
              <li>• Composables for reusable logic</li>
              <li>• Local storage integration</li>
              <li>• Reactive data binding</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="card">
        <h2 class="text-2xl font-semibold mb-4 text-gray-800 dark:text-gray-200">
          Development Tools
        </h2>
        <div class="grid md:grid-cols-2 gap-4">
          <div>
            <h3 class="font-medium text-gray-800 dark:text-gray-200 mb-2">Code Quality</h3>
            <ul class="space-y-1 text-gray-600 dark:text-gray-400">
              <li>• ESLint for Vue and TypeScript</li>
              <li>• Prettier for code formatting</li>
              <li>• TypeScript strict mode</li>
              <li>• Path aliases for clean imports</li>
            </ul>
          </div>
          <div>
            <h3 class="font-medium text-gray-800 dark:text-gray-200 mb-2">Testing</h3>
            <ul class="space-y-1 text-gray-600 dark:text-gray-400">
              <li>• Vitest testing framework</li>
              <li>• Vue Test Utils</li>
              <li>• Coverage reporting</li>
              <li>• UI testing interface</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="card">
        <h2 class="text-2xl font-semibold mb-4 text-gray-800 dark:text-gray-200">
          Project Structure
        </h2>
        <div class="bg-gray-100 dark:bg-gray-800 rounded-lg p-4 font-mono text-sm">
          <div class="text-gray-600 dark:text-gray-400">
            src/<br/>
            ├── components/     # Reusable Vue components<br/>
            ├── views/          # Route components<br/>
            ├── composables/    # Composition API functions<br/>
            ├── stores/         # Pinia stores<br/>
            ├── utils/          # Utility functions<br/>
            ├── types/          # TypeScript type definitions<br/>
            ├── router/         # Vue Router configuration<br/>
            └── test/           # Test setup files
          </div>
        </div>
      </div>

      <div class="card">
        <h2 class="text-2xl font-semibold mb-4 text-gray-800 dark:text-gray-200">
          Vue 3 Features
        </h2>
        <div class="space-y-4">
          <div>
            <h3 class="font-medium text-gray-800 dark:text-gray-200 mb-2">Composition API</h3>
            <p class="text-gray-600 dark:text-gray-400 mb-2">
              All components use the Composition API with <code class="bg-gray-200 dark:bg-gray-700 px-1 rounded">&lt;script setup&gt;</code>
              syntax for better TypeScript integration and code organization.
            </p>
          </div>
          <div>
            <h3 class="font-medium text-gray-800 dark:text-gray-200 mb-2">Reactivity System</h3>
            <p class="text-gray-600 dark:text-gray-400 mb-2">
              Leverages Vue 3's improved reactivity with <code class="bg-gray-200 dark:bg-gray-700 px-1 rounded">ref</code>,
              <code class="bg-gray-200 dark:bg-gray-700 px-1 rounded">reactive</code>, and
              <code class="bg-gray-200 dark:bg-gray-700 px-1 rounded">computed</code> for optimal performance.
            </p>
          </div>
          <div>
            <h3 class="font-medium text-gray-800 dark:text-gray-200 mb-2">Single File Components</h3>
            <p class="text-gray-600 dark:text-gray-400">
              Uses .vue files with TypeScript support in <code class="bg-gray-200 dark:bg-gray-700 px-1 rounded">&lt;script&gt;</code> blocks
              and scoped CSS styling.
            </p>
          </div>
        </div>
      </div>

      <div class="card">
        <h2 class="text-2xl font-semibold mb-4 text-gray-800 dark:text-gray-200">
          Getting Started
        </h2>
        <div class="space-y-4">
          <div>
            <h3 class="font-medium text-gray-800 dark:text-gray-200 mb-2">Installation</h3>
            <div class="bg-gray-100 dark:bg-gray-800 rounded-lg p-4 font-mono text-sm">
              <div class="text-gray-600 dark:text-gray-400">
                npm install
              </div>
            </div>
          </div>
          <div>
            <h3 class="font-medium text-gray-800 dark:text-gray-200 mb-2">Development</h3>
            <div class="bg-gray-100 dark:bg-gray-800 rounded-lg p-4 font-mono text-sm">
              <div class="text-gray-600 dark:text-gray-400">
                npm run dev
              </div>
            </div>
          </div>
          <div>
            <h3 class="font-medium text-gray-800 dark:text-gray-200 mb-2">Testing</h3>
            <div class="bg-gray-100 dark:bg-gray-800 rounded-lg p-4 font-mono text-sm">
              <div class="text-gray-600 dark:text-gray-400">
                npm run test
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
// This component demonstrates a simple page layout
// using the Composition API and TypeScript
</script>