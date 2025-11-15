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

  // Variant 7: Crimson Night - Dark red gradient
  const defaultTheme: CardTheme = {
    background: 'linear-gradient(135deg, #450a0a 0%, #7f1d1d 50%, #991b1b 100%)',
    foreground: '#fecaca',
    border: '#dc2626',
    accent: '#fca5a5',
    shadow: 'rgba(220, 38, 38, 0.4)'
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
  class="card variant-crimson"
  class:hoverable
  class:clickable
  on:click={handleClick}
  on:keypress={handleClick}
  role={clickable ? 'button' : 'article'}
  tabindex={clickable ? 0 : undefined}
  transition:fly={{ x: -20, duration: 400 }}
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
      <div class="red-vignette"></div>
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
    border: 2px solid var(--card-border);
    box-shadow: 0 10px 25px var(--card-shadow);
    overflow: hidden;
    transition: all 0.3s ease;
    position: relative;
  }

  .variant-crimson::before {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 3px;
    background: linear-gradient(90deg, transparent, var(--card-accent), transparent);
    animation: scanline 3s linear infinite;
  }

  @keyframes scanline {
    0% { transform: translateX(-100%); }
    100% { transform: translateX(100%); }
  }

  .hoverable:hover {
    transform: translateY(-8px) scale(1.01);
    box-shadow: 0 15px 35px var(--card-shadow);
    border-color: var(--card-accent);
  }

  .clickable {
    cursor: pointer;
  }

  .card-image {
    position: relative;
    width: 100%;
    height: 210px;
    overflow: hidden;
  }

  .card-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.4s ease;
    filter: contrast(1.1);
  }

  .red-vignette {
    position: absolute;
    inset: 0;
    background: radial-gradient(circle, transparent 40%, rgba(69, 10, 10, 0.6));
  }

  .hoverable:hover .card-image img {
    transform: scale(1.06);
  }

  .card-header {
    padding: 1.5rem 1.5rem 0;
  }

  .card-title {
    font-size: 1.625rem;
    font-weight: 800;
    margin: 0 0 0.5rem 0;
    color: #ffffff;
  }

  .card-subtitle {
    font-size: 0.875rem;
    margin: 0;
    opacity: 0.9;
    font-weight: 500;
  }

  .card-body {
    padding: 1rem 1.5rem;
  }

  .card-description {
    margin: 0;
    line-height: 1.6;
    opacity: 0.95;
  }

  .card-footer {
    padding: 0 1.5rem 1.5rem;
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
  }

  .card-action {
    padding: 0.5rem 1.25rem;
    background: rgba(252, 165, 165, 0.15);
    color: var(--card-accent);
    border: 2px solid var(--card-accent);
    border-radius: 10px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .card-action:hover {
    background: var(--card-accent);
    color: #450a0a;
    transform: translateY(-2px);
  }
</style>
