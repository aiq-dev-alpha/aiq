<template>
  <button :style="btnStyle" :disabled="disabled || loading" :class="btnClass" @click="handleClick">
    <span v-if="loading" class="loader"></span>
    <template v-else>
      <span v-if="prefixIcon" class="prefix">{{ prefixIcon }}</span>
      <span><slot></slot></span>
      <span v-if="suffixIcon" class="suffix">{{ suffixIcon }}</span>
    </template>
  </button>
</template>

<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  variant?: 'primary' | 'secondary' | 'success' | 'danger' | 'warning';
  appearance?: 'filled' | 'outline' | 'text' | 'soft';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
  prefixIcon?: string;
  suffixIcon?: string;
  block?: boolean;
  rounded?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  appearance: 'filled',
  size: 'md',
  disabled: false,
  loading: false,
  block: false,
  rounded: true
});

const emit = defineEmits<{
  click: [event: MouseEvent];
}>();

const colors = {
  primary: { base: '#3b82f6', light: '#60a5fa', dark: '#2563eb' },
  secondary: { base: '#8b5cf6', light: '#a78bfa', dark: '#7c3aed' },
  success: { base: '#10b981', light: '#34d399', dark: '#059669' },
  danger: { base: '#ef4444', light: '#f87171', dark: '#dc2626' },
  warning: { base: '#f59e0b', light: '#fbbf24', dark: '#d97706' }
};

const btnStyle = computed(() => {
  const c = colors[props.variant];
  const sizes = {
    sm: { padding: '6px 12px', fontSize: '13px', minHeight: '32px' },
    md: { padding: '10px 20px', fontSize: '14px', minHeight: '40px' },
    lg: { padding: '12px 24px', fontSize: '16px', minHeight: '48px' }
  };

  const appearances = {
    filled: { background: c.base, color: '#fff', border: 'none' },
    outline: { background: 'transparent', color: c.base, border: `2px solid ${c.base}` },
    text: { background: 'transparent', color: c.base, border: 'none' },
    soft: { background: `${c.base}20`, color: c.dark, border: 'none' }
  };

  return {
    ...sizes[props.size],
    ...appearances[props.appearance],
    borderRadius: props.rounded ? '8px' : '4px',
    width: props.block ? '100%' : 'auto',
    cursor: props.disabled || props.loading ? 'not-allowed' : 'pointer',
    opacity: props.disabled || props.loading ? '0.6' : '1',
    fontWeight: '600',
    transition: 'all 0.2s ease',
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '8px',
    fontFamily: 'inherit',
    outline: 'none'
  };
});

const btnClass = computed(() => [`variant-${props.variant}`, `appearance-${props.appearance}`, `size-${props.size}`]);

const handleClick = (e: MouseEvent) => {
  if (!props.disabled && !props.loading) {
    emit('click', e);
  }
};
</script>

<style scoped>
button:hover:not(:disabled) {
  filter: brightness(1.05);
  transform: translateY(-1px);
}
button:active:not(:disabled) {
  transform: translateY(0);
}
.loader {
  width: 14px;
  height: 14px;
  border: 2px solid currentColor;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}
@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>
