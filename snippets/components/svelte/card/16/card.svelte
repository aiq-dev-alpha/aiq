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

  // Variant 16: Violet Electric - Vibrant electric purple
  const defaultTheme: CardTheme = {
    background: 'linear-gradient(135deg, #5b21b6 0%, #8b5cf6 50%, #a78bfa 100%)',
    foreground: '#f5f3ff',
    border: '#c4b5fd',
    accent: '#ddd6fe',
    shadow: 'rgba(139, 92, 246, 0.5)'
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
  class="card variant-violet"
  class:hoverable
  class:clickable
  on:click={handleClick}
  on:keypress={handleClick}
  role={clickable ? 'button' : 'article'}
  tabindex={clickable ? 0 : undefined}
  transition:scale={{ duration: 350, start: 0.94 }}
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
    border-radius: 22px;
    border: none;
    box-shadow: 0 12px 32px var(--card-shadow);
    overflow: hidden;
    transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
    position: relative;
  }

  .variant-violet::before {
    content: '';
    position: absolute;
    bottom: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: radial-gradient(circle, rgba(221, 214, 254, 0.3), transparent 50%);
    animation: electric 6s ease-in-out infinite alternate;
  }

  @keyframes electric {
    0% { transform: rotate(0deg) scale(1); }
    100% { transform: rotate(180deg) scale(1.2); }
  }

  .hoverable:hover {
    transform: translateY(-12px) scale(1.02);
    box-shadow: 0 20px 45px var(--card-shadow);
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
  }

  .hoverable:hover .card-image img {
    transform: scale(1.08);
  }

  .card-header {
    padding: 1.5rem 1.5rem 0;
  }

  .card-title {
    font-size: 1.75rem;
    font-weight: 800;
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
  }

  .card-footer {
    padding: 0 1.5rem 1.5rem;
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
  }

  .card-action {
    padding: 0.625rem 1.5rem;
    background: rgba(255, 255, 255, 0.2);
    color: #ffffff;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-radius: 14px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.25s ease;
  }

  .card-action:hover {
    background: rgba(255, 255, 255, 0.35);
    border-color: var(--card-accent);
    transform: scale(1.05);
  }
</style>
