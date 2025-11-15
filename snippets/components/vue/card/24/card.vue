<template>
  <div class="component-24" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component24',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-24 {
  padding: 1.5rem 2.0rem;
  border-radius: 0.25rem;
  background: linear-gradient(405deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-weight: 500;
  transition: all 0.2s ease;
}

.component-24:hover {
  transform: translateY(-1px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.14);
}
</style>
