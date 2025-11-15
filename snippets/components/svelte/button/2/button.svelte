<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { tweened } from 'svelte/motion';
  import { cubicInOut } from 'svelte/easing';

  // Ripple Wave Button - Unique in FEEL (water ripple effect), VISUAL (concentric waves), ANIMATION (wave propagation)
  export let variant: 'primary' | 'secondary' | 'success' | 'danger' | 'warning' | 'info' = 'primary';
  export let size: 'sm' | 'md' | 'lg' = 'md';
  export let disabled: boolean = false;

  const dispatch = createEventDispatcher();

  let ripples: Array<{ id: number; x: number; y: number }> = [];

  const variants = {
    primary: '#3b82f6',
    secondary: '#a855f7',
    success: '#22c55e',
    danger: '#ef4444',
    warning: '#f59e0b',
    info: '#06b6d4'
  };

  const sizes = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-6 py-3 text-base',
    lg: 'px-8 py-4 text-lg'
  };

  function createRipple(event: MouseEvent) {
    if (disabled) return;

    const button = event.currentTarget as HTMLButtonElement;
    const rect = button.getBoundingClientRect();
    const x = event.clientX - rect.left;
    const y = event.clientY - rect.top;

    const ripple = { id: Date.now(), x, y };
    ripples = [...ripples, ripple];

    setTimeout(() => {
      ripples = ripples.filter(r => r.id !== ripple.id);
    }, 1000);

    dispatch('click', event);
  }
</script>

<button
  class="ripple-button {sizes[size]} {variant}"
  on:click={createRipple}
  {disabled}
  type="button"
>
  <slot>Ripple Wave</slot>

  {#each ripples as ripple (ripple.id)}
    <span
      class="ripple"
      style="left: {ripple.x}px; top: {ripple.y}px;"
    />
  {/each}
</button>

<style>
  .ripple-button {
    position: relative;
    border: none;
    border-radius: 50px;
    font-weight: 700;
    cursor: pointer;
    overflow: hidden;
    color: white;
    transition: all 0.3s ease;
  }

  .primary {
    background: linear-gradient(135deg, #3b82f6, #1e40af);
    box-shadow: 0 4px 20px rgba(59, 130, 246, 0.3);
  }

  .primary:hover:not(:disabled) {
    box-shadow: 0 6px 30px rgba(59, 130, 246, 0.5);
    transform: translateY(-2px);
  }

  .secondary {
    background: linear-gradient(135deg, #a855f7, #7e22ce);
    box-shadow: 0 4px 20px rgba(168, 85, 247, 0.3);
  }

  .secondary:hover:not(:disabled) {
    box-shadow: 0 6px 30px rgba(168, 85, 247, 0.5);
    transform: translateY(-2px);
  }

  .success {
    background: linear-gradient(135deg, #22c55e, #15803d);
    box-shadow: 0 4px 20px rgba(34, 197, 94, 0.3);
  }

  .success:hover:not(:disabled) {
    box-shadow: 0 6px 30px rgba(34, 197, 94, 0.5);
    transform: translateY(-2px);
  }

  .danger {
    background: linear-gradient(135deg, #ef4444, #b91c1c);
    box-shadow: 0 4px 20px rgba(239, 68, 68, 0.3);
  }

  .danger:hover:not(:disabled) {
    box-shadow: 0 6px 30px rgba(239, 68, 68, 0.5);
    transform: translateY(-2px);
  }

  .warning {
    background: linear-gradient(135deg, #f59e0b, #b45309);
    box-shadow: 0 4px 20px rgba(245, 158, 11, 0.3);
  }

  .warning:hover:not(:disabled) {
    box-shadow: 0 6px 30px rgba(245, 158, 11, 0.5);
    transform: translateY(-2px);
  }

  .info {
    background: linear-gradient(135deg, #06b6d4, #0e7490);
    box-shadow: 0 4px 20px rgba(6, 182, 212, 0.3);
  }

  .info:hover:not(:disabled) {
    box-shadow: 0 6px 30px rgba(6, 182, 212, 0.5);
    transform: translateY(-2px);
  }

  .ripple {
    position: absolute;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.6);
    pointer-events: none;
    transform: translate(-50%, -50%);
    animation: ripple-animation 1s ease-out;
  }

  @keyframes ripple-animation {
    from {
      width: 0;
      height: 0;
      opacity: 1;
    }
    to {
      width: 300px;
      height: 300px;
      opacity: 0;
    }
  }

  .ripple-button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
