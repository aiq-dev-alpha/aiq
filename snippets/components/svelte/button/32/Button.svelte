<script lang="ts">
  import { createEventDispatcher } from 'svelte';

  export let variant: 'primary' | 'secondary' | 'accent' = 'primary';
  export let look: 'solid' | 'outline' | 'ghost' | 'tonal' = 'solid';
  export let size: 'sm' | 'md' | 'lg' = 'md';
  export let disabled = false;
  export let loading = false;
  export let icon: string = '';
  export let iconPosition: 'left' | 'right' = 'left';
  export let fullWidth = false;

  const dispatch = createEventDispatcher<{ click: MouseEvent }>();

  const variants = {
    primary: { base: '#3b82f6', contrast: '#fff' },
    secondary: { base: '#8b5cf6', contrast: '#fff' },
    accent: { base: '#f59e0b', contrast: '#fff' }
  };

  const v = variants[variant];

  const sizes = {
    sm: 'padding: 6px 14px; font-size: 13px; min-height: 32px',
    md: 'padding: 10px 20px; font-size: 14px; min-height: 40px',
    lg: 'padding: 12px 24px; font-size: 16px; min-height: 48px'
  };

  const looks = {
    solid: `background: ${v.base}; color: ${v.contrast}; border: none;`,
    outline: `background: transparent; color: ${v.base}; border: 2px solid ${v.base};`,
    ghost: `background: transparent; color: ${v.base}; border: none;`,
    tonal: `background: ${v.base}20; color: ${v.base}; border: none;`
  };

  function handleClick(e: MouseEvent) {
    if (!disabled && !loading) {
      dispatch('click', e);
    }
  }
</script>

<button
  style="{sizes[size]} {looks[look]} width: {fullWidth ? '100%' : 'auto'};"
  class="btn"
  {disabled}
  on:click={handleClick}>
  {#if loading}
    <span class="spinner"></span>
  {:else}
    {#if icon && iconPosition === 'left'}
      <span class="icon">{icon}</span>
    {/if}
    <slot />
    {#if icon && iconPosition === 'right'}
      <span class="icon">{icon}</span>
    {/if}
  {/if}
</button>

<style>
  .btn {
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    font-family: inherit;
    outline: none;
  }
  .btn:disabled {
    cursor: not-allowed;
    opacity: 0.6;
  }
  .btn:not(:disabled):hover {
    filter: brightness(1.1);
  }
  .btn:not(:disabled):active {
    transform: scale(0.98);
  }
  .spinner {
    width: 14px;
    height: 14px;
    border: 2px solid currentColor;
    border-top-color: transparent;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
  }
  @keyframes spin {
    to {
      transform: rotate(360deg);
    }
  }
</style>
