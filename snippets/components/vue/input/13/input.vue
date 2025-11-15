<template>
  <div class="input-container">
    <label v-if="label" class="input-label">{{ label }}</label>
    <div class="input-wrapper">
      <input
        :type="type"
        :value="modelValue"
        :placeholder="placeholder"
        :disabled="disabled"
        @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
        class="text-input"
        :class="{ error, focused }"
        @focus="focused = true"
        @blur="focused = false"
      />
    </div>
    <p v-if="error" class="error-text">{{ error }}</p>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';

export default defineComponent({
  name: 'TextInput',
  props: {
    modelValue: { type: [String, Number], default: '' },
    type: { type: String, default: 'text' },
    label: { type: String, default: '' },
    placeholder: { type: String, default: '' },
    error: { type: String, default: '' },
    disabled: { type: Boolean, default: false }
  },
  emits: ['update:modelValue'],
  setup() {
    const focused = ref(false);
    return { focused };
  }
});
</script>

<style scoped>
.input-container {
  margin: 1rem 0;
}

.input-label {
  display: block;
  margin-bottom: 0.5rem;
  font-size: 0.875rem;
  font-weight: 500;
  color: #374151;
}

.text-input {
  width: 100%;
  padding: 0.625rem 1.25rem;
  font-size: 1rem;
  border: 2px solid #d1d5db;
  border-radius: 0.5rem;
  outline: none;
  transition: all 0.2s;
  background: white;
}

.text-input:focus {
  border-color: #indigo500;
  box-shadow: 0 0 0 3px rgba(var(--indigo-rgb), 0.1);
}

.text-input.error {
  border-color: #ef4444;
}

.error-text {
  margin-top: 0.5rem;
  font-size: 0.875rem;
  color: #ef4444;
}
</style>
