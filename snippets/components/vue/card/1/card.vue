<template>
  <div class="custom-card" :class="{ elevated, bordered }">
    <div v-if="$slots.header || title" class="card-header">
      <h3 v-if="title" class="card-title">{{ title }}</h3>
      <slot name="header" />
    </div>
    <div class="card-body">
      <slot />
    </div>
    <div v-if="$slots.footer" class="card-footer">
      <slot name="footer" />
    </div>
  </div>
</template>
<script lang="ts">
import { defineComponent } from 'vue';
export default defineComponent({
  name: 'CustomCard',
  props: {
    title: { type: String, default: '' },
    elevated: { type: Boolean, default: true },
    bordered: { type: Boolean, default: false }
  }
});
</script>
<style scoped>
.custom-card {
  background: white;
  border-radius: 1rem;
  overflow: hidden;
}
.custom-card.elevated {
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}
.custom-card.bordered {
  border: 2px solid #e5e7eb;
}
.card-header {
  padding: 1.25rem 1.5rem;
  border-bottom: 1px solid #f3f4f6;
  background: linear-gradient(to bottom, #fafafa, #ffffff);
}
.card-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #111827;
  margin: 0;
}
.card-body {
  padding: 1.5rem;
}
.card-footer {
  padding: 1rem 1.5rem;
  border-top: 1px solid #f3f4f6;
  background: #f9fafb;
}
</style>
