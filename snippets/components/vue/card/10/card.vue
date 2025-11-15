<template>
  <div class="component-10" :class="[size, variant]">
    <slot />
  </div>
</template>
<script lang="ts">
import { defineComponent } from 'vue';
export default defineComponent({
  name: 'Component10',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>
<style scoped>
.component-10 {
  padding: 0.5rem 1.0rem;
  border-radius: 1.25rem;
  background: linear-gradient(195deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-weight: 600;
  transition: all 0.3s ease;
}
.component-10:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.10);
}
</style>
