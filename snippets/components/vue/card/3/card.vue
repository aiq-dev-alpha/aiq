<template>
  <div class="stylish-card">
    <div v-if="title" class="card-top"><h4>{{ title }}</h4></div>
    <div class="card-content"><slot /></div>
    <div v-if="$slots.actions" class="card-actions"><slot name="actions" /></div>
  </div>
</template>
<script lang="ts">
import { defineComponent } from 'vue';
export default defineComponent({ name: 'StylishCard', props: { title: String } });
</script>
<style scoped>
.stylish-card { background: white; border-radius: 1rem; box-shadow: 0 8px 16px rgba(0, 0, 0, 0.08); overflow: hidden; border: 1px solid #f0f0f0; }
.card-top { padding: 1.5rem; background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); border-bottom: 1px solid #e0e0e0; }
.card-top h4 { margin: 0; font-size: 1.25rem; font-weight: 700; color: #2d3748; }
.card-content { padding: 1.5rem; }
.card-actions { padding: 1rem 1.5rem; background: #fafafa; border-top: 1px solid #e0e0e0; }
</style>
