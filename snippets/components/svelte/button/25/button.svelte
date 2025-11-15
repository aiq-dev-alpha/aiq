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
  const glowing = writable(false);
  const themes: ButtonTheme = {
    primary: '#c084fc',
    secondary: '#34d399',
    success: '#60a5fa',
    danger: '#fb7185',
    warning: '#fbbf24',
    info: '#22d3ee'
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
      glowing.set(true);
      setTimeout(() => glowing.set(false), 800);
      dispatch('click', event);
    }
  }
</script>
<button
  class="btn {sizes[size]} {variant} {theme}"
  class:full-width={fullWidth}
  class:loading={loading}
  class:glow={$glowing}
  {disabled}
  on:click={handleClick}
>
  {#if loading}
    <span class="spinner atom"></span>
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
    border: 1px solid rgba(255, 255, 255, 0.3);
    border-radius: 20px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.4s ease;
    backdrop-filter: blur(25px) saturate(200%);
  }
  .full-width {
    width: 100%;
    justify-content: center;
  }
  /* Premium Glassmorphism with Multiple Effects */
  .glass.primary {
    background: linear-gradient(135deg, rgba(192, 132, 252, 0.2), rgba(192, 132, 252, 0.1));
    color: #c084fc;
    box-shadow: 0 12px 48px rgba(192, 132, 252, 0.25), inset 0 2px 4px rgba(255, 255, 255, 0.3);
  }
  .glass.primary:hover {
    background: linear-gradient(135deg, rgba(192, 132, 252, 0.3), rgba(192, 132, 252, 0.2));
    box-shadow: 0 20px 60px rgba(192, 132, 252, 0.4), inset 0 2px 4px rgba(255, 255, 255, 0.4);
    transform: translateY(-5px) scale(1.02);
  }
  .glass.primary.glow {
    animation: glowEffect 0.8s ease-out;
  }
  .glass.secondary {
    background: linear-gradient(135deg, rgba(52, 211, 153, 0.2), rgba(52, 211, 153, 0.1));
    color: #34d399;
    box-shadow: 0 12px 48px rgba(52, 211, 153, 0.25), inset 0 2px 4px rgba(255, 255, 255, 0.3);
  }
  .glass.secondary:hover {
    transform: translateY(-5px) scale(1.02);
  }
  .glass.success {
    background: linear-gradient(135deg, rgba(96, 165, 250, 0.2), rgba(96, 165, 250, 0.1));
    color: #60a5fa;
    box-shadow: 0 12px 48px rgba(96, 165, 250, 0.25), inset 0 2px 4px rgba(255, 255, 255, 0.3);
  }
  .glass.danger {
    background: linear-gradient(135deg, rgba(251, 113, 133, 0.2), rgba(251, 113, 133, 0.1));
    color: #fb7185;
    box-shadow: 0 12px 48px rgba(251, 113, 133, 0.25), inset 0 2px 4px rgba(255, 255, 255, 0.3);
  }
  .glass.warning {
    background: linear-gradient(135deg, rgba(251, 191, 36, 0.2), rgba(251, 191, 36, 0.1));
    color: #fbbf24;
    box-shadow: 0 12px 48px rgba(251, 191, 36, 0.25), inset 0 2px 4px rgba(255, 255, 255, 0.3);
  }
  .glass.info {
    background: linear-gradient(135deg, rgba(34, 211, 238, 0.2), rgba(34, 211, 238, 0.1));
    color: #22d3ee;
    box-shadow: 0 12px 48px rgba(34, 211, 238, 0.25), inset 0 2px 4px rgba(255, 255, 255, 0.3);
  }
  @keyframes glowEffect {
    0%, 100% { box-shadow: 0 12px 48px rgba(192, 132, 252, 0.25), inset 0 2px 4px rgba(255, 255, 255, 0.3); }
    50% { box-shadow: 0 0 60px 15px rgba(192, 132, 252, 0.6), inset 0 2px 4px rgba(255, 255, 255, 0.5); }
  }
  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }
  .spinner.atom {
    width: 1.5em;
    height: 1.5em;
    position: relative;
    animation: atomSpin 2s linear infinite;
  }
  .spinner.atom::before,
  .spinner.atom::after {
    content: '';
    position: absolute;
    width: 100%;
    height: 100%;
    border: 2px solid currentColor;
    border-radius: 50%;
  }
  .spinner.atom::before {
    transform: rotate(60deg);
  }
  .spinner.atom::after {
    transform: rotate(-60deg);
  }
  @keyframes atomSpin {
    to { transform: rotate(360deg); }
  }
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
