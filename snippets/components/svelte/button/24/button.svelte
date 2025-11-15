<script lang="ts">
  import { writable } from 'svelte/store';
  import { createEventDispatcher } from 'svelte';

  export interface ButtonTheme {
    primary: string;
    secondary: string;
    success: string;
    danger: string;
    warning: string;
    info: string;
  }

  export let variant: 'solid' | 'outline' | 'ghost' | 'gradient' | 'glass' | 'neumorphic' = 'gradient';
  export let size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'md';
  export let fullWidth: boolean = false;
  export let loading: boolean = false;
  export let icon: string = '';
  export let iconPosition: 'left' | 'right' = 'left';
  export let disabled: boolean = false;
  export let theme: keyof ButtonTheme = 'primary';

  const dispatch = createEventDispatcher();

  const themes: ButtonTheme = {
    primary: '#6366f1',
    secondary: '#ec4899',
    success: '#10b981',
    danger: '#f43f5e',
    warning: '#f59e0b',
    info: '#06b6d4'
  };

  const sizes = {
    xs: 'px-2 py-1 text-xs',
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg',
    xl: 'px-8 py-4 text-xl'
  };

  function handleClick(event: MouseEvent) {
    if (!disabled && !loading) {
      dispatch('click', event);
    }
  }
</script>

<button
  class="btn {sizes[size]} {variant} {theme}"
  class:full-width={fullWidth}
  class:loading={loading}
  {disabled}
  on:click={handleClick}
>
  <span class="btn-border"></span>
  <span class="btn-content">
    {#if loading}
      <span class="spinner spiral"></span>
    {:else}
      {#if icon && iconPosition === 'left'}
        <slot name="icon-left">{icon}</slot>
      {/if}
      <slot></slot>
      {#if icon && iconPosition === 'right'}
        <slot name="icon-right">{icon}</slot>
      {/if}
    {/if}
  </span>
</button>

<style>
  .btn {
    position: relative;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    border: none;
    border-radius: 15px;
    font-weight: 600;
    cursor: pointer;
    overflow: hidden;
  }

  .btn-border {
    position: absolute;
    inset: 0;
    padding: 2px;
    border-radius: 15px;
    background: linear-gradient(45deg, currentColor, transparent, currentColor);
    -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
    -webkit-mask-composite: xor;
    mask-composite: exclude;
  }

  .btn-content {
    position: relative;
    z-index: 1;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Animated Border Gradient */
  .gradient.primary {
    background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
    color: white;
  }

  .gradient.primary .btn-border {
    animation: rotateBorder 3s linear infinite;
  }

  .gradient.secondary {
    background: linear-gradient(135deg, #ec4899 0%, #db2777 100%);
    color: white;
  }

  .gradient.success {
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    color: white;
  }

  .gradient.danger {
    background: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%);
    color: white;
  }

  .gradient.warning {
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    color: white;
  }

  .gradient.info {
    background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
    color: white;
  }

  @keyframes rotateBorder {
    to { transform: rotate(360deg); }
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner.spiral {
    width: 1em;
    height: 1em;
    border: 3px solid transparent;
    border-top-color: currentColor;
    border-radius: 50%;
    animation: spiral 1s ease-in-out infinite;
  }

  @keyframes spiral {
    0% { transform: rotate(0deg) scale(1); }
    50% { transform: rotate(180deg) scale(0.8); }
    100% { transform: rotate(360deg) scale(1); }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
