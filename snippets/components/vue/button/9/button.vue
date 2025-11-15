<template>
  <button
    :class="['neon-btn', { disabled, active: isActive }]"
    :disabled="disabled"
    @click="handleClick"
  >
    <slot />
    <span class="neon-border"></span>
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

const isActive = ref(false);

const handleClick = (event: MouseEvent) => {
  if (!disabled) {
    isActive.value = true;
    setTimeout(() => isActive.value = false, 300);
    emit('click', event);
  }
};
</script>

<style scoped>
.neon-btn {
  position: relative;
  padding: 0.875rem 2rem;
  font-size: 1rem;
  font-weight: 700;
  color: #00ff88;
  background: #0a0e27;
  border: 2px solid #00ff88;
  border-radius: 12px;
  cursor: pointer;
  text-transform: uppercase;
  letter-spacing: 1px;
  transition: all 0.3s ease;
  overflow: hidden;
}

.neon-btn:hover:not(.disabled) {
  background: rgba(0, 255, 136, 0.1);
  box-shadow:
    0 0 20px rgba(0, 255, 136, 0.5),
    inset 0 0 20px rgba(0, 255, 136, 0.2);
}

.neon-btn.active {
  animation: neon-pulse 0.3s ease;
}

.neon-btn.disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.neon-border {
  position: absolute;
  top: -2px;
  left: -2px;
  right: -2px;
  bottom: -2px;
  background: linear-gradient(45deg, #00ff88, #00ccff, #ff00ff, #00ff88);
  border-radius: 12px;
  opacity: 0;
  z-index: -1;
  animation: neon-rotate 3s linear infinite;
  transition: opacity 0.3s ease;
}

.neon-btn:hover:not(.disabled) .neon-border {
  opacity: 0.6;
  filter: blur(8px);
}

@keyframes neon-rotate {
  0% {
    filter: hue-rotate(0deg) blur(8px);
  }
  100% {
    filter: hue-rotate(360deg) blur(8px);
  }
}

@keyframes neon-pulse {
  0%, 100% {
    box-shadow: 0 0 20px rgba(0, 255, 136, 0.5);
  }
  50% {
    box-shadow: 0 0 40px rgba(0, 255, 136, 0.8);
  }
}
</style>