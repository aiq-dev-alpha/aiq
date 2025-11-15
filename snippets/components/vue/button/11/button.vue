<template>
  <button
    ref="btnRef"
    :class="['particle-btn', { disabled }]"
    :disabled="disabled"
    @click="handleClick"
  >
    <canvas ref="canvas" class="particle-canvas"></canvas>
    <span class="btn-content">
      <slot />
    </span>
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  disabled?: boolean;
}

withDefaults(defineProps<Props>(), {
  disabled: false
});

const emit = defineEmits<{
  click: [event: MouseEvent];
}>();

const btnRef = ref<HTMLElement | null>(null);
const canvas = ref<HTMLCanvasElement | null>(null);

interface Particle {
  x: number;
  y: number;
  vx: number;
  vy: number;
  life: number;
  maxLife: number;
  size: number;
}

const handleClick = (event: MouseEvent) => {
  if (!disabled) {
    createParticles(event);
    emit('click', event);
  }
};

const createParticles = (event: MouseEvent) => {
  if (!canvas.value || !btnRef.value) return;

  const ctx = canvas.value.getContext('2d');
  if (!ctx) return;

  const rect = btnRef.value.getBoundingClientRect();
  canvas.value.width = rect.width;
  canvas.value.height = rect.height;

  const particles: Particle[] = [];
  const clickX = event.clientX - rect.left;
  const clickY = event.clientY - rect.top;

  for (let i = 0; i < 20; i++) {
    const angle = (Math.PI * 2 * i) / 20;
    particles.push({
      x: clickX,
      y: clickY,
      vx: Math.cos(angle) * (2 + Math.random() * 3),
      vy: Math.sin(angle) * (2 + Math.random() * 3),
      life: 1,
      maxLife: 30 + Math.random() * 20,
      size: 2 + Math.random() * 3
    });
  }

  const animate = () => {
    ctx.clearRect(0, 0, canvas.value!.width, canvas.value!.height);

    let hasActive = false;
    particles.forEach(p => {
      if (p.life > 0) {
        p.x += p.vx;
        p.y += p.vy;
        p.life--;

        const alpha = p.life / p.maxLife;
        ctx.fillStyle = `rgba(139, 92, 246, ${alpha})`;
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
        ctx.fill();

        hasActive = true;
      }
    });

    if (hasActive) {
      requestAnimationFrame(animate);
    }
  };

  animate();
};
</script>

<style scoped>
.particle-btn {
  position: relative;
  padding: 0.875rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
  border: none;
  border-radius: 12px;
  cursor: pointer;
  overflow: hidden;
  transition: all 0.2s ease;
}

.particle-btn:hover:not(.disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(139, 92, 246, 0.4);
}

.particle-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.particle-canvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.btn-content {
  position: relative;
  z-index: 1;
}
</style>
