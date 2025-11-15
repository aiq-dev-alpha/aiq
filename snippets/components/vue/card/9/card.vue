<template>
  <div class="component-9" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component9',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-9 {
  padding: 1.5rem 2.0rem;
  border-radius: 1.0rem;
  background: linear-gradient(180deg, #f093fb 0%, #4facfe 100%);
  color: white;
  font-weight: 500;
  transition: all 0.2s ease;
}

.component-9:hover {
  transform: translateY(-1px);
  box-shadow: 0 8px 21px rgba(0, 0, 0, 0.14);
}
</style>
