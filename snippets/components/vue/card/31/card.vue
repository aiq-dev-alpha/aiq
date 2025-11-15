<template>
  <div class="component-31" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component31',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-31 {
  padding: 0.75rem 1.25rem;
  border-radius: 0.5rem;
  background: linear-gradient(510deg, #f093fb 0%, #4facfe 100%);
  color: white;
  font-weight: 600;
  transition: all 0.3s ease;
}

.component-31:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 13px rgba(0, 0, 0, 0.11);
}
</style>
