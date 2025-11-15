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
  const glowActive = writable(false);

  const themes: ButtonTheme = {
    primary: '#6366f1',
    secondary: '#a855f7',
    success: '#14b8a6',
    danger: '#dc2626',
    warning: '#d97706',
    info: '#0284c7'
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
      glowActive.set(true);
      setTimeout(() => glowActive.set(false), 300);
      dispatch('click', event);
    }
  }
</script>

<button
  class="btn {sizes[size]} {variant} {theme}"
  class:full-width={fullWidth}
  class:loading={loading}
  class:glow={$glowActive}
  {disabled}
  on:click={handleClick}
>
  {#if loading}
    <span class="spinner square"></span>
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
    border-radius: 4px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Solid with Sharp Corners and Bold Style */
  .solid.primary {
    background: #6366f1;
    color: white;
    box-shadow: 0 0 0 0 rgba(99, 102, 241, 0.7);
  }

  .solid.primary:hover {
    background: #4f46e5;
    transform: translateY(-2px);
  }

  .solid.primary.glow {
    animation: glowPulse 0.3s ease-out;
  }

  .solid.secondary {
    background: #a855f7;
    color: white;
  }

  .solid.secondary:hover {
    background: #9333ea;
  }

  .solid.success {
    background: #14b8a6;
    color: white;
  }

  .solid.success:hover {
    background: #0d9488;
  }

  .solid.danger {
    background: #dc2626;
    color: white;
  }

  .solid.danger:hover {
    background: #b91c1c;
  }

  .solid.warning {
    background: #d97706;
    color: white;
  }

  .solid.warning:hover {
    background: #b45309;
  }

  .solid.info {
    background: #0284c7;
    color: white;
  }

  .solid.info:hover {
    background: #0369a1;
  }

  @keyframes glowPulse {
    0% { box-shadow: 0 0 0 0 currentColor; }
    50% { box-shadow: 0 0 20px 10px transparent; }
    100% { box-shadow: 0 0 0 0 transparent; }
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner.square {
    width: 1em;
    height: 1em;
    border: 2px solid currentColor;
    animation: rotateSquare 1s ease-in-out infinite;
  }

  @keyframes rotateSquare {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
