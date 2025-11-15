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

  export let variant: 'solid' | 'outline' | 'ghost' | 'gradient' | 'glass' | 'neumorphic' = 'glass';
  export let size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'md';
  export let fullWidth: boolean = false;
  export let loading: boolean = false;
  export let icon: string = '';
  export let iconPosition: 'left' | 'right' = 'left';
  export let disabled: boolean = false;
  export let theme: keyof ButtonTheme = 'primary';

  const dispatch = createEventDispatcher();
  const shining = writable(false);

  const themes: ButtonTheme = {
    primary: '#a855f7',
    secondary: '#10b981',
    success: '#3b82f6',
    danger: '#ef4444',
    warning: '#f59e0b',
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
    <span class="spinner ring"></span>
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
    border: 2px solid rgba(255, 255, 255, 0.25);
    border-radius: 18px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    backdrop-filter: blur(15px) brightness(1.1);
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Frosted Glass Effect */
  .glass.primary {
    background: rgba(168, 85, 247, 0.18);
    color: #a855f7;
    box-shadow: 0 10px 40px rgba(168, 85, 247, 0.25), inset 0 2px 0 rgba(255, 255, 255, 0.2);
  }

  .glass.primary:hover {
    background: rgba(168, 85, 247, 0.28);
    box-shadow: 0 15px 50px rgba(168, 85, 247, 0.35), inset 0 2px 0 rgba(255, 255, 255, 0.3);
    transform: translateY(-3px);
  }

  .glass.secondary {
    background: rgba(16, 185, 129, 0.18);
    color: #10b981;
    box-shadow: 0 10px 40px rgba(16, 185, 129, 0.25), inset 0 2px 0 rgba(255, 255, 255, 0.2);
  }

  .glass.secondary:hover {
    transform: translateY(-3px);
  }

  .glass.success {
    background: rgba(59, 130, 246, 0.18);
    color: #3b82f6;
    box-shadow: 0 10px 40px rgba(59, 130, 246, 0.25), inset 0 2px 0 rgba(255, 255, 255, 0.2);
  }

  .glass.danger {
    background: rgba(239, 68, 68, 0.18);
    color: #ef4444;
    box-shadow: 0 10px 40px rgba(239, 68, 68, 0.25), inset 0 2px 0 rgba(255, 255, 255, 0.2);
  }

  .glass.warning {
    background: rgba(245, 158, 11, 0.18);
    color: #f59e0b;
    box-shadow: 0 10px 40px rgba(245, 158, 11, 0.25), inset 0 2px 0 rgba(255, 255, 255, 0.2);
  }

  .glass.info {
    background: rgba(20, 184, 166, 0.18);
    color: #14b8a6;
    box-shadow: 0 10px 40px rgba(20, 184, 166, 0.25), inset 0 2px 0 rgba(255, 255, 255, 0.2);
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner.ring {
    width: 1.2em;
    height: 1.2em;
    border: 3px solid transparent;
    border-top-color: currentColor;
    border-right-color: currentColor;
    border-radius: 50%;
    animation: ring 1s cubic-bezier(0.68, -0.55, 0.265, 1.55) infinite;
  }

  @keyframes ring {
    0% { transform: rotate(0deg) scale(1); }
    50% { transform: rotate(180deg) scale(1.1); }
    100% { transform: rotate(360deg) scale(1); }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
