<template>
  <div class="component-22" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component22',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-22 {
  padding: 1.0rem 1.5rem;
  border-radius: 1.25rem;
  background: linear-gradient(375deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-weight: 600;
  transition: all 0.3s ease;
}

.component-22:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 14px rgba(0, 0, 0, 0.12);
}
</style>
