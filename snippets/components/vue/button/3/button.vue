<template>
  <button
    :class="['neumorphic-btn', { pressed, disabled }]"
    :disabled="disabled"
    @mousedown="pressed = true"
    @mouseup="pressed = false"
    @mouseleave="pressed = false"
    @click="$emit('click', $event)"
  >
    <slot />
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

defineEmits<{
  click: [event: MouseEvent]
}>();

const pressed = ref(false);
</script>

<style scoped>
.neumorphic-btn {
  padding: 1rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  color: #5e6ad2;
  background: #e0e5ec;
  border: none;
  border-radius: 20px;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow:
    9px 9px 16px rgba(163, 177, 198, 0.6),
    -9px -9px 16px rgba(255, 255, 255, 0.9),
    inset 0px 0px 0px rgba(163, 177, 198, 0.6),
    inset 0px 0px 0px rgba(255, 255, 255, 0.9);
}

.neumorphic-btn:hover:not(.disabled) {
  color: #4c5ab8;
}

.neumorphic-btn.pressed:not(.disabled) {
  box-shadow:
    inset 6px 6px 12px rgba(163, 177, 198, 0.6),
    inset -6px -6px 12px rgba(255, 255, 255, 0.9),
    0px 0px 0px rgba(163, 177, 198, 0.6),
    0px 0px 0px rgba(255, 255, 255, 0.9);
}

.neumorphic-btn.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
