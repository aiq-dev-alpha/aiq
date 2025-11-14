<script lang="ts">
  let count = 0;

  function increment() {
    count += 1;
  }

  function decrement() {
    count -= 1;
  }

  function reset() {
    count = 0;
  }
</script>

<div class="text-center">
  <p class="text-2xl font-semibold mb-4">
    Count: <span class="text-blue-600">{count}</span>
  </p>
  <div class="flex gap-2 justify-center">
    <button
      on:click={decrement}
      class="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition"
    >
      -
    </button>
    <button
      on:click={reset}
      class="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600 transition"
    >
      Reset
    </button>
    <button
      on:click={increment}
      class="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition"
    >
      +
    </button>
  </div>
</div>