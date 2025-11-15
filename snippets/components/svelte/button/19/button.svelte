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
    secondary: '#a855f7',
    success: '#10b981',
    danger: '#f43f5e',
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
    <span class="spinner bars"></span>
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
    border-radius: 0;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
    clip-path: polygon(8% 0%, 100% 0%, 92% 100%, 0% 100%);
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Diagonal Gradient with Skew */
  .gradient.primary {
    background: linear-gradient(to bottom right, #6366f1, #4f46e5, #4338ca);
    color: white;
    box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
  }

  .gradient.primary:hover {
    background: linear-gradient(to top left, #6366f1, #4f46e5, #4338ca);
    transform: translateY(-2px);
  }

  .gradient.secondary {
    background: linear-gradient(to bottom right, #a855f7, #9333ea, #7e22ce);
    color: white;
  }

  .gradient.success {
    background: linear-gradient(to bottom right, #10b981, #059669, #047857);
    color: white;
  }

  .gradient.danger {
    background: linear-gradient(to bottom right, #f43f5e, #e11d48, #be123c);
    color: white;
  }

  .gradient.warning {
    background: linear-gradient(to bottom right, #f59e0b, #d97706, #b45309);
    color: white;
  }

  .gradient.info {
    background: linear-gradient(to bottom right, #14b8a6, #0d9488, #0f766e);
    color: white;
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner.bars {
    width: 1.2em;
    height: 1em;
    display: flex;
    gap: 2px;
    align-items: flex-end;
  }

  .spinner.bars::before,
  .spinner.bars::after {
    content: '';
    width: 4px;
    background: currentColor;
    animation: bars 1s ease-in-out infinite;
  }

  .spinner.bars::before {
    animation-delay: -0.3s;
  }

  @keyframes bars {
    0%, 100% { height: 30%; }
    50% { height: 100%; }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
