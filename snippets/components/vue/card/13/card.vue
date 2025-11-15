<template>
  <div class="component-13" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component13',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-13 {
  padding: 1.25rem 1.75rem;
  border-radius: 0.5rem;
  background: linear-gradient(240deg, #f093fb 0%, #4facfe 100%);
  color: white;
  font-weight: 600;
  transition: all 0.3s ease;
}

.component-13:hover {
  transform: translateY(-2px);
  box-shadow: 0 7px 15px rgba(0, 0, 0, 0.13);
}
</style>
