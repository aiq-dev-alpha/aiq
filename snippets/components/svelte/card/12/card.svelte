<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { fade, scale } from 'svelte/transition';

  interface CardTheme {
    background: string;
    foreground: string;
    border: string;
    accent: string;
    shadow: string;
  }

  type VariantType = 'default' | 'elevated' | 'outlined' | 'gradient' | 'glass' | 'neumorphic';

  export let variant: VariantType = 'default';
  export let title: string = '';
  export let subtitle: string = '';
  export let description: string = '';
  export let image: string = '';
  export let imageAlt: string = '';
  export let hoverable: boolean = true;
  export let clickable: boolean = false;
  export let actions: Array<{ label: string; onClick: () => void }> = [];
  export let theme: Partial<CardTheme> = {};

  // Variant 12: Slate Dark - Professional dark mode
  const defaultTheme: CardTheme = {
    background: 'linear-gradient(135deg, #0f172a 0%, #1e293b 100%)',
    foreground: '#f1f5f9',
    border: '#475569',
    accent: '#94a3b8',
    shadow: 'rgba(15, 23, 42, 0.6)'
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
  class="card variant-slate"
  class:hoverable
  class:clickable
  on:click={handleClick}
  on:keypress={handleClick}
  role={clickable ? 'button' : 'article'}
  tabindex={clickable ? 0 : undefined}
  transition:scale={{ duration: 300, start: 0.96 }}
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
    border-radius: 12px;
    border: 1px solid var(--card-border);
    box-shadow: 0 10px 25px var(--card-shadow);
    overflow: hidden;
    transition: all 0.3s ease;
    position: relative;
  }

  .variant-slate::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--card-accent), transparent);
  }

  .hoverable:hover {
    transform: translateY(-6px);
    box-shadow: 0 16px 35px var(--card-shadow);
    border-color: var(--card-accent);
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
    filter: grayscale(0.2) contrast(1.1);
  }

  .hoverable:hover .card-image img {
    transform: scale(1.05);
    filter: grayscale(0) contrast(1);
  }

  .card-header {
    padding: 1.5rem 1.5rem 0;
  }

  .card-title {
    font-size: 1.5rem;
    font-weight: 700;
    margin: 0 0 0.5rem 0;
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
    color: #cbd5e1;
  }

  .card-footer {
    padding: 0 1.5rem 1.5rem;
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
  }

  .card-action {
    padding: 0.5rem 1.25rem;
    background: var(--card-accent);
    color: #0f172a;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .card-action:hover {
    background: #cbd5e1;
    transform: translateY(-2px);
  }
</style>
