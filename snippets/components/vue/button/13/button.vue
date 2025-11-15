<template>
  <button
    ref="btnRef"
    :class="['magnetic-btn', { disabled }]"
    :disabled="disabled"
    @mouseenter="isHovered = true"
    @mouseleave="handleMouseLeave"
    @mousemove="handleMouseMove"
    @click="$emit('click', $event)"
  >
    <span class="btn-inner" ref="innerRef">
      <slot />
    </span>
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  disabled?: boolean;
  magnetStrength?: number;
}

const props = withDefaults(defineProps<Props>(), {
  disabled: false,
  magnetStrength: 0.3
});

defineEmits<{
  click: [event: MouseEvent];
}>();

const btnRef = ref<HTMLElement | null>(null);
const innerRef = ref<HTMLElement | null>(null);
const isHovered = ref(false);

const handleMouseMove = (e: MouseEvent) => {
  if (!btnRef.value || !innerRef.value || props.disabled) return;
  
  const rect = btnRef.value.getBoundingClientRect();
  const x = e.clientX - rect.left - rect.width / 2;
  const y = e.clientY - rect.top - rect.height / 2;
  
  const moveX = x * props.magnetStrength;
  const moveY = y * props.magnetStrength;
  
  innerRef.value.style.transform = `translate(${moveX}px, ${moveY}px)`;
};

const handleMouseLeave = () => {
  isHovered.value = false;
  if (innerRef.value) {
    innerRef.value.style.transform = 'translate(0, 0)';
  }
};
</script>

<style scoped>
.magnetic-btn {
  position: relative;
  padding: 1rem 2.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #ec4899 0%, #8b5cf6 100%);
  border: none;
  border-radius: 14px;
  cursor: pointer;
  overflow: hidden;
  box-shadow: 0 6px 20px rgba(236, 72, 153, 0.3);
}

.magnetic-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-inner {
  display: block;
  transition: transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
}
</style>