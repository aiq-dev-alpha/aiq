<template>
  <div class="component" :style="computedStyles">
    <slot />
  </div>
</template>

<script>
export default {
  name: 'Component',
  props: {
    theme: {
      type: Object,
      default: () => ({})
    }
  },
  computed: {
    computedStyles() {
      return {
        padding: '1rem',
        borderRadius: '0.5rem',
        backgroundColor: this.theme.backgroundColor || '#fff',
        ...this.theme
      };
    }
  }
}
</script>
