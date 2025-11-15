<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { fade } from 'svelte/transition';

  interface CardTheme {
    background: string;
    foreground: string;
    border: string;
    accent: string;
    shadow: string;
  }

  type VariantType = 'default' | 'elevated' | 'outlined' | 'gradient' | 'glass' | 'neumorphic';

  export let variant: VariantType = 'elevated';
  export let title: string = '';
  export let subtitle: string = '';
  export let description: string = '';
  export let image: string = '';
  export let imageAlt: string = '';
  export let hoverable: boolean = true;
  export let clickable: boolean = false;
  export let actions: Array<{ label: string; onClick: () => void }> = [];
  export let theme: Partial<CardTheme> = {};

  // Variant 15: Emerald Matrix - Cyber green
  const defaultTheme: CardTheme = {
    background: 'linear-gradient(135deg, #064e3b 0%, #059669 50%, #34d399 100%)',
    foreground: '#d1fae5',
    border: '#6ee7b7',
    accent: '#a7f3d0',
    shadow: 'rgba(5, 150, 105, 0.4)'
  };

  const dispatch = createEventDispatcher();

  $: appliedTheme = { ...defaultTheme, ...theme };

  function handleClick() {
    if (clickable) {
      dispatch('click');
    }
  }
</script>

<div
  class="card variant-emerald"
  class:hoverable
  class:clickable
  on:click={handleClick}
  on:keypress={handleClick}
  role={clickable ? 'button' : 'article'}
  tabindex={clickable ? 0 : undefined}
  transition:fade={{ duration: 300 }}
  style="
    --card-background: {appliedTheme.background};
    --card-foreground: {appliedTheme.foreground};
    --card-border: {appliedTheme.border};
    --card-accent: {appliedTheme.accent};
    --card-shadow: {appliedTheme.shadow};
  "
>
  {#if image}
    <div class="card-image">
      <img src={image} alt={imageAlt} />
    </div>
  {/if}

  <div class="card-header">
    <slot name="header">
      {#if title}
        <h3 class="card-title">{title}</h3>
      {/if}
      {#if subtitle}
        <p class="card-subtitle">{subtitle}</p>
      {/if}
    </slot>
  </div>

  <div class="card-body">
    <slot>
      {#if description}
        <p class="card-description">{description}</p>
      {/if}
    </slot>
  </div>

  {#if actions.length > 0 || $$slots.footer}
    <div class="card-footer">
      <slot name="footer">
        {#each actions as action}
          <button class="card-action" on:click|stopPropagation={action.onClick}>
            {action.label}
          </button>
        {/each}
      </slot>
    </div>
  {/if}
</div>

<style>
  .card {
    background: var(--card-background);
    color: var(--card-foreground);
    border-radius: 16px;
    border: none;
    box-shadow: 0 10px 30px var(--card-shadow), 0 0 20px rgba(5, 150, 105, 0.2);
    overflow: hidden;
    transition: all 0.3s ease;
    position: relative;
  }

  .variant-emerald::before {
    content: '';
    position: absolute;
    inset: 0;
    background: repeating-linear-gradient(
      0deg,
      transparent,
      rgba(167, 243, 208, 0.03) 1px,
      transparent 2px
    );
    animation: scan 8s linear infinite;
  }

  @keyframes scan {
    0% { transform: translateY(0); }
    100% { transform: translateY(100%); }
  }

  .hoverable:hover {
    transform: translateY(-10px);
    box-shadow: 0 16px 40px var(--card-shadow), 0 0 30px rgba(5, 150, 105, 0.3);
  }

  .clickable {
    cursor: pointer;
  }

  .card-image {
    position: relative;
    width: 100%;
    height: 200px;
    overflow: hidden;
  }

  .card-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s ease;
    filter: brightness(0.9) hue-rotate(10deg);
  }

  .hoverable:hover .card-image img {
    transform: scale(1.05);
    filter: brightness(1) hue-rotate(0deg);
  }

  .card-header {
    padding: 1.5rem 1.5rem 0;
  }

  .card-title {
    font-size: 1.625rem;
    font-weight: 800;
    margin: 0 0 0.5rem 0;
    font-family: monospace;
    letter-spacing: 0.05em;
  }

  .card-subtitle {
    font-size: 0.875rem;
    margin: 0;
    opacity: 0.9;
    font-weight: 600;
  }

  .card-body {
    padding: 1rem 1.5rem;
  }

  .card-description {
    margin: 0;
    line-height: 1.6;
  }

  .card-footer {
    padding: 0 1.5rem 1.5rem;
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
  }

  .card-action {
    padding: 0.5rem 1.25rem;
    background: rgba(167, 243, 208, 0.2);
    color: #ffffff;
    border: 2px solid rgba(167, 243, 208, 0.5);
    border-radius: 8px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.2s ease;
    font-family: monospace;
  }

  .card-action:hover {
    background: var(--card-accent);
    color: #064e3b;
    transform: translateY(-2px);
  }
</style>
