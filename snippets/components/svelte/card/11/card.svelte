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

  // Variant 11: Rose Gold - Elegant pink-gold metallic
  const defaultTheme: CardTheme = {
    background: 'linear-gradient(135deg, #831843 0%, #be185d 50%, #f472b6 100%)',
    foreground: '#fce7f3',
    border: '#f9a8d4',
    accent: '#fbcfe8',
    shadow: 'rgba(236, 72, 153, 0.4)'
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
  class="card variant-rose"
  class:hoverable
  class:clickable
  on:click={handleClick}
  on:keypress={handleClick}
  role={clickable ? 'button' : 'article'}
  tabindex={clickable ? 0 : undefined}
  transition:fade={{ duration: 350 }}
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
      <div class="rose-shine"></div>
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
    box-shadow: 0 10px 30px var(--card-shadow);
    overflow: hidden;
    transition: all 0.35s ease;
    position: relative;
  }

  .variant-rose::before {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(45deg,
      transparent 30%,
      rgba(251, 207, 232, 0.1) 50%,
      transparent 70%
    );
    background-size: 200% 200%;
    animation: sheen 3s ease-in-out infinite;
  }

  @keyframes sheen {
    0% { background-position: 200% 0%; }
    100% { background-position: -200% 0%; }
  }

  .hoverable:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: 0 16px 40px var(--card-shadow);
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
    transition: transform 0.35s ease;
    filter: saturate(1.2);
  }

  .rose-shine {
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at top left, rgba(249, 168, 212, 0.3), transparent 60%);
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
    background: linear-gradient(135deg, #ffffff, #f9a8d4);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
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
    background: rgba(251, 207, 232, 0.2);
    color: #ffffff;
    border: 2px solid rgba(251, 207, 232, 0.4);
    border-radius: 12px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.25s ease;
    backdrop-filter: blur(5px);
  }

  .card-action:hover {
    background: var(--card-accent);
    color: #831843;
    border-color: var(--card-accent);
    transform: scale(1.05);
  }
</style>
