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
  const isPressed = writable(false);
  const themes: ButtonTheme = {
    primary: '#e0e7ff',
    secondary: '#fae8ff',
    success: '#dcfce7',
    danger: '#fee2e2',
    warning: '#fef3c7',
    info: '#cffafe'
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
      setTimeout(() => isPressed.set(false), 250);
      dispatch('click', event);
    }
  }
</script>
<button
  class="btn {sizes[size]} {variant} {theme}"
  class:full-width={fullWidth}
  class:loading={loading}
  class:pressed={$isPressed}
  {disabled}
  on:click={handleClick}
>
  {#if loading}
    <span class="spinner bounce"></span>
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
    border-radius: 20px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
  }
  .full-width {
    width: 100%;
    justify-content: center;
  }
  /* Neumorphic Variant */
  .neumorphic.primary {
    background: #e0e7ff;
    color: #4338ca;
    box-shadow: 8px 8px 16px #bcc3e0, -8px -8px 16px #ffffff;
  }
  .neumorphic.primary:hover {
    box-shadow: 12px 12px 24px #bcc3e0, -12px -12px 24px #ffffff;
  }
  .neumorphic.primary.pressed {
    box-shadow: inset 4px 4px 8px #bcc3e0, inset -4px -4px 8px #ffffff;
  }
  .neumorphic.secondary {
    background: #fae8ff;
    color: #a21caf;
    box-shadow: 8px 8px 16px #d4c7d9, -8px -8px 16px #ffffff;
  }
  .neumorphic.success {
    background: #dcfce7;
    color: #15803d;
    box-shadow: 8px 8px 16px #bcd6c4, -8px -8px 16px #ffffff;
  }
  .neumorphic.danger {
    background: #fee2e2;
    color: #b91c1c;
    box-shadow: 8px 8px 16px #d9c0c0, -8px -8px 16px #ffffff;
  }
  .neumorphic.warning {
    background: #fef3c7;
    color: #a16207;
    box-shadow: 8px 8px 16px #d9cfa9, -8px -8px 16px #ffffff;
  }
  .neumorphic.info {
    background: #cffafe;
    color: #0e7490;
    box-shadow: 8px 8px 16px #b0d4d8, -8px -8px 16px #ffffff;
  }
  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }
  .spinner.bounce {
    width: 1em;
    height: 1em;
    border-radius: 50%;
    background: currentColor;
    animation: bounce 1s ease-in-out infinite;
  }
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-8px); }
  }
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
