<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { spring } from 'svelte/motion';

  // Magnetic Button - Unique in FEEL (follows cursor), INTERACTION (magnetic pull), UX (playful feedback)
  export let variant: 'primary' | 'secondary' | 'success' | 'danger' | 'warning' | 'info' = 'primary';
  export let size: 'sm' | 'md' | 'lg' = 'md';
  export let disabled: boolean = false;
  export let magneticStrength: number = 0.3;

  const dispatch = createEventDispatcher();
  const position = spring({ x: 0, y: 0 }, { stiffness: 0.15, damping: 0.4 });

  const variants = {
    primary: { bg: '#6366f1', shadow: 'rgba(99, 102, 241, 0.4)' },
    secondary: { bg: '#8b5cf6', shadow: 'rgba(139, 92, 246, 0.4)' },
    success: { bg: '#10b981', shadow: 'rgba(16, 185, 129, 0.4)' },
    danger: { bg: '#ef4444', shadow: 'rgba(239, 68, 68, 0.4)' },
    warning: { bg: '#f59e0b', shadow: 'rgba(245, 158, 11, 0.4)' },
    info: { bg: '#06b6d4', shadow: 'rgba(6, 182, 212, 0.4)' }
  };

  const sizes = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-6 py-3 text-base',
    lg: 'px-8 py-4 text-lg'
  };

  let buttonElement: HTMLButtonElement;

  function handleMouseMove(e: MouseEvent) {
    if (!buttonElement || disabled) return;

    const rect = buttonElement.getBoundingClientRect();
    const centerX = rect.left + rect.width / 2;
    const centerY = rect.top + rect.height / 2;

    const deltaX = (e.clientX - centerX) * magneticStrength;
    const deltaY = (e.clientY - centerY) * magneticStrength;

    position.set({ x: deltaX, y: deltaY });
  }

  function handleMouseLeave() {
    position.set({ x: 0, y: 0 });
  }

  function handleClick(event: MouseEvent) {
    if (!disabled) {
      dispatch('click', event);
    }
  }
</script>

<button
  bind:this={buttonElement}
  class="magnetic-button {sizes[size]} {variant}"
  style="transform: translate({$position.x}px, {$position.y}px)"
  on:mousemove={handleMouseMove}
  on:mouseleave={handleMouseLeave}
  on:click={handleClick}
  {disabled}
  type="button"
>
  <slot>Magnetic Button</slot>
</button>

<style>
  .magnetic-button {
    border: none;
    border-radius: 12px;
    font-weight: 600;
    cursor: pointer;
    transition: box-shadow 0.3s ease, filter 0.3s ease;
    color: white;
    position: relative;
  }

  .primary {
    background: linear-gradient(135deg, #6366f1, #4f46e5);
    box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
  }

  .primary:hover:not(:disabled) {
    box-shadow: 0 8px 25px rgba(99, 102, 241, 0.6);
    filter: brightness(1.1);
  }

  .secondary {
    background: linear-gradient(135deg, #8b5cf6, #7c3aed);
    box-shadow: 0 4px 15px rgba(139, 92, 246, 0.4);
  }

  .secondary:hover:not(:disabled) {
    box-shadow: 0 8px 25px rgba(139, 92, 246, 0.6);
    filter: brightness(1.1);
  }

  .success {
    background: linear-gradient(135deg, #10b981, #059669);
    box-shadow: 0 4px 15px rgba(16, 185, 129, 0.4);
  }

  .success:hover:not(:disabled) {
    box-shadow: 0 8px 25px rgba(16, 185, 129, 0.6);
    filter: brightness(1.1);
  }

  .danger {
    background: linear-gradient(135deg, #ef4444, #dc2626);
    box-shadow: 0 4px 15px rgba(239, 68, 68, 0.4);
  }

  .danger:hover:not(:disabled) {
    box-shadow: 0 8px 25px rgba(239, 68, 68, 0.6);
    filter: brightness(1.1);
  }

  .warning {
    background: linear-gradient(135deg, #f59e0b, #d97706);
    box-shadow: 0 4px 15px rgba(245, 158, 11, 0.4);
  }

  .warning:hover:not(:disabled) {
    box-shadow: 0 8px 25px rgba(245, 158, 11, 0.6);
    filter: brightness(1.1);
  }

  .info {
    background: linear-gradient(135deg, #06b6d4, #0891b2);
    box-shadow: 0 4px 15px rgba(6, 182, 212, 0.4);
  }

  .info:hover:not(:disabled) {
    box-shadow: 0 8px 25px rgba(6, 182, 212, 0.6);
    filter: brightness(1.1);
  }

  .magnetic-button:active:not(:disabled) {
    transform: scale(0.95);
  }

  .magnetic-button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
