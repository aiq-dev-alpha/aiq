<template>
  <div class="component-23" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component23',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-23 {
  padding: 1.25rem 1.75rem;
  border-radius: 1.5rem;
  background: linear-gradient(390deg, #f093fb 0%, #4facfe 100%);
  color: white;
  font-weight: 700;
  transition: all 0.4s ease;
}

.component-23:hover {
  transform: translateY(-3px);
  box-shadow: 0 7px 15px rgba(0, 0, 0, 0.13);
}
</style>
