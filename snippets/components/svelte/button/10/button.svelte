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
  const floating = writable(false);

  const themes: ButtonTheme = {
    primary: '#6366f1',
    secondary: '#ec4899',
    success: '#10b981',
    danger: '#f43f5e',
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
  on:mouseenter={() => floating.set(true)}
  on:mouseleave={() => floating.set(false)}
>
  {#if loading}
    <span class="spinner hexagon"></span>
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
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    backdrop-filter: blur(20px) saturate(180%);
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Enhanced Glassmorphism with Float Effect */
  .glass.primary {
    background: linear-gradient(135deg, rgba(99, 102, 241, 0.15), rgba(99, 102, 241, 0.25));
    color: #6366f1;
    box-shadow: 0 8px 32px rgba(99, 102, 241, 0.15), inset 0 1px 1px rgba(255, 255, 255, 0.3);
  }

  .glass.primary:hover {
    background: linear-gradient(135deg, rgba(99, 102, 241, 0.25), rgba(99, 102, 241, 0.35));
    box-shadow: 0 16px 48px rgba(99, 102, 241, 0.3), inset 0 1px 1px rgba(255, 255, 255, 0.4);
    transform: translateY(-4px);
  }

  .glass.secondary {
    background: linear-gradient(135deg, rgba(236, 72, 153, 0.15), rgba(236, 72, 153, 0.25));
    color: #ec4899;
    box-shadow: 0 8px 32px rgba(236, 72, 153, 0.15), inset 0 1px 1px rgba(255, 255, 255, 0.3);
  }

  .glass.secondary:hover {
    background: linear-gradient(135deg, rgba(236, 72, 153, 0.25), rgba(236, 72, 153, 0.35));
    transform: translateY(-4px);
  }

  .glass.success {
    background: linear-gradient(135deg, rgba(16, 185, 129, 0.15), rgba(16, 185, 129, 0.25));
    color: #10b981;
    box-shadow: 0 8px 32px rgba(16, 185, 129, 0.15), inset 0 1px 1px rgba(255, 255, 255, 0.3);
  }

  .glass.danger {
    background: linear-gradient(135deg, rgba(244, 63, 94, 0.15), rgba(244, 63, 94, 0.25));
    color: #f43f5e;
    box-shadow: 0 8px 32px rgba(244, 63, 94, 0.15), inset 0 1px 1px rgba(255, 255, 255, 0.3);
  }

  .glass.warning {
    background: linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(245, 158, 11, 0.25));
    color: #f59e0b;
    box-shadow: 0 8px 32px rgba(245, 158, 11, 0.15), inset 0 1px 1px rgba(255, 255, 255, 0.3);
  }

  .glass.info {
    background: linear-gradient(135deg, rgba(6, 182, 212, 0.15), rgba(6, 182, 212, 0.25));
    color: #06b6d4;
    box-shadow: 0 8px 32px rgba(6, 182, 212, 0.15), inset 0 1px 1px rgba(255, 255, 255, 0.3);
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner.hexagon {
    width: 1em;
    height: 1em;
    clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
    background: currentColor;
    animation: hexagonRotate 1.5s ease-in-out infinite;
  }

  @keyframes hexagonRotate {
    0%, 100% { transform: rotate(0deg) scale(1); }
    50% { transform: rotate(180deg) scale(1.2); }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
