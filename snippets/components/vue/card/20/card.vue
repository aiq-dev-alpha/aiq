<template>
  <div class="component-20" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component20',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-20 {
  padding: 0.5rem 1.0rem;
  border-radius: 0.75rem;
  background: linear-gradient(345deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-weight: 700;
  transition: all 0.4s ease;
}

.component-20:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.10);
}
</style>
