<template>
  <div class="toggle-group" role="group">
    <button
      v-for="(option, index) in options"
      :key="index"
      :class="['toggle-btn', { active: modelValue === option.value, disabled }]"
      :disabled="disabled"
      @click="selectOption(option.value)"
    >
      <span v-if="option.icon" class="btn-icon">{{ option.icon }}</span>
      <span class="btn-label">{{ option.label }}</span>
    </button>
  </div>
</template>

<script setup lang="ts">
interface Option {
  label: string;
  value: string;
  icon?: string;
}

interface Props {
  options: Option[];
  modelValue?: string;
  disabled?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  disabled: false
});

const emit = defineEmits<{
  'update:modelValue': [value: string];
}>();

const selectOption = (value: string) => {
  if (!props.disabled) {
    emit('update:modelValue', value);
  }
};
</script>

<style scoped>
.toggle-group {
  display: inline-flex;
  background: #f3f4f6;
  border-radius: 12px;
  padding: 4px;
  gap: 4px;
}

.toggle-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.625rem 1.25rem;
  border: none;
  border-radius: 8px;
  background: transparent;
  color: #6b7280;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.toggle-btn:hover:not(.disabled):not(.active) {
  color: #374151;
  background: rgba(255, 255, 255, 0.5);
}

.toggle-btn.active {
  background: white;
  color: #6366f1;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.toggle-btn.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>