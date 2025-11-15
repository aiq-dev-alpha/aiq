<template>
  <button
    :style="buttonStyles"
    :disabled="disabled || loading"
    :class="buttonClasses"
    @click="handleClick">
    <span v-if="loading" class="spinner"></span>
    <span v-if="iconLeft && !loading" class="icon-left">
      <slot name="iconLeft">{{ iconLeft }}</slot>
    </span>
    <span class="button-content">
      <slot></slot>
    </span>
    <span v-if="iconRight && !loading" class="icon-right">
      <slot name="iconRight">{{ iconRight }}</slot>
    </span>
  </button>
</template>

<script lang="ts">
import { defineComponent, computed, PropType } from 'vue';

interface ThemeConfig {
  primary: string;
  secondary: string;
  surface: string;
  onSurface: string;
  shadow: string;
}

type ButtonVariant = 'solid' | 'outline' | 'ghost' | 'soft' | 'link';
type ButtonSize = 'xs' | 'sm' | 'md' | 'lg' | 'xl';

export default defineComponent({
  name: 'Button',
  props: {
    variant: {
      type: String as PropType<ButtonVariant>,
      default: 'solid'
    },
    size: {
      type: String as PropType<ButtonSize>,
      default: 'md'
    },
    theme: {
      type: Object as PropType<Partial<ThemeConfig>>,
      default: () => ({})
    },
    disabled: {
      type: Boolean,
      default: false
    },
    loading: {
      type: Boolean,
      default: false
    },
    iconLeft: {
      type: String,
      default: ''
    },
    iconRight: {
      type: String,
      default: ''
    },
    fullWidth: {
      type: Boolean,
      default: false
    },
    rounded: {
      type: Boolean,
      default: true
    }
  },
  emits: ['click'],
  setup(props, { emit }) {
    const defaultTheme: ThemeConfig = {
      primary: '#3b82f6',
      secondary: '#8b5cf6',
      surface: '#ffffff',
      onSurface: '#111827',
      shadow: 'rgba(59, 130, 246, 0.2)'
    };

    const appliedTheme = computed(() => ({
      ...defaultTheme,
      ...props.theme
    }));

    const sizeMap = {
      xs: { padding: '4px 10px', fontSize: '12px', minHeight: '24px' },
      sm: { padding: '8px 16px', fontSize: '13px', minHeight: '32px' },
      md: { padding: '12px 24px', fontSize: '14px', minHeight: '40px' },
      lg: { padding: '14px 28px', fontSize: '16px', minHeight: '48px' },
      xl: { padding: '16px 32px', fontSize: '18px', minHeight: '56px' }
    };

    const variantStyles = computed(() => {
      const t = appliedTheme.value;
      return {
        solid: {
          background: t.primary,
          color: '#ffffff',
          border: 'none',
          boxShadow: `0 4px 6px ${t.shadow}`
        },
        outline: {
          background: 'transparent',
          color: t.primary,
          border: `2px solid ${t.primary}`,
          boxShadow: 'none'
        },
        ghost: {
          background: 'transparent',
          color: t.primary,
          border: 'none',
          boxShadow: 'none'
        },
        soft: {
          background: `${t.primary}20`,
          color: t.primary,
          border: 'none',
          boxShadow: 'none'
        },
        link: {
          background: 'transparent',
          color: t.primary,
          border: 'none',
          boxShadow: 'none',
          textDecoration: 'underline'
        }
      };
    });

    const buttonStyles = computed(() => ({
      ...sizeMap[props.size],
      ...variantStyles.value[props.variant],
      borderRadius: props.rounded ? '10px' : '4px',
      width: props.fullWidth ? '100%' : 'auto',
      cursor: props.disabled || props.loading ? 'not-allowed' : 'pointer',
      opacity: props.disabled || props.loading ? '0.6' : '1',
      fontWeight: '600',
      transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
      outline: 'none',
      fontFamily: 'inherit',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      gap: '8px'
    }));

    const buttonClasses = computed(() => ({
      [`variant-${props.variant}`]: true,
      [`size-${props.size}`]: true,
      'is-loading': props.loading,
      'is-disabled': props.disabled
    }));

    const handleClick = (event: MouseEvent) => {
      if (!props.disabled && !props.loading) {
        emit('click', event);
      }
    };

    return {
      buttonStyles,
      buttonClasses,
      handleClick
    };
  }
});
</script>

<style scoped>
button {
  position: relative;
}
button:hover:not(:disabled) {
  filter: brightness(1.05);
  transform: translateY(-1px);
}
button:active:not(:disabled) {
  transform: translateY(0);
}
.spinner {
  width: 14px;
  height: 14px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
@keyframes spin {
  to { transform: rotate(360deg); }
}
.button-content {
  display: inline-flex;
  align-items: center;
}
.icon-left,
.icon-right {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
</style>
