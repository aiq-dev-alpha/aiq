<template>
  <button
    :class="['gradient-shift-btn', { disabled, loading }]"
    :disabled="disabled || loading"
    :style="{ '--angle': `${angle}deg` }"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
    @mousemove="handleMouseMove"
    @click="$emit('click', $event)"
  >
    <span v-if="loading" class="loader"></span>
    <span class="btn-content">
      <slot />
    </span>
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  disabled?: boolean;
  loading?: boolean;
}

withDefaults(defineProps<Props>(), {
  disabled: false,
  loading: false
});

defineEmits<{
  click: [event: MouseEvent];
}>();

const isHovered = ref(false);
const angle = ref(45);

const handleMouseMove = (e: MouseEvent) => {
  if (!isHovered.value) return;

  const rect = (e.currentTarget as HTMLElement).getBoundingClientRect();
  const x = e.clientX - rect.left;
  const y = e.clientY - rect.top;

  const centerX = rect.width / 2;
  const centerY = rect.height / 2;

  const angleRad = Math.atan2(y - centerY, x - centerX);
  angle.value = (angleRad * 180 / Math.PI) + 90;
};
</script>

<style scoped>
.gradient-shift-btn {
  position: relative;
  padding: 0.875rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(
    var(--angle, 45deg),
    #ff6b6b 0%,
    #ee5a6f 25%,
    #c44569 50%,
    #a83a5a 75%,
    #ff6b6b 100%
  );
  background-size: 200% 200%;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);
}

.gradient-shift-btn:hover:not(.disabled):not(.loading) {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 8px 30px rgba(255, 107, 107, 0.5);
  animation: gradient-shift 3s ease infinite;
}

.gradient-shift-btn:active:not(.disabled):not(.loading) {
  transform: translateY(-1px) scale(0.98);
}

.gradient-shift-btn.disabled,
.gradient-shift-btn.loading {
  opacity: 0.6;
  cursor: not-allowed;
  animation: none;
}

.btn-content {
  position: relative;
  z-index: 1;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
}

.loader {
  width: 1rem;
  height: 1rem;
  border: 2px solid currentColor;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes gradient-shift {
  0%, 100% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
