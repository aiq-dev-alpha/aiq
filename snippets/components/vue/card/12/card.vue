<template>
  <div class="component-12" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component12',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-12 {
  padding: 1.0rem 1.5rem;
  border-radius: 0.25rem;
  background: linear-gradient(225deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-weight: 500;
  transition: all 0.2s ease;
}

.component-12:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 14px rgba(0, 0, 0, 0.12);
}
</style>
