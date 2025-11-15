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

  export let variant: VariantType = 'gradient';
  export let title: string = '';
  export let subtitle: string = '';
  export let description: string = '';
  export let image: string = '';
  export let imageAlt: string = '';
  export let hoverable: boolean = true;
  export let clickable: boolean = false;
  export let actions: Array<{ label: string; onClick: () => void }> = [];
  export let theme: Partial<CardTheme> = {};

  // Variant 8: Teal Wave - Oceanic cyan design
  const defaultTheme: CardTheme = {
    background: 'linear-gradient(135deg, #0f766e 0%, #14b8a6 50%, #2dd4bf 100%)',
    foreground: '#f0fdfa',
    border: '#5eead4',
    accent: '#99f6e4',
    shadow: 'rgba(20, 184, 166, 0.4)'
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
  class="card variant-teal"
  class:hoverable
  class:clickable
  on:click={handleClick}
  on:keypress={handleClick}
  role={clickable ? 'button' : 'article'}
  tabindex={clickable ? 0 : undefined}
  transition:scale={{ duration: 350, start: 0.9 }}
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
      <div class="wave-overlay"></div>
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
    border-radius: 18px;
    border: none;
    box-shadow: 0 8px 28px var(--card-shadow);
    overflow: hidden;
    transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
    position: relative;
  }

  .variant-teal::after {
    content: '';
    position: absolute;
    inset: 0;
    background: repeating-linear-gradient(
      90deg,
      transparent,
      rgba(153, 246, 228, 0.05) 2px,
      transparent 4px
    );
    pointer-events: none;
    animation: flow 20s linear infinite;
  }

  @keyframes flow {
    0% { transform: translateX(0); }
    100% { transform: translateX(100px); }
  }

  .hoverable:hover {
    transform: translateY(-10px) rotate(1deg);
    box-shadow: 0 16px 40px var(--card-shadow);
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
    transition: transform 0.35s ease;
  }

  .wave-overlay {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 40%;
    background: linear-gradient(to top, rgba(15, 118, 110, 0.8), transparent);
  }

  .wave-overlay::before {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 2px;
    background: var(--card-accent);
    animation: wave 2s ease-in-out infinite;
  }

  @keyframes wave {
    0%, 100% { transform: scaleX(1); opacity: 0.8; }
    50% { transform: scaleX(0.95); opacity: 1; }
  }

  .hoverable:hover .card-image img {
    transform: scale(1.08) rotate(-1deg);
  }

  .card-header {
    padding: 1.5rem 1.5rem 0;
  }

  .card-title {
    font-size: 1.625rem;
    font-weight: 700;
    margin: 0 0 0.5rem 0;
  }

  .card-subtitle {
    font-size: 0.875rem;
    margin: 0;
    opacity: 0.95;
    font-weight: 600;
  }

  .card-body {
    padding: 1rem 1.5rem;
  }

  .card-description {
    margin: 0;
    line-height: 1.65;
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
    background: rgba(153, 246, 228, 0.2);
    color: #ffffff;
    border: 2px solid rgba(153, 246, 228, 0.5);
    border-radius: 10px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.25s ease;
  }

  .card-action:hover {
    background: var(--card-accent);
    color: #0f766e;
    border-color: var(--card-accent);
    transform: scale(1.05);
  }
</style>
