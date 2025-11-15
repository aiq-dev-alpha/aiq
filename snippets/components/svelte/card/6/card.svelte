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

  export let variant: VariantType = 'neumorphic';
  export let title: string = '';
  export let subtitle: string = '';
  export let description: string = '';
  export let image: string = '';
  export let imageAlt: string = '';
  export let hoverable: boolean = true;
  export let clickable: boolean = false;
  export let actions: Array<{ label: string; onClick: () => void }> = [];
  export let theme: Partial<CardTheme> = {};

  // Variant 6: Neumorphic Light - Soft embossed design
  const defaultTheme: CardTheme = {
    background: '#e0e5ec',
    foreground: '#4a5568',
    border: 'transparent',
    accent: '#667eea',
    shadow: 'rgba(163, 177, 198, 0.6)'
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
  class="card variant-neumorphic"
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
    border-radius: 20px;
    border: none;
    box-shadow:
      9px 9px 16px var(--card-shadow),
      -9px -9px 16px rgba(255, 255, 255, 0.8);
    overflow: hidden;
    transition: all 0.3s ease;
    position: relative;
  }

  .hoverable:hover {
    box-shadow:
      6px 6px 12px var(--card-shadow),
      -6px -6px 12px rgba(255, 255, 255, 0.9);
  }

  .clickable {
    cursor: pointer;
  }

  .clickable:active {
    box-shadow:
      inset 4px 4px 8px var(--card-shadow),
      inset -4px -4px 8px rgba(255, 255, 255, 0.8);
  }

  .card-image {
    position: relative;
    width: 100%;
    height: 200px;
    overflow: hidden;
    box-shadow:
      inset 2px 2px 4px rgba(163, 177, 198, 0.3),
      inset -2px -2px 4px rgba(255, 255, 255, 0.5);
  }

  .card-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s ease;
  }

  .hoverable:hover .card-image img {
    transform: scale(1.05);
  }

  .card-header {
    padding: 1.5rem 1.5rem 0;
  }

  .card-title {
    font-size: 1.5rem;
    font-weight: 700;
    margin: 0 0 0.5rem 0;
    color: var(--card-foreground);
  }

  .card-subtitle {
    font-size: 0.875rem;
    margin: 0;
    color: var(--card-accent);
    font-weight: 600;
  }

  .card-body {
    padding: 1rem 1.5rem;
  }

  .card-description {
    margin: 0;
    line-height: 1.6;
    color: #718096;
  }

  .card-footer {
    padding: 0 1.5rem 1.5rem;
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
  }

  .card-action {
    padding: 0.5rem 1.25rem;
    background: #e0e5ec;
    color: var(--card-accent);
    border: none;
    border-radius: 12px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
    box-shadow:
      4px 4px 8px var(--card-shadow),
      -4px -4px 8px rgba(255, 255, 255, 0.8);
  }

  .card-action:hover {
    box-shadow:
      2px 2px 4px var(--card-shadow),
      -2px -2px 4px rgba(255, 255, 255, 0.9);
  }

  .card-action:active {
    box-shadow:
      inset 2px 2px 4px var(--card-shadow),
      inset -2px -2px 4px rgba(255, 255, 255, 0.8);
  }
</style>
