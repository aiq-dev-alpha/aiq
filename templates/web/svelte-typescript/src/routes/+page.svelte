<script lang="ts">
  import Counter from '$lib/Counter.svelte';

  let name = 'world';
</script>

<svelte:head>
  <title>Svelte TypeScript Template</title>
  <meta name="description" content="Svelte TypeScript starter template" />
</svelte:head>

<main class="min-h-screen bg-gray-100">
  <div class="container mx-auto px-4 py-8">
    <header class="text-center mb-8">
      <h1 class="text-4xl font-bold text-gray-900 mb-4">
        Welcome to Svelte + TypeScript
      </h1>
      <p class="text-lg text-gray-600">
        Edit <code class="bg-gray-200 px-2 py-1 rounded">src/routes/+page.svelte</code> to get started
      </p>
    </header>

    <section class="max-w-2xl mx-auto">
      <div class="bg-white rounded-lg shadow-md p-6 mb-6">
        <h2 class="text-2xl font-semibold mb-4">Interactive Demo</h2>
        <div class="space-y-4">
          <div>
            <label for="name" class="block text-sm font-medium text-gray-700 mb-1">
              Your name:
            </label>
            <input
              id="name"
              bind:value={name}
              type="text"
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Enter your name"
            />
          </div>
          <p class="text-lg">
            Hello <span class="font-semibold text-blue-600">{name}</span>!
          </p>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow-md p-6 mb-6">
        <h2 class="text-2xl font-semibold mb-4">Counter Component</h2>
        <Counter />
      </div>

      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-2xl font-semibold mb-4">Quick Links</h2>
        <nav>
          <ul class="space-y-2">
            <li>
              <a href="/about" class="text-blue-600 hover:underline">About Page</a>
            </li>
            <li>
              <a href="/todos" class="text-blue-600 hover:underline">Todo List Demo</a>
            </li>
            <li>
              <a href="https://kit.svelte.dev" target="_blank" rel="noreferrer" class="text-blue-600 hover:underline">
                SvelteKit Documentation ↗
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </section>
  </div>
</main>