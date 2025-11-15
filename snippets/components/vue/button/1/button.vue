<template>
  <button
    :class="['animated-btn', variant, size, { 'is-disabled': disabled, 'is-loading': loading }]"
    :disabled="disabled || loading"
    @click="handleClick"
  >
    <span v-if="loading" class="spinner"></span>
    <span class="btn-content">
      <slot />
    </span>
    <span class="ripple" ref="ripple"></span>
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  variant?: 'primary' | 'secondary' | 'success' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md',
  disabled: false,
  loading: false
});

const emit = defineEmits<{
  click: [event: MouseEvent]
}>();

const ripple = ref<HTMLElement | null>(null);

const handleClick = (event: MouseEvent) => {
  if (props.disabled || props.loading) return;

  // Create ripple effect
  if (ripple.value) {
    const rect = (event.currentTarget as HTMLElement).getBoundingClientRect();
    const x = event.clientX - rect.left;
    const y = event.clientY - rect.top;

    ripple.value.style.left = `${x}px`;
    ripple.value.style.top = `${y}px`;
    ripple.value.classList.add('active');

    setTimeout(() => {
      ripple.value?.classList.remove('active');
    }, 600);
  }

  emit('click', event);
};
</script>

<style scoped>
.animated-btn {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  font-weight: 600;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

.animated-btn.primary {
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  color: white;
  box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
}

.animated-btn.secondary {
  background: linear-gradient(135deg, #64748b 0%, #475569 100%);
  color: white;
  box-shadow: 0 4px 15px rgba(100, 116, 139, 0.3);
}

.animated-btn.success {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
  box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
}

.animated-btn.danger {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: white;
  box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
}

.animated-btn.sm {
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
}

.animated-btn.md {
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
}

.animated-btn.lg {
  padding: 1rem 2rem;
  font-size: 1.125rem;
}

.animated-btn:hover:not(.is-disabled):not(.is-loading) {
  transform: translateY(-2px) scale(1.02);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
}

.animated-btn:active:not(.is-disabled):not(.is-loading) {
  transform: translateY(0) scale(0.98);
}

.animated-btn.is-disabled,
.animated-btn.is-loading {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none !important;
}

.btn-content {
  position: relative;
  z-index: 1;
}

.spinner {
  width: 1rem;
  height: 1rem;
  border: 2px solid currentColor;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

.ripple {
  position: absolute;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.6);
  transform: scale(0);
  pointer-events: none;
}

.ripple.active {
  animation: ripple-effect 0.6s ease-out;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

@keyframes ripple-effect {
  to {
    transform: scale(20);
    opacity: 0;
  }
}
</style>
