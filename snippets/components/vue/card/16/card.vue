<template>
  <div :class="cardClasses">
    <div v-if="$slots.header" class="px-6 py-4 border-b border-gray-200 bg-gray-50">
      <slot name="header" />
    </div>
    <div class="px-6 py-4">
      <slot />
    </div>
    <div v-if="$slots.footer" class="px-6 py-4 border-t border-gray-200 bg-gray-50">
      <slot name="footer" />
    </div>
  </div>
</template>
<script setup lang="ts">
import { computed } from 'vue';
interface Props {
  variant?: 'default' | 'outlined' | 'elevated';
  hoverable?: boolean;
}
const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
  hoverable: false
});
const cardClasses = computed(() => {
  const base = 'rounded-xl overflow-hidden';
  const variants = {
    default: 'bg-white shadow-md',
    outlined: 'bg-white border-2 border-gray-200',
    elevated: 'bg-white shadow-2xl'
  };
  const hover = props.hoverable ? 'hover:shadow-xl hover:-translate-y-1 transition-all duration-300' : '';
  return `${base} ${variants[props.variant]} ${hover}`;
});
</script>
