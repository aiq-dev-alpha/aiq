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
  const rippleActive = writable(false);

  const themes: ButtonTheme = {
    primary: '#0ea5e9',
    secondary: '#f97316',
    success: '#65a30d',
    danger: '#be123c',
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
      rippleActive.set(true);
      setTimeout(() => rippleActive.set(false), 600);
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
  <span class="btn-content">
    {#if loading}
      <span class="spinner orbit"></span>
    {:else}
      {#if icon && iconPosition === 'left'}
        <slot name="icon-left">{icon}</slot>
      {/if}
      <slot></slot>
      {#if icon && iconPosition === 'right'}
        <slot name="icon-right">{icon}</slot>
      {/if}
    {/if}
  </span>
  {#if $rippleActive}
    <span class="ripple"></span>
  {/if}
</button>

<style>
  .btn {
    position: relative;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    overflow: hidden;
  }

  .btn-content {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    position: relative;
    z-index: 1;
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Solid with Metallic Effect */
  .solid.primary {
    background: linear-gradient(180deg, #38bdf8, #0ea5e9, #0284c7);
    color: white;
    box-shadow: 0 4px 6px rgba(14, 165, 233, 0.3), inset 0 1px 0 rgba(255, 255, 255, 0.2);
  }

  .solid.primary:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 12px rgba(14, 165, 233, 0.4), inset 0 1px 0 rgba(255, 255, 255, 0.3);
  }

  .solid.secondary {
    background: linear-gradient(180deg, #fb923c, #f97316, #ea580c);
    color: white;
    box-shadow: 0 4px 6px rgba(249, 115, 22, 0.3), inset 0 1px 0 rgba(255, 255, 255, 0.2);
  }

  .solid.success {
    background: linear-gradient(180deg, #84cc16, #65a30d, #4d7c0f);
    color: white;
    box-shadow: 0 4px 6px rgba(101, 163, 13, 0.3), inset 0 1px 0 rgba(255, 255, 255, 0.2);
  }

  .solid.danger {
    background: linear-gradient(180deg, #f43f5e, #be123c, #9f1239);
    color: white;
    box-shadow: 0 4px 6px rgba(190, 18, 60, 0.3), inset 0 1px 0 rgba(255, 255, 255, 0.2);
  }

  .solid.warning {
    background: linear-gradient(180deg, #facc15, #ca8a04, #a16207);
    color: white;
    box-shadow: 0 4px 6px rgba(202, 138, 4, 0.3), inset 0 1px 0 rgba(255, 255, 255, 0.2);
  }

  .solid.info {
    background: linear-gradient(180deg, #22d3ee, #0891b2, #0e7490);
    color: white;
    box-shadow: 0 4px 6px rgba(8, 145, 178, 0.3), inset 0 1px 0 rgba(255, 255, 255, 0.2);
  }

  .ripple {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.6);
    transform: translate(-50%, -50%);
    animation: ripple 0.6s ease-out;
  }

  @keyframes ripple {
    to {
      width: 300px;
      height: 300px;
      opacity: 0;
    }
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner.orbit {
    width: 1em;
    height: 1em;
    position: relative;
  }

  .spinner.orbit::before {
    content: '';
    position: absolute;
    width: 100%;
    height: 100%;
    border: 2px solid transparent;
    border-top-color: currentColor;
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }

  .spinner.orbit::after {
    content: '';
    position: absolute;
    top: 3px;
    left: 3px;
    right: 3px;
    bottom: 3px;
    border: 2px solid transparent;
    border-bottom-color: currentColor;
    border-radius: 50%;
    animation: spin 0.5s linear reverse infinite;
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
