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

  export let variant: 'solid' | 'outline' | 'ghost' | 'gradient' | 'glass' | 'neumorphic' = 'neumorphic';
  export let size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'md';
  export let fullWidth: boolean = false;
  export let loading: boolean = false;
  export let icon: string = '';
  export let iconPosition: 'left' | 'right' = 'left';
  export let disabled: boolean = false;
  export let theme: keyof ButtonTheme = 'primary';

  const dispatch = createEventDispatcher();
  const pressed = writable(false);

  const themes: ButtonTheme = {
    primary: '#dbeafe',
    secondary: '#fce7f3',
    success: '#d1fae5',
    danger: '#fee2e2',
    warning: '#fef3c7',
    info: '#ccfbf1'
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
      pressed.set(true);
      setTimeout(() => pressed.set(false), 150);
      dispatch('click', event);
    }
  }
</script>

<button
  class="btn {sizes[size]} {variant} {theme}"
  class:full-width={fullWidth}
  class:loading={loading}
  class:pressed={$pressed}
  {disabled}
  on:click={handleClick}
>
  {#if loading}
    <span class="spinner ellipsis"></span>
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
    border-radius: 35px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .full-width {
    width: 100%;
    justify-content: center;
  }

  /* Soft Neumorphic */
  .neumorphic.primary {
    background: #dbeafe;
    color: #1e40af;
    box-shadow: 6px 6px 12px #b8ccd9, -6px -6px 12px #ffffff;
  }

  .neumorphic.primary:hover {
    box-shadow: 9px 9px 18px #b8ccd9, -9px -9px 18px #ffffff;
  }

  .neumorphic.primary.pressed {
    box-shadow: inset 3px 3px 6px #b8ccd9, inset -3px -3px 6px #ffffff;
  }

  .neumorphic.secondary {
    background: #fce7f3;
    color: #9f1239;
    box-shadow: 6px 6px 12px #d3c4cd, -6px -6px 12px #ffffff;
  }

  .neumorphic.success {
    background: #d1fae5;
    color: #065f46;
    box-shadow: 6px 6px 12px #aed4be, -6px -6px 12px #ffffff;
  }

  .neumorphic.danger {
    background: #fee2e2;
    color: #991b1b;
    box-shadow: 6px 6px 12px #d5bfbf, -6px -6px 12px #ffffff;
  }

  .neumorphic.warning {
    background: #fef3c7;
    color: #78350f;
    box-shadow: 6px 6px 12px #d5cfa7, -6px -6px 12px #ffffff;
  }

  .neumorphic.info {
    background: #ccfbf1;
    color: #134e4a;
    box-shadow: 6px 6px 12px #aad4cd, -6px -6px 12px #ffffff;
  }

  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }

  .spinner.ellipsis {
    display: flex;
    gap: 4px;
    align-items: center;
  }

  .spinner.ellipsis::before,
  .spinner.ellipsis::after {
    content: '';
    width: 5px;
    height: 5px;
    border-radius: 50%;
    background: currentColor;
    animation: ellipsis 1.4s ease-in-out infinite;
  }

  .spinner.ellipsis::before {
    animation-delay: -0.3s;
  }

  @keyframes ellipsis {
    0%, 60%, 100% { opacity: 0.3; }
    30% { opacity: 1; }
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
