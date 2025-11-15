<template>
  <div class="component-15" :class="[size, variant]">
    <slot />
  </div>
</template>
<script lang="ts">
import { defineComponent } from 'vue';
export default defineComponent({
  name: 'Component15',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>
<style scoped>
.component-15 {
  padding: 0.5rem 1.0rem;
  border-radius: 1.0rem;
  background: linear-gradient(270deg, #f093fb 0%, #4facfe 100%);
  color: white;
  font-weight: 500;
  transition: all 0.2s ease;
}
.component-15:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 17px rgba(0, 0, 0, 0.10);
}
</style>
