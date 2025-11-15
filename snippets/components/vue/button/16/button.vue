<template>
  <button
    :class="['custom-btn', variant, size, { disabled, loading }]"
    :disabled="disabled || loading"
    @click="$emit('click')"
  >
    <span v-if="loading" class="loader"></span>
    <slot />
  </button>
</template>
<script lang="ts">
import { defineComponent } from 'vue';
export default defineComponent({
  name: 'CustomButton',
  props: {
    variant: { type: String, default: 'primary' },
    size: { type: String, default: 'md' },
    disabled: { type: Boolean, default: false },
    loading: { type: Boolean, default: false }
  },
  emits: ['click']
});
</script>
<style scoped>
.custom-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 600;
  border: none;
  border-radius: 0.75rem;
  cursor: pointer;
  transition: all 0.2s ease;
}
.custom-btn.primary {
  background: linear-gradient(135deg, #pink400 0%, #pink600 100%);
  color: white;
}
.custom-btn.primary:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}
.custom-btn.md {
  padding: 0.875rem 1.75rem;
  font-size: 1rem;
}
.custom-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
.loader {
  width: 1rem;
  height: 1rem;
  border: 2px solid currentColor;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}
@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>
