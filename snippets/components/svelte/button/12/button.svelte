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
  const borderGlow = writable(false);

  const themes: ButtonTheme = {
    primary: '#4f46e5',
    secondary: '#9333ea',
    success: '#16a34a',
    danger: '#dc2626',
    warning: '#ca8a04',
    info: '#0891b2'
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
      borderGlow.set(true);
      setTimeout(() => borderGlow.set(false), 400);
      dispatch('click', event);
    }
  }
</script>

<button
  class="btn {sizes[size]} {variant} {theme}"
  class:full-width={fullWidth}
  class:loading={loading}
  class:glow={$borderGlow}
  {disabled}
  on:click={handleClick}
>
  {#if loading}
    <span class="spinner circle-dots"></span>
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
    border: 3px solid;
    border-radius: 8px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Thick Outline with Animated Border */
  .outline.primary {
    border-color: #4f46e5;
    color: #4f46e5;
  }

  .outline.primary:hover {
    background: rgba(79, 70, 229, 0.05);
    border-width: 4px;
    padding: calc(0.5rem - 1px) calc(1rem - 1px);
  }

  .outline.primary.glow {
    animation: borderGlow 0.4s ease-out;
  }

  .outline.secondary {
    border-color: #9333ea;
    color: #9333ea;
  }

  .outline.secondary:hover {
    background: rgba(147, 51, 234, 0.05);
    border-width: 4px;
  }

  .outline.success {
    border-color: #16a34a;
    color: #16a34a;
  }

  .outline.danger {
    border-color: #dc2626;
    color: #dc2626;
  }

  .outline.warning {
    border-color: #ca8a04;
    color: #ca8a04;
  }

  .outline.info {
    border-color: #0891b2;
    color: #0891b2;
  }

  @keyframes borderGlow {
    0% { box-shadow: 0 0 0 0 currentColor; }
    50% { box-shadow: 0 0 20px 5px transparent; }
    100% { box-shadow: 0 0 0 0 transparent; }
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner.circle-dots {
    width: 1.2em;
    height: 1.2em;
    position: relative;
  }

  .spinner.circle-dots::before,
  .spinner.circle-dots::after {
    content: '';
    position: absolute;
    width: 4px;
    height: 4px;
    border-radius: 50%;
    background: currentColor;
    animation: circleDots 1.5s ease-in-out infinite;
  }

  .spinner.circle-dots::before {
    top: 0;
    left: 50%;
    transform: translateX(-50%);
  }

  .spinner.circle-dots::after {
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    animation-delay: 0.75s;
  }

  @keyframes circleDots {
    0%, 100% { opacity: 0.2; }
    50% { opacity: 1; }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
