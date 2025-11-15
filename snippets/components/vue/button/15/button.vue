<template>
  <div class="tilt-wrapper" ref="wrapper">
    <button
      :class="['tilt-btn', { disabled }]"
      :disabled="disabled"
      @mouseenter="isHovered = true"
      @mouseleave="handleMouseLeave"
      @mousemove="handleMouseMove"
      @click="$emit('click', $event)"
    >
      <slot />
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  disabled?: boolean;
  maxTilt?: number;
}

const props = withDefaults(defineProps<Props>(), {
  disabled: false,
  maxTilt: 15
});

defineEmits<{
  click: [event: MouseEvent];
}>();

const wrapper = ref<HTMLElement | null>(null);
const isHovered = ref(false);

const handleMouseMove = (e: MouseEvent) => {
  if (!wrapper.value || props.disabled) return;
  
  const rect = wrapper.value.getBoundingClientRect();
  const x = e.clientX - rect.left;
  const y = e.clientY - rect.top;
  
  const centerX = rect.width / 2;
  const centerY = rect.height / 2;
  
  const rotateX = ((y - centerY) / centerY) * -props.maxTilt;
  const rotateY = ((x - centerX) / centerX) * props.maxTilt;
  
  const btn = wrapper.value.querySelector('.tilt-btn') as HTMLElement;
  if (btn) {
    btn.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.05, 1.05, 1.05)`;
  }
};

const handleMouseLeave = () => {
  isHovered.value = false;
  const btn = wrapper.value?.querySelector('.tilt-btn') as HTMLElement;
  if (btn) {
    btn.style.transform = 'perspective(1000px) rotateX(0) rotateY(0) scale3d(1, 1, 1)';
  }
};
</script>

<style scoped>
.tilt-wrapper {
  perspective: 1000px;
  display: inline-block;
}

.tilt-btn {
  padding: 1rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
  border: none;
  border-radius: 14px;
  cursor: pointer;
  transform-style: preserve-3d;
  transition: transform 0.3s cubic-bezier(0.23, 1, 0.32, 1);
  box-shadow: 0 8px 24px rgba(245, 158, 11, 0.3);
}

.tilt-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>