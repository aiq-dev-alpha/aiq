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
  const themes: ButtonTheme = {
    primary: '#a855f7',
    secondary: '#3b82f6',
    success: '#22c55e',
    danger: '#f43f5e',
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
    <span class="spinner pulse-ring"></span>
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
    border-radius: 50px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
  }
  .full-width {
    width: 100%;
    justify-content: center;
  }
  /* Rounded Outline with Glow */
  .outline.primary {
    border-color: #a855f7;
    color: #a855f7;
  }
  .outline.primary:hover {
    background: #a855f7;
    color: white;
    box-shadow: 0 0 20px rgba(168, 85, 247, 0.5), inset 0 0 10px rgba(168, 85, 247, 0.2);
    transform: scale(1.05);
  }
  .outline.secondary {
    border-color: #3b82f6;
    color: #3b82f6;
  }
  .outline.secondary:hover {
    background: #3b82f6;
    color: white;
  }
  .outline.success {
    border-color: #22c55e;
    color: #22c55e;
  }
  .outline.danger {
    border-color: #f43f5e;
    color: #f43f5e;
  }
  .outline.warning {
    border-color: #fbbf24;
    color: #fbbf24;
  }
  .outline.info {
    border-color: #22d3ee;
    color: #22d3ee;
  }
  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }
  .spinner.pulse-ring {
    width: 1em;
    height: 1em;
    border: 2px solid currentColor;
    border-radius: 50%;
    animation: pulseRing 1.5s cubic-bezier(0.215, 0.610, 0.355, 1.000) infinite;
  }
  @keyframes pulseRing {
    0% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.3); opacity: 0.5; }
    100% { transform: scale(1); opacity: 1; }
  }
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
