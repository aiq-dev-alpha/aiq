<template>
  <div class="component-8" :class="[size, variant]">
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Component8',
  props: {
    size: { type: String, default: 'md' },
    variant: { type: String, default: 'default' }
  }
});
</script>

<style scoped>
.component-8 {
  padding: 1.25rem 1.75rem;
  border-radius: 0.75rem;
  background: linear-gradient(165deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-weight: 700;
  transition: all 0.4s ease;
}

.component-8:hover {
  transform: translateY(-3px);
  box-shadow: 0 7px 20px rgba(0, 0, 0, 0.13);
}
</style>
