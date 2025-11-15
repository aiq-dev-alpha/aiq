<template>
  <button
    :class="buttonClasses"
    :disabled="disabled || loading"
    @click="handleClick"
  >
    <span v-if="loading" class="spinner"></span>
    <span v-if="icon && iconPosition === 'left' && !loading" class="icon-left">{{ icon }}</span>
    <span class="button-content"><slot /></span>
    <span v-if="icon && iconPosition === 'right' && !loading" class="icon-right">{{ icon }}</span>
  </button>
</template>

<script lang="ts">
import { defineComponent, computed, PropType } from 'vue';

interface ButtonTheme {
  primary: string;
  secondary: string;
  success: string;
  danger: string;
  warning: string;
  info: string;
}

export default defineComponent({
  name: 'Button',
  props: {
    variant: {
      type: String as PropType<'solid' | 'outline' | 'ghost' | 'glass'>,
      default: 'solid'
    },
    size: {
      type: String as PropType<'xs' | 'sm' | 'md' | 'lg' | 'xl'>,
      default: 'md'
    },
    fullWidth: {
      type: Boolean,
      default: false
    },
    loading: {
      type: Boolean,
      default: false
    },
    icon: {
      type: String,
      default: ''
    },
    iconPosition: {
      type: String as PropType<'left' | 'right'>,
      default: 'left'
    },
    disabled: {
      type: Boolean,
      default: false
    },
    theme: {
      type: Object as PropType<Partial<ButtonTheme>>,
      default: () => ({})
    }
  },
  emits: ['click'],
  setup(props, { emit }) {
    const defaultTheme: ButtonTheme = {
      primary: '#10b981',
      secondary: '#059669',
      success: '#34d399',
      danger: '#f87171',
      warning: '#fbbf24',
      info: '#22d3ee'
    };

    const appliedTheme = { ...defaultTheme, ...props.theme };

    const buttonClasses = computed(() => [
      'btn',
      `btn-${props.variant}`,
      `btn-${props.size}`,
      { 'btn-full-width': props.fullWidth },
      { 'btn-loading': props.loading }
    ]);

    const handleClick = (event: MouseEvent) => {
      if (!props.disabled && !props.loading) {
        emit('click', event);
      }
    };

    return { buttonClasses, handleClick };
  }
});
</script>

<style scoped>
.btn {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  font-weight: 600;
  border: none;
  border-radius: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: inherit;
  outline: none;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Sizes */
.btn-xs {
  padding: 0.375rem 0.75rem;
  font-size: 0.75rem;
}

.btn-sm {
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
}

.btn-md {
  padding: 0.625rem 1.25rem;
  font-size: 1rem;
}

.btn-lg {
  padding: 0.75rem 1.5rem;
  font-size: 1.125rem;
}

.btn-xl {
  padding: 1rem 2rem;
  font-size: 1.25rem;
}

/* Solid Variant - Emerald Green */
.btn-solid {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
  box-shadow: 0 4px 14px rgba(16, 185, 129, 0.35);
}

.btn-solid:hover:not(:disabled) {
  background: linear-gradient(135deg, #059669 0%, #047857 100%);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.45);
  transform: translateY(-3px) scale(1.02);
}

.btn-solid:active:not(:disabled) {
  transform: translateY(-1px) scale(1);
}

/* Outline Variant */
.btn-outline {
  background: transparent;
  color: #10b981;
  border: 2px solid #10b981;
  box-shadow: none;
}

.btn-outline:hover:not(:disabled) {
  background: rgba(16, 185, 129, 0.1);
  border-color: #059669;
  color: #059669;
  box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
}

/* Ghost Variant */
.btn-ghost {
  background: rgba(16, 185, 129, 0.05);
  color: #10b981;
  box-shadow: none;
}

.btn-ghost:hover:not(:disabled) {
  background: rgba(16, 185, 129, 0.15);
  transform: translateX(4px);
}

/* Glass Variant */
.btn-glass {
  background: rgba(16, 185, 129, 0.2);
  color: #047857;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(16, 185, 129, 0.3);
  box-shadow: 0 8px 32px rgba(16, 185, 129, 0.2);
}

.btn-glass:hover:not(:disabled) {
  background: rgba(16, 185, 129, 0.3);
  border-color: rgba(16, 185, 129, 0.5);
  transform: translateY(-2px);
}

.btn-full-width {
  width: 100%;
}

/* Loading Spinner */
.spinner {
  width: 1rem;
  height: 1rem;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-right-color: white;
  border-radius: 50%;
  animation: spinPulse 0.8s ease-in-out infinite;
}

@keyframes spinPulse {
  0%, 100% {
    transform: rotate(0deg) scale(1);
    opacity: 1;
  }
  50% {
    transform: rotate(180deg) scale(1.1);
    opacity: 0.8;
  }
  100% {
    transform: rotate(360deg) scale(1);
  }
}

.icon-left, .icon-right {
  display: flex;
  align-items: center;
}

.button-content {
  display: flex;
  align-items: center;
}
</style>
