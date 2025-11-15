<template>
  <button class="modern-btn" :class="[size, variant]" :disabled="disabled" @click="$emit('click')">
    <span v-if="icon" class="icon">{{ icon }}</span>
    <slot />
  </button>
</template>
<script lang="ts">
import { defineComponent } from 'vue';
export default defineComponent({
  name: 'ModernButton',
  props: { size: { type: String, default: 'md' }, variant: { type: String, default: 'primary' }, disabled: Boolean, icon: String },
  emits: ['click']
});
</script>
<style scoped>
.modern-btn { display: inline-flex; align-items: center; gap: 0.5rem; font-weight: 600; border: none; cursor: pointer; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
.modern-btn.primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 0.625rem 1.5rem; border-radius: 0.75rem; }
.modern-btn:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15); }
.modern-btn:disabled { opacity: 0.5; cursor: not-allowed; }
</style>
