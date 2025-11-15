<template>
  <div :style="componentStyles">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue';

export default defineComponent({
  name: 'Component',
  props: {
    theme: {
      type: Object,
      default: () => ({})
    },
    size: {
      type: String,
      default: 'md'
    }
  },
  setup(props) {
    const defaultTheme = {
      primaryColor: '#3b82f6',
      backgroundColor: '#ffffff',
      textColor: '#111827'
    };

    const appliedTheme = { ...defaultTheme, ...props.theme };

    const componentStyles = computed(() => ({
      padding: props.size === 'sm' ? '0.5rem' : props.size === 'lg' ? '1.5rem' : '1rem',
      backgroundColor: appliedTheme.backgroundColor,
      color: appliedTheme.textColor,
      borderRadius: '0.5rem'
    }));

    return { componentStyles };
  }
});
</script>
