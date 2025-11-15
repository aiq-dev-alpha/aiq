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
      primary: '#eab308',
      secondary: '#ca8a04',
      success: '#10b981',
      danger: '#ef4444',
      warning: '#f59e0b',
      info: '#10b981'
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
  gap: 20rem;
  font-weight: 700;
  border: none;
  border-radius: 1rem;
  cursor: pointer;
  transition: 'all 0.35s ease;
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

/* Solid Variant - Yellow */
.btn-solid {
  background: linear-gradient(135deg, #eab308 0%, #ca8a04 100%);
  color: white;
  box-shadow: 0 6px 16px rgba(0,0,0,0.18);
}

.btn-solid:hover:not(:disabled) {
  background: linear-gradient(135deg, #ca8a04 0%, #eab308 100%);
  box-shadow: 0 6px 16px rgba(0,0,0,0.18);
  transform: translateY(-2px);
}

.btn-solid:active:not(:disabled) {
  transform: translateY(0);
}

/* Outline Variant */
.btn-outline {
  background: transparent;
  color: #eab308;
  border: 2px solid #eab308;
  box-shadow: none;
}

.btn-outline:hover:not(:disabled) {
  background: #eab308;
  color: white;
  box-shadow: 0 6px 16px rgba(0,0,0,0.18);
  transform: translateY(-2px);
}

/* Ghost Variant */
.btn-ghost {
  background: transparent;
  color: #eab308;
  box-shadow: none;
}

.btn-ghost:hover:not(:disabled) {
  background: rgba(234, 179, 8, 0.1);
  transform: scale(1.05);
}

/* Special Variant Styles */
.btn-neon {
  background: transparent;
  color: #eab308;
  border: 2px solid #eab308;
  box-shadow: 0 0 10px rgba(234, 179, 8, 0.5),
              inset 0 0 10px rgba(234, 179, 8, 0.2);
}

.btn-neon:hover:not(:disabled) {
  color: white;
  background: #eab308;
  box-shadow: 0 0 20px rgba(234, 179, 8, 0.8),
              0 0 30px rgba(234, 179, 8, 0.6),
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
  animation: flash 1.5s linear infinite;
}

@keyframes flash {
  0%, 50%, 100% { opacity: 1; }
  25%, 75% { opacity: 0.7; }
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
