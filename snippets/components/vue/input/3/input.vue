<template>
  <div class="input-wrapper" :class="{ 'has-error': error, 'is-disabled': disabled }">
    <div class="input-container" :class="[`size-${size}`, `variant-${variant}`, { 'is-floating': variant === 'floating' && (isFocused || modelValue) }]">
      <input
        :type="type"
        :value="modelValue"
        :placeholder="variant === 'floating' ? ' ' : placeholder"
        :disabled="disabled"
        :required="required"
        @input="handleInput"
        @focus="isFocused = true"
        @blur="isFocused = false"
        class="input-field"
        :style="inputStyles"
        :id="inputId"
      />
      <label v-if="label" :for="inputId" class="floating-label" :class="{ 'required': required }">
        {{ label }}
      </label>
      <span v-if="icon && iconPosition === 'left'" class="input-icon left">{{ icon }}</span>
      <span v-if="icon && iconPosition === 'right'" class="input-icon right">{{ icon }}</span>
      <button v-if="showClear && modelValue && !disabled" @click="clearInput" class="clear-button" type="button">×</button>
    </div>
    <div v-if="error || helperText || showCounter" class="input-footer">
      <span v-if="error" class="error-message">{{ error }}</span>
      <span v-else-if="helperText" class="helper-text">{{ helperText }}</span>
      <span v-if="showCounter" class="character-counter">{{ characterCount }}/{{ maxLength }}</span>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed, ref, PropType } from 'vue';

interface InputTheme {
  primary: string;
  background: string;
  border: string;
  text: string;
  error: string;
  success: string;
}

export default defineComponent({
  name: 'Input',
  props: {
    modelValue: { type: [String, Number], default: '' },
    type: { type: String, default: 'text' },
    label: { type: String, default: '' },
    placeholder: { type: String, default: '' },
    error: { type: String, default: '' },
    helperText: { type: String, default: '' },
    disabled: { type: Boolean, default: false },
    required: { type: Boolean, default: false },
    icon: { type: String, default: '' },
    iconPosition: { type: String as PropType<'left' | 'right'>, default: 'left' },
    variant: { type: String as PropType<'default' | 'filled' | 'outlined' | 'underlined' | 'floating'>, default: 'floating' },
    size: { type: String as PropType<'sm' | 'md' | 'lg'>, default: 'md' },
    theme: { type: Object as PropType<Partial<InputTheme>>, default: () => ({}) },
    showClear: { type: Boolean, default: false },
    showCounter: { type: Boolean, default: false },
    maxLength: { type: Number, default: 100 }
  },
  emits: ['update:modelValue'],
  setup(props, { emit }) {
    const isFocused = ref(false);
    const inputId = ref(`input-${Math.random().toString(36).substr(2, 9)}`);

    const defaultTheme: InputTheme = {
      primary: '#06b6d4',
      background: '#ffffff',
      border: '#cbd5e1',
      text: '#0f172a',
      error: '#dc2626',
      success: '#059669'
    };

    const appliedTheme = { ...defaultTheme, ...props.theme };

    const handleInput = (event: Event) => {
      emit('update:modelValue', (event.target as HTMLInputElement).value);
    };

    const clearInput = () => {
      emit('update:modelValue', '');
    };

    const characterCount = computed(() => String(props.modelValue).length);

    const inputStyles = computed(() => ({
      '--primary-color': appliedTheme.primary,
      '--bg-color': appliedTheme.background,
      '--border-color': appliedTheme.border,
      '--text-color': appliedTheme.text,
      '--error-color': appliedTheme.error,
      '--success-color': appliedTheme.success
    }));

    return { isFocused, inputId, handleInput, clearInput, characterCount, inputStyles };
  }
});
</script>

<style scoped>
.input-wrapper {
  width: 100%;
  margin-bottom: 1.5rem;
}

.input-container {
  position: relative;
  display: flex;
  align-items: center;
}

.input-field {
  width: 100%;
  font-family: inherit;
  font-size: 1rem;
  color: var(--text-color);
  background-color: var(--bg-color);
  border: 2px solid var(--border-color);
  border-radius: 0.375rem;
  transition: all 0.3s ease;
  outline: none;
}

.floating-label {
  position: absolute;
  left: 1rem;
  top: 50%;
  transform: translateY(-50%);
  font-size: 1rem;
  color: #94a3b8;
  pointer-events: none;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  background-color: var(--bg-color);
  padding: 0 0.25rem;
}

.is-floating .floating-label,
.input-field:focus + .floating-label {
  top: 0;
  font-size: 0.75rem;
  color: var(--primary-color);
  font-weight: 600;
}

.floating-label.required::after {
  content: ' *';
  color: var(--error-color);
}

.input-field:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(6, 182, 212, 0.1);
}

.has-error .input-field {
  border-color: var(--error-color);
}

.size-sm .input-field { padding: 0.625rem 0.875rem; font-size: 0.875rem; }
.size-md .input-field { padding: 0.875rem 1rem; font-size: 1rem; }
.size-lg .input-field { padding: 1.125rem 1.25rem; font-size: 1.125rem; }

.variant-filled .input-field {
  background-color: #f1f5f9;
  border-color: transparent;
}

.variant-outlined .input-field {
  background-color: transparent;
}

.variant-underlined .input-field {
  border: none;
  border-bottom: 2px solid var(--border-color);
  border-radius: 0;
  padding-left: 0;
}

.input-icon {
  position: absolute;
  color: #64748b;
  pointer-events: none;
}

.input-icon.left { left: 1rem; }
.input-icon.right { right: 1rem; }

.clear-button {
  position: absolute;
  right: 1rem;
  background: none;
  border: none;
  font-size: 1.5rem;
  color: #94a3b8;
  cursor: pointer;
  transition: color 0.2s;
}

.clear-button:hover {
  color: var(--primary-color);
}

.input-footer {
  display: flex;
  justify-content: space-between;
  margin-top: 0.5rem;
  font-size: 0.75rem;
}

.error-message { color: var(--error-color); }
.helper-text { color: #64748b; }
.character-counter { color: #94a3b8; margin-left: auto; }
</style>
