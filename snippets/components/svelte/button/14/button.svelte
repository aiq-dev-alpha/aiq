<script lang="ts">
  import { createEventDispatcher, onMount } from 'svelte';
  import { writable } from 'svelte/store';

  // Particle Burst Button - Unique in FEEL (particle physics), LOOK (explosion effect), USER EXPERIENCE (celebration feedback)
  export let variant: 'primary' | 'secondary' | 'success' | 'danger' | 'warning' | 'info' = 'primary';
  export let size: 'sm' | 'md' | 'lg' = 'md';
  export let disabled: boolean = false;
  export let particleCount: number = 20;

  const dispatch = createEventDispatcher();
  const particles = writable<Array<{id: number; x: number; y: number; vx: number; vy: number; life: number}>>([]);

  const variants = {
    primary: { color: '#3b82f6', particleColors: ['#3b82f6', '#60a5fa', '#93c5fd'] },
    secondary: { color: '#a855f7', particleColors: ['#a855f7', '#c084fc', '#e9d5ff'] },
    success: { color: '#22c55e', particleColors: ['#22c55e', '#4ade80', '#86efac'] },
    danger: { color: '#ef4444', particleColors: ['#ef4444', '#f87171', '#fca5a5'] },
    warning: { color: '#f59e0b', particleColors: ['#f59e0b', '#fbbf24', '#fde047'] },
    info: { color: '#06b6d4', particleColors: ['#06b6d4', '#22d3ee', '#67e8f9'] }
  };

  const sizes = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-6 py-3 text-base',
    lg: 'px-8 py-4 text-lg'
  };

  let buttonElement: HTMLButtonElement;

  function createParticleBurst() {
    if (!buttonElement) return;

    const rect = buttonElement.getBoundingClientRect();
    const centerX = rect.width / 2;
    const centerY = rect.height / 2;
    const newParticles = [];

    for (let i = 0; i < particleCount; i++) {
      const angle = (Math.PI * 2 * i) / particleCount;
      const velocity = 2 + Math.random() * 3;
      newParticles.push({
        id: Date.now() + i,
        x: centerX,
        y: centerY,
        vx: Math.cos(angle) * velocity,
        vy: Math.sin(angle) * velocity,
        life: 1
      });
    }

    particles.set(newParticles);

    // Animate particles
    const animate = () => {
      particles.update(p => {
        const updated = p.map(particle => ({
          ...particle,
          x: particle.x + particle.vx,
          y: particle.y + particle.vy,
          vy: particle.vy + 0.2, // gravity
          life: particle.life - 0.02
        })).filter(p => p.life > 0);

        if (updated.length > 0) {
          requestAnimationFrame(animate);
        }
        return updated;
      });
    };

    requestAnimationFrame(animate);
  }

  function handleClick(event: MouseEvent) {
    if (!disabled) {
      createParticleBurst();
      dispatch('click', event);
    }
  }
</script>

<button
  bind:this={buttonElement}
  class="particle-button {sizes[size]} {variant}"
  on:click={handleClick}
  {disabled}
  type="button"
>
  <slot>Click Me!</slot>

  {#if $particles.length > 0}
    <div class="particle-container">
      {#each $particles as particle (particle.id)}
        <div
          class="particle"
          style="
            left: {particle.x}px;
            top: {particle.y}px;
            opacity: {particle.life};
            background: {variants[variant].particleColors[Math.floor(Math.random() * 3)]};
          "
        />
      {/each}
    </div>
  {/if}
</button>

<style>
  .particle-button {
    position: relative;
    border: none;
    border-radius: 12px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
    overflow: visible;
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  .primary {
    background: linear-gradient(135deg, #3b82f6, #1e40af);
    color: white;
    box-shadow: 0 4px 15px rgba(59, 130, 246, 0.4);
  }

  .primary:hover:not(:disabled) {
    transform: scale(1.05);
    box-shadow: 0 6px 20px rgba(59, 130, 246, 0.6);
  }

  .secondary {
    background: linear-gradient(135deg, #a855f7, #7e22ce);
    color: white;
    box-shadow: 0 4px 15px rgba(168, 85, 247, 0.4);
  }

  .secondary:hover:not(:disabled) {
    transform: scale(1.05);
  }

  .success {
    background: linear-gradient(135deg, #22c55e, #15803d);
    color: white;
    box-shadow: 0 4px 15px rgba(34, 197, 94, 0.4);
  }

  .success:hover:not(:disabled) {
    transform: scale(1.05);
  }

  .danger {
    background: linear-gradient(135deg, #ef4444, #b91c1c);
    color: white;
    box-shadow: 0 4px 15px rgba(239, 68, 68, 0.4);
  }

  .danger:hover:not(:disabled) {
    transform: scale(1.05);
  }

  .warning {
    background: linear-gradient(135deg, #f59e0b, #b45309);
    color: white;
    box-shadow: 0 4px 15px rgba(245, 158, 11, 0.4);
  }

  .warning:hover:not(:disabled) {
    transform: scale(1.05);
  }

  .info {
    background: linear-gradient(135deg, #06b6d4, #0e7490);
    color: white;
    box-shadow: 0 4px 15px rgba(6, 182, 212, 0.4);
  }

  .info:hover:not(:disabled) {
    transform: scale(1.05);
  }

  .particle-button:active:not(:disabled) {
    transform: scale(0.95);
  }

  .particle-button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  .particle-container {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    overflow: visible;
  }

  .particle {
    position: absolute;
    width: 6px;
    height: 6px;
    border-radius: 50%;
    pointer-events: none;
    transform: translate(-50%, -50%);
    box-shadow: 0 0 4px currentColor;
  }
</style>
