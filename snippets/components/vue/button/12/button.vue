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
      type: String as PropType<'solid' | 'outline' | 'ghost' | 'neon'>,
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
      primary: '#d946ef',
      secondary: '#c026d3',
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

/* Solid Variant - Fuchsia */
.btn-solid {
  background: linear-gradient(135deg, #d946ef 0%, #c026d3 100%);
  color: white;
  box-shadow: 0 4px 12px rgba(217, 70, 239, 0.35);
}

.btn-solid:hover:not(:disabled) {
  background: linear-gradient(135deg, #c026d3 0%, #d946ef 100%);
  box-shadow: 0 6px 18px rgba(217, 70, 239, 0.45);
  transform: translateY(-2px);
}

.btn-solid:active:not(:disabled) {
  transform: translateY(0);
}

/* Outline Variant */
.btn-outline {
  background: transparent;
  color: #d946ef;
  border: 2px solid #d946ef;
  box-shadow: none;
}

.btn-outline:hover:not(:disabled) {
  background: #d946ef;
  color: white;
  box-shadow: 0 4px 12px rgba(217, 70, 239, 0.3);
  transform: translateY(-2px);
}

/* Ghost Variant */
.btn-ghost {
  background: transparent;
  color: #d946ef;
  box-shadow: none;
}

.btn-ghost:hover:not(:disabled) {
  background: rgba(217, 70, 239, 0.1);
  transform: scale(1.05);
}

/* Special Variant Styles */
.btn-neon {
  background: transparent;
  color: #d946ef;
  border: 2px solid #d946ef;
  box-shadow: 0 0 10px rgba(217, 70, 239, 0.5),
              inset 0 0 10px rgba(217, 70, 239, 0.2);
}

.btn-neon:hover:not(:disabled) {
  color: white;
  background: #d946ef;
  box-shadow: 0 0 20px rgba(217, 70, 239, 0.8),
              0 0 30px rgba(217, 70, 239, 0.6),
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
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: flip 1s ease-in-out infinite;
}

@keyframes flip {
  0% { transform: rotateY(0deg); }
  100% { transform: rotateY(360deg); }
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
