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
  const isPressed = writable(false);
  const themes: ButtonTheme = {
    primary: '#6366f1',
    secondary: '#d946ef',
    success: '#84cc16',
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
      isPressed.set(true);
      setTimeout(() => isPressed.set(false), 180);
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
    <span class="spinner dots"></span>
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
    border-radius: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    backdrop-filter: blur(10px);
  }
  .full-width {
    width: 100%;
    justify-content: center;
  }
  /* Glassmorphism Variant */
  .glass.primary {
    background: rgba(99, 102, 241, 0.2);
    border: 1px solid rgba(99, 102, 241, 0.3);
    color: #6366f1;
    box-shadow: 0 8px 32px rgba(99, 102, 241, 0.2);
  }
  .glass.primary:hover {
    background: rgba(99, 102, 241, 0.3);
    box-shadow: 0 12px 48px rgba(99, 102, 241, 0.3);
    transform: translateY(-2px);
  }
  .glass.secondary {
    background: rgba(217, 70, 239, 0.2);
    border: 1px solid rgba(217, 70, 239, 0.3);
    color: #d946ef;
    box-shadow: 0 8px 32px rgba(217, 70, 239, 0.2);
  }
  .glass.secondary:hover {
    background: rgba(217, 70, 239, 0.3);
    box-shadow: 0 12px 48px rgba(217, 70, 239, 0.3);
  }
  .glass.success {
    background: rgba(132, 204, 22, 0.2);
    border: 1px solid rgba(132, 204, 22, 0.3);
    color: #84cc16;
    box-shadow: 0 8px 32px rgba(132, 204, 22, 0.2);
  }
  .glass.danger {
    background: rgba(251, 113, 133, 0.2);
    border: 1px solid rgba(251, 113, 133, 0.3);
    color: #fb7185;
    box-shadow: 0 8px 32px rgba(251, 113, 133, 0.2);
  }
  .glass.warning {
    background: rgba(251, 191, 36, 0.2);
    border: 1px solid rgba(251, 191, 36, 0.3);
    color: #fbbf24;
    box-shadow: 0 8px 32px rgba(251, 191, 36, 0.2);
  }
  .glass.info {
    background: rgba(34, 211, 238, 0.2);
    border: 1px solid rgba(34, 211, 238, 0.3);
    color: #22d3ee;
    box-shadow: 0 8px 32px rgba(34, 211, 238, 0.2);
  }
  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }
  .spinner.dots {
    display: flex;
    gap: 4px;
  }
  .spinner.dots::before,
  .spinner.dots::after {
    content: '';
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: currentColor;
    animation: dotPulse 1.4s ease-in-out infinite;
  }
  .spinner.dots::before {
    animation-delay: -0.32s;
  }
  .spinner.dots::after {
    animation-delay: -0.16s;
  }
  @keyframes dotPulse {
    0%, 80%, 100% { opacity: 0.3; transform: scale(0.8); }
    40% { opacity: 1; transform: scale(1); }
  }
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
