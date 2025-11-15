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
  const pulsing = writable(false);
  const themes: ButtonTheme = {
    primary: '#8b5cf6',
    secondary: '#06b6d4',
    success: '#84cc16',
    danger: '#f43f5e',
    warning: '#fb923c',
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
>
  {#if loading}
    <span class="spinner morph"></span>
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
    border-radius: 30px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  }
  .full-width {
    width: 100%;
    justify-content: center;
  }
  /* Radial Gradient with Glow */
  .gradient.primary {
    background: radial-gradient(circle at top left, #a78bfa, #8b5cf6, #7c3aed);
    color: white;
    box-shadow: 0 8px 24px rgba(139, 92, 246, 0.4);
  }
  .gradient.primary:hover {
    background: radial-gradient(circle at bottom right, #a78bfa, #8b5cf6, #7c3aed);
    box-shadow: 0 12px 32px rgba(139, 92, 246, 0.6);
    transform: translateY(-3px);
  }
  .gradient.secondary {
    background: radial-gradient(circle at top left, #22d3ee, #06b6d4, #0891b2);
    color: white;
    box-shadow: 0 8px 24px rgba(6, 182, 212, 0.4);
  }
  .gradient.secondary:hover {
    transform: translateY(-3px);
  }
  .gradient.success {
    background: radial-gradient(circle at top left, #a3e635, #84cc16, #65a30d);
    color: white;
    box-shadow: 0 8px 24px rgba(132, 204, 22, 0.4);
  }
  .gradient.danger {
    background: radial-gradient(circle at top left, #fb7185, #f43f5e, #e11d48);
    color: white;
    box-shadow: 0 8px 24px rgba(244, 63, 94, 0.4);
  }
  .gradient.warning {
    background: radial-gradient(circle at top left, #fbbf24, #fb923c, #f59e0b);
    color: white;
    box-shadow: 0 8px 24px rgba(251, 146, 60, 0.4);
  }
  .gradient.info {
    background: radial-gradient(circle at top left, #7dd3fc, #38bdf8, #0ea5e9);
    color: white;
    box-shadow: 0 8px 24px rgba(56, 189, 248, 0.4);
  }
  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }
  .spinner.morph {
    width: 1em;
    height: 1em;
    border-radius: 50%;
    background: currentColor;
    animation: morph 1.5s ease-in-out infinite;
  }
  @keyframes morph {
    0%, 100% { border-radius: 50%; transform: rotate(0deg); }
    25% { border-radius: 0%; transform: rotate(90deg); }
    50% { border-radius: 50%; transform: rotate(180deg); }
    75% { border-radius: 0%; transform: rotate(270deg); }
  }
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
