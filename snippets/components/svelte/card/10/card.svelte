<script lang="ts">
  import { fly, scale } from 'svelte/transition';
  import { quintOut } from 'svelte/easing';

  export let image: string | undefined = undefined;
  export let imageAlt: string = '';
  export let imagePosition: 'top' | 'left' | 'right' = 'top';
  export let interactive: boolean = false;
  export let loading: boolean = false;
  export let dismissible: boolean = false;
  export let onDismiss: (() => void) | undefined = undefined;

  let visible = true;
  let flipped = false;

  function handleDismiss() {
    visible = false;
    onDismiss?.();
  }

  function handleFlip() {
    if (interactive && $$slots.back) {
      flipped = !flipped;
    }
  }

  $: isHorizontal = imagePosition === 'left' || imagePosition === 'right';
  $: imageOrder = imagePosition === 'right' ? 'order-2' : 'order-1';
  $: contentOrder = imagePosition === 'right' ? 'order-1' : 'order-2';
</script>

{#if visible}
  <div
    class="card-container bg-white rounded-2xl shadow-lg hover:shadow-2xl transition-shadow duration-300 overflow-hidden relative"
    class:horizontal={isHorizontal}
    on:click={handleFlip}
    on:keydown={(e) => e.key === 'Enter' && handleFlip()}
    role={interactive ? 'button' : undefined}
    tabindex={interactive ? 0 : undefined}
    transition:fly={{ y: 20, duration: 400, easing: quintOut }}
  >
    {#if loading}
      <div class="absolute inset-0 bg-white bg-opacity-90 flex items-center justify-center z-10">
        <div class="animate-spin rounded-full h-12 w-12 border-4 border-blue-500 border-t-transparent"></div>
      </div>
    {/if}

    {#if dismissible}
      <button
        class="absolute top-3 right-3 z-20 p-1 rounded-full bg-gray-100 hover:bg-gray-200 transition-colors"
        on:click|stopPropagation={handleDismiss}
        aria-label="Dismiss card"
      >
        <svg class="w-5 h-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    {/if}

    <div class="card-inner" class:flipped>
      <div class="card-face card-front">
        <div class:flex={isHorizontal}>
          {#if image}
            <div class="card-image {imageOrder}" class:flex-1={isHorizontal}>
              <img src={image} alt={imageAlt} class="w-full h-full object-cover" class:h-48={!isHorizontal} />
            </div>
          {/if}

          <div class="card-content p-6 {contentOrder}" class:flex-1={isHorizontal}>
            {#if $$slots.title}
              <div class="card-title mb-3 text-xl font-bold text-gray-900">
                <slot name="title" />
              </div>
            {/if}

            <div class="card-body text-gray-700">
              <slot />
            </div>

            {#if $$slots.actions}
              <div class="card-actions mt-4 flex gap-2">
                <slot name="actions" />
              </div>
            {/if}
          </div>
        </div>
      </div>

      {#if $$slots.back}
        <div class="card-face card-back absolute inset-0 bg-gradient-to-br from-blue-500 to-purple-600 text-white">
          <div class="p-6 h-full flex flex-col justify-center">
            <slot name="back" />
          </div>
        </div>
      {/if}
    </div>
  </div>
{/if}

<style>
  .card-container {
    perspective: 1000px;
  }

  .card-container.horizontal {
    max-width: 100%;
  }

  .card-inner {
    position: relative;
    width: 100%;
    height: 100%;
    transition: transform 0.6s;
    transform-style: preserve-3d;
  }

  .card-inner.flipped {
    transform: rotateY(180deg);
  }

  .card-face {
    backface-visibility: hidden;
  }

  .card-back {
    transform: rotateY(180deg);
  }

  .card-image img {
    display: block;
  }

  .card-container[role="button"] {
    cursor: pointer;
  }

  .card-container[role="button"]:hover .card-inner:not(.flipped) {
    transform: scale(1.02);
  }
</style>
