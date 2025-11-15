<template>
  <button
    :class="['confetti-btn', { disabled }]"
    :disabled="disabled"
    @click="handleClick"
  >
    <slot />
    <canvas ref="canvas" class="confetti-canvas"></canvas>
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

const canvas = ref<HTMLCanvasElement | null>(null);

const handleClick = (event: MouseEvent) => {
  if (!disabled) {
    createConfetti();
    emit('click', event);
  }
};

const createConfetti = () => {
  if (!canvas.value) return;
  
  const ctx = canvas.value.getContext('2d');
  if (!ctx) return;
  
  const rect = canvas.value.getBoundingClientRect();
  canvas.value.width = rect.width;
  canvas.value.height = rect.height;
  
  const particles: any[] = [];
  const colors = ['#ff0000', '#00ff00', '#0000ff', '#ffff00', '#ff00ff'];
  
  for (let i = 0; i < 30; i++) {
    particles.push({
      x: rect.width / 2,
      y: rect.height / 2,
      vx: (Math.random() - 0.5) * 8,
      vy: (Math.random() - 0.5) * 8 - 2,
      color: colors[Math.floor(Math.random() * colors.length)],
      size: Math.random() * 4 + 2
    });
  }
  
  const animate = () => {
    ctx.clearRect(0, 0, rect.width, rect.height);
    
    let active = false;
    particles.forEach(p => {
      p.x += p.vx;
      p.y += p.vy;
      p.vy += 0.3;
      
      if (p.y < rect.height) {
        ctx.fillStyle = p.color;
        ctx.fillRect(p.x, p.y, p.size, p.size);
        active = true;
      }
    });
    
    if (active) requestAnimationFrame(animate);
  };
  
  animate();
};
</script>

<style scoped>
.confetti-btn {
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

.confetti-btn:hover:not(.disabled) {
  transform: scale(1.05);
  box-shadow: 0 8px 25px rgba(139, 92, 246, 0.4);
}

.confetti-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.confetti-canvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}
</style>