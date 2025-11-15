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
    primary: '#6366f1',
    secondary: '#ec4899',
    success: '#14b8a6',
    danger: '#ef4444',
    warning: '#f59e0b',
    info: '#3b82f6'
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
    <span class="spinner cross"></span>
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
    border: 2px dashed;
    border-radius: 12px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
  }
  .full-width {
    width: 100%;
    justify-content: center;
  }
  /* Dashed Outline */
  .outline.primary {
    border-color: #6366f1;
    color: #6366f1;
  }
  .outline.primary:hover {
    border-style: solid;
    background: rgba(99, 102, 241, 0.08);
    transform: translateX(2px);
  }
  .outline.secondary {
    border-color: #ec4899;
    color: #ec4899;
  }
  .outline.secondary:hover {
    border-style: solid;
    background: rgba(236, 72, 153, 0.08);
  }
  .outline.success {
    border-color: #14b8a6;
    color: #14b8a6;
  }
  .outline.danger {
    border-color: #ef4444;
    color: #ef4444;
  }
  .outline.warning {
    border-color: #f59e0b;
    color: #f59e0b;
  }
  .outline.info {
    border-color: #3b82f6;
    color: #3b82f6;
  }
  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }
  .spinner.cross {
    width: 1em;
    height: 1em;
    position: relative;
  }
  .spinner.cross::before,
  .spinner.cross::after {
    content: '';
    position: absolute;
    background: currentColor;
    top: 50%;
    left: 50%;
  }
  .spinner.cross::before {
    width: 100%;
    height: 2px;
    transform: translate(-50%, -50%);
    animation: crossX 1.2s ease-in-out infinite;
  }
  .spinner.cross::after {
    width: 2px;
    height: 100%;
    transform: translate(-50%, -50%);
    animation: crossY 1.2s ease-in-out infinite;
  }
  @keyframes crossX {
    0%, 100% { width: 100%; }
    50% { width: 0%; }
  }
  @keyframes crossY {
    0%, 100% { height: 0%; }
    50% { height: 100%; }
  }
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
