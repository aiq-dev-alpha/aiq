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
      type: String as PropType<'solid' | 'outline' | 'ghost' | 'glass' | 'soft'>,
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
      primary: '#ec4899',
      secondary: '#db2777',
      success: '#22c55e',
      danger: '#ef4444',
      warning: '#f59e0b',
      info: '#3b82f6'
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
  border-radius: 1.25rem;
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
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

/* Solid Variant - Pink */
.btn-solid {
  background: linear-gradient(135deg, #ec4899 0%, #db2777 100%);
  color: white;
  box-shadow: 0 4px 15px rgba(236, 72, 153, 0.4);
}

.btn-solid:hover:not(:disabled) {
  background: linear-gradient(135deg, #db2777 0%, #be185d 100%);
  box-shadow: 0 8px 25px rgba(236, 72, 153, 0.5);
  transform: translateY(-4px) scale(1.02);
}

.btn-solid:active:not(:disabled) {
  transform: translateY(-2px) scale(1);
}

/* Outline Variant */
.btn-outline {
  background: transparent;
  color: #ec4899;
  border: 2px solid #ec4899;
  box-shadow: none;
}

.btn-outline:hover:not(:disabled) {
  background: rgba(236, 72, 153, 0.1);
  border-color: #db2777;
  color: #db2777;
  box-shadow: 0 0 0 5px rgba(236, 72, 153, 0.1);
  transform: scale(1.05);
}

/* Ghost Variant */
.btn-ghost {
  background: transparent;
  color: #ec4899;
  box-shadow: none;
}

.btn-ghost:hover:not(:disabled) {
  background: rgba(236, 72, 153, 0.12);
  transform: translateY(-2px);
}

/* Glass Variant */
.btn-glass {
  background: rgba(236, 72, 153, 0.15);
  color: #be185d;
  backdrop-filter: blur(12px);
  border: 1px solid rgba(236, 72, 153, 0.25);
  box-shadow: 0 8px 32px rgba(236, 72, 153, 0.15);
}

.btn-glass:hover:not(:disabled) {
  background: rgba(236, 72, 153, 0.25);
  border-color: rgba(236, 72, 153, 0.4);
  box-shadow: 0 12px 40px rgba(236, 72, 153, 0.25);
  transform: translateY(-2px);
}

/* Soft Variant */
.btn-soft {
  background: rgba(236, 72, 153, 0.15);
  color: #be185d;
  box-shadow: none;
}

.btn-soft:hover:not(:disabled) {
  background: rgba(236, 72, 153, 0.25);
  transform: scale(1.05);
}

.btn-full-width {
  width: 100%;
}

/* Loading Spinner */
.spinner {
  width: 1rem;
  height: 1rem;
  border: 2px solid rgba(255, 255, 255, 0.25);
  border-top-color: white;
  border-bottom-color: white;
  border-radius: 50%;
  animation: spinElegant 1s ease-in-out infinite;
}

@keyframes spinElegant {
  0% { transform: rotate(0deg); opacity: 1; }
  50% { transform: rotate(180deg); opacity: 0.7; }
  100% { transform: rotate(360deg); opacity: 1; }
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
