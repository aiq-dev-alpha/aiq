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
      type: String as PropType<'solid' | 'outline' | 'ghost' | 'gradient' | 'neon'>,
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
      primary: '#f97316',
      secondary: '#ea580c',
      success: '#10b981',
      danger: '#dc2626',
      warning: '#eab308',
      info: '#0891b2'
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
  font-weight: 700;
  border: none;
  border-radius: 0.625rem;
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: inherit;
  outline: none;
  letter-spacing: 0.025em;
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

/* Solid Variant - Orange */
.btn-solid {
  background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
  color: white;
  box-shadow: 0 4px 14px rgba(249, 115, 22, 0.4);
}

.btn-solid:hover:not(:disabled) {
  background: linear-gradient(135deg, #ea580c 0%, #c2410c 100%);
  box-shadow: 0 6px 20px rgba(249, 115, 22, 0.5);
  transform: translateY(-2px) scale(1.02);
}

.btn-solid:active:not(:disabled) {
  transform: scale(0.98);
}

/* Outline Variant */
.btn-outline {
  background: transparent;
  color: #f97316;
  border: 2px solid #f97316;
  box-shadow: none;
}

.btn-outline:hover:not(:disabled) {
  background: #f97316;
  color: white;
  box-shadow: 0 4px 14px rgba(249, 115, 22, 0.35);
  transform: translateY(-2px);
}

/* Ghost Variant */
.btn-ghost {
  background: transparent;
  color: #f97316;
  box-shadow: none;
}

.btn-ghost:hover:not(:disabled) {
  background: rgba(249, 115, 22, 0.1);
  transform: scale(1.03);
}

/* Gradient Variant */
.btn-gradient {
  background: linear-gradient(135deg, #f97316 0%, #ec4899 50%, #8b5cf6 100%);
  color: white;
  box-shadow: 0 4px 16px rgba(249, 115, 22, 0.4);
  background-size: 200% 200%;
  animation: gradientFlow 4s ease infinite;
}

.btn-gradient:hover:not(:disabled) {
  box-shadow: 0 6px 24px rgba(249, 115, 22, 0.5);
  transform: translateY(-2px);
}

@keyframes gradientFlow {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

/* Neon Variant */
.btn-neon {
  background: transparent;
  color: #f97316;
  border: 2px solid #f97316;
  box-shadow: 0 0 10px rgba(249, 115, 22, 0.5),
              inset 0 0 10px rgba(249, 115, 22, 0.2);
}

.btn-neon:hover:not(:disabled) {
  color: white;
  background: #f97316;
  box-shadow: 0 0 20px rgba(249, 115, 22, 0.8),
              0 0 30px rgba(249, 115, 22, 0.6),
              inset 0 0 20px rgba(255, 255, 255, 0.2);
  transform: scale(1.05);
}

.btn-full-width {
  width: 100%;
}

/* Loading Spinner */
.spinner {
  width: 1rem;
  height: 1rem;
  border: 2.5px solid rgba(255, 255, 255, 0.2);
  border-top-color: white;
  border-radius: 50%;
  animation: spinFast 0.5s linear infinite;
}

@keyframes spinFast {
  to { transform: rotate(360deg); }
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
