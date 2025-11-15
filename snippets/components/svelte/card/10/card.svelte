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

  // Variant 10: Midnight Indigo - Deep blue night sky
  const defaultTheme: CardTheme = {
    background: '#ffffff',
    foreground: '#312e81',
    border: '#4f46e5',
    accent: '#818cf8',
    shadow: 'rgba(79, 70, 229, 0.25)'
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
  class="card variant-indigo"
  class:hoverable
  class:clickable
  on:click={handleClick}
  on:keypress={handleClick}
  role={clickable ? 'button' : 'article'}
  tabindex={clickable ? 0 : undefined}
  transition:fly={{ y: 30, duration: 400 }}
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
      <div class="stars"></div>
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
    box-shadow: 0 6px 20px var(--card-shadow);
    overflow: hidden;
    transition: all 0.3s ease;
    position: relative;
  }

  .variant-indigo {
    background: linear-gradient(to bottom right, #ffffff 0%, #eef2ff 100%);
  }

  .variant-indigo::before {
    content: '';
    position: absolute;
    top: 0;
    right: 0;
    width: 100px;
    height: 100px;
    background: radial-gradient(circle, rgba(129, 140, 248, 0.2), transparent 70%);
    border-radius: 50%;
    animation: float 6s ease-in-out infinite;
  }

  @keyframes float {
    0%, 100% { transform: translate(0, 0); }
    50% { transform: translate(-20px, 20px); }
  }

  .hoverable:hover {
    transform: translateY(-6px) scale(1.01);
    border-color: var(--card-accent);
    box-shadow: 0 12px 32px var(--card-shadow);
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

  .stars {
    position: absolute;
    inset: 0;
    background-image:
      radial-gradient(2px 2px at 20% 30%, white, transparent),
      radial-gradient(2px 2px at 60% 70%, white, transparent),
      radial-gradient(1px 1px at 50% 50%, white, transparent),
      radial-gradient(1px 1px at 80% 10%, white, transparent),
      radial-gradient(2px 2px at 90% 60%, white, transparent);
    background-size: 200% 200%;
    animation: twinkle 8s ease-in-out infinite;
  }

  @keyframes twinkle {
    0%, 100% { opacity: 0.6; }
    50% { opacity: 1; }
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
    color: #4338ca;
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
