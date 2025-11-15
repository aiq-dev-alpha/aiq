<template>
  <div class="icon-btn-wrapper">
    <button
      :class="['icon-btn', { disabled }]"
      :disabled="disabled"
      @click="$emit('click', $event)"
      @mouseenter="showTooltip = true"
      @mouseleave="showTooltip = false"
    >
      <span class="icon">{{ icon }}</span>
    </button>
    <Transition name="tooltip">
      <div v-if="showTooltip && tooltip" class="tooltip">
        {{ tooltip }}
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  icon: string;
  tooltip?: string;
  disabled?: boolean;
}

withDefaults(defineProps<Props>(), {
  disabled: false
});

defineEmits<{
  click: [event: MouseEvent]
}>();

const showTooltip = ref(false);
</script>

<style scoped>
.icon-btn-wrapper {
  position: relative;
  display: inline-block;
}

.icon-btn {
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-size: 1.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
}

.icon-btn:hover:not(.disabled) {
  transform: translateY(-4px) scale(1.1);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
}

.icon-btn:active:not(.disabled) {
  transform: translateY(-2px) scale(1.05);
}

.icon-btn.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.icon {
  display: block;
}

.tooltip {
  position: absolute;
  bottom: calc(100% + 8px);
  left: 50%;
  transform: translateX(-50%);
  padding: 0.5rem 1rem;
  background: rgba(0, 0, 0, 0.9);
  color: white;
  border-radius: 8px;
  font-size: 0.875rem;
  white-space: nowrap;
  pointer-events: none;
  z-index: 1000;
}

.tooltip::after {
  content: '';
  position: absolute;
  top: 100%;
  left: 50%;
  transform: translateX(-50%);
  border: 6px solid transparent;
  border-top-color: rgba(0, 0, 0, 0.9);
}

.tooltip-enter-active,
.tooltip-leave-active {
  transition: all 0.2s ease;
}

.tooltip-enter-from,
.tooltip-leave-to {
  opacity: 0;
  transform: translateX(-50%) translateY(4px);
}
</style>
