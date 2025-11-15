<template>
  <div class="relative">
    <label v-if="label" :for="inputId" class="block text-sm font-medium text-gray-700 mb-1">
      {{ label }}
      <span v-if="required" class="text-red-500">*</span>
    </label>
    <div class="relative">
      <div v-if="$slots.prefix" class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">
        <slot name="prefix" />
      </div>
      <input
        :id="inputId"
        :type="type"
        :value="modelValue"
        :placeholder="placeholder"
        :disabled="disabled"
        :required="required"
        :class="inputClasses"
        @input="handleInput"
        @focus="isFocused = true"
        @blur="isFocused = false"
      />
      <div v-if="$slots.suffix" class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400">
        <slot name="suffix" />
      </div>
    </div>
    <p v-if="error" class="mt-1 text-sm text-red-600">{{ error }}</p>
    <p v-else-if="hint" class="mt-1 text-sm text-gray-500">{{ hint }}</p>
  </div>
</template>
<script setup lang="ts">
import { computed, ref } from 'vue';
interface Props {
  modelValue?: string;
  label?: string;
  type?: string;
  placeholder?: string;
  disabled?: boolean;
  required?: boolean;
  error?: string;
  hint?: string;
}
const props = withDefaults(defineProps<Props>(), {
  type: 'text',
  disabled: false,
  required: false
});
const emit = defineEmits<{
  'update:modelValue': [value: string]
}>();
const inputId = `input-${Math.random().toString(36).substr(2, 9)}`;
const isFocused = ref(false);
const inputClasses = computed(() => {
  const base = 'w-full px-4 py-2.5 border rounded-lg transition-all duration-200 focus:outline-none focus:ring-2';
  const prefix = props.$slots?.prefix ? 'pl-10' : '';
  const suffix = props.$slots?.suffix ? 'pr-10' : '';
  const state = props.error
    ? 'border-red-300 focus:ring-red-500 focus:border-red-500'
    : 'border-gray-300 focus:ring-blue-500 focus:border-blue-500';
  const disabled = props.disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white';
  return `${base} ${prefix} ${suffix} ${state} ${disabled}`;
});
const handleInput = (event: Event) => {
  const target = event.target as HTMLInputElement;
  emit('update:modelValue', target.value);
};
</script>
