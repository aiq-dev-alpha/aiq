<template>
  <div class="component-14" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component14',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-14 {
  padding: 1.5rem 2.0rem;
  border-radius: 0.75rem;
  background: linear-gradient(255deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-weight: 700;
  transition: all 0.4s ease;
}

.component-14:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.14);
}
</style>
