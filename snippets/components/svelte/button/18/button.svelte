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

  export let variant: 'solid' | 'outline' | 'ghost' | 'gradient' | 'glass' | 'neumorphic' = 'ghost';
  export let size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'md';
  export let fullWidth: boolean = false;
  export let loading: boolean = false;
  export let icon: string = '';
  export let iconPosition: 'left' | 'right' = 'left';
  export let disabled: boolean = false;
  export let theme: keyof ButtonTheme = 'primary';

  const dispatch = createEventDispatcher();

  const themes: ButtonTheme = {
    primary: '#8b5cf6',
    secondary: '#06b6d4',
    success: '#22c55e',
    danger: '#f43f5e',
    warning: '#eab308',
    info: '#0ea5e9'
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
    <span class="spinner infinity"></span>
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
    background: transparent;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    border-radius: 8px;
    border: 2px solid transparent;
    transition: all 0.3s ease;
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Ghost with Border Animation */
  .ghost.primary {
    color: #8b5cf6;
  }

  .ghost.primary:hover {
    background: rgba(139, 92, 246, 0.12);
  }

  .ghost.primary:hover::before {
    border-color: #8b5cf6;
    border-left-width: 4px;
  }

  .ghost.secondary {
    color: #06b6d4;
  }

  .ghost.secondary:hover {
    background: rgba(6, 182, 212, 0.12);
  }

  .ghost.success {
    color: #22c55e;
  }

  .ghost.danger {
    color: #f43f5e;
  }

  .ghost.warning {
    color: #eab308;
  }

  .ghost.info {
    color: #0ea5e9;
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner.infinity {
    width: 1.5em;
    height: 0.8em;
    position: relative;
  }

  .spinner.infinity::before,
  .spinner.infinity::after {
    content: '';
    position: absolute;
    width: 0.8em;
    height: 0.8em;
    border: 2px solid currentColor;
    border-radius: 50%;
  }

  .spinner.infinity::before {
    left: 0;
    animation: infinityLeft 2s ease-in-out infinite;
  }

  .spinner.infinity::after {
    right: 0;
    animation: infinityRight 2s ease-in-out infinite;
  }

  @keyframes infinityLeft {
    0%, 100% { transform: translateX(0) scale(1); }
    50% { transform: translateX(0.4em) scale(0.7); }
  }

  @keyframes infinityRight {
    0%, 100% { transform: translateX(0) scale(1); }
    50% { transform: translateX(-0.4em) scale(0.7); }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
