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
  const isPressed = writable(false);

  const themes: ButtonTheme = {
    primary: '#3b82f6',
    secondary: '#a855f7',
    success: '#22c55e',
    danger: '#f43f5e',
    warning: '#eab308',
    info: '#14b8a6'
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
      isPressed.set(true);
      setTimeout(() => isPressed.set(false), 200);
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
  {#if loading}
    <span class="spinner pulse"></span>
  {:else}
    {#if icon && iconPosition === 'left'}
      <slot name="icon-left">{icon}</slot>
    {/if}
    <slot></slot>
    {#if icon && iconPosition === 'right'}
      <slot name="icon-right">{icon}</slot>
    {/if}
  {/if}
</button>

<style>
  .btn {
    position: relative;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    border: none;
    border-radius: 12px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.4s ease;
    background-size: 200% 200%;
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Gradient Variant with Neon Effect */
  .gradient.primary {
    background: linear-gradient(45deg, #3b82f6, #8b5cf6, #ec4899);
    color: white;
    box-shadow: 0 0 20px rgba(59, 130, 246, 0.5), 0 0 40px rgba(139, 92, 246, 0.3);
    animation: gradientShift 3s ease infinite;
  }

  .gradient.primary:hover {
    box-shadow: 0 0 30px rgba(59, 130, 246, 0.8), 0 0 60px rgba(139, 92, 246, 0.5);
    transform: scale(1.05);
  }

  .gradient.secondary {
    background: linear-gradient(45deg, #a855f7, #ec4899, #f59e0b);
    color: white;
    box-shadow: 0 0 20px rgba(168, 85, 247, 0.5);
    animation: gradientShift 3s ease infinite;
  }

  .gradient.success {
    background: linear-gradient(45deg, #22c55e, #10b981, #14b8a6);
    color: white;
    box-shadow: 0 0 20px rgba(34, 197, 94, 0.5);
    animation: gradientShift 3s ease infinite;
  }

  .gradient.danger {
    background: linear-gradient(45deg, #f43f5e, #ef4444, #dc2626);
    color: white;
    box-shadow: 0 0 20px rgba(244, 63, 94, 0.5);
    animation: gradientShift 3s ease infinite;
  }

  .gradient.warning {
    background: linear-gradient(45deg, #eab308, #f59e0b, #fb923c);
    color: white;
    box-shadow: 0 0 20px rgba(234, 179, 8, 0.5);
    animation: gradientShift 3s ease infinite;
  }

  .gradient.info {
    background: linear-gradient(45deg, #14b8a6, #06b6d4, #0ea5e9);
    color: white;
    box-shadow: 0 0 20px rgba(20, 184, 166, 0.5);
    animation: gradientShift 3s ease infinite;
  }

  @keyframes gradientShift {
    0%, 100% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner {
    width: 1em;
    height: 1em;
    border: 2px solid transparent;
    border-top-color: currentColor;
    border-right-color: currentColor;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
  }

  .spinner.pulse {
    animation: spin 0.6s linear infinite, pulse 1.5s ease-in-out infinite;
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }

  @keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
