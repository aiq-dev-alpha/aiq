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
  const pressed = writable(false);

  const themes: ButtonTheme = {
    primary: '#6366f1',
    secondary: '#8b5cf6',
    success: '#10b981',
    danger: '#ef4444',
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
  {#if loading}
    <span class="spinner flip"></span>
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
    border-radius: 6px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Ghost with Underline Effect */
  .ghost.primary {
    color: #6366f1;
    position: relative;
  }

  .ghost.primary::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 50%;
    width: 0;
    height: 2px;
    background: #6366f1;
    transition: all 0.3s ease;
    transform: translateX(-50%);
  }

  .ghost.primary:hover::after {
    width: 100%;
  }

  .ghost.primary:hover {
    background: rgba(99, 102, 241, 0.1);
  }

  .ghost.secondary {
    color: #8b5cf6;
  }

  .ghost.secondary::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 50%;
    width: 0;
    height: 2px;
    background: #8b5cf6;
    transition: all 0.3s ease;
    transform: translateX(-50%);
  }

  .ghost.secondary:hover::after {
    width: 100%;
  }

  .ghost.secondary:hover {
    background: rgba(139, 92, 246, 0.1);
  }

  .ghost.success {
    color: #10b981;
  }

  .ghost.success::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 50%;
    width: 0;
    height: 2px;
    background: #10b981;
    transition: all 0.3s ease;
    transform: translateX(-50%);
  }

  .ghost.success:hover::after {
    width: 100%;
  }

  .ghost.danger {
    color: #ef4444;
  }

  .ghost.danger::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 50%;
    width: 0;
    height: 2px;
    background: #ef4444;
    transition: all 0.3s ease;
    transform: translateX(-50%);
  }

  .ghost.danger:hover::after {
    width: 100%;
  }

  .ghost.warning {
    color: #f59e0b;
  }

  .ghost.warning::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 50%;
    width: 0;
    height: 2px;
    background: #f59e0b;
    transition: all 0.3s ease;
    transform: translateX(-50%);
  }

  .ghost.warning:hover::after {
    width: 100%;
  }

  .ghost.info {
    color: #06b6d4;
  }

  .ghost.info::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 50%;
    width: 0;
    height: 2px;
    background: #06b6d4;
    transition: all 0.3s ease;
    transform: translateX(-50%);
  }

  .ghost.info:hover::after {
    width: 100%;
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner.flip {
    width: 1em;
    height: 1em;
    border: 2px solid currentColor;
    border-radius: 3px;
    animation: flip 1.2s ease-in-out infinite;
  }

  @keyframes flip {
    0%, 100% { transform: rotateY(0deg); }
    50% { transform: rotateY(180deg); }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
