<template>
  <div class="component-19" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component19',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-19 {
  padding: 1.5rem 2.0rem;
  border-radius: 0.5rem;
  background: linear-gradient(330deg, #f093fb 0%, #4facfe 100%);
  color: white;
  font-weight: 600;
  transition: all 0.3s ease;
}

.component-19:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 21px rgba(0, 0, 0, 0.14);
}
</style>
