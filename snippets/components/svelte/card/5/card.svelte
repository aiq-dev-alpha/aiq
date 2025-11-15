<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { fade, blur } from 'svelte/transition';

  interface CardTheme {
    background: string;
    foreground: string;
    border: string;
    accent: string;
    shadow: string;
  }

  type VariantType = 'default' | 'elevated' | 'outlined' | 'gradient' | 'glass' | 'neumorphic';

  export let variant: VariantType = 'glass';
  export let title: string = '';
  export let subtitle: string = '';
  export let description: string = '';
  export let image: string = '';
  export let imageAlt: string = '';
  export let hoverable: boolean = true;
  export let clickable: boolean = false;
  export let actions: Array<{ label: string; onClick: () => void }> = [];
  export let theme: Partial<CardTheme> = {};

  // Variant 5: Glacial Frost - Frosted glass design
  const defaultTheme: CardTheme = {
    background: 'rgba(255, 255, 255, 0.1)',
    foreground: '#f0f9ff',
    border: 'rgba(125, 211, 252, 0.3)',
    accent: '#7dd3fc',
    shadow: 'rgba(59, 130, 246, 0.2)'
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
  class="card variant-glass"
  class:hoverable
  class:clickable
  on:click={handleClick}
  on:keypress={handleClick}
  role={clickable ? 'button' : 'article'}
  tabindex={clickable ? 0 : undefined}
  transition:blur={{ duration: 300 }}
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
      <div class="frost-overlay"></div>
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
    border: 1px solid var(--card-border);
    box-shadow: 0 8px 32px var(--card-shadow);
    overflow: hidden;
    transition: all 0.3s ease;
    position: relative;
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
  }

  .variant-glass {
    background: linear-gradient(135deg,
      rgba(255, 255, 255, 0.15) 0%,
      rgba(255, 255, 255, 0.05) 100%
    );
  }

  .variant-glass::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg,
      transparent,
      rgba(125, 211, 252, 0.8),
      transparent
    );
  }

  .variant-glass::after {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at top left, rgba(125, 211, 252, 0.1), transparent 50%);
    pointer-events: none;
  }

  .hoverable:hover {
    background: linear-gradient(135deg,
      rgba(255, 255, 255, 0.2) 0%,
      rgba(255, 255, 255, 0.1) 100%
    );
    border-color: var(--card-accent);
    box-shadow: 0 12px 48px var(--card-shadow);
    transform: translateY(-6px);
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
  }

  .frost-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(to bottom,
      rgba(240, 249, 255, 0.1),
      rgba(240, 249, 255, 0.3)
    );
    backdrop-filter: blur(2px);
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
    color: #ffffff;
    text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
  }

  .card-subtitle {
    font-size: 0.875rem;
    margin: 0;
    color: var(--card-accent);
    font-weight: 500;
  }

  .card-body {
    padding: 1rem 1.5rem;
  }

  .card-description {
    margin: 0;
    line-height: 1.6;
    color: #e0f2fe;
  }

  .card-footer {
    padding: 0 1.5rem 1.5rem;
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
  }

  .card-action {
    padding: 0.5rem 1.25rem;
    background: rgba(125, 211, 252, 0.15);
    color: #ffffff;
    border: 1px solid rgba(125, 211, 252, 0.4);
    border-radius: 12px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
    backdrop-filter: blur(10px);
  }

  .card-action:hover {
    background: rgba(125, 211, 252, 0.25);
    border-color: var(--card-accent);
    transform: translateY(-2px);
  }
</style>
