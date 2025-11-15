<template>
  <div class="component-6" :class="[size, variant]">
    <slot />
  </div>
</template>
<script lang="ts">
import { defineComponent } from 'vue';
export default defineComponent({
  name: 'Component6',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>
<style scoped>
.component-6 {
  padding: 0.75rem 1.25rem;
  border-radius: 0.25rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-weight: 500;
  transition: all 0.2s ease;
}
.component-6:hover {
  transform: translateY(-1px);
  box-shadow: 0 5px 18px rgba(0, 0, 0, 0.11);
}
</style>
