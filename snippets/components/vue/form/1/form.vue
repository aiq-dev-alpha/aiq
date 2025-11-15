<template>
  <form :class="['smart-form', { 'has-errors': hasErrors }]" @submit.prevent="handleSubmit">
    <div class="form-header" v-if="title || $slots.header">
      <slot name="header">
        <h2 class="form-title">{{ title }}</h2>
        <p v-if="description" class="form-description">{{ description }}</p>
      </slot>
    </div>

    <div class="form-body">
      <slot :errors="errors" :values="formData" />
    </div>

    <div class="form-footer" v-if="$slots.footer || !hideDefaultActions">
      <slot name="footer">
        <div class="default-actions">
          <button
            type="button"
            class="btn btn-secondary"
            @click="handleReset"
            :disabled="loading"
          >
            {{ resetLabel }}
          </button>
          <button
            type="submit"
            class="btn btn-primary"
            :disabled="loading || (validateOnSubmit && hasErrors)"
          >
            <span v-if="loading" class="spinner"></span>
            {{ loading ? loadingLabel : submitLabel }}
          </button>
        </div>
      </slot>
    </div>

    <div v-if="successMessage" class="success-message">
      {{ successMessage }}
    </div>
    <div v-if="errorMessage" class="error-message">
      {{ errorMessage }}
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

interface Props {
  title?: string;
  description?: string;
  submitLabel?: string;
  resetLabel?: string;
  loadingLabel?: string;
  hideDefaultActions?: boolean;
  validateOnSubmit?: boolean;
  modelValue?: Record<string, any>;
}

const props = withDefaults(defineProps<Props>(), {
  submitLabel: 'Submit',
  resetLabel: 'Reset',
  loadingLabel: 'Submitting...',
  hideDefaultActions: false,
  validateOnSubmit: true,
  modelValue: () => ({})
});

const emit = defineEmits<{
  'update:modelValue': [value: Record<string, any>];
  submit: [data: Record<string, any>];
  reset: [];
}>();

const formData = ref({ ...props.modelValue });
const errors = ref<Record<string, string>>({});
const loading = ref(false);
const successMessage = ref('');
const errorMessage = ref('');

const hasErrors = computed(() => Object.keys(errors.value).length > 0);

const handleSubmit = async () => {
  errorMessage.value = '';
  successMessage.value = '';

  if (props.validateOnSubmit && hasErrors.value) {
    return;
  }

  loading.value = true;
  try {
    emit('submit', formData.value);
    emit('update:modelValue', formData.value);
  } catch (error) {
    errorMessage.value = error instanceof Error ? error.message : 'An error occurred';
  } finally {
    loading.value = false;
  }
};

const handleReset = () => {
  formData.value = {};
  errors.value = {};
  successMessage.value = '';
  errorMessage.value = '';
  emit('reset');
  emit('update:modelValue', {});
};
</script>

<style scoped>
.smart-form {
  background: white;
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.form-header {
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 2px solid #f3f4f6;
}

.form-title {
  margin: 0 0 0.5rem 0;
  font-size: 1.75rem;
  font-weight: 700;
  color: #111827;
}

.form-description {
  margin: 0;
  color: #6b7280;
  line-height: 1.6;
}

.form-body {
  margin-bottom: 2rem;
}

.form-footer {
  padding-top: 1.5rem;
  border-top: 2px solid #f3f4f6;
}

.default-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
}

.btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-primary {
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  color: white;
}

.btn-primary:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(59, 130, 246, 0.3);
}

.btn-secondary {
  background: #f3f4f6;
  color: #374151;
}

.btn-secondary:hover:not(:disabled) {
  background: #e5e7eb;
}

.spinner {
  width: 1rem;
  height: 1rem;
  border: 2px solid currentColor;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.success-message,
.error-message {
  margin-top: 1rem;
  padding: 1rem;
  border-radius: 8px;
  font-weight: 500;
}

.success-message {
  background: #ecfdf5;
  color: #059669;
  border: 1px solid #d1fae5;
}

.error-message {
  background: #fef2f2;
  color: #dc2626;
  border: 1px solid #fee2e2;
}

.smart-form.has-errors {
  border: 2px solid #fecaca;
}
</style>
