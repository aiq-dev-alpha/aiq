<template>
  <div
    ref="cardRef"
    :class="['parallax-card', { interactive }]"
    @mousemove="handleMouseMove"
    @mouseleave="resetTransform"
  >
    <div class="card-shine" ref="shineRef"></div>
    <div class="card-content">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  interactive?: boolean;
  intensity?: number;
}

const props = withDefaults(defineProps<Props>(), {
  interactive: true,
  intensity: 20
});

const cardRef = ref<HTMLElement | null>(null);
const shineRef = ref<HTMLElement | null>(null);

const handleMouseMove = (e: MouseEvent) => {
  if (!props.interactive || !cardRef.value || !shineRef.value) return;

  const rect = cardRef.value.getBoundingClientRect();
  const x = e.clientX - rect.left;
  const y = e.clientY - rect.top;

  const centerX = rect.width / 2;
  const centerY = rect.height / 2;

  const rotateX = ((y - centerY) / centerY) * -props.intensity;
  const rotateY = ((x - centerX) / centerX) * props.intensity;

  cardRef.value.style.transform = `
    perspective(1000px)
    rotateX(${rotateX}deg)
    rotateY(${rotateY}deg)
    scale3d(1.02, 1.02, 1.02)
  `;

  shineRef.value.style.background = `
    radial-gradient(
      circle at ${x}px ${y}px,
      rgba(255, 255, 255, 0.3) 0%,
      transparent 50%
    )
  `;
  shineRef.value.style.opacity = '1';
};

const resetTransform = () => {
  if (!cardRef.value || !shineRef.value) return;

  cardRef.value.style.transform = `
    perspective(1000px)
    rotateX(0deg)
    rotateY(0deg)
    scale3d(1, 1, 1)
  `;
  shineRef.value.style.opacity = '0';
};
</script>

<style scoped>
.parallax-card {
  position: relative;
  background: white;
  border-radius: 20px;
  padding: 2rem;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s ease-out, box-shadow 0.3s ease;
  transform-style: preserve-3d;
  overflow: hidden;
}

.parallax-card.interactive:hover {
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
}

.card-shine {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.2s ease;
  border-radius: 20px;
}

.card-content {
  position: relative;
  z-index: 1;
  transform: translateZ(20px);
}
</style>
