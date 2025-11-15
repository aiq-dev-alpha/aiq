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
  export let elevated = false;

  const dispatch = createEventDispatcher<{ click: MouseEvent }>();

  const variants = {
    primary: { base: '#ec4899', contrast: '#fff', shadow: '#ec489960' },
    secondary: { base: '#f59e0b', contrast: '#fff', shadow: '#f59e0b60' },
    accent: { base: '#06b6d4', contrast: '#fff', shadow: '#06b6d460' }
  };

  const v = variants[variant];

  const sizes = {
    sm: 'padding: 7px 15px; font-size: 13px; min-height: 34px; gap: 6px',
    md: 'padding: 11px 22px; font-size: 14px; min-height: 42px; gap: 8px',
    lg: 'padding: 14px 28px; font-size: 16px; min-height: 50px; gap: 10px'
  };

  const looks = {
    solid: `background: linear-gradient(135deg, ${v.base}, ${v.base}dd); color: ${v.contrast}; border: none; box-shadow: ${elevated ? `0 4px 12px ${v.shadow}` : '0 2px 4px rgba(0,0,0,0.1)'};`,
    outline: `background: transparent; color: ${v.base}; border: 2px solid ${v.base}; box-shadow: none;`,
    ghost: `background: transparent; color: ${v.base}; border: none; box-shadow: none;`,
    tonal: `background: ${v.base}15; color: ${v.base}; border: 1px solid ${v.base}30; box-shadow: 0 1px 3px rgba(0,0,0,0.05);`
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
    border-radius: 10px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-family: inherit;
    outline: none;
    letter-spacing: 0.3px;
    position: relative;
    overflow: hidden;
  }
  .btn:disabled {
    cursor: not-allowed;
    opacity: 0.55;
    filter: grayscale(0.2);
  }
  .btn:not(:disabled):hover {
    transform: translateY(-2px);
    filter: brightness(1.15);
  }
  .btn:not(:disabled):active {
    transform: translateY(0) scale(0.97);
  }
  .spinner {
    width: 15px;
    height: 15px;
    border: 2px solid currentColor;
    border-top-color: transparent;
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
  }
  @keyframes spin {
    to {
      transform: rotate(360deg);
    }
  }
</style>
