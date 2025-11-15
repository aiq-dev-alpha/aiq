<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { fade, fly } from 'svelte/transition';

  interface CardTheme {
    background: string;
    foreground: string;
    border: string;
    accent: string;
    shadow: string;
  }

  type VariantType = 'default' | 'elevated' | 'outlined' | 'gradient' | 'glass' | 'neumorphic';

  export let variant: VariantType = 'outlined';
  export let title: string = '';
  export let subtitle: string = '';
  export let description: string = '';
  export let image: string = '';
  export let imageAlt: string = '';
  export let hoverable: boolean = true;
  export let clickable: boolean = false;
  export let actions: Array<{ label: string; onClick: () => void }> = [];
  export let theme: Partial<CardTheme> = {};

  // Variant 14: Cyan Sky - Bright sky blue
  const defaultTheme: CardTheme = {
    background: '#ffffff',
    foreground: '#164e63',
    border: '#06b6d4',
    accent: '#22d3ee',
    shadow: 'rgba(6, 182, 212, 0.25)'
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
  class="card variant-cyan"
  class:hoverable
  class:clickable
  on:click={handleClick}
  on:keypress={handleClick}
  role={clickable ? 'button' : 'article'}
  tabindex={clickable ? 0 : undefined}
  transition:fly={{ x: 20, duration: 400 }}
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
    border-radius: 14px;
    border: 3px solid var(--card-border);
    box-shadow: 0 6px 18px var(--card-shadow);
    overflow: hidden;
    transition: all 0.3s ease;
    position: relative;
  }

  .variant-cyan {
    background: linear-gradient(to bottom left, #ffffff 0%, #ecfeff 100%);
  }

  .variant-cyan::before {
    content: '';
    position: absolute;
    top: -2px;
    right: -2px;
    width: 80px;
    height: 80px;
    background: linear-gradient(135deg, var(--card-accent), transparent);
    border-radius: 50%;
    animation: ripple 3s ease-in-out infinite;
  }

  @keyframes ripple {
    0%, 100% { transform: scale(1); opacity: 0.5; }
    50% { transform: scale(1.2); opacity: 0.8; }
  }

  .hoverable:hover {
    transform: translateX(8px);
    box-shadow: -8px 8px 24px var(--card-shadow);
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
    border-bottom: 3px solid var(--card-border);
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
    color: #155e75;
  }

  .card-footer {
    padding: 0 1.5rem 1.5rem;
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
  }

  .card-action {
    padding: 0.5rem 1.25rem;
    background: transparent;
    color: var(--card-accent);
    border: 2px solid var(--card-accent);
    border-radius: 10px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .card-action:hover {
    background: var(--card-accent);
    color: #ffffff;
    transform: translateY(-2px);
  }
</style>
