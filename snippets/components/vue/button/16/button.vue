<template>
  <button
    :class="['pulse-btn', { pulsing, disabled }]"
    :disabled="disabled"
    @click="handleClick"
  >
    <slot />
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  disabled?: boolean;
  autoPulse?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  disabled: false,
  autoPulse: true
});

const emit = defineEmits<{
  click: [event: MouseEvent];
}>();

const pulsing = ref(props.autoPulse);

const handleClick = (event: MouseEvent) => {
  if (!props.disabled) {
    emit('click', event);
  }
};
</script>

<style scoped>
.pulse-btn {
  padding: 0.875rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  border: none;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s ease;
  position: relative;
}

.pulse-btn:hover:not(.disabled) {
  transform: scale(1.05);
}

.pulse-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.pulse-btn.pulsing {
  animation: heartbeat 1.5s ease-in-out infinite;
}

.pulse-btn.pulsing::before {
  content: '';
  position: absolute;
  inset: -4px;
  border-radius: 14px;
  background: inherit;
  opacity: 0.4;
  animation: pulse-ring 1.5s ease-in-out infinite;
}

@keyframes heartbeat {
  0%, 100% {
    transform: scale(1);
  }
  10% {
    transform: scale(1.05);
  }
  20% {
    transform: scale(1);
  }
  30% {
    transform: scale(1.05);
  }
  40% {
    transform: scale(1);
  }
}

@keyframes pulse-ring {
  0% {
    transform: scale(1);
    opacity: 0.4;
  }
  100% {
    transform: scale(1.3);
    opacity: 0;
  }
}
</style>