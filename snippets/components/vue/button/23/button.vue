<template>
  <button
    :class="['double-tap-btn', { armed, disabled }]"
    :disabled="disabled"
    @click="handleClick"
  >
    <span v-if="!armed"><slot>Double Tap</slot></span>
    <span v-else class="armed-text">Tap again to confirm</span>
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  disabled?: boolean;
  timeout?: number;
}

const props = withDefaults(defineProps<Props>(), {
  disabled: false,
  timeout: 3000
});

const emit = defineEmits<{
  confirm: [];
}>();

const armed = ref(false);
let timeoutId: number | null = null;

const handleClick = () => {
  if (props.disabled) return;
  
  if (!armed.value) {
    armed.value = true;
    timeoutId = window.setTimeout(() => {
      armed.value = false;
    }, props.timeout);
  } else {
    if (timeoutId) clearTimeout(timeoutId);
    armed.value = false;
    emit('confirm');
  }
};
</script>

<style scoped>
.double-tap-btn {
  padding: 0.875rem 2rem;
  min-width: 200px;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.double-tap-btn:hover:not(.disabled) {
  transform: translateY(-2px);
}

.double-tap-btn.armed {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  animation: shake 0.5s ease;
}

.double-tap-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.armed-text {
  font-size: 0.875rem;
}

@keyframes shake {
  0%, 100% {
    transform: translateX(0);
  }
  25% {
    transform: translateX(-4px);
  }
  75% {
    transform: translateX(4px);
  }
}
</style>