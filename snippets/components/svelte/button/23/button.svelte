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
    primary: '#ec4899',
    secondary: '#14b8a6',
    success: '#84cc16',
    danger: '#ef4444',
    warning: '#fb923c',
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
    <span class="spinner dots-circle"></span>
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
    border-radius: 10px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }
  .btn::after {
    content: '';
    position: absolute;
    bottom: 2px;
    left: 50%;
    width: 0;
    height: 3px;
    background: currentColor;
    transform: translateX(-50%);
    transition: width 0.3s ease;
    border-radius: 2px;
  }
  .full-width {
    width: 100%;
    justify-content: center;
  }
  /* Ghost with Bottom Bar */
  .ghost.primary {
    color: #ec4899;
  }
  .ghost.primary:hover {
    background: rgba(236, 72, 153, 0.1);
  }
  .ghost.primary:hover::after {
    width: 80%;
  }
  .ghost.secondary {
    color: #14b8a6;
  }
  .ghost.secondary:hover {
    background: rgba(20, 184, 166, 0.1);
  }
  .ghost.secondary:hover::after {
    width: 80%;
  }
  .ghost.success {
    color: #84cc16;
  }
  .ghost.success:hover::after {
    width: 80%;
  }
  .ghost.danger {
    color: #ef4444;
  }
  .ghost.warning {
    color: #fb923c;
  }
  .ghost.info {
    color: #0ea5e9;
  }
  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }
  .spinner.dots-circle {
    width: 1.2em;
    height: 1.2em;
    position: relative;
    animation: dotsCircle 2s linear infinite;
  }
  .spinner.dots-circle::before,
  .spinner.dots-circle::after {
    content: '';
    position: absolute;
    width: 4px;
    height: 4px;
    border-radius: 50%;
    background: currentColor;
  }
  .spinner.dots-circle::before {
    top: 0;
    left: 50%;
    transform: translateX(-50%);
  }
  .spinner.dots-circle::after {
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
  }
  @keyframes dotsCircle {
    to { transform: rotate(360deg); }
  }
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
