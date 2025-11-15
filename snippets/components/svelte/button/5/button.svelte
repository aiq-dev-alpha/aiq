<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { tweened } from 'svelte/motion';
  import { cubicOut } from 'svelte/easing';

  // 3D Flip Button - Unique in STRUCTURE (card-like front/back), LOOK (3D perspective), FEEL (flip animation)
  export let variant: 'primary' | 'secondary' | 'success' | 'danger' | 'warning' | 'info' = 'primary';
  export let size: 'sm' | 'md' | 'lg' = 'md';
  export let disabled: boolean = false;
  export let loadingText: string = 'Loading...';
  export let successText: string = 'Success!';
  export let state: 'idle' | 'loading' | 'success' | 'error' = 'idle';

  const dispatch = createEventDispatcher();
  const rotation = tweened(0, { duration: 600, easing: cubicOut });

  const variants = {
    primary: { front: '#3b82f6', back: '#1d4ed8' },
    secondary: { front: '#8b5cf6', back: '#6d28d9' },
    success: { front: '#10b981', back: '#047857' },
    danger: { front: '#ef4444', back: '#b91c1c' },
    warning: { front: '#f59e0b', back: '#d97706' },
    info: { front: '#06b6d4', back: '#0e7490' }
  };

  const sizes = {
    sm: { padding: 'px-3 py-1.5 text-sm', height: '32px' },
    md: { padding: 'px-5 py-2.5 text-base', height: '42px' },
    lg: { padding: 'px-7 py-3.5 text-lg', height: '52px' }
  };

  async function handleClick() {
    if (!disabled && state === 'idle') {
      rotation.set(180);
      setTimeout(() => rotation.set(0), 600);
      dispatch('click');
    }
  }

  $: if (state === 'loading' || state === 'success' || state === 'error') {
    rotation.set(180);
  } else {
    rotation.set(0);
  }
</script>

<div class="flip-button-container" style="height: {sizes[size].height}">
  <button
    class="flip-button {sizes[size].padding} {variant}"
    style="transform: rotateX({$rotation}deg)"
    on:click={handleClick}
    {disabled}
    type="button"
  >
    <div class="flip-button-face flip-button-front">
      <slot>Click Me</slot>
    </div>
    <div class="flip-button-face flip-button-back">
      {#if state === 'loading'}
        <div class="loader-dots">
          <span></span><span></span><span></span>
        </div>
        {loadingText}
      {:else if state === 'success'}
        <span class="status-icon">✓</span>
        {successText}
      {:else if state === 'error'}
        <span class="status-icon">✕</span>
        Error
      {:else}
        <slot name="back">Flipped!</slot>
      {/if}
    </div>
  </button>
</div>

<style>
  .flip-button-container {
    perspective: 1000px;
    display: inline-block;
  }

  .flip-button {
    position: relative;
    width: 100%;
    height: 100%;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    font-weight: 600;
    transform-style: preserve-3d;
    transition: transform 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  }

  .flip-button-face {
    position: absolute;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    backface-visibility: hidden;
    border-radius: 10px;
  }

  .flip-button-front {
    color: white;
  }

  .flip-button-back {
    color: white;
    transform: rotateX(180deg);
  }

  .primary .flip-button-front {
    background: linear-gradient(135deg, #3b82f6, #2563eb);
    box-shadow: 0 4px 15px rgba(59, 130, 246, 0.4);
  }

  .primary .flip-button-back {
    background: linear-gradient(135deg, #1d4ed8, #1e40af);
    box-shadow: 0 4px 15px rgba(29, 78, 216, 0.4);
  }

  .secondary .flip-button-front {
    background: linear-gradient(135deg, #8b5cf6, #7c3aed);
  }

  .secondary .flip-button-back {
    background: linear-gradient(135deg, #6d28d9, #5b21b6);
  }

  .success .flip-button-front {
    background: linear-gradient(135deg, #10b981, #059669);
  }

  .success .flip-button-back {
    background: linear-gradient(135deg, #047857, #065f46);
  }

  .danger .flip-button-front {
    background: linear-gradient(135deg, #ef4444, #dc2626);
  }

  .danger .flip-button-back {
    background: linear-gradient(135deg, #b91c1c, #991b1b);
  }

  .warning .flip-button-front {
    background: linear-gradient(135deg, #f59e0b, #d97706);
  }

  .warning .flip-button-back {
    background: linear-gradient(135deg, #d97706, #b45309);
  }

  .info .flip-button-front {
    background: linear-gradient(135deg, #06b6d4, #0891b2);
  }

  .info .flip-button-back {
    background: linear-gradient(135deg, #0e7490, #0c4a6e);
  }

  .flip-button:hover:not(:disabled) {
    transform: rotateX(10deg);
  }

  .flip-button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  .loader-dots {
    display: flex;
    gap: 4px;
  }

  .loader-dots span {
    width: 6px;
    height: 6px;
    background: currentColor;
    border-radius: 50%;
    animation: dotBounce 1.4s ease-in-out infinite both;
  }

  .loader-dots span:nth-child(1) { animation-delay: -0.32s; }
  .loader-dots span:nth-child(2) { animation-delay: -0.16s; }

  @keyframes dotBounce {
    0%, 80%, 100% { transform: scale(0); }
    40% { transform: scale(1); }
  }

  .status-icon {
    font-size: 1.2em;
    font-weight: bold;
  }
</style>
