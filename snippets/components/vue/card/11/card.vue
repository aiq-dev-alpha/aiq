<template>
  <div class="component-11" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component11',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-11 {
  padding: 0.75rem 1.25rem;
  border-radius: 1.5rem;
  background: linear-gradient(210deg, #f093fb 0%, #4facfe 100%);
  color: white;
  font-weight: 700;
  transition: all 0.4s ease;
}

.component-11:hover {
  transform: translateY(-3px);
  box-shadow: 0 5px 13px rgba(0, 0, 0, 0.11);
}
</style>
