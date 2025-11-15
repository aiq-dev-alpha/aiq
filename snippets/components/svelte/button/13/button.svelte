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
  export let variant: 'solid' | 'outline' | 'ghost' | 'gradient' | 'glass' | 'neumorphic' = 'solid';
  export let size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'md';
  export let fullWidth: boolean = false;
  export let loading: boolean = false;
  export let icon: string = '';
  export let iconPosition: 'left' | 'right' = 'left';
  export let disabled: boolean = false;
  export let theme: keyof ButtonTheme = 'primary';
  const dispatch = createEventDispatcher();
  const slideActive = writable(false);
  const themes: ButtonTheme = {
    primary: '#6366f1',
    secondary: '#f59e0b',
    success: '#22c55e',
    danger: '#ef4444',
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
      slideActive.set(true);
      setTimeout(() => slideActive.set(false), 500);
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
  <span class="btn-slide"></span>
  <span class="btn-text">
    {#if loading}
      <span class="spinner triangle"></span>
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
    border-radius: 6px;
    font-weight: 600;
    cursor: pointer;
    overflow: hidden;
  }
  .btn-slide {
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    transition: left 0.4s ease;
  }
  .btn-text {
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
  /* Solid with Slide Effect */
  .solid.primary {
    background: #6366f1;
    color: white;
  }
  .solid.primary .btn-slide {
    background: #4f46e5;
  }
  .solid.primary:hover .btn-slide {
    left: 0;
  }
  .solid.secondary {
    background: #f59e0b;
    color: white;
  }
  .solid.secondary .btn-slide {
    background: #d97706;
  }
  .solid.secondary:hover .btn-slide {
    left: 0;
  }
  .solid.success {
    background: #22c55e;
    color: white;
  }
  .solid.success .btn-slide {
    background: #16a34a;
  }
  .solid.success:hover .btn-slide {
    left: 0;
  }
  .solid.danger {
    background: #ef4444;
    color: white;
  }
  .solid.danger .btn-slide {
    background: #dc2626;
  }
  .solid.danger:hover .btn-slide {
    left: 0;
  }
  .solid.warning {
    background: #eab308;
    color: white;
  }
  .solid.warning .btn-slide {
    background: #ca8a04;
  }
  .solid.warning:hover .btn-slide {
    left: 0;
  }
  .solid.info {
    background: #14b8a6;
    color: white;
  }
  .solid.info .btn-slide {
    background: #0d9488;
  }
  .solid.info:hover .btn-slide {
    left: 0;
  }
  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }
  .spinner.triangle {
    width: 0;
    height: 0;
    border-left: 8px solid transparent;
    border-right: 8px solid transparent;
    border-bottom: 14px solid currentColor;
    animation: triangleSpin 1.5s ease-in-out infinite;
  }
  @keyframes triangleSpin {
    0%, 100% { transform: rotate(0deg); }
    33% { transform: rotate(120deg); }
    66% { transform: rotate(240deg); }
  }
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
