<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { spring } from 'svelte/motion';

  // Liquid/Morphing Button - Unique in FEEL (liquid physics), LOOK (morphing shape), CAPABILITIES (progress tracking)
  export let variant: 'primary' | 'secondary' | 'success' | 'danger' | 'warning' | 'info' = 'primary';
  export let size: 'sm' | 'md' | 'lg' = 'md';
  export let disabled: boolean = false;
  export let progress: number = 0; // 0-100 for liquid fill animation
  export let morphOnHover: boolean = true;

  const dispatch = createEventDispatcher();
  const liquidLevel = spring(0, { stiffness: 0.1, damping: 0.3 });
  const morphAmount = spring(0, { stiffness: 0.2, damping: 0.4 });

  const variants = {
    primary: { color: '#3b82f6', gradient: 'linear-gradient(135deg, #3b82f6, #1d4ed8)' },
    secondary: { color: '#a855f7', gradient: 'linear-gradient(135deg, #a855f7, #7c3aed)' },
    success: { color: '#22c55e', gradient: 'linear-gradient(135deg, #22c55e, #16a34a)' },
    danger: { color: '#f43f5e', gradient: 'linear-gradient(135deg, #f43f5e, #dc2626)' },
    warning: { color: '#fb923c', gradient: 'linear-gradient(135deg, #fb923c, #ea580c)' },
    info: { color: '#22d3ee', gradient: 'linear-gradient(135deg, #22d3ee, #06b6d4)' }
  };

  const sizes = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-6 py-3 text-base',
    lg: 'px-8 py-4 text-lg'
  };

  function handleClick() {
    if (!disabled) {
      dispatch('click');
    }
  }

  function handleMouseEnter() {
    if (morphOnHover && !disabled) {
      morphAmount.set(1);
    }
  }

  function handleMouseLeave() {
    if (morphOnHover) {
      morphAmount.set(0);
    }
  }

  $: liquidLevel.set(progress);
</script>

<button
  class="liquid-button {sizes[size]} {variant}"
  on:click={handleClick}
  on:mouseenter={handleMouseEnter}
  on:mouseleave={handleMouseLeave}
  {disabled}
  type="button"
>
  <svg class="liquid-svg" viewBox="0 0 200 60" preserveAspectRatio="none">
    <defs>
      <linearGradient id="liquid-gradient-{variant}" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" style="stop-color:{variants[variant].color};stop-opacity:0.8" />
        <stop offset="100%" style="stop-color:{variants[variant].color};stop-opacity:1" />
      </linearGradient>
    </defs>
    <path
      class="liquid-path"
      d="M 0,{60 - ($liquidLevel * 0.6)}
         Q 25,{60 - ($liquidLevel * 0.6) - (Math.sin(Date.now() * 0.001) * 3 * $morphAmount)}
         50,{60 - ($liquidLevel * 0.6)}
         T 100,{60 - ($liquidLevel * 0.6)}
         T 150,{60 - ($liquidLevel * 0.6)}
         T 200,{60 - ($liquidLevel * 0.6)}
         L 200,60 L 0,60 Z"
      fill="url(#liquid-gradient-{variant})"
    />
  </svg>
  <span class="liquid-content">
    <slot>Liquid Button</slot>
  </span>
  <div class="blob blob-1" style="opacity: {$morphAmount * 0.3}"></div>
  <div class="blob blob-2" style="opacity: {$morphAmount * 0.2}"></div>
</button>

<style>
  .liquid-button {
    position: relative;
    border: 2px solid;
    border-radius: 50px;
    font-weight: 600;
    cursor: pointer;
    overflow: hidden;
    transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
    background: rgba(255, 255, 255, 0.05);
  }

  .liquid-svg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 0;
  }

  .liquid-content {
    position: relative;
    z-index: 2;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .primary {
    border-color: #3b82f6;
    color: #3b82f6;
  }

  .primary:hover:not(:disabled) {
    color: white;
    border-color: #2563eb;
    box-shadow: 0 0 20px rgba(59, 130, 246, 0.4);
  }

  .secondary {
    border-color: #a855f7;
    color: #a855f7;
  }

  .secondary:hover:not(:disabled) {
    color: white;
    box-shadow: 0 0 20px rgba(168, 85, 247, 0.4);
  }

  .success {
    border-color: #22c55e;
    color: #22c55e;
  }

  .success:hover:not(:disabled) {
    color: white;
    box-shadow: 0 0 20px rgba(34, 197, 94, 0.4);
  }

  .danger {
    border-color: #f43f5e;
    color: #f43f5e;
  }

  .danger:hover:not(:disabled) {
    color: white;
    box-shadow: 0 0 20px rgba(244, 63, 94, 0.4);
  }

  .warning {
    border-color: #fb923c;
    color: #fb923c;
  }

  .warning:hover:not(:disabled) {
    color: white;
    box-shadow: 0 0 20px rgba(251, 146, 60, 0.4);
  }

  .info {
    border-color: #22d3ee;
    color: #22d3ee;
  }

  .info:hover:not(:disabled) {
    color: white;
    box-shadow: 0 0 20px rgba(34, 211, 238, 0.4);
  }

  .blob {
    position: absolute;
    border-radius: 50%;
    background: currentColor;
    pointer-events: none;
    z-index: 1;
    animation: blobFloat 3s ease-in-out infinite;
  }

  .blob-1 {
    width: 40px;
    height: 40px;
    top: -10px;
    left: 10%;
    animation-delay: 0s;
  }

  .blob-2 {
    width: 30px;
    height: 30px;
    bottom: -5px;
    right: 15%;
    animation-delay: 1.5s;
  }

  @keyframes blobFloat {
    0%, 100% { transform: translate(0, 0) scale(1); }
    33% { transform: translate(10px, -10px) scale(1.1); }
    66% { transform: translate(-10px, 10px) scale(0.9); }
  }

  .liquid-button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  .liquid-button:active:not(:disabled) {
    transform: scale(0.95);
  }
</style>
