<template>
  <div class="component-5" :class="[size, variant]">
    <slot />
  </div>
</template>
<script lang="ts">
import { defineComponent } from 'vue';
export default defineComponent({
  name: 'Component5',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>
<style scoped>
.component-5 {
  padding: 0.5rem 1.0rem;
  border-radius: 1.5rem;
  background: linear-gradient(120deg, #f093fb 0%, #4facfe 100%);
  color: white;
  font-weight: 700;
  transition: all 0.4s ease;
}
.component-5:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 17px rgba(0, 0, 0, 0.10);
}
</style>
