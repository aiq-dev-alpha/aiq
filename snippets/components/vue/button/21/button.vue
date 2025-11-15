<template>
  <button
    :class="buttonClasses"
    :disabled="disabled || loading"
    @click="handleClick"
  >
    <span v-if="loading" class="animate-spin mr-2">⏳</span>
    <slot />
  </button>
</template>
<script setup lang="ts">
import { computed } from 'vue';
interface Props {
  variant?: 'solid' | 'outline' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
}
const props = withDefaults(defineProps<Props>(), {
  variant: 'solid',
  size: 'md',
  disabled: false,
  loading: false
});
const emit = defineEmits<{
  click: []
}>();
const buttonClasses = computed(() => {
  const base = 'rounded-lg font-semibold transition-all duration-200 focus:outline-none focus:ring-2';
  const variants = {
    solid: 'bg-gradient-to-r from-purple-600 to-pink-600 text-white hover:from-purple-700 hover:to-pink-700 shadow-lg',
    outline: 'border-2 border-purple-600 text-purple-700 hover:bg-purple-50',
    ghost: 'text-purple-700 hover:bg-purple-100'
  };
  const sizes = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-5 py-2.5 text-base',
    lg: 'px-7 py-3.5 text-lg'
  };
  const disabled = props.disabled || props.loading ? 'opacity-50 cursor-not-allowed' : '';
  return `${base} ${variants[props.variant]} ${sizes[props.size]} ${disabled}`;
});
const handleClick = () => {
  if (!props.disabled && !props.loading) {
    emit('click');
  }
};
</script>
