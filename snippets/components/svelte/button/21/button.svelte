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
  const shaking = writable(false);
  const themes: ButtonTheme = {
    primary: '#14b8a6',
    secondary: '#f59e0b',
    success: '#84cc16',
    danger: '#dc2626',
    warning: '#f97316',
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
      shaking.set(true);
      setTimeout(() => shaking.set(false), 500);
      dispatch('click', event);
    }
  }
</script>
<button
  class="btn {sizes[size]} {variant} {theme}"
  class:full-width={fullWidth}
  class:loading={loading}
  class:shake={$shaking}
  {disabled}
  on:click={handleClick}
>
  {#if loading}
    <span class="spinner radar"></span>
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
    border-radius: 5px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
    text-transform: uppercase;
    letter-spacing: 0.1em;
  }
  .full-width {
    width: 100%;
    justify-content: center;
  }
  /* Solid with Vibrant Colors */
  .solid.primary {
    background: #14b8a6;
    color: white;
    box-shadow: 0 0 0 0 rgba(20, 184, 166, 0.4), 0 4px 10px rgba(20, 184, 166, 0.3);
  }
  .solid.primary:hover {
    background: #0d9488;
    box-shadow: 0 0 0 4px rgba(20, 184, 166, 0.2), 0 6px 15px rgba(20, 184, 166, 0.4);
  }
  .solid.primary.shake {
    animation: shake 0.5s ease;
  }
  .solid.secondary {
    background: #f59e0b;
    color: white;
  }
  .solid.success {
    background: #84cc16;
    color: white;
  }
  .solid.danger {
    background: #dc2626;
    color: white;
  }
  .solid.warning {
    background: #f97316;
    color: white;
  }
  .solid.info {
    background: #06b6d4;
    color: white;
  }
  @keyframes shake {
    0%, 100% { transform: translateX(0); }
    25% { transform: translateX(-5px); }
    75% { transform: translateX(5px); }
  }
  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }
  .spinner.radar {
    width: 1.2em;
    height: 1.2em;
    border: 2px solid transparent;
    border-top-color: currentColor;
    border-right-color: currentColor;
    border-radius: 50%;
    animation: radar 1s linear infinite;
  }
  @keyframes radar {
    0% { transform: rotate(0deg); opacity: 1; }
    50% { opacity: 0.5; }
    100% { transform: rotate(360deg); opacity: 1; }
  }
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
