<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { fade, slide } from 'svelte/transition';

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

  // Variant 4: Purple Dream - Mystical gradient design
  const defaultTheme: CardTheme = {
    background: 'linear-gradient(135deg, #6b21a8 0%, #a855f7 50%, #e879f9 100%)',
    foreground: '#ffffff',
    border: '#c084fc',
    accent: '#f0abfc',
    shadow: 'rgba(192, 132, 252, 0.5)'
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
  class="card variant-purple"
  class:hoverable
  class:clickable
  on:click={handleClick}
  on:keypress={handleClick}
  role={clickable ? 'button' : 'article'}
  tabindex={clickable ? 0 : undefined}
  transition:fade={{ duration: 400 }}
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
      <div class="sparkle"></div>
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
    border-radius: 24px;
    border: none;
    box-shadow: 0 12px 36px var(--card-shadow);
    overflow: hidden;
    transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
    position: relative;
    background-size: 200% 200%;
    animation: gradientShift 8s ease infinite;
  }

  @keyframes gradientShift {
    0%, 100% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
  }

  .variant-purple::before {
    content: '';
    position: absolute;
    inset: -2px;
    background: linear-gradient(45deg, #f0abfc, #c084fc, #a855f7, #c084fc, #f0abfc);
    background-size: 300% 300%;
    border-radius: 24px;
    z-index: -1;
    animation: rotateBorder 6s linear infinite;
    opacity: 0;
    transition: opacity 0.4s;
  }

  .hoverable:hover::before {
    opacity: 1;
  }

  @keyframes rotateBorder {
    0% { background-position: 0% 50%; }
    100% { background-position: 300% 50%; }
  }

  .hoverable:hover {
    transform: translateY(-10px) scale(1.03);
    box-shadow: 0 20px 48px var(--card-shadow);
  }

  .clickable {
    cursor: pointer;
  }

  .card-image {
    position: relative;
    width: 100%;
    height: 240px;
    overflow: hidden;
  }

  .card-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: all 0.4s ease;
    filter: hue-rotate(10deg);
  }

  .hoverable:hover .card-image img {
    transform: scale(1.08);
    filter: hue-rotate(0deg) brightness(1.1);
  }

  .sparkle {
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at 30% 30%, rgba(240, 171, 252, 0.3), transparent 60%);
    animation: sparkleMove 5s ease-in-out infinite;
  }

  @keyframes sparkleMove {
    0%, 100% { transform: translate(0, 0); opacity: 0.5; }
    50% { transform: translate(20px, 20px); opacity: 0.8; }
  }

  .card-header {
    padding: 1.5rem 1.5rem 0;
  }

  .card-title {
    font-size: 1.75rem;
    font-weight: 800;
    margin: 0 0 0.5rem 0;
    background: linear-gradient(to right, #ffffff, #f0abfc);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
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
    line-height: 1.7;
    opacity: 0.95;
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
    border-radius: 16px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
    backdrop-filter: blur(8px);
  }

  .card-action:hover {
    background: rgba(255, 255, 255, 0.3);
    border-color: #ffffff;
    transform: translateY(-2px) scale(1.05);
  }
</style>
