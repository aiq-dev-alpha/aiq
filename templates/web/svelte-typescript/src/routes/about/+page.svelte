<script lang="ts">
  import { onMount } from 'svelte';

  let mounted = false;

  onMount(() => {
    mounted = true;
  });
</script>

<svelte:head>
  <title>About - Svelte TypeScript Template</title>
</svelte:head>

<main class="min-h-screen bg-gray-100">
  <div class="container mx-auto px-4 py-8">
    <div class="max-w-3xl mx-auto">
      <h1 class="text-4xl font-bold text-gray-900 mb-6">About This Template</h1>

      {#if mounted}
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
          <h2 class="text-2xl font-semibold mb-4">Features</h2>
          <ul class="list-disc list-inside space-y-2 text-gray-700">
            <li>SvelteKit with TypeScript</li>
            <li>Tailwind CSS for styling</li>
            <li>ESLint and Prettier configured</li>
            <li>Component-based architecture</li>
            <li>Server-side rendering support</li>
            <li>File-based routing</li>
          </ul>
        </div>

        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
          <h2 class="text-2xl font-semibold mb-4">Technology Stack</h2>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <h3 class="font-semibold text-lg mb-2">Frontend</h3>
              <ul class="text-gray-700 space-y-1">
                <li>Svelte 4</li>
                <li>SvelteKit 2</li>
                <li>TypeScript 5</li>
                <li>Tailwind CSS 3</li>
              </ul>
            </div>
            <div>
              <h3 class="font-semibold text-lg mb-2">Development</h3>
              <ul class="text-gray-700 space-y-1">
                <li>Vite</li>
                <li>ESLint</li>
                <li>Prettier</li>
                <li>PostCSS</li>
              </ul>
            </div>
          </div>
        </div>
      {/if}

      <div class="text-center">
        <a href="/" class="inline-block bg-blue-600 text-white px-6 py-3 rounded-md hover:bg-blue-700 transition">
          Back to Home
        </a>
      </div>
    </div>
  </div>
</main>