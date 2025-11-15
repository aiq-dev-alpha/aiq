<template>
  <div class="premium-input">
    <label v-if="label" class="label">{{ label }}</label>
    <input :type="type" :value="modelValue" :placeholder="placeholder" @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)" class="input" />
  </div>
</template>
<script lang="ts">
import { defineComponent } from 'vue';
export default defineComponent({
  name: 'PremiumInput',
  props: { modelValue: [String, Number], type: { type: String, default: 'text' }, label: String, placeholder: String },
  emits: ['update:modelValue']
});
</script>
<style scoped>
.premium-input { margin: 1.25rem 0; }
.label { display: block; margin-bottom: 0.625rem; font-size: 0.875rem; font-weight: 600; color: #1a202c; }
.input { width: 100%; padding: 0.875rem 1.25rem; font-size: 1rem; border: 2px solid #e2e8f0; border-radius: 0.625rem; outline: none; transition: all 0.25s; background: linear-gradient(to bottom, #ffffff, #f7fafc); }
.input:focus { border-color: #4299e1; box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.15); background: white; }
</style>
