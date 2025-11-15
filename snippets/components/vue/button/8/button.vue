<template>
  <button
    :class="['glass-btn', { disabled }]"
    :disabled="disabled"
    @click="$emit('click', $event)"
  >
    <span class="btn-bg"></span>
    <span class="btn-content">
      <slot />
    </span>
  </button>
</template>

<script setup lang="ts">
interface Props {
  disabled?: boolean;
}

withDefaults(defineProps<Props>(), {
  disabled: false
});

defineEmits<{
  click: [event: MouseEvent];
}>();
</script>

<style scoped>
.glass-btn {
  position: relative;
  padding: 0.875rem 1.75rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 16px;
  cursor: pointer;
  overflow: hidden;
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  background: linear-gradient(
    135deg,
    rgba(255, 255, 255, 0.1),
    rgba(255, 255, 255, 0.05)
  );
  box-shadow:
    0 8px 32px 0 rgba(31, 38, 135, 0.37),
    inset 0 0 20px rgba(255, 255, 255, 0.05);
  transition: all 0.3s ease;
}

.glass-btn:hover:not(.disabled) {
  background: linear-gradient(
    135deg,
    rgba(255, 255, 255, 0.15),
    rgba(255, 255, 255, 0.08)
  );
  border-color: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
  box-shadow:
    0 12px 40px 0 rgba(31, 38, 135, 0.45),
    inset 0 0 20px rgba(255, 255, 255, 0.08);
}

.glass-btn.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-content {
  position: relative;
  z-index: 1;
}
</style>