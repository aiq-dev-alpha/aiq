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
  const expanding = writable(false);

  const themes: ButtonTheme = {
    primary: '#ec4899',
    secondary: '#8b5cf6',
    success: '#10b981',
    danger: '#dc2626',
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
      expanding.set(true);
      setTimeout(() => expanding.set(false), 300);
      dispatch('click', event);
    }
  }
</script>

<button
  class="btn {sizes[size]} {variant} {theme}"
  class:full-width={fullWidth}
  class:loading={loading}
  class:expanding={$expanding}
  {disabled}
  on:click={handleClick}
>
  {#if loading}
    <span class="spinner gear"></span>
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
    border-radius: 10px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Solid with Expand Effect */
  .solid.primary {
    background: linear-gradient(to right, #ec4899, #db2777);
    color: white;
    box-shadow: 0 4px 15px rgba(236, 72, 153, 0.3);
  }

  .solid.primary:hover {
    background: linear-gradient(to right, #db2777, #be185d);
    box-shadow: 0 6px 20px rgba(236, 72, 153, 0.5);
  }

  .solid.primary.expanding {
    transform: scale(1.08);
  }

  .solid.secondary {
    background: linear-gradient(to right, #8b5cf6, #7c3aed);
    color: white;
  }

  .solid.success {
    background: linear-gradient(to right, #10b981, #059669);
    color: white;
  }

  .solid.danger {
    background: linear-gradient(to right, #dc2626, #b91c1c);
    color: white;
  }

  .solid.warning {
    background: linear-gradient(to right, #f59e0b, #d97706);
    color: white;
  }

  .solid.info {
    background: linear-gradient(to right, #06b6d4, #0891b2);
    color: white;
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner.gear {
    width: 1.2em;
    height: 1.2em;
    border: 3px solid currentColor;
    border-radius: 3px;
    position: relative;
    animation: gearSpin 1.5s ease-in-out infinite;
  }

  .spinner.gear::before,
  .spinner.gear::after {
    content: '';
    position: absolute;
    background: currentColor;
  }

  .spinner.gear::before {
    top: -3px;
    left: 50%;
    transform: translateX(-50%);
    width: 3px;
    height: 6px;
  }

  .spinner.gear::after {
    left: -3px;
    top: 50%;
    transform: translateY(-50%);
    height: 3px;
    width: 6px;
  }

  @keyframes gearSpin {
    0%, 100% { transform: rotate(0deg); }
    50% { transform: rotate(180deg); }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
