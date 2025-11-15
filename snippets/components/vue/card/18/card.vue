<template>
  <div class="component-18" :class="[size, variant]">
    <slot />
  </div>
</template>
<script lang="ts">
import { defineComponent } from 'vue';
export default defineComponent({
  name: 'Component18',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>
<style scoped>
.component-18 {
  padding: 1.25rem 1.75rem;
  border-radius: 0.25rem;
  background: linear-gradient(315deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-weight: 500;
  transition: all 0.2s ease;
}
.component-18:hover {
  transform: translateY(-1px);
  box-shadow: 0 7px 20px rgba(0, 0, 0, 0.13);
}
</style>
