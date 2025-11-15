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

  export let variant: 'solid' | 'outline' | 'ghost' | 'gradient' | 'glass' | 'neumorphic' = 'outline';
  export let size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'md';
  export let fullWidth: boolean = false;
  export let loading: boolean = false;
  export let icon: string = '';
  export let iconPosition: 'left' | 'right' = 'left';
  export let disabled: boolean = false;
  export let theme: keyof ButtonTheme = 'primary';

  const dispatch = createEventDispatcher();
  const hoverIntensity = writable(0);

  const themes: ButtonTheme = {
    primary: '#818cf8',
    secondary: '#c084fc',
    success: '#4ade80',
    danger: '#f87171',
    warning: '#fbbf24',
    info: '#38bdf8'
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
  on:mouseenter={() => hoverIntensity.set(1)}
  on:mouseleave={() => hoverIntensity.set(0)}
>
  {#if loading}
    <span class="spinner wave"></span>
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
    border: 2px solid;
    border-radius: 10px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Outline with Bounce Effect */
  .outline.primary {
    border-color: #818cf8;
    color: #818cf8;
  }

  .outline.primary:hover {
    background: #818cf8;
    color: white;
    transform: scale(1.1);
    box-shadow: 0 0 25px rgba(129, 140, 248, 0.5);
  }

  .outline.secondary {
    border-color: #c084fc;
    color: #c084fc;
  }

  .outline.secondary:hover {
    background: #c084fc;
    color: white;
    transform: scale(1.1);
    box-shadow: 0 0 25px rgba(192, 132, 252, 0.5);
  }

  .outline.success {
    border-color: #4ade80;
    color: #4ade80;
  }

  .outline.success:hover {
    background: #4ade80;
    color: white;
    transform: scale(1.1);
  }

  .outline.danger {
    border-color: #f87171;
    color: #f87171;
  }

  .outline.danger:hover {
    background: #f87171;
    color: white;
    transform: scale(1.1);
  }

  .outline.warning {
    border-color: #fbbf24;
    color: #fbbf24;
  }

  .outline.warning:hover {
    background: #fbbf24;
    color: white;
    transform: scale(1.1);
  }

  .outline.info {
    border-color: #38bdf8;
    color: #38bdf8;
  }

  .outline.info:hover {
    background: #38bdf8;
    color: white;
    transform: scale(1.1);
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner.wave {
    width: 1.5em;
    height: 1em;
    display: flex;
    gap: 3px;
    align-items: center;
  }

  .spinner.wave::before,
  .spinner.wave::after {
    content: '';
    width: 4px;
    height: 100%;
    background: currentColor;
    border-radius: 2px;
    animation: wave 1.2s ease-in-out infinite;
  }

  .spinner.wave::before {
    animation-delay: -0.4s;
  }

  .spinner.wave::after {
    animation-delay: -0.2s;
  }

  @keyframes wave {
    0%, 100% { height: 50%; }
    50% { height: 100%; }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
