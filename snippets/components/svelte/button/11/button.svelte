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
  const isActive = writable(false);
  const themes: ButtonTheme = {
    primary: '#f0f4ff',
    secondary: '#fdf4ff',
    success: '#f0fdf4',
    danger: '#fef2f2',
    warning: '#fffbeb',
    info: '#f0f9ff'
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
      isActive.set(true);
      setTimeout(() => isActive.set(false), 200);
      dispatch('click', event);
    }
  }
</script>
<button
  class="btn {sizes[size]} {variant} {theme}"
  class:full-width={fullWidth}
  class:loading={loading}
  class:active={$isActive}
  {disabled}
  on:click={handleClick}
>
  {#if loading}
    <span class="spinner star"></span>
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
    border-radius: 25px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }
  .full-width {
    width: 100%;
    justify-content: center;
  }
  /* Enhanced Neumorphic with Soft Shadows */
  .neumorphic.primary {
    background: #f0f4ff;
    color: #3730a3;
    box-shadow: 10px 10px 20px #d0d4df, -10px -10px 20px #ffffff;
  }
  .neumorphic.primary:hover {
    box-shadow: 15px 15px 30px #d0d4df, -15px -15px 30px #ffffff;
  }
  .neumorphic.primary.active {
    box-shadow: inset 6px 6px 12px #d0d4df, inset -6px -6px 12px #ffffff;
  }
  .neumorphic.secondary {
    background: #fdf4ff;
    color: #86198f;
    box-shadow: 10px 10px 20px #ddd4df, -10px -10px 20px #ffffff;
  }
  .neumorphic.success {
    background: #f0fdf4;
    color: #166534;
    box-shadow: 10px 10px 20px #d0ddd4, -10px -10px 20px #ffffff;
  }
  .neumorphic.danger {
    background: #fef2f2;
    color: #991b1b;
    box-shadow: 10px 10px 20px #ded2d2, -10px -10px 20px #ffffff;
  }
  .neumorphic.warning {
    background: #fffbeb;
    color: #92400e;
    box-shadow: 10px 10px 20px #dfdbcb, -10px -10px 20px #ffffff;
  }
  .neumorphic.info {
    background: #f0f9ff;
    color: #075985;
    box-shadow: 10px 10px 20px #d0d9df, -10px -10px 20px #ffffff;
  }
  /* Loading State */
  .btn.loading {
    pointer-events: none;
    opacity: 0.7;
  }
  .spinner.star {
    width: 1em;
    height: 1em;
    clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
    background: currentColor;
    animation: starRotate 2s linear infinite;
  }
  @keyframes starRotate {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
