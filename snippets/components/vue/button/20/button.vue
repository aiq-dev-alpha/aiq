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
      type: String as PropType<'solid' | 'outline' | 'ghost' | 'gradient'>,
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
      primary: '#ff6b35',
      secondary: '#f7522f',
      success: '#10b981',
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
  border-radius: 0.5rem;
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

/* Solid Variant - OrangeRed */
.btn-solid {
  background: linear-gradient(135deg, #ff6b35 0%, #f7522f 100%);
  color: white;
  box-shadow: 0 4px 12px rgba(255, 107, 53, 0.35);
}

.btn-solid:hover:not(:disabled) {
  background: linear-gradient(135deg, #f7522f 0%, #ff6b35 100%);
  box-shadow: 0 6px 18px rgba(255, 107, 53, 0.45);
  transform: translateY(-2px);
}

.btn-solid:active:not(:disabled) {
  transform: translateY(0);
}

/* Outline Variant */
.btn-outline {
  background: transparent;
  color: #ff6b35;
  border: 2px solid #ff6b35;
  box-shadow: none;
}

.btn-outline:hover:not(:disabled) {
  background: #ff6b35;
  color: white;
  box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
  transform: translateY(-2px);
}

/* Ghost Variant */
.btn-ghost {
  background: transparent;
  color: #ff6b35;
  box-shadow: none;
}

.btn-ghost:hover:not(:disabled) {
  background: rgba(255, 107, 53, 0.1);
  transform: scale(1.05);
}

/* Special Variant Styles */
.btn-gradient {
  background: linear-gradient(135deg, #ff6b35 0%, #f7522f 50%, #ff6b35 100%);
  color: white;
  box-shadow: 0 4px 16px rgba(255, 107, 53, 0.4);
  background-size: 200% 200%;
  animation: gradientShift 3s ease infinite;
}

.btn-gradient:hover:not(:disabled) {
  box-shadow: 0 6px 20px rgba(255, 107, 53, 0.5);
  transform: translateY(-2px);
}

@keyframes gradientShift {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
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
  border-radius: 50%;
  animation: heartbeat 1.3s ease-in-out infinite;
}

@keyframes heartbeat {
  0%, 100% { transform: scale(1); }
  14%, 28% { transform: scale(1.15); }
  21%, 42% { transform: scale(1); }
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
