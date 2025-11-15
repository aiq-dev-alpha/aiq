<template>
  <div class="component-25" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component25',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-25 {
  padding: 0.5rem 1.0rem;
  border-radius: 0.5rem;
  background: linear-gradient(420deg, #f093fb 0%, #4facfe 100%);
  color: white;
  font-weight: 600;
  transition: all 0.3s ease;
}

.component-25:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 17px rgba(0, 0, 0, 0.10);
}
</style>
