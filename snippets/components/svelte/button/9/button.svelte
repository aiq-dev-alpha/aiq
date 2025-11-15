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
  const shimmer = writable(false);
  const themes: ButtonTheme = {
    primary: '#4f46e5',
    secondary: '#7c3aed',
    success: '#059669',
    danger: '#be123c',
    warning: '#ea580c',
    info: '#0369a1'
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
      shimmer.set(true);
      setTimeout(() => shimmer.set(false), 600);
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
  <span class="btn-bg"></span>
  <span class="btn-content">
    {#if loading}
      <span class="spinner diamond"></span>
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
    border-radius: 50px;
    font-weight: 600;
    cursor: pointer;
    overflow: hidden;
  }
  .btn-bg {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    transition: all 0.4s ease;
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
  /* Gradient with Shimmer Effect */
  .gradient.primary .btn-bg {
    background: linear-gradient(135deg, #4f46e5 0%, #6366f1 50%, #818cf8 100%);
  }
  .gradient.primary {
    color: white;
  }
  .gradient.primary:hover .btn-bg {
    background: linear-gradient(135deg, #4338ca 0%, #4f46e5 50%, #6366f1 100%);
    transform: scale(1.05);
  }
  .gradient.secondary .btn-bg {
    background: linear-gradient(135deg, #7c3aed 0%, #8b5cf6 50%, #a78bfa 100%);
  }
  .gradient.secondary {
    color: white;
  }
  .gradient.success .btn-bg {
    background: linear-gradient(135deg, #059669 0%, #10b981 50%, #34d399 100%);
  }
  .gradient.success {
    color: white;
  }
  .gradient.danger .btn-bg {
    background: linear-gradient(135deg, #be123c 0%, #e11d48 50%, #f43f5e 100%);
  }
  .gradient.danger {
    color: white;
  }
  .gradient.warning .btn-bg {
    background: linear-gradient(135deg, #ea580c 0%, #f97316 50%, #fb923c 100%);
  }
  .gradient.warning {
    color: white;
  }
  .gradient.info .btn-bg {
    background: linear-gradient(135deg, #0369a1 0%, #0284c7 50%, #0ea5e9 100%);
  }
  .gradient.info {
    color: white;
  }
  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }
  .spinner.diamond {
    width: 1em;
    height: 1em;
    background: currentColor;
    transform: rotate(45deg);
    animation: diamondSpin 1.2s ease-in-out infinite;
  }
  @keyframes diamondSpin {
    0%, 100% { transform: rotate(45deg) scale(1); }
    50% { transform: rotate(225deg) scale(0.7); }
  }
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
